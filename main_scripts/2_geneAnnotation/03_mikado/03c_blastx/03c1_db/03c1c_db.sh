#!/bin/bash
#SBATCH --mem=8G
#SBATCH --time=1-00:00:00
makeblastdb -in uniprot-viridiplantae.fasta -dbtype prot -parse_seqids 

