# origin data-preparation
```
cd "/number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/"
mamba activate anvio-8
# Profiling the mapping results with anvi’o
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
```

# get the internal-genome.txt


# build the pangenome
## using the internal-genome.txt

## get the single-copy gene for phylogenetic analysis by iqtree

# build metabolic for strain