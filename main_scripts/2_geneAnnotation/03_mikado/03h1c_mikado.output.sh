# copy outputs
cp 03f_tesorter/mikado* .
# simplify names and remove "." as "stop codons"
sed 's/ .*//g' mikado.proteins.clean.fasta | sed 's/\.$//g' | sed '/^$/d' > mikado.proteins.clean.reformat.fasta
