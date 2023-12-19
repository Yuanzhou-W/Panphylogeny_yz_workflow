for file in *.fasta; do
  seqkit seq "$file" -w 60 > newpath/$file
done


