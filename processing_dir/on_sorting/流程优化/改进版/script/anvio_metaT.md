# merge multiple clade genome
```
for file in '/home/user/wlh_workpath/metaT/genome_data_and_edit/fasta_contig_name/*.fasta'
do
    cat $file >> /home/user/wlh_workpath/metaT/genome_data_and_edit/merge.fasta
done
```


# Generating anvi’o contigs databases for each metagenomic set
```
conda activate anvio-7
anvi-gen-contigs-database -f /home/user/wlh_workpath/metaT/genome_data_and_edit/merge.fasta -o /home/user/wlh_workpath/metaT/genome_data_and_edit/merge-CONTIGS.db -T 20
anvi-run-hmms -c /home/user/wlh_workpath/metaT/genome_data_and_edit/merge-CONTIGS.db \
              --num-threads 20
anvi-run-ncbi-cogs -c /home/user/wlh_workpath/metaT/genome_data_and_edit/merge-CONTIGS.db \
                   --num-threads 20 
anvi-run-kegg-kofams -c /home/user/wlh_workpath/metaT/genome_data_and_edit/merge-CONTIGS.db -T 20


### - eggnog 
anvi-get-sequences-for-gene-calls -c /home/user/wlh_workpath/metaT/genome_data_and_edit/merge-CONTIGS.db \
                                    --get-aa-sequences \
                                    -o /home/user/wlh_workpath/metaT/genome_data_and_edit/merge_protein.fa
conda activate emapper
mkdir /home/user/wlh_workpath/metaT/genome_data_and_edit/merge_annot
emapper.py --cpu 20 -o merge_all --output_dir /home/user/wlh_workpath/metaT/genome_data_and_edit/merge_annot --override -m diamond --dmnd_ignore_warnings  -i /home/user/wlh_workpath/metaT/genome_data_and_edit/merge_protein.fa --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --itype proteins --excel

sed 's/^\([0-9]\)/g\1/' /home/user/wlh_workpath/metaT/genome_data_and_edit/merge_annot/merge_all.emapper.annotations > /home/user/wlh_workpath/metaT/genome_data_and_edit/merge_annot/merge_all.emapper.annotations/merge_all.emapper.annotations_fixed

anvi-script-run-eggnog-mapper -c /home/user/wlh_workpath/metaT/genome_data_and_edit/merge-CONTIGS.db --annotation /home/user/wlh_workpath/metaT/genome_data_and_edit/merge_annot/merge_all.emapper.annotations/merge_all.emapper.annotations_fixed --use-version 2.1.6


anvi-export-gene-calls -c  /home/user/wlh_workpath/metaT/genome_data_and_edit/merge-CONTIGS.db -o /home/user/wlh_workpath/metaT/genome_data_and_edit/gene_calls_summary.txt

```



# Recruitment of metagenomic reads
```
bowtie2-build 1.fasta  merged
```
### (1h)
```
conda activate anvio-7
mkdir bam
for sample in `awk '{print $1}'  samples1.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi    
    # do the bowtie mapping to get the SAM file:
    bowtie2 --threads 10 \
            -x /home/user/wlh_workpath/metaT/Genome_v_dRep95/bowtie_build/merge \
            -1 /media/user/数据/gj/Tara-metaT/1/$sample-QUALITY_PASSED_R1.fastq \
            -2 /media/user/数据/gj/Tara-metaT/1/$sample-QUALITY_PASSED_R2.fastq \
            --no-unal \
            -S $sample.sam  
        samtools view -F 4 -bS $sample.sam > $sample-RAW.bam
        samtools sort $sample-RAW.bam -o bam/$sample.bam
        samtools index bam/$sample.bam
        rm $sample.sam $sample-RAW.bam
done
``` 
### (15min×n）
  

# Profiling the mapping results with anvi’o
```
for sample in `awk '{print $1}'  samples4.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
    anvi-profile -c merge-CONTIGS.db \
                 -i bam/$sample.sam \
                 --profile-SCVs \
                 --num-threads 10 \
                 -o $sample
done
```
### (25min×n）
 
 
 
# Profiling the mapping results with anvi’o
```
mkdir profile
for sample in `awk '{print $1}' samples3.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
    anvi-profile -c /home/user/wlh_workpath/metaT/genome_data_and_edit/merge-CONTIGS.db \
                 -i bam/$sample.bam \
                 --profile-SCVs \
                 --num-threads 20 \
                 -o profile/$sample
done (25min×n）
```

# Generating merged anvi’o profiles
```
anvi-merge */PROFILE.db -o 3-merged -c /home/user/wlh_workpath/metaT/genome_data_and_edit/merge-CONTIGS.db --enforce-hierarchical-clustering  （30min/20)(1.5h/80） (1h/50)
```

# Generating a collection
```
for split_name in `sqlite3  /home/wlh/workpath/metaT/Genome_v_dRep95/merge-CONTIGS.db 'select split from splits_basic_info;'`
do
 which
    GENOME=`echo $split_name | awk 'BEGIN{FS="-"}{print $1}'`
    echo -e "$split_name\t$GENOME"
done > merge-GENOME-COLLECTION2.txt  （1.5h） （2.5h)



anvi-import-collection merge-GENOME-COLLECTION.txt \
                       -c /home/user/wlh_workpath/metaT/genome_data_and_edit/merge-CONTIGS.db \
                       -p 3-merged/PROFILE.db \
                       -C Genomes   （4h）


anvi-show-collections-and-bins -p 3-merged/PROFILE.db

anvi-summarize -c /home/user/wlh_workpath/metaT/genome_data_and_edit/merge-CONTIGS.db \
               -p 3-merged/PROFILE.db \
               -C Genomes \
               --init-gene-coverages \
               -o try3-SUMMARY
```






