# Rule to define all as the final output

import os

file_names = os.listdir("genome/")
fasta_files = [file for file in file_names if file.endswith(".fasta")]

SAMPLE = [os.path.splitext(file)[0] for file in fasta_files]

# Rule to define all as the final output
rule all:
    input:
        gtf_dir1 = expand("II_mask-prokka/prokka/origin_gtf_res/{sample1}.gtf", sample1=SAMPLE),
        gtf_dir2 = expand("II_mask-prokka/prokka/aft_mask_gtf_res/{sample1}.gtf", sample1=SAMPLE)

############################################################################
#
#  genome mask
#
#
############################################################################


# Rule to activate metaxa2 for a given sample
rule metaxa2:
    input:
        fasta=expand("genome/{sample}.fasta",sample = SAMPLE)
    output:
        su=directory("II_mask-prokka/mask/I_str_mask/{sample}/I_metaxa2/"),
        metaxa_bed="II_mask-prokka/mask/I_str_mask/{sample}/I_metaxa2/masked_metaxa.bed"
    shell:
        "source activate metaxa2 && \
        metaxa2 --plus --mode m --cpu 32 --multi_thread T --table T -g ssu --not_found T -1 {input.fasta} -o {output.su}/{wildcards.sample}.metaxa2_ssu && \
        metaxa2 --plus --mode m --cpu 32 --multi_thread T --table T -g lsu --not_found T -1 {input.fasta} -o {output.su}/{wildcards.sample}.metaxa2_lsu && \
        cut -f 1,9,10 {output.su}/{wildcards.sample}.metaxa2_ssu.extraction.results >> {output.metaxa_bed} && \
        cut -f 1,9,10 {output.su}/{wildcards.sample}.metaxa2_lsu.extraction.results >> {output.metaxa_bed}"

# Rule to activate barrnap for a given sample
rule barrnap:
    input:
        fasta=expand("genome/{sample}.fasta",sample = SAMPLE),
        rRNA_metaxa_bed="II_mask-prokka/mask/I_str_mask/{sample}/I_metaxa2/masked_metaxa.bed"
    output:
        out_bac="II_mask-prokka/mask/I_str_mask/{sample}/II_barrnap/out_bac.gff",
        out_arc="II_mask-prokka/mask/I_str_mask/{sample}/II_barrnap/out_arc.gff",
        out_euk="II_mask-prokka/mask/I_str_mask/{sample}/II_barrnap/out_euk.gff",
        rRNA_barrnap_bed="II_mask-prokka/mask/I_str_mask/{sample}/masked_barrnap.bed",
        rRNA="II_mask-prokka/mask/I_str_mask/{sample}/masked_rrna.bed"
    shell:
        "source activate barrnap_wlh && \
        barrnap --kingdom bac --threads 32 --reject 0.3 {input.fasta} > {output.out_bac} && \
        barrnap --kingdom arc --threads 32 --reject 0.3 {input.fasta} > {output.out_arc} && \
        barrnap --kingdom euk --threads 32 --reject 0.3 {input.fasta} > {output.out_euk} && \
        cut -f 1,4,5 {output.out_bac} >> {output.rRNA_barrnap_bed} && \
        cut -f 1,4,5 {output.out_arc} >> {output.rRNA_barrnap_bed} && \
        cut -f 1,4,5 {output.out_euk} >> {output.rRNA_barrnap_bed} && \
        cat {output.rRNA_barrnap_bed} {input.rRNA_metaxa_bed} > {output.rRNA}"

# Rule to activate tRNAscan-SE for a given sample
rule tRNAscan_se:
    input:
        fasta=expand("genome/{sample}.fasta",sample = SAMPLE)
    output:
        bedformat="II_mask-prokka/mask/I_str_mask/{sample}/III_tRNAscan/{sample}.bedformat",
        tRNA_bed="II_mask-prokka/mask/I_str_mask/{sample}/III_tRNAscan/masked_trna.bed"
    shell:
        "source activate tRNAscan-SE_wlh && \
        tRNAscan-SE -A -b {output.bedformat} --thread 32 {input.fasta} && \
        cut -f 1,2,3 {output.bedformat} >> {output.tRNA_bed}"

