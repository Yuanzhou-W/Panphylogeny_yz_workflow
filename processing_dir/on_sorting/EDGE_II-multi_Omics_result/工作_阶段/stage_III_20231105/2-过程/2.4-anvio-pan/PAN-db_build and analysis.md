![[pan_isolate.sh]]
# build genome-storge-db by using the internal-genome.txt--way from merged contig-db
cd /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human
mamba activate anvio-8
anvi-gen-genomes-storage -i /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/pro_subclade_genome_internal.txt \
                         -o /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/str57-PAN-SAMPLE-storge-GENOMES.db

# build pan-db from genome-storge-db
anvi-pan-genome -g /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/str57-PAN-SAMPLE-storge-GENOMES.db \
                --use-ncbi-blast \
                --minbit 0.5 \
                --min-occurrence 5 \
                --mcl-inflation 8 \
                --project-name str57-PAN \
                --num-threads 40 \
                --I-know-this-is-not-a-good-idea \
                -o /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/PAN_GENOME

# get info form the pan-db and import to pan-db
anvi-compute-genome-similarity -i /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/pro_subclade_genome_internal.txt \
                               --program pyANI \
				--method ANIm \
                               -o /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/PAN_GENOME/ani.txt \
                               -T 20 \
                               --pan-db  /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/PAN_GENOME/str57-PAN-PAN.db


anvi-script-compute-bayesian-pan-core -p /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/PAN_GENOME/str57-PAN-PAN.db \
                                      -g /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/str57-PAN-SAMPLE-storge-GENOMES.db \
                                      -o /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/PAN_GENOME/pan_Core.tsv \
                                      --store-in-db \
                                      -T 40 \
                                      -B 1000


anvi-import-misc-data -p /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/PAN_GENOME/str57-PAN-PAN.db \
                      --target-data-table layers \
                      /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/Group.txt

# enrichment analysis on pan-db
for sample in EGGNOG_BACT  EGGNOG_COG_CATEGORY EGGNOG_KEGG_MODULE EGGNOG_KEGG_PATHWAYS EGGNOG_CAZy KEGG_Module KEGG_Class COG20_CATEGORY COG20_PATHWAY
do
anvi-compute-functional-enrichment-in-pan -p /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/PAN_GENOME/str57-PAN-PAN.db \
                                          -g /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/str57-PAN-SAMPLE-storge-GENOMES.db \
                                          --category-variable clade \
                                          --annotation-source $sample \
                                          -o //number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/PAN_enrichment/$sample-functional-enrichment.txt
done


# build profile-db based on function-merge
anvi-display-functions -i /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/pro_subclade_genome_internal.txt \
                       -g /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/str57-PAN-SAMPLE-storge-GENOMES.db \
                       --groups-txt /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/Group.txt \
                       --annotation-source EGGNOG_BACT \
                       --profile-db /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/EACT_FUNCTION \
                       --min-occurrence 3

# build metapan-db by using bam/sam-profile
anvi-meta-pan-genome -p /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/PAN_GENOME/str57-PAN-PAN.db \
                     -g /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/str57-PAN-SAMPLE-storge-GENOMES.db \
                     -i /number1/SUSTech_project/workflow_v2/stage_III/PAN_isolate_human/pro_subclade_genome_internal.txt \
                     --min-detection 0.25