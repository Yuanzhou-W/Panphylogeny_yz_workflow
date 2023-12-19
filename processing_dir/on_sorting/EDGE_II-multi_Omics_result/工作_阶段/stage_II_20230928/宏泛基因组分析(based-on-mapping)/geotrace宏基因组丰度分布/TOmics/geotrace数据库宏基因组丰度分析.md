---
tags:
  - TOmicsisV
  - geotrace
ppt思路: 
---
# 说明
1. 本分析基于geotrace数据库中的宏基因组与所有原绿球藻亚种搜库结果进行，使用anvio计算的丰度数据
2. 为了简便分析流程，本分析基于在线分析平台[TOmicVis](https://shiny.hiplot.cn/tomicsvis-shiny/)与[BIC](https://www.bic.ac.cn/BIC/#/)进行
3. 鉴于anvio计算的丰度数据本质上是OTUs/ASVs差异分析中的计算方法，且前期对于基因组已经做过尽量完备的预处理，故不再考虑完整度等带来的丰度计算影响，默认株系为ASV水平
4. 鉴于本次数据矩阵与环境参数、数据规模，以及limma、edgeR等方法在OTUs分析中的应用，为了简便分析，默认anvio计算的丰度数值与基因差异表达分析中的raw Counts处于同一数据水平

# 技术流程与数据预处理
## 基因组处理及宏基因组搜库流程
![[Pasted image 20231102180459.png]]

## 样本筛选标准与丰度数据处理
1. 宏基因组样本处理  -  共506个合格数据
   - 回帖质量筛选(samtools)  -  align rate > 0.03
   - 株系回帖深度(anvio-8)  -  detection > 0.2
   - 环境参数  -   南北纬50
                          深度0-255m
                          温度8度以上
2. 丰度数据
   未作其他输出，直接使用原始abundance数值
3. 环境参数
   来自[ENA](https://www.ebi.ac.uk/ena/browser/home)的检索与邹学长整理的数据

# 基于TOmicsVis的数据特征分析
## I - sample stats
样本分布分析，仅使用环境参数数据
### 1 Quantile-Plot
P value观测值（Y轴）和p value期望值的一致性
#### pictures
1. Depth
   ![[depth_QuantilePlot.pdf]]
3. lat
   ![[lat_QuantilePlot.pdf]]
4. lon
   ![[lon_QuantilePlot.pdf]]
5. Temp
   ![[temp_QuantilePlot.pdf]]
#### Analysis
1. 以ENA中提供的四个采样位置进行划分，分别绘制了Q-Q图。
2. 本次搜库样本在深度、温度分布中体现了较好的连续性
3. 本次搜库样本在纬度、经度上，均只对一个采样地点有较好的分布连续性

### 2 Box Plot
#### pictures
1. depth
   ![[depth_BoxPlot.pdf]]
2. lat
   ![[lat_BoxPlot.pdf]]
3. lon
   ![[lon_BoxPlot.pdf]]
4. Temp
   ![[temp_BoxPlot.pdf]]

#### Analysis
1. 本次搜库样本在深度、温度分布中体现了较好的连续性分布
3. 本次搜库样本在纬度、经度上，均只对一个采样地点有较好的分布连续性

### Volin Plot
#### pictures

![[ViolinPlot.pdf]]


#### Analysis
分析结果同上


## II - Traits Plot
使用丰度矩阵与样本环境参数共同分析
### 1 Corr Heatmap
使用spearman方法样本间相关性，但无聚类
#### Pictutes
[[CorrHeatmap (1) 1.pdf]]

![[CorrHeatmap (1).jpg]]

## III - differential expression
使用Limma方法计算的差异ASVs丰度分析结果，与温度（3 °C）分组信息
### 1 - BIC Differential expression analysis (made by limma)
鉴于本次数据矩阵与环境参数、数据规模，以及limma、edgeR等方法在OTUs分析中的应用，为了简便分析，默认anvio计算的丰度数值与基因差异表达分析中的raw Counts处于同一数据水平

>本分析更多关注于技术可行性，故而暂不进行生物学分析
>
### 2 upsetr plot
![[UpsetrPlot.pdf]]


## 3 flower plot
![[FlowerPlot.pdf]]

### 4 heatmap group
#### Picture
[[HeatmapGroup (12).pdf]]
#### Analysis
![[Pasted image 20231102190958.png]]

# 基于BIC的WGCNA分析
## Pictures
### WGCNA_ModuleGeneTraitHeatmap

![[6b60e881-8ecf-44e7-b9c7-8dffbb917ce0.WGCNA_ModuleGeneTraitHeatmap.pdf]]
### WGCNA_moduleTraitHeatmap
![[6b60e881-8ecf-44e7-b9c7-8dffbb917ce0.WGCNA_moduleTraitHeatmap.pdf]]

### network visualization
![[屏幕截图 2023-11-02 160138.png]]

## Analysis
### 各模块核心株系
1. turquoise
   HLII
2. green
   另一部分HLII
3. yellow
   HLI
4. blue
   LLother和LLIV
5. brown
   LLI
6. red
   LLIILLIII与HLVI
# 关于种内的六个调控网络
![[图片2.png]]