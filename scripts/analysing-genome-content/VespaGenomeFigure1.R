# figure plotting
# genome stats of new and old species

# load libraries
library("tidyverse",
        "ggplot2",
        "scales",
        "readxl")

# csv file with genomes stats on chosen species
# accession assembly_level contig_n50 assembly_name Genus_species 
# assembly_length submission_date year Family     
Hymenoptera_curated <- read.csv("~/Documents/local_myriad/Hymenoptera_genomes_stats_subset.csv",
                                header=TRUE,
                                stringsAsFactors = FALSE)


# excel sheet with genome stats including busco
# "Species Family Size (bb) Contigs N50              
# L50 GC% # N’s per 100 kbp Total Complete Single-Copy   
# Duplicated Fragmented Missing Accession Assembly level 
# Assembly name Submission date Year    
ST2_genome_stats <- read_excel("ST2-genome-stats.xlsx")

# vector of colours
green_seq_vec <- c('#ffffd9', '#edf8b1', '#c7e9b4', '#7fcdbb', '#41b6c4',
                   '#1d91c0', '#225ea8', '#253494', '#081d58')


# plot assembly status (assembly length and N50)
ggplot(data = Hymenoptera_curated) + 
  geom_point(aes(assembly_length, 
                 contig_n50,
                 colour = as.factor(year),
                shape = as.factor(Family)), 
             alpha = I(0.6),
             size = 6) + 
  scale_colour_manual(values = green_seq_vec) + 
  theme_bw() + 
  geom_text(data = Hymenoptera_curated,
             aes(assembly_length,
                 contig_n50,
                 label = Genus_species),
             colour = I(alpha("black", 0.85)), size = 5 ) +
  scale_x_continuous(limits = c(-15350018, 496009169),
                     labels = scales::label_comma(),
                     breaks = c(0, 200000000, 400000000, 600000000)) +
  scale_y_log10(
                labels = scales::label_comma())

# save
ggsave(filename = "2021-07-02-Figure1-n50-length.pdf")

# set levels to phylogenetic order
ST2_genome_stats$Species <- factor(x = ST2_genome_stats$Species,
  levels = c("Acromyrmex echinatior", "Atta cephalotes", "Formica selysi" ,      
             "Solenopsis invicta",
             
             "Apis mellifera" , "Megalopta genalis",
             
             "Polistes canadensis", "Polistes dominula", "Polistes dorsalis",
             "Polistes fuscatus", "Polistes metricus",
             
             "Vespa crabro", "Vespa velutina", "Vespa mandarinia",
             
             "Vespula germanica", "Vespula pensylvanica", "Vespula vulgaris"

              ))



# transform ST2 to make a bar plot
assembly_content_data <- ST2_genome_stats %>% 
  select(Species, `Single-Copy`, Duplicated, Fragmented,
                            Missing) %>% 
  gather(key = "BUSCO", value = "value",
         -Species )

# set levels to busco order
assembly_content_data$BUSCO <- factor(x = assembly_content_data$BUSCO,
                                   levels = c("Missing",
                                              "Fragmented",
                                              "Duplicated",
                                              "Single-Copy"
                                              ))
                                   
# set four diverging colours
orange_to_purple_vec <- c("#fdb863", "#e66101", "#5e3c99", "#b2abd2")

# plot assembly content (busco and GC%)
ggplot(data = assembly_content_data,
       aes(fill = BUSCO, 
           y = value,
           x = Species )) + 
  geom_bar(position = "stack", stat = "identity") +
  scale_fill_manual(values = orange_to_purple_vec) + 
  theme_bw() + coord_flip()

# save
ggsave(filename = "2021-07-30-Figure1-busco.pdf")
