# Overview
A workflow established with Snakemake, meticulously crafted to facilitate genomic data preprocessing and deduplication. This comprehensive workflow is specifically designed to construct a pangenome using Anvio from a genomic dataset. The ultimate goal is to generate a robust phylogenetic tree using IQ-TREE from the pangenome and reconstruct metabolic modules within the genomes.

# Genomic Processing Pipeline
## Part I - Genome Data Preprocessing and Deduplication
Panphylogeny_yz_workflow/I_genome_pre_analysis.py

This section focuses on the crucial initial steps of genome data preprocessing. The script `I_genome_pre_analysis.py` undertakes genome quality assessment based on the CheckM framework. It evaluates key metrics, including completeness, contamination, and heterogeneity. The assessment employs the marker gene set derived from original green algae for CheckM, and the heterogeneity data originates from the CheckM results due to limitations in CheckM2. Following this, the workflow utilizes Drep for deduplication based on CheckM results and employs ANIm (Average Nucleotide Identity based on whole-genome nucleotide consistency) to reduce redundancy.

## Part II - Genome Annotation and Region Masking
![[Panphylogeny_yz_workflow/II_mask_and_prokka.py]]

This section revolves around genome annotation and region masking using the `II_mask_and_prokka.py` script. The script encompasses the masking of rRNA and tRNA regions, as well as the export of genome data post-masking. Additionally, the section details the annotation of bacterial genomes using Prokka, enhancing the understanding of genomic content.

## Part III - Pangenome Construction
![[Panphylogeny_yz_workflow/III_pangenome_by_anvio.py]]
Delving into the core of pangenome analysis, this section focuses on `III_pangenome_by_anvio.py`. This script is instrumental in constructing a pangenome using Anvio, setting the stage for subsequent steps in the workflow. The ultimate aim is to gain insights into the systematics through the creation of a phylogenetic tree using IQ-TREE.


# Something about this project

This section provides a comprehensive overview of the project, detailing its evolution into a potentially standalone analysis pipeline. Covering activities from January 2023 to the present, the project harnesses publicly available databases for various omics data, employing tools such as Anvio and InStrain. The analyses span comparative genomics, pangenomics, and environmental genomics studies, with a primary focus on exploring genomic variations and identifying features associated with environmental phenotypes.


