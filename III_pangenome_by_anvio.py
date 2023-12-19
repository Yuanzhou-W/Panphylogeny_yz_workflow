rule all:
    input:
        str_collection = "III_pangenome_anvio/I_cotigsdb/str_collection.txt",
        result_tree = "III_pangenome_anvio/III_phylogeny/tree_result/SCG_all.iqtree",
        metabolic = "III_pangenome_anvio/IV_metabolic_rebuild/str_all/"

rule merge_genome_file:
    input:
        "genome/"
    output:
        "III_pangenome_anvio/I_cotigsdb/contigs.fasta"
    shell:
        "cat {input}/*.fasta >> {output}"

rule gen_contigdb_annote:
    input:
        contig_fa = "III_pangenome_anvio/I_cotigsdb/contigs.fasta"
    output:
        contig_db = "III_pangenome_anvio/I_cotigsdb/genome_all-contigs.db"
    threads: 32
    shell:
        "source activate anvio-8 && \
        anvi-gen-contigs-database -f {input.contig_fa} -o {output.contig_db}  && \
        anvi-run-hmms -c {output.contig_db} --num-threads {threads} --just-do-it && \
        anvi-run-kegg-kofams -c {output.contig_db} -T {threads} --just-do-it && \
        anvi-run-ncbi-cogs -c {output.contig_db} && \
        anvi-run-cazymes -c {output.contig_db} -T {threads} && \
        anvi-run-pfams -c {output.contig_db} -T {threads} && \
        anvi-run-interacdome -c {output.contig_db} -T {threads} "



rule gen_blankprofile:
    input:
        contig_db = "III_pangenome_anvio/I_cotigsdb/genome_all-contigs.db"
    output:
        profile_db = directory("III_pangenome_anvio/I_cotigsdb/genome_all_blank_profile/")
    threads: 32
    shell:
        "source activate anvio-8 && \
        anvi-profile -c {input.contig_db} \
            --blank-profile -T {threads} -W \
            -o {output.profile_db} \
            -S Blank "



rule get_str_collection:
    input:
        contig_db = "III_pangenome_anvio/I_cotigsdb/genome_all-contigs.db",
        profile_db = "III_pangenome_anvio/I_cotigsdb/genome_all_blank_profile/"
    output:
        str_collection = "III_pangenome_anvio/I_cotigsdb/str_collection.txt"
    shell:
        "source activate anvio-8 && \
        for split_name in `sqlite3 {input.contig_db} 'select split from splits_basic_info;'`; do  which;     GENOME=`echo $split_name | awk 'BEGIN{{FS=\"-\"}}{{print $1}}'`;   echo -e \"$split_name\t$GENOME\" ; done > {output.str_collection} && \
        source activate anvio-8 && \
        anvi-import-collection {output.str_collection} \
                       -c {input.contig_db} \
                       -p {input.profile_db}/PROFILE.db \
                       -C str "


rule generate_internal_list:
    input:
        fasta = "genome/",
        contig_db = "III_pangenome_anvio/I_cotigsdb/genome_all-contigs.db",
        profile_db = "III_pangenome_anvio/I_cotigsdb/genome_all_blank_profile/"
    output:
        internal = "III_pangenome_anvio/II_pangenome/internal_genome.txt"
    shell:
        "python generate_internal_genoms.py -f {input.fasta}  -c {input.contig_db} -p {input.profile_db}/PROFILE.db -o {output.internal} -t str "





#######################################################################
#
#  build pangenome with all genomes
#  construct the phylogenetic tree with iqtree
#
#######################################################################

rule build_genome_storge:
    input:
        internal = "III_pangenome_anvio/II_pangenome/internal_genome.txt"
    output:
        genome_storge_db = "III_pangenome_anvio/II_pangenome/genome-storge-GENOMES.db"
    log:
        "III_pangenome_anvio/II_pangenome/log/genome-storge.log"
    shell:
        "source activate anvio-8 && \
        anvi-gen-genomes-storage \
                         -i {input.internal} \
                         -o {output.genome_storge_db} >> {log}"


