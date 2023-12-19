# -*- coding: utf-8 -*-
"""
Created on Mon Aug 21 21:12:36 2023

@author: 15982
"""

import os
import re
 

folder_path = input("path to input fold:")
output_file = input("Please enter the path to the folder where modified fasta files should be saved: ")



with open(output_file, 'w') as f:

    for filename in os.listdir(folder_path):
        if filename.endswith(".fasta.yaml"):
            
            with open(os.path.join(folder_path, filename)) as yaml_file:
                
                for line in yaml_file:
                    if "contamination_state" in line:
                        match = re.search(r'contamination_state:\s+(\w+)', line)
                        if match:
                            contamination = match.group(1)
                            
            f.write(f"{filename}\t{contamination}\n")


                              
print("Done!")