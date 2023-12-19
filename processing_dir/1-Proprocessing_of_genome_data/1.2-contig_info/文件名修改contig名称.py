import os
import re
import pandas as pd

def modify_contig_names(input_folder, output_folder):
    fasta_files = [f for f in os.listdir(input_folder) if f.endswith(".fasta")]

    file_mapping = []
    contig_mapping = []

    for fasta_file in fasta_files:
        file_name = os.path.splitext(fasta_file)[0]
        file_mapping.append([fasta_file, file_name])

        input_path = os.path.join(input_folder, fasta_file)
        output_path = os.path.join(output_folder, fasta_file)

        contig_count = 0
        new_lines = []

        with open(input_path, "r") as input_file:
            lines = input_file.readlines()

            for line in lines:
                if line.startswith(">"):
                    contig_count += 1
                    contig_name = f"{file_name}-{contig_count:03d}"
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

input_folder= input("请输入包含.fasta文件的文件夹路径：")
output_folder= input("请输入输出文件夹路径：")
modify_contig_names(input_folder, output_folder)
