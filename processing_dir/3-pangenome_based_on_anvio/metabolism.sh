

##########################metabolic





anvi-summarize -p /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/PAN_sample_db/PAN-GENOME/Pro618-PAN-PAN.db \
               -g /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/PAN_sample_db/Pro618-PAN-SAMPLE-storge-GENOMES.db \
               -C C_A \
               -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/PAN_sample_db/PAN-GENOME/SUMMARY
            
             
              
anvi-estimate-metabolism -i /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/II_Metabolic_SAMPLE_db/internal_genomes_prosyn.txt \
                         -p /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/SAMPLE_Profile_db/MERGE_506/pct95/PROFILE.db \
                         -C Genomes_Pro618 \
                         -O /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_V_analysis_of_mapping/IV_anvio_metapangenome/II_Metabolic_SAMPLE_db/kegg_metabolic \
                         --include-zeros \
                         --add-copy-number \
                         --include-kos-not-in-kofam \
                         --just-do-it \
                         --add-coverage \
                         --matrix-format \
                         --include-metadata \
                         
                         


anvi-matrix-to-newick Enterococcus-completeness-MATRIX.txt


anvi-estimate-metabolism -e additional-files/pangenomics/external-genomes.txt \
                         -O Enterococcus \
                         --matrix-format











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
