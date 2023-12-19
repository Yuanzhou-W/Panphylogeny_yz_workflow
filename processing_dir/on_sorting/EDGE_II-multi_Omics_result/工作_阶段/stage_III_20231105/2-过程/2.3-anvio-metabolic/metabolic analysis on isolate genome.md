![[metabolism.sh]]
# tutorial website
[Site Unreachable](https://merenlab.org/tutorials/infant-gut/)
# Estimating metabolism in the **selected** genomes
cd  /number1/SUSTech_project/workflow_v2/stage_III/metabolic_try_a/
## only numeric data
anvi-estimate-metabolism -i pro_subclade_genome_internal.txt \
                         -O metabolic_res/str57_internal/Pro_str7 \
                         --just-do-it \
                         --matrix-format 
                         --module-completion-threshold 0.75
                         **(default)**
## get more info
anvi-estimate-metabolism -i pro_subclade_genome_internal.txt \
                         -p /number1/SUSTech_project/workflow_v2/stage_III/data/anvio_origin/mapping_profile/merge/try_a/a/PROFILE.db \
                         -C Pro_outSysn619_Genome \
                         -O metaB_re \
                         --include-zeros \
                         --add-copy-number \
                         --include-kos-not-in-kofam \
                         --just-do-it \
                         --add-coverage \
                         --matrix-format \
                         --include-metadata
# visualization

## dry run to get the profile db:
cd metabolic_res/str57_internal

for sample in Pro_str7-enzyme_hits Pro_str7-module_pathwise_completeness Pro_str7-module_pathwise_presence Pro_str7-module_stepwise_completeness Pro_str7-module_stepwise_presence Pro_str7-step_completeness 
do
anvi-matrix-to-newick matrix/$sample-MATRIX.txt \
                      -o newick/$sample.newick
done 

## visualization the metabolic prediction (all results)
for sample in Pro_str7-enzyme_hits Pro_str7-module_pathwise_completeness Pro_str7-module_pathwise_presence Pro_str7-module_stepwise_completeness Pro_str7-module_stepwise_presence Pro_str7-step_completeness 
do
anvi-interactive --manual-mode \
                 -d matrix/$sample-MATRIX.txt \
                 -t newick/$sample.newick \
                 -p profile/$sample-PROFILE.db \
                 --title "Pro_str57 $sample Heatmap"
done

# generate a useful [miscellaneous data file](https://anvio.org/help/main/artifacts/misc-data-items-txt) to import into our profile database
## learn where the MODULES.db is:
export ANVIO_MODULES_DB=`python -c "import anvio; import os; print(os.path.join(os.path.dirname(anvio.__file__), '/home/user/anaconda3/envs/anvio-8/lib/python3.10/site-packages/anvio/data/misc/KEGG/MODULES.db'))"`

## start an empty file:
echo -e "module\tclass\tcategory\tsubcategory\tname" > modules_info.txt

## get module classes:
sqlite3 $ANVIO_MODULES_DB "select module, data_value from modules where data_name='CLASS'" | \
    sed 's/; /|/g' | \
    tr '|' '\t' >> module_class.txt

## get module names:
sqlite3 $ANVIO_MODULES_DB "select module,data_value from modules where data_name='NAME'" | \
    tr '|' '\t' > module_names.txt

## join everything
paste module_class.txt <(cut -f 2 module_names.txt ) >> modules_info.txt

# import this file into the established profile database
anvi-import-misc-data modules_info.txt \
                      -p Enterococcus_metabolism_PROFILE.db \
                      -t items

for sample in Pro_str7-enzyme_hits Pro_str7-module_pathwise_completeness Pro_str7-module_pathwise_presence Pro_str7-module_stepwise_completeness Pro_str7-module_stepwise_presence Pro_str7-step_completeness 
do
anvi-import-misc-data  modules_info.txt \
                      -p profile/$sample-PROFILE.db \
                      -t items
                      
anvi-import-misc-data  ko_list.txt \
                      -p profile/$sample-PROFILE.db \
                      -t items     
                      
done

# interactive visualizations
for sample in Pro_str7-enzyme_hits Pro_str7-module_pathwise_completeness Pro_str7-module_pathwise_presence Pro_str7-module_stepwise_completeness Pro_str7-module_stepwise_presence Pro_str7-step_completeness 
do
anvi-interactive --manual-mode \
                 -d matrix/$sample-MATRIX.txt \
                 -t newick/$sample.newick \
                 -p profile/$sample-PROFILE.db \
                 --title "Pro_str57 $sample Heatmap"
done


# Metabolism Enrichment
for sample in str57-enzyme_hits str57-module_pathwise_completeness str57-module_pathwise_presence str57-module_stepwise_completeness str57-module_stepwise_presence str57-step_completeness             
do     
anvi-compute-metabolic-enrichment -M matrix_info/$sample-MATRIX.txt \
                                  -G Group.txt \
                                  --include-samples-missing-from-groups-txt \
                                  -o enrichment/$sample-enriched_modules.txt

done






