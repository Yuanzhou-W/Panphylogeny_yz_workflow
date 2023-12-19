cd "/number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/"
mamba activate anvio-8
# Profiling the mapping results with anvi¡¯o
anvi-gen-contigs-database  \
                           -f /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn.fasta \
                           -o /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-contigs.db --num-threads 32
                           
# annote the contigs database by anvio
anvi-run-hmms -c /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-contigs.db --num-threads 32 --just-do-it
anvi-run-kegg-kofams -c /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-contigs.db -T 32 --just-do-it
anvi-run-ncbi-cogs -c /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-contigs.db
anvi-run-cazymes -c /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-contigs.db -T 32
anvi-run-pfams -c /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-contigs.db -T 32
anvi-run-interacdome -c /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-contigs.db -T 32

# annote the contigs database by eggnog
mkdir /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-eggnog
anvi-get-sequences-for-gene-calls -c /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-contigs.db \
                                  --get-aa-sequences \
                                  -o /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-eggnog/Pro_outSyn.fa
mamba activate emapper
emapper.py --cpu 32 -o Pro_outSyn --output_dir /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-eggnog --override -m diamond --dmnd_ignore_warnings  -i /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-eggnog/Pro_outSyn.fa --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --itype proteins --excel

mamba activate anvio-8
sed 's/^\([0-9]\)/g\1/' /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-eggnog/Pro_outSyn.emapper.annotations > /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-eggnog/Pro_outSyn.emapper.annotations_fixed

anvi-script-run-eggnog-mapper -c /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-contigs.db \
                              --annotation /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-eggnog/Pro_outSyn.emapper.annotations_fixed \
                              --use-version 2.1.6

# import collection
for split_name in `sqlite3 /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-contigs.db 'select split from splits_basic_info;'`
do
 which
    GENOME=`echo $split_name | awk 'BEGIN{FS="-"}{print $1}'`
    echo -e "$split_name\t$GENOME"
done > /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-GENOME-COLLECTION.txt

anvi-import-collection /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-GENOME-COLLECTION.txt \
                       -c /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-contigs.db \
                       -C Pro_outSyn_619Genomes



# profling mapping by anvio
cd /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/mapping_profile/Profile_pct92/
for sample in `awk '{print $1}' /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/mapping_profile/samples-506_pass_list.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
    anvi-profile -c /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-contigs.db \
                 -i /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_bam/$sample.bam \
                 --profile-SCVs \
                 --num-threads 40 \
                 -S $sample \
                 --min-percent-identity 92 \
                 --report-variability-full \
                 -o /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/mapping_profile/Profile_pct92/$sample
done

## try_a
cd /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/mapping_profile/Profile_pct92

anvi-merge `awk '{print $1}' /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/mapping_profile/merge/try_a/a.txt` \
           -o /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/mapping_profile/merge/try_a/a/ \
           -c /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-contigs.db


anvi-import-collection /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-GENOME-COLLECTION.txt \
                       -c /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-contigs.db \
                       -p /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/mapping_profile/merge/try_a/a/PROFILE.db \
                       -C Pro_outSysn619_Genome



anvi-summarize -c /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/Pro_outSyn-contigs.db \
               -p /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/mapping_profile/merge/try_a/a//PROFILE.db \
               -C Pro_outSysn619_Genome \
               --init-gene-coverages \
               -o /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/mapping_profile/merge/try_a/a/a_summary






