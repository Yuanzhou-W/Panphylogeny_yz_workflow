# -*- coding: utf-8 -*-
"""
Created on Mon May 29 13:25:46 2023

@author: 15982
"""

import os
import shutil
import pandas as pd

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

# 示例用法
input_folder_path = input("请输入原文件夹路径：")
output_folder_path = input("请输入输出文件夹路径：")
rename_table_path = input("请输入改名表路径：")

process_files(input_folder_path, output_folder_path, rename_table_path)
