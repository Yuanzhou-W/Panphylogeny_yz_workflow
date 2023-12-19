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


