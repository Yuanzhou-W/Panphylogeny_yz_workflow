#  鉴于数据大小问题，临时存放质控后数据与以下两个路径
## up350
  列表： /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/V_QC_by_fastp/samples_list_up350.txt
  文件路径：/number3/geotrace_up350fastq
## down242
  列表：/number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/V_QC_by_fastp/samples_list_down242.txt
  文件路径： /number2/geotrace_down242
  
  
# fastp 默认参数质控
## 默认： adapter 、 reads质量-Q15 、 slidewindow-Q20 、polyG 、UMI
```
fastp -i in.R1.fq.gz -I in.R2.fq.gz -o out.R1.fq.gz -O out.R2.fq.gz
```



###################



for sample in `awk '{print $1}' /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/V_QC_by_fastp/samples_list_up350_down175.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
    mamba activate multiqc
    cd /media/user/54d3d04b-f453-4e6a-9dec-9f973624edc3/geotracer610
    fastp -i $sample-QUALITY_PASSED_R1.fastq -I $sample-QUALITY_PASSED_R2.fastq -o /number3/geotrace_up350/$sample-QUALITY_fastp_R1.fastq -O /number3/geotrace_up350/$sample-QUALITY_fastp_R2.fastq -g -q 20 -h /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/V_QC_by_fastp/sample_fastp_report_html/$sample-fastp.html -w 16 -R "$sample-fastp"  -j /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/V_QC_by_fastp/sample_fastp_report_json/$sample-fastp.json
    
    mamba activate bowtie2.5.1
    cd /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2
    bowtie2 --threads 36 -x /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/III_refgenome-and-refpangenome/IV_ref_bowtie-build/Pro_outsyn -1 /number3/geotrace_up350/$sample-QUALITY_fastp_R1.fastq -2 /number3/geotrace_up350/$sample-QUALITY_fastp_R2.fastq --no-unal  --very-sensitive -S /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_sam/$sample.sam 2> /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_log/$sample.log
            
        samtools view -F 4 -bS /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_sam/$sample.sam > /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_raw_bam/$sample-RAW.bam
        samtools sort /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_raw_bam/$sample-RAW.bam -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_bam/$sample.bam
        samtools index /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_bam/$sample.bam
        
        rm /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_sam/$sample.sam /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_raw_bam/$sample-RAW.bam


done  #(15min×n）



## 


for sample in `awk '{print $1}' /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/V_QC_by_fastp/samples_list_up350_up175.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
    mamba activate multiqc
    cd /media/user/54d3d04b-f453-4e6a-9dec-9f973624edc3/geotracer610
    fastp -i $sample-QUALITY_PASSED_R1.fastq -I $sample-QUALITY_PASSED_R2.fastq -o /number3/geotrace_up350/$sample-QUALITY_fastp_R1.fastq -O /number3/geotrace_up350/$sample-QUALITY_fastp_R2.fastq -g -q 20 -h /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/V_QC_by_fastp/sample_fastp_report_html/$sample-fastp.html -w 16 -R "$sample-fastp" -j /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/V_QC_by_fastp/sample_fastp_report_json/$sample-fastp.json
    
    mamba activate bowtie2.5.1
    cd /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2
    bowtie2 --threads 36 -x /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/III_refgenome-and-refpangenome/IV_ref_bowtie-build/Pro_outsyn -1 /number3/geotrace_up350/$sample-QUALITY_fastp_R1.fastq -2 /number3/geotrace_up350/$sample-QUALITY_fastp_R2.fastq --no-unal  --very-sensitive -S /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_sam/$sample.sam 2> /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_log/$sample.log
            
        samtools view -F 4 -bS /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_sam/$sample.sam > /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_raw_bam/$sample-RAW.bam
        samtools sort /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_raw_bam/$sample-RAW.bam -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_bam/$sample.bam
        samtools index /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_bam/$sample.bam
        
        rm /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_sam/$sample.sam /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_raw_bam/$sample-RAW.bam


done  #(15min×n）



























 #####################33

for sample in `awk '{print $1}' /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/V_QC_by_fastp/samples_list_down242_up100.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
    mamba activate multiqc
    cd /media/user/54d3d04b-f453-4e6a-9dec-9f973624edc3/geotracer610
    fastp -i $sample-QUALITY_PASSED_R1.fastq -I $sample-QUALITY_PASSED_R2.fastq -o /number2/geotrace_down242/$sample-QUALITY_fastp_R1.fastq -O /number2/geotrace_down242/$sample-QUALITY_fastp_R2.fastq -g -q 20 -h /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/V_QC_by_fastp/sample_fastp_report_html/$sample-fastp.html -w 16 -R "$sample-fastp" -j /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/V_QC_by_fastp/sample_fastp_report_json/$sample-fastp.json
    
    mamba activate bowtie2.5.1
    cd /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2
    bowtie2 --threads 36 -x /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/III_refgenome-and-refpangenome/IV_ref_bowtie-build/Pro_outsyn -1 /number2/geotrace_down242/$sample-QUALITY_fastp_R1.fastq -2 /number2/geotrace_down242/$sample-QUALITY_fastp_R2.fastq --no-unal --very-sensitive -S /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_sam/$sample.sam 2> /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_log/$sample.log
            
        samtools view -F 4 -bS /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_sam/$sample.sam > /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_raw_bam/$sample-RAW.bam
        samtools sort /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_raw_bam/$sample-RAW.bam -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_bam/$sample.bam
        samtools index /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_bam/$sample.bam
        
        rm /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_sam/$sample.sam /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_raw_bam/$sample-RAW.bam


done  #(15min×n）


###


for sample in `awk '{print $1}' /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/V_QC_by_fastp/samples_list_down242_down142.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
    mamba activate multiqc
    cd /media/user/54d3d04b-f453-4e6a-9dec-9f973624edc3/geotracer610
    fastp -i $sample-QUALITY_PASSED_R1.fastq -I $sample-QUALITY_PASSED_R2.fastq -o /number2/geotrace_down242/$sample-QUALITY_fastp_R1.fastq -O /number2/geotrace_down242/$sample-QUALITY_fastp_R2.fastq -g -q 20 -h /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/V_QC_by_fastp/sample_fastp_report_html/$sample-fastp.html -w 16 -R "$sample-fastp" -j /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/V_QC_by_fastp/sample_fastp_report_json/$sample-fastp.json
    
    mamba activate bowtie2.5.1
    cd /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2
    bowtie2 --threads 36 -x /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/III_refgenome-and-refpangenome/IV_ref_bowtie-build/Pro_outsyn -1 /number2/geotrace_down242/$sample-QUALITY_fastp_R1.fastq -2 /number2/geotrace_down242/$sample-QUALITY_fastp_R2.fastq --no-unal --very-sensitive -S /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_sam/$sample.sam 2> /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_log/$sample.log
            
        samtools view -F 4 -bS /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_sam/$sample.sam > /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_raw_bam/$sample-RAW.bam
        samtools sort /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_raw_bam/$sample-RAW.bam -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_bam/$sample.bam
        samtools index /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_bam/$sample.bam
        
        rm /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_sam/$sample.sam /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/VI_bowtie2/sample_raw_bam/$sample-RAW.bam


done  #(15min×n）
 
 
 