rule build_pangenome:
    input:
        genome_storge_db = "III_pangenome_anvio/II_pangenome/genome-storge-GENOMES.db",
        internal = "III_pangenome_anvio/II_pangenome/internal_genome.txt"
    output:
        pangenome_dir = directory("III_pangenome_anvio/II_pangenome/PAN_GENOME/")
    log:
        pan_log = "III_pangenome_anvio/II_pangenome/log/pan.log",
        ANI_log = "III_pangenome_anvio/II_pangenome/log/ANI.log",
        metapan_log = "III_pangenome_anvio/II_pangenome/log/metapan.log"
    threads:32
    shell:
        "source activate anvio-8 && \
        anvi-pan-genome -g {input.genome_storge_db} \
                --use-ncbi-blast \
                --minbit 0.5 \
                --min-occurrence 5 \
                --mcl-inflation 8 \
                --project-name PANGENOME \
                --num-threads {threads} \
                --I-know-this-is-not-a-good-idea \
                -o {output.pangenome_dir}  > {log.pan_log} && \
         anvi-script-compute-bayesian-pan-core -p {output.pangenome_dir}/PANGENOME-PAN.db \
                                      -g {input.genome_storge_db} \
                                      -o {output.pangenome_dir}/CLUSTER_pan_Core.tsv \
                                      --store-in-db \
                                      -T {threads} \
                                      -B 1000 > {log.metapan_log} && \
         anvi-compute-genome-similarity -i {input.internal} \
                               --program pyANI \
                               --method ANIm \
                               -o {output.pangenome_dir}/ANIm.matrix \
                               -T {threads} \
                               --pan-db  {output.pangenome_dir}/PANGENOME-PAN.db  > {log.ANI_log} "


import os

def count_fasta_files(folder_path):
    """
    Count the number of FASTA files in the specified folder.
    Parameters:
    - folder_path (str): The path to the folder.
    Returns:
    - int: The rounded number of FASTA files in the folder.
    """
    # 检查文件夹是否存在
    if not os.path.exists(folder_path):
        print(f"Error: Folder '{folder_path}' does not exist.")
        return -1  # 返回 -1 表示错误
    # 获取文件夹中的所有文件
    all_files = os.listdir(folder_path)
    # 筛选出以 '.fasta' 或 '.fa' 结尾的文件
    fasta_files = [file for file in all_files if file.endswith(('.fasta', '.fa'))]
    # 返回四舍五入后的 FASTA 文件数量
    return round(len(fasta_files)*3/5)




rule get_single_copy_seq:
    input:
        genome_storge_db = "III_pangenome_anvio/II_pangenome/genome-storge-GENOMES.db",
        pangenome_dir = "III_pangenome_anvio/II_pangenome/PAN_GENOME/"
    output:
        SCG_fasta = "III_pangenome_anvio/II_pangenome/phylogeny/SCG.fasta"
    params:
        SCG_NUM = count_fasta_files("genome/")
    shell:
        "source activate anvio-8 && \
        anvi-get-sequences-for-gene-clusters -g {input.genome_storge_db} \
                                     -p {input.pangenome_dir}/PANGENOME-PAN.db \
                                     --min-num-genomes-gene-cluster-occurs {params.SCG_NUM} \
                                     --max-num-genes-from-each-genome 1 \
                                     --concatenate-gene-clusters \
                                     -o {output.SCG_fasta} "




#######################################################################
#
#  build pangenome with all genomes
#  construct the phylogenetic tree with iqtree
#
#######################################################################


rule phylogenetic_all_by_iqtree:
    input:
        SCG_fasta = "III_pangenome_anvio/II_pangenome/phylogeny/SCG.fasta"
    output:
        trim_fasta = "III_pangenome_anvio/III_phylogeny/str_all_workdir/SCG.trimal.fasta",
        result_tree = "III_pangenome_anvio/III_phylogeny/tree_result/SCG_all.iqtree"
    threads:32
    shell:
        "source activate iqtree && \
        trimal -in {input.SCG_fasta} -out {output.trim_fasta} -automated1 && \
        iqtree -s {output.trim_fasta} -m MFP+MERGE -T {threads} -alrt 1000 -B 1000 --bnni && \
        cp {output.trim_fasta}.iqtree {output.result_tree}"


#######################################################################
#
#  rebuild metabolic module for str
#  
#
#######################################################################

rule gen_metabolic_matrix:
    input:
        internal = "III_pangenome_anvio/II_pangenome/internal_genome.txt",
        profile_db = "III_pangenome_anvio/I_cotigsdb/genome_all_blank_profile/"
    output:
        metabolic = directory("III_pangenome_anvio/IV_metabolic_rebuild/str_all/")
    shell:
        "source activate anvio-8 && \
        anvi-estimate-metabolism -i {input.internal} \
                         -p {input.profile_db}/PROFILE.db \
                         -C str \
                         -O {output.metabolic} \
                         --include-zeros \
                         --add-copy-number \
                         --include-kos-not-in-kofam \
                         --just-do-it \
                         --add-coverage \
                         --matrix-format \
                         --include-metadata"


