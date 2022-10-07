#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# title: "subset-longest-protein-isoform"
# author: "Emeline"
# date: "16/09/2020"
# Copyright 2021 Emeline Favreau, University College London.

#args[1] "inputOnScratch/gff/Apis_mellifera.tsv"
#args[2] "inputOnScratch/sequence-length/Apis_mellifera-sequence-length-no-mito.tsv"
#args[3] "inputOnScratch/longest-isoform/Apis_mellifera_protein_longest_isoform.txt"

# Objective of analysis
# Subset protein sequences to the longest isoform per protein.

# Step 1
# write a subsetting function
longest_isoform <- function(gene_protein_id, protein_length){
  
  # merge the files
  file_merge <- cbind(gene_protein_id[, 1], protein_length)
  colnames(file_merge) <- c("gene", "isoform", "length")
  
  # rearrange the merged file, first with ascending order of gene ID
  # next for each gene ID order the length in descending order
  df <- file_merge[order(file_merge[, 'gene'], -file_merge[, 'length']),]
  
  # remove duplicated rows
  # this will keep the longest isoform for a gene ID and remove the rest
  df_no_duplicate <- df[!duplicated(df$gene), ]
}


# Step 2
# obtain data
# two columns tab-delimited, gene ID and protein ID
species_gene_protein_id <- read.table(args[1])

# two columns tab-delimited, protein ID and protein length
species_protein_length <- read.table(args[2])

# Step 3
# run function
# expect three columns gene isoform length
species_longest_isoform <- longest_isoform(gene_protein_id = species_gene_protein_id,
                                                     protein_length = species_protein_length)

# Step 4
# save the protein ids
species_protein_longest_isoform <- write.table(x = species_longest_isoform$isoform,
                                               file = args[3],
                                                         quote = FALSE,
                                                         row.names = FALSE,
                                                         col.names = FALSE)

