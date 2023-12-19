# 回贴
``` {bash}
bowtie2-build 1.fasta  merged ###(1h)

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
done ###(15min×n）
``` 

# 基因组预测+注释
``` {bash} 

emapper.py --cpu 20 -o out --output_dir /emapper_web_jobs/emapper_jobs/user_data/MM_unwcz_3z --override -m diamond --dmnd_ignore_warnings -i /emapper_web_jobs/emapper_jobs/user_data/MM_unwcz_3z/queries.fasta --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --itype genome --genepred prodigal --tax_scope auto --target_orthologs all --go_evidence non-electronic --pfam_realign none --report_orthologs --decorate_gff yes --excel 

```

# gff转换为gtf
```{bash}
gffread my.gff -T -o my.gtf
```

# 拆分gtf为各基因组gtf
``` {python}
import os
import csv
def split_gtf(original_gtf_path, save_path):
    # 检查保存路径是否存在，如果不存在则创建
    if not os.path.exists(save_path):
        os.makedirs(save_path)
    # 打开原始的gtf文件
    with open(original_gtf_path, 'r') as gtf:
        reader = csv.reader(gtf, delimiter='\t')
        # 创建一个字典用于存储文件对象，这样可以避免不必要的打开和关闭文件操作
        file_dict = {}
        # 遍历每一行
        for row in reader:
            # 检查行是否为空
            if row:
                # 从source字段中获取前缀
                prefix = "-".join(row[0].split('-')[:-1])
                # 创建新文件的路径
                new_gtf_path = os.path.join(save_path, prefix + '.gtf')
                # 检查文件是否已经在字典中，如果不在则打开并添加到字典中
                if new_gtf_path not in file_dict:
                    file_dict[new_gtf_path] = open(new_gtf_path, 'w', newline='')
                # 我们不再使用csv.writer，而是直接写入字符串
                file_dict[new_gtf_path].write('\t'.join(row) + '\n')
        # 记得关闭所有的文件
        for file in file_dict.values():
            file.close()
# 调用函数
input_folder_path = input("请输入原gtf文件夹路径：")
output_folder_path = input("请输入输出文件夹路径：")

split_gtf(input_folder_path, output_folder_path)
```

# 对每个基因组作比对
``` {bash}
# 路径
bam_dir="/home/wlh/workpath/metaT/Genome_v_dRep95/bam/"
gtf_dir="/home/wlh/workpath/metaT/Genome_v_dRep95/gtf_split/result/"
result_dir="t/home/wlh/workpath/metaT/Genome_v_dRep95/quantify_featurecounts/"

# 遍历gtf文件夹
for gtf in $(ls $gtf_dir/*.gtf); do
    # 获取gtf文件的基本名（没有路径和扩展名）
    base_name=$(basename $gtf .gtf)
    # 创建新的结果文件夹
    mkdir -p $result_dir/$base_name
    # 调用featureCounts
    featureCounts -T 16 -a $gtf -o $result_dir/$base_name/counts.txt $bam_dir/*.bam -F GTF -t CDS  -g gene_id -p 
done
```

# 标准化
```{pyhton}
import os
import gffutils
import pandas as pd

def calculate_gene_lengths(gtf_file):
    # 创建数据库
    db = gffutils.create_db(gtf_file, ':memory:')
    
    # 计算基因长度
    gene_lengths = {gene.id: gene.end - gene.start + 1 for gene in db.features_of_type('gene')}
    
    return pd.Series(gene_lengths)
def calculate_rpkm_tpm(counts_dir):
    # 遍历counts文件夹
    for dirpath, dirnames, filenames in os.walk(counts_dir):
        for filename in filenames:
            if filename.endswith('counts.txt'):
                # 读取counts文件
                counts = pd.read_csv(os.path.join(dirpath, filename), sep='\t', index_col=0)
                # 从对应的gtf文件计算基因长度
                gtf_file = os.path.join('/path/to/your/gtf/files', dirpath.split('/')[-1] + '.gtf')
                lengths = calculate_gene_lengths(gtf_file)
                # 计算RPKM和TPM
                rpkm = counts / lengths / counts.sum() * 1e6
                tpm = counts / lengths / (counts / lengths).sum() * 1e6
                # 保存结果
                rpkm.to_csv(os.path.join(dirpath, 'rpkm.txt'), sep='\t')
                tpm.to_csv(os.path.join(dirpath, 'tpm.txt'), sep='\t')
# 调用函数
calculate_rpkm_tpm("/path/to/your/counts/files")
```