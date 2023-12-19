# -*- coding: utf-8 -*-
"""
Created on Tue Dec 12 15:46:47 2023

@author: 15982
"""

import argparse
import pandas as pd

def checkm2drep(input_file, output_file):
    # 读取 tab 分隔的 txt 文件
    df = pd.read_csv(input_file, sep='\t')

    # 修改列名
    df = df.rename(columns={
        df.columns[0]: 'genome',
        df.columns[5]: 'completeness',
        df.columns[6]: 'contamination',
        df.columns[7]: 'strain heterogeneity'
    })

    # 将 DataFrame 保存为以逗号分隔的 csv 文件
    df.to_csv(output_file, index=False)

if __name__ == "__main__":
    # 使用 argparse 处理命令行参数
    parser = argparse.ArgumentParser(description="Process checkm2drep parameters.")
    parser.add_argument('--input', help='Input file path', required=True)
    parser.add_argument('--output', help='Output file path', required=True)
    args = parser.parse_args()

    # 调用函数
    checkm2drep(args.input, args.output)
