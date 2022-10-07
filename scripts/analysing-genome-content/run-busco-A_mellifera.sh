#!/bin/bash
#$ -pe smp 4
#$ -l h_vmem=8G
#$ -l tmem=8G
#$ -l h_rt=10:00:00 
#$ -j y
export TMPDIR=/SAN/ugi/VespaCrabro/tmp
source /share/apps/source_files/python/python-3.8.5.source

species="Apis_mellifera"
filename="GCF_003254395.2_Amel_HAv3.1_genomic.fna.gz"

# unzip
gunzip -d -c /SAN/ugi/VespaCrabro/input/${filename} > /SAN/ugi/VespaCrabro/input/${species}.fasta

# busco assessement
busco -m genome -i /SAN/ugi/VespaCrabro/input/${species}.fasta -o ${species} -l hymenoptera_odb10 -f --config busco-config.ini

