conda activate drep
dRep dereplicate /number1/SUSTech_project/workflow_v2/IV_drep/III_drep/dereplication90059098/ -p 30 -g /number1/SUSTech_project/workflow_v2/IV_drep/III_drep/genome_newcontig/*.fasta --genomeInfo /number1/SUSTech_project/workflow_v2/IV_drep/III_drep/checkm250510.csv --gen_warnings --warn_dist 0.25 --warn_sim 0.98 --warn_aln 0.25 -comp 90 -con 5 -pa 0.9 -sa 0.98 --S_algorithm ANImf

