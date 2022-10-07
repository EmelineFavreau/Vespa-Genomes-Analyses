#!/bin/bash

# Obtain longest transcript for  each gene in Solenopsis invicta
# Copyright Emeline Favreau, UCL

## Analysis overview
### Step 1: get the gene and protein ids from gff files
### Step 2: get the protein length from the proteomes
### Step 3: obtain the longest isoform for each protein
### Step 4: subset protein fasta file for just those isoforms

#################################################################################
## Step 1: get the gene and protein ids from gff files

# obtain gff
mkdir -p input/gff

cd input/gff

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/016/802/725/GCF_016802725.1_UNIL_Sinv_3.0/GCF_016802725.1_UNIL_Sinv_3.0_genomic.gff.gz

mv GCF_016802725.1_UNIL_Sinv_3.0_genomic.gff.gz S_invicta.gff.gz

thisspecies="S_invicta"

# check that gff is NCBI format (RefSeq)
# zcat ${thisspecies}.gff.gz | head

# this is specific to each GFF (not a norm unless from Ensembl)
# get gene and protein IDs from GFF file, e.g. 105205108  XP_011172705.3
# use uniq to remove duplicated
# useful link : https://www.biostars.org/p/388936/
# remove in column 9 anything that is before and includes ;Dbxref=GeneID:
# remove in column 9 anything that is after ;Name
# remove the string ,Genbank: and replace it by a tab
zcat ${thisspecies}.gff.gz | awk '$3=="CDS"{gsub(".+;Dbxref=GeneID:", "", $9); gsub(";Name=.+", "", $9); gsub(",Genbank:", "\t", $9); print $9}' | sort | uniq > ${thisspecies}.tsv

cd ..



#################################################################################
## Step 2: get the protein length from the proteomes


# first, tidy fastaa headers by checking first ( head -n 1 proteins/A_mellifera.faa | cut -d " " -f 1)
# remove the second part of the sequence header after the gene ID
# fx2tab calculate the sequence length
# sort the result
../tools/./seqkit fx2tab -n -l proteins/${thisspecies}.faa \
  | awk 'BEGIN{FS="\t"}{gsub(" .*", "", $1); print}' \
  | sort \
  > sequence-length/${thisspecies}-sequence-length.tsv


cd ..

#################################################################################
## Step 3: obtain the longest isoform for each protein
# based on Anindita Brahma's code
module load default/R/4.0.2 

Rscript --vanilla scripts/subset-longest-protein-isoform.R input/gff/${thisspecies}.tsv input/sequence-length/${thisspecies}-sequence-length.tsv input/longest-isoform/${thisspecies}_protein_longest_isoform.txt


#################################################################################
## Step 4: subset protein fasta file for just those isoforms
# subset protein sequences for those longest proteins


# update the faa headers for short name (ie just the gene name)
awk '{gsub(" .*", ""); print}' input/proteins/${thisspecies}.faa > input/proteins/${thisspecies}-short-name.faa

# remove protein sequences that are not the longest isoform
/share/apps/genomics/seqtk/seqtk subseq input/proteins/${thisspecies}-short-name.faa \
	input/longest-isoform/${thisspecies}_protein_longest_isoform.txt \
	> input/primary_transcripts/${thisspecies}-longest-isoforms.faa


# this protein fasta has 14790 longest isoforms, with headers containing just gene id (i.e. >NP_001291509.1)
# grep ">" input/primary_transcripts/${thisspecies}-longest-isoforms.faa | wc -l


