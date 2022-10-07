#!/bin/bash

# Obtain longest transcript for  each gene in Vespula pensylvanica
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

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/014/466/175/GCA_014466175.1_ASM1446617v1/GCA_014466175.1_ASM1446617v1_genomic.gff.gz

mv GCA_014466175.1_ASM1446617v1_genomic.gff.gz V_pensylvanica.gff.gz

thisspecies="V_pensylvanica"

# check that gff is NCBI format (RefSeq)
# zcat ${thisspecies}.gff.gz | grep "CDS" | head

# this is specific to each GFF (not a norm unless from Ensembl)
# get gene and protein IDs from GFF file, e.g. Vgerm1g00000.t1 KAF7417348.1
# there will be multiple protein IDs, but only one gene
# use uniq to remove duplicated
# useful link : https://www.biostars.org/p/388936/
# remove in column 9 anything that is before and includes ;Dbxref=NCBI_GP:
# remove in column 9 anything that is after gbkey=CDS
# remove the string ;Name= and replace it by a tab

# 92498 instances of gene names 
zcat ${thisspecies}.gff.gz | awk '$3=="CDS"{gsub(".+WGS:JACSDY\\|", "", $9); gsub(";.*", "", $9) ; print $9}' | wc -l

# 92498 instances of protein names
zcat ${thisspecies}.gff.gz | awk '$3=="CDS"{gsub(".+;Dbxref=NCBI_GP:", "", $9); gsub(";.*", "", $9) ; print $9}' | wc -l

# the first column is gene-names, second column is protein name
zcat ${thisspecies}.gff.gz | awk '$3=="CDS"{gsub(".+WGS:JACSDY\\|", "", $9); gsub(";.*", "", $9) ; print $9}' > ${thisspecies}-gene-names
zcat ${thisspecies}.gff.gz | awk '$3=="CDS"{gsub(".+;Dbxref=NCBI_GP:", "", $9); gsub(";.*", "", $9) ; print $9}' > ${thisspecies}-protein-names

paste ${thisspecies}-gene-names ${thisspecies}-protein-names | sort | uniq > ${thisspecies}.tsv

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


# this protein fasta has 18491 longest isoforms, with headers containing just gene id (i.e. >NP_001291509.1)
# grep ">" input/primary_transcripts/${thisspecies}-longest-isoforms.faa | wc -l


