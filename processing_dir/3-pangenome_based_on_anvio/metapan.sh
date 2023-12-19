mamba activate anvio-7

# Profiling the mapping results with anvi’o
cd /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance 
for sample in `awk '{print $1}' /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/sample_geotrace_list.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
    anvi-profile -c /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/Pro_outsyn-CONTIGS.db \
                 -i /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_bam/$sample.bam \
                 --profile-SCVs \
                 --num-threads 40 \
                 -S $sample \
                 --min-percent-identity 98 \
                 --report-variability-full \
                 -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/I_profiling_mapping_min98/$sample
done ##(25min×n）



######################################################################################
cd /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance 
cd /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/I_profiling_mapping


anvi-export-splits-and-coverages -p /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/I_profiling_mapping/$sample/PROFILE.db \
                                 -c /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/Pro_outsyn-CONTIGS.db \
                                 --use-Q2Q3-coverages \
                                 --report-contigs \
                                 -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/II_coverage_contigs/$sample.coverages.txt
   
   
   
   
                                 
#########################################################################################                   
cd /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/I_profiling_mapping_min98  

anvi-merge `awk '{print $6}' /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/align_0.03_sample.txt` -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/III_summary/pct98/ -c /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/Pro_outsyn-CONTIGS.db


anvi-import-collection /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/Pro_outsyn-GENOME-COLLECTION.txt \
                       -c /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/Pro_outsyn-CONTIGS.db \
                       -p /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/III_summary/pct98/PROFILE.db \
                       -C Genome

anvi-summarize -c /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/Pro_outsyn-CONTIGS.db \
               -p /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/III_summary/pct98/PROFILE.db \
               -C Genome \
               --init-gene-coverages \
               -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/III_summary/pct98/geotrace_pct98_summary






cd /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/I_profiling_mapping_min95 

anvi-merge `awk '{print $6}' /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/align_0.03_sample.txt` -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/III_summary/pct95/ -c /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/Pro_outsyn-CONTIGS.db


anvi-import-collection /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/Pro_outsyn-GENOME-COLLECTION.txt \
                       -c /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/Pro_outsyn-CONTIGS.db \
                       -p /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/III_summary/pct95/PROFILE.db \
                       -C Genome


anvi-summarize -c /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/Pro_outsyn-CONTIGS.db \
               -p /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/III_summary/pct95/PROFILE.db \
               -C Genome \
               --init-gene-coverages \
               -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/III_summary/pct95/geotrace_pct98_summary



#######################metapan

cd /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/I_anvio_abundance/I_profiling_mapping_min95/
anvi-merge `awk '{print $1}' /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/samples-506.txt` \
                             -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/SAMPLE_Profile_db/MERGE_506/ \
                             -c /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/Contig_db_619/Pro_outsyn-CONTIGS.db


cd /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/
anvi-import-collection /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/Contig_db_619/Pro_outsyn-GENOME-COLLECTION.txt \
                       -c /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/Contig_db_619/Pro_outsyn-CONTIGS.db \
                       -p /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/SAMPLE_Profile_db/MERGE_506/pct95/PROFILE.db \
                       -C  Genomes_Pro618
                       


anvi-summarize -c /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/Contig_db_619/Pro_outsyn-CONTIGS.db \
               -p /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/SAMPLE_Profile_db/MERGE_506/pct95/PROFILE.db \
               -C Genomes_Pro618 \
               --init-gene-coverages \
               -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/SAMPLE_Profile_db/MERGE_506/pct95/summary/ \
               --quick-summary \
               --just-do-it





anvi-gen-genomes-storage -i /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/I_PAN-METAPAN/internal_genomes_prosyn.txt \
                         -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/I_PAN-METAPAN/str619-PAN-SAMPLE-storge-GENOMES.db



anvi-gen-genomes-storage -i /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/Contig_db_619/mask/internal_genomes_onlyPro.txt \
                         -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/PAN_sample_db/Pro618-PAN-SAMPLE-storge-GENOMES.db






anvi-pan-genome -g /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/I_PAN-METAPAN/str619-PAN-SAMPLE-storge-GENOMES.db \
                --use-ncbi-blast \
                --minbit 0.5 \
                --min-occurrence 5 \
                --mcl-inflation 8 \
                --project-name str619-PAN \
                --num-threads 40 \
                --I-know-this-is-not-a-good-idea \
                -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/I_PAN-METAPAN//PAN-GENOME 




anvi-compute-genome-similarity -i /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/Contig_db_619/mask/internal_genomes_onlyPro.txt \
                                   --program pyANI \
				   --method ANIm \
                                   -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/PAN_sample_db/PAN-GENOME/ani.txt \
                                   -T 20 \
                                   --pan-db  /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/PAN_sample_db/PAN-GENOME/Pro618-PAN-PAN.db

anvi-script-compute-bayesian-pan-core -p /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/PAN_sample_db/PAN-GENOME/Pro618-PAN-PAN.db \
                                      -g /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/PAN_sample_db/Pro618-PAN-SAMPLE-storge-GENOMES.db \
                                      -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/PAN_sample_db/pan_Core.tsv --store-in-db -T 40 -B 1000



anvi-display-functions -i /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/Contig_db_619/mask/internal_genomes_onlyPro.txt \
                       -g /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/PAN_sample_db/Pro618-PAN-SAMPLE-storge-GENOMES.db \
                       --groups-txt /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/FUNC_PAN_sample_db/Pro_618/internal_genomes_Group.txt \
                       --annotation-source EGGNOG_BACT \
                       --profile-db /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/FUNC_PAN_sample_db/Pro_618/EGGNOG_BACT-PROFILE.db \
                       --min-occurrence 5








  
anvi-meta-pan-genome -p /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/I_PAN-METAPAN/Pro618-PAN-PAN.db \
                     -g /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/I_PAN-METAPAN/str619-PAN-SAMPLE-storge-GENOMES.db \
                     -i /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/I_PAN-METAPAN/a2/internal_genomes_a2prosyn.txt \
                     --min-detection 0.2














##########################metabolic


anvi-estimate-metabolism -i /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/Metabolic_SAMPLE_db/internal_genomes_onlyPro.txt \
                         -p /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/FUNC_PAN_sample_db/Pro_618/EGGNOG_BACT-PROFILE.db \
                         -C Genomes_Pro618 \
                         -O /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/Metabolic_SAMPLE_db/matbolic \
                         --include-kos-not-in-kofam \
                         --include-zeros \
                         --matrix-format \
                         --include-metadata 

anvi-matrix-to-newick Enterococcus-completeness-MATRIX.txt














# dry run to get the profile db:
anvi-interactive -d Enterococcus-completeness-MATRIX.txt \
                 -p Enterococcus_metabolism_PROFILE.db \
                 --manual-mode \
                 --dry-run

# import the state file:
anvi-import-state -s additional-files/state-files/state-metabolism.json \
                  -p Enterococcus_metabolism_PROFILE.db \
                  -n default

# run for reals:
anvi-interactive --manual-mode \
                 -d Enterococcus-completeness-MATRIX.txt \
                 -t Enterococcus-completeness-MATRIX.txt.newick \
                 -p Enterococcus_metabolism_PROFILE.db \
                 --title "Enterococcus Metabolism Heatmap"


####
# learn where the MODULES.db is:
export ANVIO_MODULES_DB=`python -c "import anvio; import os; print(os.path.join(os.path.dirname(anvio.__file__), 'data/misc/KEGG/MODULES.db'))"`

# start an empty file:
echo -e "module\tclass\tcategory\tsubcategory\tname" > modules_info.txt

# get module classes:
sqlite3 $ANVIO_MODULES_DB "select module, data_value from modules where data_name='CLASS'" | \
    sed 's/; /|/g' | \
    tr '|' '\t' >> module_class.txt

# get module names:
sqlite3 $ANVIO_MODULES_DB "select module,data_value from modules where data_name='NAME'" | \
    tr '|' '\t' > module_names.txt

# join everything
paste module_class.txt <(cut -f 2 module_names.txt ) >> modules_info.txt

# empty the trash bin:
rm module_names.txt module_class.txt
####
anvi-import-misc-data additional-files/metabolism/modules_info.txt \
                      -p Enterococcus_metabolism_PROFILE.db \
                      -t items


anvi-import-state -s additional-files/metabolism/metabolism_state.json \
                  -p Enterococcus_metabolism_PROFILE.db \
                  -n default
                  
                  
                  
anvi-estimate-metabolism -e additional-files/pangenomics/external-genomes.txt \
                         -O Enterococcus_metabolism \
                         --kegg-output-modes modules,kofam_hits


anvi-compute-metabolic-enrichment -M Enterococcus_metabolism_modules.txt \
                                  -G additional-files/metabolism/entero_groups.txt \
                                  -o Enterococcus_enriched_modules.txt
