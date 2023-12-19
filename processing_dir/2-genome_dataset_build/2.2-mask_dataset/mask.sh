# 区域masking: 
## 识别mask区域
### 识别rRNA
#### metaxa2
mamba activate metaxa2
for sample in `awk '{print $1}' '/number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/Pro_genome_list-drep2598.txt'`
do
mkdir /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample
mkdir /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/I_metaxa2


metaxa2 --plus --mode m --cpu 32 --multi_thread T --table T -g ssu --not_found T  -1 /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/data_genome_drep2598/$sample.fasta -o  /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/I_metaxa2/$sample.metaxa2_ssu

metaxa2 --plus --mode m --cpu 32 --multi_thread T --table T -g lsu --not_found T  -1 /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/data_genome_drep2598/$sample.fasta -o /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/I_metaxa2/$sample.metaxa2_lsu

cut -f 1,9,10 /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/I_metaxa2/$sample.metaxa2_ssu.extraction.results >> /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/I_metaxa2/masked_metaxa.bed

cut -f 1,9,10 /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/I_metaxa2/$sample.metaxa2_lsu.extraction.results >> /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/I_metaxa2/masked_metaxa.bed

done

#### barrnap

mamba activate barrnap_wlh

for sample in `awk '{print $1}' '/number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/Pro_genome_list-drep2598.txt'`
do
mkdir /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/II_barrnap

conda activate barrnap_wlh
barrnap --kingdom bac --threads 32 --reject 0.3 /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/data_genome_drep2598/$sample.fasta > /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/II_barrnap/out_bac.gff

barrnap --kingdom arc --threads 32 --reject 0.3 /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/data_genome_drep2598/$sample.fasta > /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/II_barrnap/out_arc.gff

barrnap --kingdom euk --threads 32 --reject 0.3 /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/data_genome_drep2598/$sample.fasta > /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/II_barrnap/out_euk.gff

cut -f 1,4,5 /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/II_barrnap/out_bac.gff >> /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/II_barrnap/masked_barrnap.bed
cut -f 1,4,5 /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/II_barrnap/out_arc.gff >> /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/II_barrnap/masked_barrnap.bed
cut -f 1,4,5 /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/II_barrnap/out_euk.gff >> /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/II_barrnap/masked_barrnap.bed

cat /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/II_barrnap/masked_barrnap.bed /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/I_metaxa2/masked_metaxa.bed > /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/masked_rrna.bed

done
### 识别tRNA
#### tRNAscan-SE

mamba activate tRNAscan-SE_wlh
for sample in `awk '{print $1}' '/number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/Pro_genome_list-drep2598.txt'`
do
mkdir /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/III_tRNAscan

tRNAscan-SE -A -b /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/III_tRNAscan/$sample.bedformat --thread 32 /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/data_genome_drep2598/$sample.fasta

cut -f 1,2,3 /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/III_tRNAscan/$sample.bedformat >> /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/III_tRNAscan/masked_trna.bed

done

### 识别低复杂度区域
#### ncbi-cxx-toolkit - dustmasker
mamba activate tRNAscan-SE_wlh
for sample in `awk '{print $1}' '/number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/Pro_genome_list-drep2598.txt'`
do
mkdir /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/IV_dustmasker

dustmasker -in /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/data_genome_drep2598/$sample.fasta -out /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/IV_dustmasker/$sample_decontaminated.lowcom.out -outfmt acclist

sed 's/>//' /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/IV_dustmasker/$sample_decontaminated.lowcom.out > /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/IV_dustmasker/masked_dustmasker.bed

done 


## 对以上区域进行mask
#### bedtools
mamba activate bedtools
for sample in `awk '{print $1}' '/number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/Pro_genome_list-drep2598.txt'`
do
mkdir /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/V_bedtools


cat /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/masked_rrna.bed /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/III_tRNAscan/masked_trna.bed /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/IV_dustmasker/masked_dustmasker.bed > /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/V_bedtools/$sample_masked.bed

bedtools maskfasta -fi /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/data_genome_drep2598/$sample.fasta -bed /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/V_bedtools/$sample_masked.bed -fo /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/$sample.masked.fa




done






for sample in `awk '{print $1}' '/number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/Pro_genome_list-drep2598.txt'`
do

cp /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/I_genome_workdir/$sample/$sample.masked.fa /number1/SUSTech_project/workflow_v2/stage_II_20230928/edge_IV_mapping/I_genome_mask/II_genome_masked/$sample.fasta


done 






