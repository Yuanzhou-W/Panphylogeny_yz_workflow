# -*- coding: utf-8 -*-

import argparse
import pandas as pd

def add_extension(input_file, output_file):
    # 读取逗号分隔的csv文件
    df = pd.read_csv(input_file, sep=',')

    # 将第一列的元素名称后加上".fasta"
    df.iloc[:, 0] = df.iloc[:, 0].astype(str) + ".fasta"

    # 保存为新的csv文件，保留列名
    df.to_csv(output_file, sep=',', index=False)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Process input CSV file and add extension to the first column.")
    parser.add_argument("-i", "--input_file", help="Path to the input CSV file", required=True)
    parser.add_argument("-o", "--output_file", help="Path to the output CSV file", required=True)

    args = parser.parse_args()

    add_extension(args.input_file, args.output_file)
