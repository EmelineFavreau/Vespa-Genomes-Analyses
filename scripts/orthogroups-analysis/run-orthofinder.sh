#!/bin/bash
#$ -pe smp 8 # request 8 cores
#$ -l h_vmem=50G
#$ -l tmem=50G
#$ -l h_rt=30:00:00 
#$ -j y

export TMPDIR=/SAN/ugi/VespaCrabro/tmp
export PATH=/share/apps/genomics/muscle-3.8.31:$PATH
export PATH=/SAN/ugi/VespaCrabro/tools:$PATH
export PATH=/share/apps/genomics/diamond-v2.0.4.142:$PATH
export PATH=/share/apps/genomics/samtools-1.9/bin:$PATH
export PATH=/share/apps/genomics/cufflinks/2.2.1:$PATH

source /share/apps/source_files/python/python-3.8.5.source

python3 /share/apps/genomics/OrthoFinder-2.5.4/orthofinder.py \
	-t 8 \
	-f /SAN/ugi/VespaCrabro/input/primary_transcripts \
	-A muscle \
	-S diamond \
	-M msa
