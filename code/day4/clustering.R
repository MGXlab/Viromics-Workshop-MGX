# 0. Libraries & load data --------------------------------------------------
library(tidyverse)
library(ComplexHeatmap)


# 1. Read data ------------------------------------------------------------
pc_file <- "/home/jeroen/course-jena/annotated_clusters.txt" # Location of annotated protein clusters made on day 3 of the workshop
proteins <- data.table::fread(pc_file, header = TRUE)


# 1.1. Explore data -----------------------------------------------------
# Take a moment to look what is in this table. What are the columns?
View(proteins)

# histogram of cluster sizes
proteins %>% 
  count(cluster_id) %>% 
  ggplot() + 
  geom_histogram(aes(x = n), binwidth = 5) + 
  xlab("Cluster size") + 
  ylab("Number of clusters")


# Add some extra observables
proteins <- proteins %>% 
  mutate(
    seq_id = gsub("_[0-9]*$", "", member), 
    seq_origin = case_when(str_detect(member, "NODE") ~ "assembly",
                       TRUE ~ "refseq"), 
    seq_length = case_when(seq_origin == "assembly" ~ as.numeric(gsub(".*length_|_cov.*", "", member)), 
                       TRUE ~ 9999999 # some high number for refseq sequences -- could also try to get this info from RefSeq
                       )
  )
    
# Drop some columns that we don't need
proteins <- select(proteins, reference, member, cluster_id, members, prodigal, Category, RefSeq, seq_id, seq_origin, seq_length)



# 2. Cluster contigs ------------------------------------------------------
# Make clustering of proteins WITHOUT RefSeq proteins
length_cutoff = 5000
prot_wide <- 
  proteins %>% 
  filter(seq_length > length_cutoff) %>% 
  filter(seq_origin == "assembly") %>% # only keep contigs from the assembly; removes RefSeq Sequences
  select(seq_id, seq_length, seq_origin, cluster_id) %>% 
  pivot_wider(names_from = cluster_id, 
              values_from = cluster_id, 
              values_fill = 0, 
              values_fn = function(x) 1)

for_heatmap <- 
  select(prot_wide, -seq_id, -seq_length, -seq_origin) %>% 
  as.matrix()

ht <- Heatmap(for_heatmap, 
        show_column_names = FALSE, 
        col = c("white", "blue"), 
        clustering_distance_columns = "euclidean",
        clustering_distance_rows = "euclidean",
        name = "PC presence", 
        column_title = paste(ncol(for_heatmap), "Protein clusters (MMSeqs2)"), 
        row_title = paste(nrow(for_heatmap), "Contigs >", min(prot_wide$seq_length), "kbp"), 
        column_dend_height = unit(4, "cm"), 
        row_dend_width = unit(4, "cm"), 
        use_raster = TRUE, 
        border = TRUE
)
 
draw(ht)

# . . Interpret what you see. 
# . . (1) it is a very sparse matrix, so the majority of viral sequences shares 
# . . . . very little genes
# . . (2) Some contigs cluster together based on shared protein clusters. 


# 3. Add RefSeq to heatmap ------------------------------------------------
set.seed(786)



# Add binning information -------------------------------------------------
bins <- data.table::fread("/home/jeroen/teaching/2022-jena-viromics/data/day_4/bin_stats.txt")


# filter by finding closest RefSeq hits

# A: RefSeq is sparse: lot of uncharted viral diversity
# . . Zoom in on a cluster ------------------------------------------------

# What proteins are shared? Do you think these are the same genus? Why or why not?
# Answer: If there are several distinct RefSeq in the cluster that agree on that taxonomic 
# level, and this is robust. 
#
# Q: how would you improve your belief in this taxonomic assignment?
# A: read up on classification: perhaps there are hallmark genes. Look for conserved synteny.
#
# What would limit this clustering approahc? 
# --> fragmented genomes
# n. Add CheckV output -------------------------------------------------------
#
# Read XX of the CheckV paper. Discuss why viral taxonomy is an iterative process. 
# add checkV annotation to heatmap


# Conserved genes ---------------------------------------------------------
# Look for terminase Large subunit (and portal and MCap?)
# add those to the heatmap
# make phylogeny based on these marker genes


# Gene sharing networks

