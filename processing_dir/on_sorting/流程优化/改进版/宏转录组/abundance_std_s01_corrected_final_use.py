
import pandas as pd
import os
import numpy as np

def check_dir(dir_path):
    if not os.path.exists(dir_path):
        os.makedirs(dir_path)

def read_files(abundance_path, traits_path):
    abundance_df = pd.read_csv(abundance_path, sep='	', index_col=0)
    traits_df = pd.read_csv(traits_path, sep='	', index_col=0)
    return abundance_df, traits_df

def normalize_abundance(abundance_path,abundance_df, output_dir):
    normalized_df = abundance_df.div(abundance_df.sum(axis=0), axis=1)
    output_path = os.path.join(output_dir, os.path.basename(abundance_path).replace('.txt', 'std.txt'))
    normalized_df.to_csv(output_path, sep='	')
    return normalized_df

def print_traits_info(traits_df):
    traits_info = traits_df.agg(['min', 'max']).T
    for i, (trait, row) in enumerate(traits_info.iterrows()):
        print(f'{i+1}. {trait}: min={row["min"]}, max={row["max"]}')
    return traits_info

def group_samples_by_trait(normalized_df, traits_df, trait, min_val, max_val, interval, output_dir):
    bins = np.arange(min_val, max_val+interval, interval)
    traits_df['group'] = pd.cut(traits_df[trait], bins=bins, right=False, labels=[f"{i}_{i+interval}" for i in bins[:-1]])
    traits_df = traits_df[traits_df.index.isin(normalized_df.columns)]
    output_path = os.path.join(output_dir, f'groupBY{trait}.txt')
    traits_df.to_csv(output_path, sep='	')
    return traits_df

def merge_group_abundance(normalized_df, traits_df, trait, output_dir):
    merged_df = normalized_df.T.merge(traits_df['group'], left_index=True, right_index=True)
    count_per_group = merged_df.groupby('group').count().iloc[:, 0]
    sum_per_group = merged_df.groupby('group').sum()
    abundance_trait_df = sum_per_group.div(count_per_group, axis=0).T
    output_path = os.path.join(output_dir, f'abundance_trait_{trait}.txt')
    abundance_trait_df.to_csv(output_path, sep='	')
    return abundance_trait_df

def normalize_abundance_trait(abundance_trait_df, trait, output_dir):
    normalized_trait_df = abundance_trait_df.div(abundance_trait_df.sum(axis=1), axis=0)
    output_path = os.path.join(output_dir, f'abundance_trait_{trait}_strain.txt')
    normalized_trait_df.to_csv(output_path, sep='	')
    return normalized_trait_df

def normalize_0_1(df, axis):
    min_val = df.min(axis=axis)
    max_val = df.max(axis=axis)
    normalized_df = (df - min_val) / (max_val - min_val)
    return normalized_df

def main():
    abundance_path = input('请输入丰度矩阵文件路径：')
    traits_path = input('请输入样本信息表文件路径：')
    output_dir = input('请输入输出目录路径：')
    check_dir(output_dir)
    abundance_df, traits_df = read_files(abundance_path, traits_path)
    normalized_df = normalize_abundance(abundance_path,abundance_df, output_dir)
    traits_info = print_traits_info(traits_df)
    trait_num = int(input('请输入环境参数编号：')) - 1
    trait = traits_info.index[trait_num]
    min_val = float(input(f'请输入 {trait} 的最小值：'))
    max_val = float(input(f'请输入 {trait} 的最大值：'))
    interval = float(input(f'请输入 {trait} 的区间大小：'))
    traits_df = group_samples_by_trait(normalized_df, traits_df, trait, min_val, max_val, interval, output_dir)
    abundance_trait_df = merge_group_abundance(normalized_df, traits_df, trait, output_dir)
    abundance_trait_01_df = normalize_0_1(abundance_trait_df, 0)
    output_path = os.path.join(output_dir, f'abundance_{trait}_01.txt')
    abundance_trait_01_df.to_csv(output_path, sep='	')
    normalized_trait_df = normalize_abundance_trait(abundance_trait_df, trait, output_dir)
    normalized_trait_df_T= normalized_trait_df.T
    abundance_trait_strain_01_df = normalize_0_1(normalized_trait_df_T, 0)  
    abundance_trait_strain_01_df_T = abundance_trait_strain_01_df.T
    output_path = os.path.join(output_dir, f'abundance_{trait}_strain_01.txt')
    abundance_trait_strain_01_df_T.to_csv(output_path, sep='	')

if __name__ == "__main__":
    main()
