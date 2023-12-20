#########################################################
#
#    some parameters
#
#########################################################
COMP = [50, 75]
SA = [98, 95]


#########################################################
#
#    script
#
########################################################
rule all:
    input:
        Drep_dir = expand("I_genome_pre/I_II-Drep/dereplicate/drep{comp}_{sa}", comp = COMP, sa =  SA),
        Pyani_dir = expand("I_genome_pre/I_II-Drep/Pyani_aft_drep/drep{comp1}_{sa1}",comp1 = COMP, sa1 =  SA),
        GTDB_tree = expand("I_genome_pre/I_III-GTDB/tree/result/drep{comp2}_{sa2}.tree",comp2 = COMP, sa2 =  SA)
 
#########################################################
#
#    run checkm and checkm2
#    transfer their result to the drep type
#
##########################################################

rule checkm_get_marker:
    output:
        marker = "I_genome_pre/I_I-checkm/checkm/Pro.ms"
    log:
        "I_genome_pre/I_I-checkm/log/1.1-checkm_get_marker.log"
    shell:
        "source activate checkm && \
        checkm taxon_set genus Prochlorococcus {output.marker} >> {log}"



rule checkm_analysis:
    input:
        genome_dir = "genome/",
        marker = "I_genome_pre/I_I-checkm/checkm/Pro.ms"
    output:
        analysis_dir = directory("I_genome_pre/I_I-checkm/checkm/analysis/")
    log:
        "I_genome_pre/I_I-checkm/log/1.2-checkm_analysis.log"
    threads:32
    shell:
        "source activate checkm && \
        checkm analyze -x fasta -t {threads} {input.marker} {input.genome_dir} {output.analysis_dir} >> {log}"


rule checkm_qa:
    input:
        marker = "I_genome_pre/I_I-checkm/checkm/Pro.ms",
        analysis_dir = "I_genome_pre/I_I-checkm/checkm/analysis/"
    output:
        origin_info = "I_genome_pre/I_I-checkm/checkm/qa/qa_2.txt"
    log:
        "I_genome_pre/I_I-checkm/log/1.3-checkm_qa.log"
    shell:
        "source activate checkm && \
        checkm qa {input.marker} {input.analysis_dir} -o 2 --tab_table -f {output.origin_info} >> {log}"




rule checkm2drep_result:
    input:
        checkm_origin_info="I_genome_pre/I_I-checkm/checkm/qa/qa_2.txt"
    output:
        checkm_drep_info="I_genome_pre/I_I-checkm/result/checkm_result.csv"
    shell:
        "python checkm_2drep.py  --input {input.checkm_origin_info} --output {output.checkm_drep_info}"


rule checkm2:
    input:
        genome_dir = "genome/"
    output:
        checkm2_result = directory("I_genome_pre/I_I-checkm/checkm2/")
    log:
        "I_genome_pre/I_I-checkm/log/2.1-checkm2_analysis.log"
    threads:32
    shell:
        "source activate checkm2 && \
        checkm2 predict --threads {threads} --allmodels -x fasta --force \
        -i {input.genome_dir} \
        -o {output.checkm2_result} >> {log}"


rule checkm22drep:
    input:
        origin_checkm2_result = "I_genome_pre/I_I-checkm/checkm2",
        checkm_drep_info = "I_genome_pre/I_I-checkm/result/checkm_result.csv"
    output:
        drep_info_checkm2 = "I_genome_pre/I_I-checkm/result/checkm2_result.csv"
    shell:
        "python checkm2_2drep.py -i {input.origin_checkm2_result}/quality_report.tsv -a {input.checkm_drep_info} -o {output.drep_info_checkm2}"
        

rule checkm2drep_final_type:
    input:
        checkm_drep_info = "I_genome_pre/I_I-checkm/result/checkm_result.csv",
        drep_info_checkm2 = "I_genome_pre/I_I-checkm/result/checkm2_result.csv"
    output:
        drep_type_checkm = "I_genome_pre/I_I-checkm/result/checkm_drep_type.csv",
        drep_type_checkm2 = "I_genome_pre/I_I-checkm/result/checkm2_drep_type.csv"
    shell:
        "python final_drep_type.py -i {input.checkm_drep_info} -o {output.drep_type_checkm} && \
        python final_drep_type.py -i {input.drep_info_checkm2} -o {output.drep_type_checkm2}"


#############################################################
#
# run drep with the result running by checkm
# and then running the pyani on the dereplicated genomes
#
#############################################################
rule drep:
    input:
        genome_dir="genome/",
        drep_type_checkm="I_genome_pre/I_I-checkm/result/checkm_drep_type.csv" 
    output:
        drep_result=directory("I_genome_pre/I_II-Drep/dereplicate/drep{comp}_{sa}")
    log:
        "I_genome_pre/I_II-Drep/log/drep{comp}_{sa}.log"
    threads: 32
    shell:
        "source activate drep && \
        dRep dereplicate {output.drep_result} \
        -p {threads} \
        -g {input.genome_dir}/*.fasta \
        --genomeInfo {input.drep_type_checkm} \
        --gen_warnings --warn_dist 0.25 --warn_sim 0.98 --warn_aln 0.25 \
        -comp {wildcards.comp} -con 5 -pa 0.9 -sa 0.{wildcards.sa} \
        --S_algorithm ANImf >> {log}"

rule pyani:
    input:
        drep_result = "I_genome_pre/I_II-Drep/dereplicate/drep{comp1}_{sa1}/"
    output:
        Pyani_result = directory("I_genome_pre/I_II-Drep/Pyani_aft_drep/drep{comp1}_{sa1}/")
    log:
        "I_genome_pre/I_II-Drep/log/pyani{comp1}_{sa1}.log"
    threads: 32
    shell:
        "source activate pyani && \
        average_nucleotide_identity.py -f -o {output.Pyani_result} \
                  -i {input.drep_result}/dereplicated_genomes/ \
                  -l {log} \
                  -g --gmethod seaborn -m ANIm \
                  --workers {threads} \
                  --write_excel"


#############################################################
#
# running GTDB-tk
# 
#
#############################################################

rule gtdb_tk:
    input:
        drep_result = "I_genome_pre/I_II-Drep/dereplicate/drep{comp2}_{sa2}/"
    output:
        GTDB_result = directory("I_genome_pre/I_III-GTDB/GTDB_TREE{comp2}_{sa2}/"),
        GTDB_TREE = "I_genome_pre/I_III-GTDB/tree/result/drep{comp2}_{sa2}.tree"
    log:
        "I_genome_pre/I_III-GTDB/log/GTDB{comp2}_{sa2}.log"
    threads: 32
    shell:
        "source activate gtdbtk_2.3.2 && \
        gtdbtk identify \
          --genome_dir {input.drep_result}/dereplicated_genomes/ \
          --out_dir {output.GTDB_result} \
          --cpus {threads} \
          --extension fasta && \
        gtdbtk align \
          --identify_dir {output.GTDB_result} \
          --skip_gtdb_refs \
          --out_dir {output.GTDB_result} && \
        gtdbtk infer \
          --msa_file {output.GTDB_result}/align/gtdbtk.bac120.user_msa.fasta.gz \
          --cpus {threads} \
          --out_dir {output.GTDB_result} && \
        cp {output.GTDB_result}/infer/intermediate_results/gtdbtk.unrooted.tree {output.GTDB_TREE} "
        