# Rule to activate dustmasker for a given sample
rule dustmasker:
    input:
        fasta= "genome/{sample}.fasta"
    output:
        lowcom_out="II_mask-prokka/mask/I_str_mask/{sample}/IV_dustmasker/{sample}_decontaminated.lowcom.out",
        dustmasker_bed="II_mask-prokka/mask/I_str_mask/{sample}/IV_dustmasker/masked_dustmasker.bed"
    shell:
        "source activate tRNAscan-SE_wlh && \
        dustmasker -in {input.fasta} -out {output.lowcom_out} -outfmt acclist && \
        sed 's/>//' {output.lowcom_out} > {output.dustmasker_bed}"

# Rule to mask regions using bedtools
rule mask_regions:
    input:
        rRNA="II_mask-prokka/mask/I_str_mask/{sample}/masked_rrna.bed",
        tRNA="II_mask-prokka/mask/I_str_mask/{sample}/III_tRNAscan/masked_trna.bed",
        dustmasker="II_mask-prokka/mask/I_str_mask/{sample}/IV_dustmasker/masked_dustmasker.bed"
    output:
        masked_bed="II_mask-prokka/mask/I_str_mask/{sample}/V_bedtools/{sample}_masked.bed",
        masked_fa="II_mask-prokka/mask/I_str_mask/{sample}/{sample}.masked.fa"
    shell:
        "source activate bedtools && \
        cat {input.rRNA} {input.tRNA} {input.dustmasker} > {output.masked_bed} && \
        bedtools maskfasta -fi genome/{wildcards.sample}.fasta -bed {output.masked_bed} -fo {output.masked_fa}"

# Rule to copy masked fasta to II_genome_masked
rule copy_masked_fasta:
    input:
        "II_mask-prokka/mask/I_str_mask/{sample}/{sample}.masked.fa"
    output:
        "II_mask-prokka/mask/II_genome_masked/{sample}.fasta"
    shell:
        "cp {input} {output}"




############################################################################
#
#  microbial genome annote
#
#
############################################################################

rule prokka_origin_genomes:
    input:
        fasta=expand("genome/{sample}.fasta",sample = SAMPLE)
    output:
        origin_prokka=directory("II_mask-prokka/prokka/origin/{sample}_/")
    log:
        "II_mask-prokka/prokka/origin_log/origin_{sample}.log"
    threads: 32
    shell:
        "source activate prokka_env && \
        prokka {input.fasta} --outdir {output.origin_prokka}  \
               --prefix {wildcards.sample} \
               --metagenome  --cpus {threads}\
               --kingdom Bacteria \
               > {log} "




rule prokka_masked_genomes:
    input:
        fasta=expand("II_mask-prokka/mask/II_genome_masked/{str}.fasta", str = SAMPLE)
    output:
        aft_mask_prokka = directory("II_mask-prokka/prokka/aft_mask/{str}_/")
    log:
        "II_mask-prokka/prokka/aft_log/aft_{str}.log"
    threads:32
    shell:
        "source activate prokka_env && \
        prokka {input.fasta} --outdir {output.aft_mask_prokka}  \
               --prefix {wildcards.str} \
               --metagenome  --cpus {threads}\
               --kingdom Bacteria \
               > {log} "
    
rule gff2gtf:
    input:
        gff_dir1 = "II_mask-prokka/prokka/origin/{sample1}_/", 
        gff_dir2 = "II_mask-prokka/prokka/aft_mask/{sample1}_/"
    output:
        gtf_dir1 = "II_mask-prokka/prokka/origin_gtf_res/{sample1}.gtf",
        gtf_dir2 = "II_mask-prokka/prokka/aft_mask_gtf_res/{sample1}.gtf"
    shell:
        "source activate prokka_env && \
        gffread {input.gff_dir1}/{wildcards.sample1}.gff -T -o {output.gtf_dir1} && \
        gffread {input.gff_dir2}/{wildcards.sample1}.gff -T -o {output.gtf_dir2} "
