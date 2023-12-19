# checkm-genome
## 运行提供的maker gene
```
##查询phylum分类单元名录
checkm taxon_list  --rank phylum  --tmpdir /number1
/SUSTech_project/better_workflow_build/I_genome_pre_analysis/II_checkm/xubu_checkm/taxon_list/

###使用Cyanobacteria-phylum 和 Prochlorococcus-genus
checkm taxon_set phylum Cyanobacteria Cyanobacteria.ms


##根据分类单元的maker运行checkm
checkm taxon_set phylum Cyanobacteria Cyanobacteria.ms
checkm analyze Cyanobacteria.ms /number1/SUSTech_project/better_workflow_build/I_genome_pre_analysis/data_newname/ /number1/SUSTech_project/better_workflow_build/I_genome_pre_analysis/II_checkm/xubu_checkm/Cyanobacteria_result -x fasta  -t 40 --ali --nt 

for num in 1 2 3 4 5 6 7 8 9
do
checkm qa Cyanobacteria.ms  -o 4  /number1/SUSTech_project/better_workflow_build/I_genome_pre_analysis/II_checkm/xubu_checkm/Cyanobacteria_result --tab_table -f  /number1/SUSTech_project/better_workflow_build/I_genome_pre_analysis/II_checkm/xubu_checkm/Cyanobacteria_result/qa_o4.txt -a --aai_strain
done
done



checkm taxon_set genus   Prochlorococcus   Prochlorococcus.ms
checkm analyze Prochlorococcus.ms /number1/SUSTech_project/better_workflow_build/I_genome_pre_analysis/data_newname/ /number1/SUSTech_project/better_workflow_build/I_genome_pre_analysis/II_checkm/xubu_checkm/Prochlorococcus_result -x fasta  -t 40 --ali --nt 

for num in 1 2 3 4 5 6 7 8 9
do
checkm qa Prochlorococcus.ms /number1/SUSTech_project/better_workflow_build/I_genome_pre_analysis/II_checkm/xubu_checkm/Prochlorococcus_result -o $num --tab_table -f /number1/SUSTech_project/better_workflow_build/I_genome_pre_analysis/II_checkm/xubu_checkm/Prochlorococcus_result/qa_$num.txt -a --aai_strain
done

```

![[checkm_sh.txt]]

![[文件/qa.xlsx]]
## maker list构建
鉴于maker gene分布，以 数据集中的genius prochlorococcus为基础，去除PF02533.10、PF02532.9、PF02419.12 三个基因，构建新的marker list 。
![[Pasted image 20230818150757.png]]


# acdc 
**GitHub地址: [GitHub - mlux86/acdc: acdc - (a)utomated (c)ontamination (d)etection and (c)onfidence estimation for single-cell genome data](https://github.com/mlux86/acdc)**
```
acdc -I [path-to-fasta.list]

```

# drep
1. 第一次：com90 - ANIm98 - cont5，取非sc部分
2. 第二次：com50 - ANIm98 - cont5，取sc部分
	对单细胞测序基因组的完整度要求不要太高 >50
```
conda activate drep

dRep dereplicate /data/wlh/基因组数据_final/数据整理_Pro_Syn/drep_pro/ANImf/contam10/ANI95/dereplication359095/ -p 40 -g /data/wlh/基因组数据_final/数据整理_Pro_Syn/原绿球藻/data_newname/*.fasta --genomeInfo GENOMEINFO.csv   --gen_warnings --warn_dist 0.25 --warn_sim 0.98 --warn_aln 0.25 -comp 35 -con 10 -pa 0.9 -sa 0.95 


```