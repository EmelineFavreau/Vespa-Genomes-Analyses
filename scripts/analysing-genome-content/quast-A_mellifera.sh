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

# obtain genome assembly stats
python /share/apps/genomics/quast-5.0.2/quast.py -o /SAN/ugi/VespaCrabro/${species} -t 4 --eukaryote --est-ref-size 300000000 /SAN/ugi/VespaCrabro/input/${filename}

