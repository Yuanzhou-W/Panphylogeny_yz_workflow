[[常规anvio-pangenome]]
# 挑选核心基因
[anvi-get sequence-for-gene-cluster](https://anvio.org/help/7.1/programs/anvi-get-sequences-for-gene-clusters/)
[An anvi'o workflow for phylogenomics]([An anvi'o workflow for phylogenomics – (merenlab.org)](https://merenlab.org/2017/06/07/phylogenomics/#pangenomic--phylogenomics))
[Single-cell 'Omics with anvi'o – (merenlab.org)](https://merenlab.org/tutorials/single-cell-genomics/)
# 按照泛基因组划分核心基因bin
```
anvi-display-pan -p PAN.db -g storge-genomes.db
#人工在可视化界面中选择 - 或者 用参数筛选
```
# 输出bin的PAN
```
anvi-split -g /data/wlh/数据分析/组学分析/泛基因组/20230606_wlh_new/PANgenome_workfile/PAN-110GENOMES.db \
           -p /data/wlh/数据分析/组学分析/泛基因组/20230606_wlh_new/PANgenome_workfile/proPANGENOME110/PAN110-PAN.db \
           -C split_v1 \
           -o target-SPLIT-BINS
```
# 输出核心基因簇 - 需要蛋白质序列
```
anvi-get-sequences-for-gene-clusters -g genomes-storage-db \
                                     -p pan-[Core]-db \
                                     -o genes-fasta

```
# 将不同的簇分离为不同的fasta

```
# -*- coding: utf-8 -*-
"""
Created on Tue Aug  8 16:49:07 2023

@author: 15982
"""

from collections import defaultdict
import os

def parse_fasta(file_path):
    """Parse a FASTA file and return sequences as a dictionary."""
    sequences = {}
    with open(file_path, 'r') as f:
        sequence = ""
        header = ""
        for line in f:
            line = line.strip()
            if line.startswith(">"):
                if header:
                    sequences[header] = sequence
                    sequence = ""
                header = line[1:]
            else:
                sequence += line
        if header:
            sequences[header] = sequence
    return sequences

def cluster_sequences(input_file_path, output_folder_path):
    # Parse the fasta file
    fasta_data = parse_fasta(input_file_path)

    # Classify sequences based on gene_cluster
    clusters = defaultdict(list)
    for header, sequence in fasta_data.items():
        cluster_name = [x.split(":")[1] for x in header.split("|") if x.startswith("gene_cluster")][0]
        clusters[cluster_name].append((header, sequence))
    
    # Create the output folder if it doesn't exist
    if not os.path.exists(output_folder_path):
        os.makedirs(output_folder_path)
    
    # Save each cluster to a separate fasta file
    for cluster, sequences in clusters.items():
        with open(os.path.join(output_folder_path, f"{cluster}.fasta"), "w") as f:
            for header, sequence in sequences:
                f.write(f">{header}\n{sequence}\n")

if __name__ == "__main__":
    INPUT_FILE_PATH = input("请输入需要处理的文件路径：")
    OUTPUT_FOLDER_PATH = input("请输入输出文件夹路径：")

    cluster_sequences(INPUT_FILE_PATH, OUTPUT_FOLDER_PATH)

```
# (1) anvi - 核心基因簇和系统发生
```
anvi-gen-phylogenomic-tree -f concatenated-gene-alignment-fasta \
                           -o PATH/TO/phylogeny

```
# (2) muscle & trimAI & iqtree - 对每个核心基因簇建树
## 序列比对-muscle
```
for sample in `awk '{print $1}' '/lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/contig_db_withouteggnog/pre_visualize/contig_db_withouteggnog/target_bin/Core/clustername.txt'`
do
muscle -in /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/contig_db_withouteggnog/pre_visualize/contig_db_withouteggnog/target_bin/Core/cluster/$sample.fasta -out /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/contig_db_withouteggnog/pre_visualize/contig_db_withouteggnog/target_bin/Core/cluster_msa//$sample.msa
done
```
## 文件路径处理
``` {对于msa文件路径上的一些处理}
for sample in `awk '{print $1}' '/lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/contig_db_withouteggnog/pre_visualize/contig_db_withouteggnog/target_bin/Core/clustername.txt'`
do
mkdir /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/contig_db_withouteggnog/pre_visualize/contig_db_withouteggnog/target_bin/Core/cluster_msa/tree/$sample
cp /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/contig_db_withouteggnog/pre_visualize/contig_db_withouteggnog/target_bin/Core/cluster_msa/msa/$sample.msa  /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/contig_db_withouteggnog/pre_visualize/contig_db_withouteggnog/target_bin/Core/cluster_msa/tree/$sample
done
```
## trimAI修剪
[GitHub - inab/trimal](https://github.com/inab/trimal)
```
trimal -in AtARFs.muscle.aln -out AtARFs.muscle.trimal.aln -automated1
```
## iqtree建树
[GitHub - iqtree/iqtree2](https://github.com/iqtree/iqtree2)
[如何构建进化树 | 基于IQ-TREE - 知乎](https://zhuanlan.zhihu.com/p/408382758#:~:text=iqtree%20-s%20example.phy%20-s%3A%20%E6%8C%87%E5%AE%9A%E8%BE%93%E5%85%A5%E7%9A%84%E6%AF%94%E5%AF%B9%E7%9A%84%E7%BB%93%E6%9E%9C%20%E8%BE%93%E5%87%BA%E4%B8%89%E4%B8%AA%E6%96%87%E4%BB%B6%20example.phy.iqtree%3A,%E8%AE%A1%E7%AE%97%E7%BB%93%E6%9E%9C%20example.phy.treefile%3A%20NEWICK%E6%A0%BC%E5%BC%8F%E7%9A%84%E8%AE%A1%E7%AE%97%E7%BB%93%E6%9E%9C%EF%BC%8C%E5%8F%AF%E4%BB%A5%E5%B0%86%E6%AD%A4%E6%96%87%E4%BB%B6%E8%BE%93%E5%85%A5%E7%BB%99%20FigTree%E6%88%96%E8%80%85iTOL%E8%BF%9B%E8%A1%8C%E5%8F%AF%E8%A7%86%E5%8C%96%20example.phy.log%3A%20log%20%E6%96%87%E4%BB%B6)
```
for sample in `awk '{print $1}' '/lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/contig_db_withouteggnog/pre_visualize/contig_db_withouteggnog/target_bin/Core/clustername.txt'`
do
cd /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/contig_db_withouteggnog/pre_visualize/contig_db_withouteggnog/target_bin/Core/cluster_msa/tree/$sample/
iqtree -s /lomi_home/wangluhang/SUSTech_project/task/anvio-pangenome/contig_db_withouteggnog/pre_visualize/contig_db_withouteggnog/target_bin/Core/cluster_msa/tree/$sample/$sample.msa -nt AUTO
done

#####
iqtree -s AtARFs.muscle.trimal.aln -m MFP -nt 2 -bb 5000 -bnni -pre AtARFs.muscle.trimal.iqtree -redo 
####
iqtree -s example.phy -m MFP -B 1000 -alrt 1000 -T 2
# -B 和 -alrt可以同时使用
# 结果和值在 treefile会写

```

