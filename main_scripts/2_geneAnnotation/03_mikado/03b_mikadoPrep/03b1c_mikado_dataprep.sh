#!/bin/bash
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=3G
#SBATCH --time=1-00:00:00

. "/homes/liu3zhen/anaconda3/etc/profile.d/conda.sh"
export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
conda activate mikado

###############################################################################################################################
# this step is needed
# wget https://raw.githubusercontent.com/HuffordLab/NAM-genomes/master/gene-prediction/scripts-evidence/plants.yaml
# cp plants.yaml /homes/liu3zhen/anaconda3/envs/mikado/lib/python3.9/site-packages/Mikado/configuration/scoring_files/plant.yaml
###############################################################################################################################

# code modified from 
# https://raw.githubusercontent.com/HuffordLab/NAM-genomes/master/gene-prediction/scripts-evidence/copy-files-for-mikado.sh

# generate List file
gtf_path=../03a_dataPrep
echo -e "$(realpath ${gtf_path}/stringtie.gtf)\tSt\tTrue" > list.txt
echo -e "$(realpath ${gtf_path}/strawberry.gtf)\tSw\tTrue" >> list.txt
echo -e "$(realpath ${gtf_path}/cufflinks.gtf)\tCf\tTrue" >> list.txt
echo -e "$(realpath ${gtf_path}/class2.gtf)\tCl\tTrue" >> list.txt

list=$(realpath list.txt)
# get files required
junctions=${gtf_path}/portcullis_filtered.pass.junctions.bed
genome=${gtf_path}/Ch7-2v1.fasta

# run configure
mikado configure \
   --list $list \
   --reference $genome \
   --mode permissive \
   --scoring plant.yaml \
   --copy-scoring plant.yaml \
   --junctions $junctions \
   configuration.yaml

# --copy-scoring plant.yaml \
# edit config files
sed -i 's/threads: 1/threads: 16/g' configuration.yaml

# consolidate transcripts
mikado prepare \
   --json-conf configuration.yaml

