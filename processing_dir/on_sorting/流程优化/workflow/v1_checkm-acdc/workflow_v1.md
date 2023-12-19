# I_Prochlorococcus-checkm
## 步骤
1. checkm_1.0.2 基于提供的 Prochlorococcus(genius) 序列集，计算了质量相关参数
2. Prochlorococcus.ms中的 806 个基因的分布如下：
   ![[Pasted image 20230823155434.png]]
   因为整体分布正常，只有3个基因组的频数明显不正常：
   ![[Pasted image 20230823155608.png]]
   是否去除这三个基因，还在讨论。
   去除频数 0.5 以下的
1. 根据上述checkm结果，以**完整度25、污染度5、异质性10**为标准筛选出803株系
2. 加入外类群聚球藻 WH8102  
       - 基于**r95**的**gtdbtk1.4.1**作进化树：
	      ![[cjXfir-BB5-PjVse-2kzLQ.pdf]]
       - 基于**r214**的**gtdbtk2.3.2**作进化树
	      ![[gWm099PeTVMXYWtqWb-BSg.pdf]]
5. 基于gtdb_1.4.1 + r95的进化关系进行了clade的划分，后续实践中证实基本正确

## 问题
在HLI、HLII、HLVII、HLVI分支内的进化关系在不同版本gtdb之间出现了异常
	- gtdb_1.4.1 + r95 :
		![[AoNq9Xf3yhlZhy0HEpAP6g.pdf]]
	- gtdb_2.3.2 + r214：
		![[YrAYfsiBWjNo8BwHj7JXtA.pdf]]

# II-acdc
## 步骤
1. 对1417个株系的原绿球藻进行了污染序列检测，结果如下：

| contamination state | num  |
|---------------------|------|
| clean               | 1100 |
| contaminated        | 131  |
| warning             | 186  |
2. 通过键盘宏，导出了1417株系的去污序列(基于参数cc的聚类)

# III-1_drep-tree （based on acdc）
## 步骤
1. 基于完整度25、次级聚类(ANIm)98的去冗余结果(603株)
   考虑acdc的结果，只保留clean级别株系(470株)
2. 基于**r214**的**gtdbtk2.3.2**作进化树
   鉴于AMZ株系在acdc结果中的特殊性，额外一版人为回填AMZ株系
	- 保留clean部分（470株）：
		![[JeKqxNHXcnGVytIxCCxSsw.pdf]]
	- 添加AMZ部分（485株）：
		![[5tyY7ZlaLHE0D-nw44VWbw.pdf]]
## 问题
1. 原本处于**HL**与**LL**之间的长支 **notsure_Prochlorococcus_sp__AG_402_N21** ，在只保留clean株系的进化树中出现在**LLIILLIII**与**LLI**之间
	现：
		![[T5VAbzny-I4uO50ZnQmy7Q 1.pdf]]
	原：
		![[XkBh8q-2LsLJKJHf4HWWrw.pdf]]
# III-2_ clade-internal-tree  (based on drep without acdc)
1. 以**完整度25、污染度5、异质性10**为标准筛选出的803株系，基于**r95**的**gtdbtk1.4.1**进化树，划分了clade
2. 基于完整度25、次级聚类(ANIm)98的去冗余结果(603株)，划分各clade

| clade | HLII | HLVII | HLVI | HLI | HLIV | HLIII | LLI | LLII-LLIII | LLother | LLIV | AMZ |
| ----- | ---- | ----- | ---- | --- | ---- | ----- | --- | ---------- | ------- | ---- | --- |
| num   | 320  | 2     | 17   | 68  | 11   | 4     | 77  | 28         | 44      | 14   | 15  |

3. 对每个clade，基于**r214**的**gtdbtk2.3.2**作进化树，并计算ANIm矩阵
4. 鉴于数量原因，合并**HLIII和HLIV**、**HLVI和HLVII**的株系，建树及ANI

# IV_pan-phylogenetic  (based on cluster)
[[基于anvio的cluster_进行的系统发育分析]]
405株系pangenome - 5921个cluster
![[Pasted image 20230825144933.png]]
核心基因簇 - 991个
![[Pasted image 20230825145445.png]]
SCG - 102
