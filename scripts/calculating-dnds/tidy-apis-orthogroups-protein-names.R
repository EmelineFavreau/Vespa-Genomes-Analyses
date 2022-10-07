# tidy table orthogroup | Apis proteins
# orthogoups are under positive selection in at least one species
# V_crabro V_germanica V_mandarinia V_pensylvanica V_velutina V_vulgaris

# get tidyverse loaded
library(tidyverse)

# import file
Apis_proteins_orthogroups_raw <- read.delim("../input/orthogroup-apis_protein-all_species_protein",
                                            header=FALSE,
                                            stringsAsFactors = FALSE)

# currently one line per orthorgoup (column one, e.g OG0002441 )
# on column two, names of Apis protein related to these orthogroups (e.g. XP_006565841.1)
# separated by comma, between 0 and 3 copies

# aim: one line per apis protein names

# check nrow 200
nrow(Apis_proteins_orthogroups_raw)

# name columns
colnames(Apis_proteins_orthogroups_raw) <- c("orthogroup", "protein_names")

# remove orthogroups without a protein name associated with it
Apis_proteins_orthogroups <- 
  Apis_proteins_orthogroups_raw[Apis_proteins_orthogroups_raw$protein_names != "", ]

# make a vector of all proteins
Apis_proteins_vec <- unlist(strsplit(Apis_proteins_orthogroups_raw$protein_names, ", "))

# make an empty dataframe 
protein_orthogroup_mat <- c("protein", "orthogroup")

# for each protein
for(protein in Apis_proteins_vec){
  # find the corresponding orthogroup
  orthogroup <- Apis_proteins_orthogroups$orthogroup[grep(x = Apis_proteins_orthogroups$protein_names, 
                                                          pattern = protein)]
  # update the dataframe
  protein_orthogroup_mat <- rbind(protein_orthogroup_mat,
                                  c(protein, orthogroup))
}

# check result
# summary(protein_orthogroup_mat)
# head(protein_orthogroup_mat)
# tail(protein_orthogroup_mat)

# make it into a dataframe
protein_orthogroup_df <- data.frame(protein_orthogroup_mat,
                                    row.names = NULL)

# add column names
colnames(protein_orthogroup_df) <-  c("protein", "orthogroup")

# remove the row " protein orthogroup
protein_orthogroup_df <- protein_orthogroup_df %>% filter(protein != "protein")

# save it for future analysis (e.g. obtaining pootein description using esearch)
write.table(protein_orthogroup_df, 
            file = "../result/Apis_protein_orthogroup",
            quote = FALSE,
            row.names = FALSE)

