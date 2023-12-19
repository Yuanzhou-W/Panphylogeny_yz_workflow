![[pan_data_prepare.sh]]
# CONVERT TO THE RIGHT FILEPATH
cd "/number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/"


# Profiling the mapping results with anvi’o
mamba activate anvio-8
anvi-gen-contigs-database  \
                           -f Pro_outSyn.fasta \
                           -o Pro_outSyn-contigs.db --num-threads 32


# annote the contigs database by anvio
anvi-run-hmms -c Pro_outSyn-contigs.db --num-threads 32 --just-do-it
anvi-run-kegg-kofams -c Pro_outSyn-contigs.db -T 32 --just-do-it
anvi-run-ncbi-cogs -c Pro_outSyn-contigs.db
anvi-run-cazymes -c Pro_outSyn-contigs.db -T 32
anvi-run-pfams -c Pro_outSyn-contigs.db -T 32
anvi-run-interacdome -c Pro_outSyn-contigs.db -T 32


# annote the contigs database by eggnog
mkdir Pro_outSyn-eggnog
anvi-get-sequences-for-gene-calls -c Pro_outSyn-contigs.db \
                                  --get-aa-sequences \
                                  -o Pro_outSyn-eggnog/Pro_outSyn.fa
mamba activate emapper
emapper.py --cpu 32 -o Pro_outSyn --output_dir Pro_outSyn-eggnog --override -m diamond --dmnd_ignore_warnings  -i Pro_outSyn-eggnog/Pro_outSyn.fa --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --itype proteins --excel

mamba activate anvio-8
sed 's/^\([0-9]\)/g\1/' Pro_outSyn-eggnog/Pro_outSyn.emapper.annotations > Pro_outSyn-eggnog/Pro_outSyn.emapper.annotations_fixed

anvi-script-run-eggnog-mapper -c Pro_outSyn-contigs.db \
                              --annotation Pro_outSyn-eggnog/Pro_outSyn.emapper.annotations_fixed \
                              --use-version 2.1.6


# Prepare the genome-bin collection
for split_name in `sqlite3 Pro_outSyn-contigs.db 'select split from splits_basic_info;'`
do
 which
    GENOME=`echo $split_name | awk 'BEGIN{FS="-"}{print $1}'`
    echo -e "$split_name\t$GENOME"
done > Pro_outSyn-GENOME-COLLECTION.txt


# profling and merge mapping by anvio
cd mapping_profile/Profile_pct92/
for sample in `awk '{print $1}' mapping_profile/samples-506_pass_list.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
    anvi-profile -c Pro_outSyn-contigs.db \
                 -i /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_bam/$sample.bam \
                 --profile-SCVs \
                 --num-threads 40 \
                 -S $sample \
                 --min-percent-identity 92 \
                 --report-variability-full \
                 -o mapping_profile/Profile_pct92/$sample
done

cd mapping_profile/Profile_pct92

anvi-merge `awk '{print $1}' mapping_profile/merge/try_a/a.txt` \
           -o mapping_profile/merge/try_a/a/ \
           -c Pro_outSyn-contigs.db


# import the genome-bin collection to contig-database and merge-profile
anvi-import-collection Pro_outSyn-GENOME-COLLECTION.txt \
                       -c Pro_outSyn-contigs.db \
                       -p mapping_profile/merge/try_a/a/PROFILE.db \
                       -C Pro_outSysn619_Genome

anvi-summarize -c Pro_outSyn-contigs.db \
               -p mapping_profile/merge/try_a/a//PROFILE.db \
               -C Pro_outSysn619_Genome \
               --init-gene-coverages \
               -o mapping_profile/merge/try_a/a/a_summary






