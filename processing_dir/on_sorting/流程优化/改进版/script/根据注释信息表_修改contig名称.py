import os
import pandas as pd

def modify_contig_names_with_annotation_final(input_folder, annotation_file, output_folder):
    """
    Modify contig names in fasta files based on annotations from a given file.

    :param input_folder: str, Path to the folder containing fasta files.
    :param annotation_file: str, Path to the annotation file (txt format with tab-separated columns).
    :param output_folder: str, Path to the folder where modified fasta files should be saved.
    """

    # Ensure output folder exists
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
    
    # Load and preprocess the annotation data
    annotation_df = pd.read_csv(annotation_file, sep="\t")
    annotation_df.replace("-", "Alternative", inplace=True)
    
    # Display columns other than contig name for the user to choose from
    columns = list(annotation_df.columns)
    print("Available columns for annotation:")
    for idx, col in enumerate(columns[1:], 1):  # Excluding the first column which is contig name
        print(f"{idx}. {col}")
    
    # Ask user to choose a column for annotation
    chosen_idx = int(input("Please choose a column number for annotation: ")) - 1
    chosen_column = columns[chosen_idx + 1]  # +1 to account for the excluded contig name column

    # Create a dictionary for contig name to chosen annotation mapping
    contig_to_annotation = dict(zip(annotation_df[columns[0]], annotation_df[chosen_column]))

    # Loop through all fasta files in the input folder and rename contigs
    fasta_files = [f for f in os.listdir(input_folder) if f.endswith(".fasta")]

    for fasta_file in fasta_files:
        input_path = os.path.join(input_folder, fasta_file)
        output_path = os.path.join(output_folder, fasta_file)
        
        new_lines = []
        with open(input_path, "r") as input_file:
            lines = input_file.readlines()

            for line in lines:
                if line.startswith(">"):
                    contig_name = line.strip()[1:]  # Remove ">"
                    file_part, contig_number = contig_name.rsplit("-", 1)
                    annotation = contig_to_annotation.get(contig_name, "unknown")
                    new_contig_name = f"{file_part}-{annotation.replace(' ', '_')}-{contig_number}"
                    new_lines.append(f">{new_contig_name}\n")
                else:
                    new_lines.append(line)
        
        with open(output_path, "w") as output_file:
            output_file.writelines(new_lines)


# Ask user for input paths
input_folder = input("Please enter the path to the folder containing fasta files: ")
annotation_file = input("Please enter the path to the annotation file (txt format with tab-separated columns): ")
output_folder = input("Please enter the path to the folder where modified fasta files should be saved: ")

modify_contig_names_with_annotation_final(input_folder, annotation_file, output_folder)
