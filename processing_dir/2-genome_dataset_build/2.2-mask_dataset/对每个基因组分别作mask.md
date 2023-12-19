# 区域masking: 
## 识别mask区域
### 识别rRNA
#### metaxa2
```
conda activate metaxa2
metaxa2 --plus --mode m --cpu 32 --multi_thread T --table T -g ssu --not_found T  -1 all_2kb.fasta -o all_2kb.metaxa2_ssu

metaxa2 --plus --mode m --cpu 32 --multi_thread T --table T -g lsu --not_found T  -1 all_2kb.fasta -o all_2kb.metaxa2_lsu

cut -f 1,9,10 all_2kb.metaxa2_ssu.extraction.results >> masked_metaxa.bed

cut -f 1,9,10 all_2kb.metaxa2_lsu.extraction.results >> masked_metaxa.bed
```
#### barrnap
```
conda activate barrnap_wlh
barrnap --kingdom bac --threads 32 --reject 0.3 all_2kb.fasta > out_bac.gff

barrnap --kingdom arc --threads 32 --reject 0.3 all_2kb.fasta > out_arc.gff

barrnap --kingdom euk --threads 32 --reject 0.3 all_2kb.fasta > out_euk.gff

cut -f 1,4,5 out_bac.gff >> masked_barrnap.bed
cut -f 1,4,5 out_arc.gff >> masked_barrnap.bed
cut -f 1,4,5 out_euk.gff >> masked_barrnap.bed

cat masked_barrnap.bed masked_metaxa.bed > masked_rrna.bed


```
### 识别tRNA
#### tRNAscan-SE
```
conda activate tRNAscan-SE_wlh
tRNAscan-SE -A -b all_2kb.bedformat --thread 32 all_2kb.fasta

cut -f 1,2,3 all_2kb.bedformat >> masked_trna.bed
```

### 识别低复杂度区域
#### ncbi-cxx-toolkit - dustmasker
```
module load ncbi-cxx-toolkit

dustmasker -in all_mags_2kb_clean.fasta -out all_mags_2k_decontaminated.lowcom.out -outfmt acclist

sed 's/>//' all_mags_2k_decontaminated.lowcom.out > masked_dustmasker.bed
```

## 对以上区域进行mask
#### bedtools
```
cat masked_rrna.bed masked_trna.bed masked_dustmasker.bed > all_mags_2k_masked.bed

conda activate bedtools 
bedtools maskfasta -fi all_mags_2kb_clean.fasta -bed all_mags_2k_masked.bed -fo all_mags_2k_masked.fa