# 0. Libraries  -----------------------------------------------------------
library(tidyverse)
library(ComplexHeatmap)

# 1. Read data ------------------------------------------------------------
pc_file <- "../../data/day_4/annotated_clusters.txt" # Location of annotated protein clusters made on day 3 of the workshop
proteins <- data.table::fread(pc_file, header = TRUE)


# 1.1. Explore data -----------------------------------------------------
# Take a moment to look what is in this table. What are the columns?
View(proteins)

# Histogram of cluster sizes (optional)
proteins %>% 
  count(cluster_id) %>% 
  ggplot() + 
  geom_histogram(aes(x = n), binwidth = 5) + 
  xlab("Cluster size") + 
  ylab("Number of clusters")



# 2.  Clean up data -------------------------------------------------------
# add a few extra observables
proteins <- proteins %>% 
  mutate(
    # add unique id for contig
    seq_id = gsub("_[0-9]*$", "", member), 
    
    # is it RefSeq or one of our own contigs?
    seq_origin = case_when(str_detect(member, "NODE") ~ "assembly",
                       TRUE ~ "refseq"), 
    
    # get the length from the contig name, and add some high value for RefSeq sequences (too lazy to look up the RefSeq lengths :) 
    seq_length = case_when(seq_origin == "assembly" ~ as.numeric(gsub(".*length_|_cov.*", "", member)), 
                       TRUE ~ 9999999 
                       )
  )
    
# Drop the columns we don't need
proteins <- select(proteins, reference, member, cluster_id, members, prodigal, Category, RefSeq, seq_id, seq_origin, seq_length)

# Add binning information
bins <- data.table::fread("../../data/day_4/bin_stats.txt")

# we need to split the contig column
# This is a bit messy, if you know a better way to do this please let me know :)
nmax <- max(stringr::str_count(bins$contig, "\\,")) + 1 # max nr. of contigs in bin

bins <- bins %>% 
  separate(contigs,
           sep = ",",
           into = paste0("contig_", seq_len(nmax))) %>% 
  pivot_longer(
    cols = starts_with("contig"),
    names_to = c(".value", "item"),
    names_sep = "_"
  ) %>%
  drop_na("contig") %>%
  select(-item)

# @Dani: it seems not all contigs in bins are in the protein clustering table!
table(bins$contig %in% proteins$seq_id)

# add the bin annotation to the protein data frame
proteins <- left_join(proteins, bins, by = c("seq_id" = "contig"))


# make the bin heatmap
prot_wide <- 
  proteins %>% 
  filter(seq_origin == "assembly") %>% # only keep contigs from the assembly; removes RefSeq Sequences
  filter(!is.na(bin_id)) %>% 
  select(bin_id, cluster_id) %>% 
  
  # convert from 'long' to 'wide' format. Look at prot_wide and proteins if you don't know what that is. 
  pivot_wider(names_from = cluster_id, 
              values_from = cluster_id, 
              values_fill = 0, 
              values_fn = function(x) 1) 

# Only keep protein presence/absence for plotting
for_heatmap <- 
  select(prot_wide, -bin_id) %>% 
  as.matrix()

# make heatmap object
hmap <- Heatmap(for_heatmap, 
                show_column_names = FALSE, 
                col = c("white", "blue"), 
                clustering_distance_columns = "euclidean",
                clustering_distance_rows = "euclidean",
                name = "PC presence", 
                column_title = paste(ncol(for_heatmap), "Protein clusters (MMSeqs2)"), 
                row_title = paste(nrow(for_heatmap), "bins"), 
                column_dend_height = unit(4, "cm"), 
                row_dend_width = unit(4, "cm"), 
                use_raster = TRUE, 
                border = TRUE
)

# Draw the heatmap object 
draw(hmap)

# If you want to save to a file, do it like this:
pdf("heatmap.pdf", width = 12, height = 8)
draw(hmap)
dev.off() # don't forget to close the file!




# Old code: cluster contigs instead of bins ------------------------------------------------------
# Let's first do a clustering WITHOUT any RefSeq proteins/sequences
length_cutoff = 5000

prot_wide <- 
  proteins %>% 
  filter(seq_length > length_cutoff) %>% 
  filter(seq_origin == "assembly") %>% # only keep contigs from the assembly; removes RefSeq Sequences
  select(seq_id, seq_length, seq_origin, cluster_id) %>% 
  
  # convert from 'long' to 'wide' format. Look at prot_wide and proteins if you don't know what that is. 
  pivot_wider(names_from = cluster_id, 
              values_from = cluster_id, 
              values_fill = 0, 
              values_fn = function(x) 1)

# Only keep protein presence/absence for plotting
for_heatmap <- 
  select(prot_wide, -seq_id, -seq_length, -seq_origin) %>% 
  as.matrix()

# make heatmap object
hmap <- Heatmap(for_heatmap, 
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

# Draw the heatmap object 
draw(hmap)



