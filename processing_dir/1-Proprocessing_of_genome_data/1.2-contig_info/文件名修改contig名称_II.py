import os
import re
import pandas as pd
import shutil


def process_files(input_folder_path, output_folder_path, rename_table_path):
    # 读取改名表
    rename_table = {}
    new_name_set = set()
    with open(rename_table_path, "r") as f:
        for line in f:
            origin_name, accession, new_name = line.strip().split("\t")
            if new_name in new_name_set:
                new_name = origin_name + "_" + new_name
            new_name_set.add(new_name)
            rename_table[origin_name] = (accession, new_name)

    # 复制和重命名文件
    failed_files = []
    existing_files = set()
    for filename in os.listdir(output_folder_path):
        if filename.endswith(".fasta"):
            existing_files.add(filename)

    for filename in os.listdir(input_folder_path):
        if not filename.endswith(".fasta"):
            continue
        origin_name = os.path.splitext(filename)[0]  # 去掉扩展名
        if origin_name not in rename_table:
            print(f"无法找到 {filename} 在改名表中的访问号和新名字")
            failed_files.append(filename)
            continue
        accession, new_name = rename_table[origin_name]
        output_file_path = os.path.join(output_folder_path, new_name + ".fasta")
        if os.path.exists(output_file_path):
            print(f"{new_name}.fasta 已存在，忽略 {filename} 的复制和重命名")
            continue
        input_file_path = os.path.join(input_folder_path, filename)
        try:
            shutil.copy(input_file_path, output_file_path)
            print(f"已将 {filename} 复制并重命名为 {new_name}.fasta")
        except Exception as e:
            print(f"复制并重命名 {filename} 失败：{str(e)}")
            failed_files.append(filename)

    # 创建Excel表格并写入数据
    failed_df = pd.DataFrame({'Failed Files': failed_files})
    missing_df = pd.DataFrame({'Missing Files': []})
    duplicate_df = pd.DataFrame({'Duplicate Files': []})

    # 输出缺失的文件名单
    missing_files = []
    for filename in os.listdir(output_folder_path):
        if not filename.endswith(".fasta"):
            continue
        if filename not in existing_files:
            missing_files.append(filename)

    if missing_files:
        missing_df = pd.DataFrame({'Missing Files': missing_files})

    # 输出重名的文件名单
    duplicated_names = set()
    for origin_name, (accession, new_name) in rename_table.items():
        if new_name in duplicated_names:
            duplicate_df = duplicate_df.append({'Duplicate Files': new_name}, ignore_index=True)
        else:
            duplicated_names.add(new_name)

    with pd.ExcelWriter('output.xlsx') as writer:
        failed_df.to_excel(writer, sheet_name='Failed Files', index=False)
        missing_df.to_excel(writer, sheet_name='Missing Files', index=False)
        duplicate_df.to_excel(writer, sheet_name='Duplicate Files', index=False)

    print("处理完成！已生成输出文件。")

def modify_contig_names(input_folder, output_folder):
    fasta_files = [f for f in os.listdir(input_folder) if f.endswith(".fasta")]

    file_mapping = []
    contig_mapping = []

    for fasta_file in fasta_files:
        file_name = os.path.splitext(fasta_file)[0]
        new_file_name = re.sub(r"[^-_.\w]", "_", file_name)
        file_mapping.append([fasta_file, new_file_name])

        input_path = os.path.join(input_folder, fasta_file)
        output_path = os.path.join(output_folder, new_file_name + ".fasta")

        contig_count = 0
        new_lines = []

        with open(input_path, "r") as input_file:
            lines = input_file.readlines()

            for line in lines:
                if line.startswith(">"):
                    contig_count += 1
                    contig_name = f"{new_file_name}-{contig_count:03d}"
                    contig_mapping.append([line.strip(), contig_name])
                    new_line = f">{contig_name}\n"
                    new_lines.append(new_line)
                else:
                    new_lines.append(line)

        with open(output_path, "w") as output_file:
            
            output_file.writelines(new_lines)

    # 生成名称映射表
    file_mapping_df = pd.DataFrame(file_mapping, columns=["Original File Name", "New File Name"])
    contig_mapping_df = pd.DataFrame(contig_mapping, columns=["Original Contig Name", "New Contig Name"])

    file_mapping_df.to_excel(os.path.join(output_folder, "genome_name.xlsx"), index=False)
    contig_mapping_df.to_excel(os.path.join(output_folder, "contig_name_mapping.xlsx"), index=False)

# 示例使用

input_folder_path = input("请输入原文件夹路径：")
output_folder_path = input("请输入输出文件夹路径：")
rename_table_path = input("请输入改名表路径：")

process_files(input_folder_path, output_folder_path, rename_table_path)

input_folder= output_folder_path
output_folder= input("请输入修改contig名称的的输出文件夹路径：")
modify_contig_names(input_folder, output_folder)
