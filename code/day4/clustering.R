# Please run this script line by line by pressing CTRL-enter 
# and read what you're doing. 

# 0. Load libraries  ------------------------------------------------------
library(tidyverse)

# 1. Read data ------------------------------------------------------------
# Enter the path to the MMSeqs2 clustering file you made on day 3: 
#pc_file <- "/path/to/mmseqs2/clusters.tsv"
pc_file <- "../../data/refseq_clusters.tsv"

proteins <- data.table::fread(pc_file, header = FALSE)
colnames(proteins) <- c("reference", "member")


# _1.1. Explore data -----------------------------------------------------
# Take a moment to look what is in this table. What is in the columns?
View(proteins)

# Go back to the main lesson.

# _1.2. Data cleaning -----------------------------------------------------
# Let's add a column 'seq_origin' to indicate if the protein came from a RefSeq 
# genome or an assembled contig:
proteins <- 
  proteins %>% 
  mutate(
    seq_origin = case_when(str_detect(member, "NODE") ~"assembly", 
                           TRUE ~ 'refseq')
  )

# We have a unique protein identifier for the RefSeq proteins 
# but don't know to which genomes they belong.
# Let's load the ncbi metadata we downloaded:

#ncbi <- data.table::fread("/path/to/sequences.csv)
ncbi <- data.table::fread("../../data/sequences_bac.csv")

# For the MMSeqs2 clusters on day 3 we included all RefSeq viruses. Today, we 
# will focus on bacteriophages, so let's remove all RefSeq proteins that had a 
# non-bacteriophage origin:
proteins <- filter(proteins, seq_origin == "assembly" | member %in% ncbi$Assembly)

# merge protein data frame with the NCBI metadata
proteins <- left_join(proteins, ncbi, by = c("member" = "Assembly"))

# Add a 'bin' column that indicates what genome the protein belongs to:
proteins <- mutate(proteins, 
                   bin = case_when(seq_origin == "refseq" ~ Species, 
                                   seq_origin == "assembly" ~ gsub("\\|\\|.*$", "", member)) # parse the protein name to get the bin
                   )



# 2. Make heatmaps -----------------------------------------------------------

# _2.1. only bins ---------------------------------------------------------------
# make presence/absence matrix:
prot_wide <- 
  proteins %>% 
  filter(seq_origin == "assembly") %>% 
  select(bin, reference, member) %>% 
  pivot_wider(names_from = reference, 
              values_from = member, 
              values_fill = 0, 
              values_fn = function(x) 1)

# remove the first column
for_heatmap <- 
  select(prot_wide, -bin) %>% 
  as.matrix()
rownames(for_heatmap) <- prot_wide$bin

# heatmap(for_heatmap, 
#         scale = 'none', 
#         labCol = FALSE)

# plot the heatmap:
jpeg(file="heatmap_bins.jpg", width = 1200, height = 1200, units = 'px')
heatmap(for_heatmap, 
        scale = "none", 
        labCol = FALSE, 
        main = "Please think of a good title", 
        xlab = paste(ncol(for_heatmap), "MMseqs2 Protein Clusters"), 
        ylab = paste(nrow(for_heatmap), "Bins")
)
dev.off()

# Go back to the lessons page and answer some questions. 


#_2.2. add crassphages ---------------------------------------------------------
# find the crAssphages in the RefSeq genomes:
RefSeq_crassphages <- unique(grep('crAss', 
                           proteins$Species,  
                           value = TRUE
                           )
                      )
# make presence/absence matrix:
prot_wide <- 
  proteins %>% 
  filter(seq_origin == "assembly" | Species %in% RefSeq_crassphages) %>% 
  select(bin, reference, member) %>% 
  pivot_wider(names_from = reference, 
              values_from = member, 
              values_fill = 0, 
              values_fn = function(x) 1)

# remove the first column
for_heatmap <- 
  select(prot_wide, -bin) %>% 
  as.matrix()
rownames(for_heatmap) <- prot_wide$bin

# heatmap(for_heatmap, 
#         scale = 'none')

# plot the heatmap:
jpeg(file="heatmap_crass.jpg", width = 1200, height = 1200, units = 'px')
heatmap(for_heatmap, 
        scale = "none", 
        labCol= FALSE, # too many columns to plot column names, 
        main = "Think of a good title",
        xlab = paste(ncol(for_heatmap), "MMseqs2 Protein Clusters"), 
        ylab = paste(nrow(for_heatmap), "Bins and crAssphage RefSeq genomes")
        )
dev.off()

# Go back to the lessons