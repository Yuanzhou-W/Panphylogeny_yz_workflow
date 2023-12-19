# generate database of each genome

conda activate anvio-7


for sample in `awk '{print $1}' '/lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/fasta_list.txt'`
do
    if [ "$sample" == "sample" ]; then continue; fi    
    anvi-gen-contigs-database -f  /lomi_home/wangluhang/SUSTech_project/task/I_drep/drep_900598/dereplicated_genomes/$sample.fasta \
                          -o /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/I_contig_db/$sample-contigs.db \
                          --num-threads 32
done


# generate annotation 
## anvio

conda activate anvio-7

for sample in `awk '{print $1}' '/lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/fasta_list.txt'`
do
    if [ "$sample" == "sample" ]; then continue; fi    
    anvi-run-hmms -c /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/I_contig_db/$sample-contigs.db --num-threads 32 --just-do-it
    anvi-run-kegg-kofams -c /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/I_contig_db/$sample-contigs.db -T 32 --just-do-it
    anvi-run-ncbi-cogs -c /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/I_contig_db/$sample-contigs.db
done

conda activate anvio-7

for sample in `awk '{print $1}' '/lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/fasta_list.txt'`
do
    if [ "$sample" == "sample" ]; then continue; fi    
    anvi-run-ncbi-cogs -c /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/I_contig_db/$sample-contigs.db --num-threads 32
done


## eggnog

conda activate anvio-7

for sample in `awk '{print $1}' '/lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/fasta_list.txt'`
do
	if [ "$sample" == "sample" ]; then continue; fi
	anvi-get-sequences-for-gene-calls -c /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/I_contig_db/$sample-contigs.db \
                                    --get-aa-sequences \
                                    -o /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/II_eggnog_annot/protein_fa/$sample.fa
done


### 

conda activate eggnog_wlh
for sample in `awk '{print $1}' '/lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/fasta_list.txt'`
do
mkdir /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/II_eggnog_annot/emapper_result/$sample
emapper.py --cpu 32 -o $sample --output_dir /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/II_eggnog_annot/emapper_result/$sample --override -m diamond --dmnd_ignore_warnings  -i /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/II_eggnog_annot/protein_fa/$sample.fa --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --itype proteins --excel
done

### 

conda activate anvio-7
for sample in `awk '{print $1}' '/lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/fasta_list.txt'`
do
sed 's/^\([0-9]\)/g\1/' /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/II_eggnog_annot/emapper_result/$sample/$sample.emapper.annotations > /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/II_eggnog_annot/emapper_result/$sample/$sample.emapper.annotations_fixed

anvi-script-run-eggnog-mapper -c /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/I_contig_db/$sample-contigs.db --annotation /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/II_eggnog_annot/emapper_result/$sample/$sample.emapper.annotations_fixed --use-version 2.1.6
done



# generate merged-contigs database

conda activate anvio-7
#
anvi-gen-genomes-storage -e /home/user/wlh_workpath/Omics_analysis/Pangenome_anvi/HL_panwork/AMZ_clade/external.txt \
                         -o /home/user/wlh_workpath/Omics_analysis/Pangenome_anvi/HL_panwork/AMZ_clade/PAN_result/PAN-all-GENOMES.db



# generate pangenome from merged-contigs database

conda activate anvio-7

anvi-pan-genome -g /home/user/wlh_workpath/Omics_analysis/Pangenome_anvi/HL_panwork/AMZ_clade/PAN_result/PAN-all-GENOMES.db \
                --use-ncbi-blast \
                -o /home/user/wlh_workpath/Omics_analysis/Pangenome_anvi/HL_panwork/AMZ_clade/PAN_result/proPAN-all-GENOME \
                --project-name proPAN-all \
                --num-threads 20  \
                --min-occurrence 5 \
                --minbit 0.5 \
                --mcl-inflation 8 


# run ANIm for pangenome

anvi-compute-genome-similarity -e  /home/user/wlh_workpath/Omics_analysis/Pangenome_anvi/HL_panwork/AMZ_clade/external.txt \
                                   --program pyANI \
				   --method ANIm \
                                   -o ANIm_AMZ \
                                   -T 20 \
                                   --pan-db  /home/user/wlh_workpath/Omics_analysis/Pangenome_anvi/HL_panwork/AMZ_clade/PAN_result/proPAN-all-GENOME/proPAN-all-PAN.db



# import layers for genomes

anvi-import-misc-data /data/wlh/数据分析/组学分析/泛基因组/2023608_wlh_HLI-II-VI211_分支/onlyCOG20/index/layer.txt \
                      -p  /data/wlh/数据分析/组学分析/泛基因组/2023608_wlh_HLI-II-VI211_分支/onlyCOG20/PANgenome_workfile/proPAN-211GENOME/PAN211-PAN.db \
                      --target-data-table layers


# visaulization

anvi-display-pan -p /home/user/wlh_workpath/Omics_analysis/Pangenome_anvi/HL_panwork/HLI_clade/PAN_result/all_123/proPAN-HLI123GENOME/HLI_proPAN123.db \
                 -g /home/user/wlh_workpath/Omics_analysis/Pangenome_anvi/HL_panwork/HLI_clade/PAN_result/all_123/PAN-GENOMES.db



# pre-split analysis

需要在可视化界面里，手动划分感兴趣的bin


# functional enrichment analysis

anvi-compute-functional-enrichment-in-pan -g '/data/wlh/数据分析/组学分析/泛基因组/20230606_wlh_new/PANgenome_workfile/PAN-110GENOMES.db' -p /data/wlh/数据分析/组学分析/泛基因组/20230606_wlh_new/PANgenome_workfile/target-SPLIT-BINS/HL_noncore/PAN.db --category clade --annotation-source COG20_FUNCTION -o COG20_FUNCTION_enriched-functions.txt


# export information of pangenome

anvi-summarize -p target-SPLIT-BINS/target/PAN.db \
               -g PAN-GENOMES.db \
               -C default \
               -o target-SPLIT-BINS/target/PAN-SUMMARY




