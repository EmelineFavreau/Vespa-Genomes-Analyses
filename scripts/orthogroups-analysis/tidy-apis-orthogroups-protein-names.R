# tidy messy tables where second column includes many genes separated by comma

# tidy table orthogroup | Apis proteins
# orthogoups are under positive selection in at least one species
# V_crabro V_germanica V_mandarinia V_pensylvanica V_velutina V_vulgaris

# get tidyverse loaded
library(tidyverse)

# make a function that tidy these tables
tidying_table_function <- function(this_file_name, this_result_name){
  # read file in
  proteins_orthogroups_raw <- read.delim(this_file_name,
                                         header=FALSE,
                                         stringsAsFactors = FALSE)
  
  # currently one line per orthorgoup (column one, e.g OG0002441 )
  # on column two, names of Apis protein related to these orthogroups (e.g. XP_006565841.1)
  # separated by comma, between 0 and 3 copies
  
  # aim: one line per apis protein names
  
  # check nrow 273
  nrow(proteins_orthogroups_raw)
  
  # name columns
  colnames(proteins_orthogroups_raw) <- c("orthogroup", "protein_names")
  
  # remove orthogroups without a protein name associated with it
  proteins_orthogroups <- 
    proteins_orthogroups_raw[proteins_orthogroups_raw$protein_names != "", ]
  
  # make a vector of all proteins
  proteins_vec <- unlist(strsplit(proteins_orthogroups_raw$protein_names, ", "))
  
  # make an empty dataframe 
  protein_orthogroup_mat <- c("protein", "orthogroup")
  
  # for each protein
  for(protein in proteins_vec){
    # find the corresponding orthogroup
    orthogroup <- proteins_orthogroups$orthogroup[grep(x = proteins_orthogroups$protein_names, 
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
              file = this_result_name,
              quote = FALSE,
              row.names = FALSE,
              col.names = FALSE,
              sep = "\t")
  
  
}
# do it for Drosophila
tidying_table_function(this_file_name = "../../input/orthogroup-analysis/orthogroup-dmel_protein-all_species_protein",
                       this_result_name = "../../result/dmel_protein_orthogroup")


# do it for Apis
tidying_table_function(this_file_name = "../../input/orthogroup-analysis/orthogroup-apis_protein-all_species_protein",
                       this_result_name = "../../result/Apis_protein_orthogroup")

# do it for V_crabro
tidying_table_function(this_file_name = "../../input/orthogroup-analysis/orthogroup-apis_protein-V_crabro_protein",
                       this_result_name = "../../result/V_crabro_protein_orthogroup")

# do it for V_germanica
tidying_table_function(this_file_name = "../../input/orthogroup-analysis/orthogroup-apis_protein-V_germanica_protein",
                       this_result_name = "../../result/V_germanica_protein_orthogroup")

# do it for V_mandarinia
tidying_table_function(this_file_name = "../../input/orthogroup-analysis/orthogroup-apis_protein-V_mandarinia_protein",
                       this_result_name = "../../result/V_mandarinia_protein_orthogroup")

# do it for V_pensylvanica
tidying_table_function(this_file_name = "../../input/orthogroup-analysis/orthogroup-apis_protein-V_pensylvanica_protein",
                       this_result_name = "../../result/V_pensylvanica_protein_orthogroup")

# do it for V_velutina
tidying_table_function(this_file_name = "../../input/orthogroup-analysis/orthogroup-apis_protein-V_velutina_protein",
                       this_result_name = "../../result/V_velutina_protein_orthogroup")

# do it for V_vulgaris
tidying_table_function(this_file_name = "../../input/orthogroup-analysis/orthogroup-apis_protein-V_vulgaris_protein",
                       this_result_name = "../../result/V_vulgaris_protein_orthogroup")

