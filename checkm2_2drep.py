import argparse
import pandas as pd

def checkmv22drep(input_file, additional_file, output_file):
    # 读取tab分隔的txt文件
    df = pd.read_csv(input_file, sep='\t')

    # 修改列名
    df = df.rename(columns={
        df.columns[0]: 'genome',
        df.columns[3]: 'completeness',
        df.columns[2]: 'contamination',
    })

    # 读取逗号分隔的csv文件，假设第一列元素相同
    additional_df = pd.read_csv(additional_file, sep=',')

    # 合并两个DataFrame，仅添加第八列的信息
    merged_df = pd.merge(df, additional_df.iloc[:, [0, 7]], left_on='genome', right_on=additional_df.columns[0], how='left')

    # 将DataFrame保存为以逗号分隔的csv文件
    merged_df.to_csv(output_file, index=False)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Process input files and generate output file.")
    parser.add_argument("-i", "--input_file", help="Path to the input tab-separated file", required=True)
    parser.add_argument("-a", "--additional_file", help="Path to the additional comma-separated file", required=True)
    parser.add_argument("-o", "--output_file", help="Path to the output CSV file", required=True)

    args = parser.parse_args()

    checkmv22drep(args.input_file, args.additional_file, args.output_file)
