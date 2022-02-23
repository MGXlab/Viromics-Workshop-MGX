library(tidyverse)
library(ComplexHeatmap)

cfile <- "/net/mgx/linuxhome/mgx/courses/Viromics_2022/day_4/clusters.tsv"
clusters <- data.table::fread(cfile, header = FALSE)
colnames(clusters) <- c("representative", "members")

# clean up protein names
clusters$members <- gsub("_cov.*$", "", clusters$members)
clusters$representative <- gsub("_cov.*$", "", clusters$representative)
clusters$virus <- gsub("^.*_\\[|\\]", "", clusters$members)
#clusters$annotation <- gsub("^.*_.*_|\\[.*", "", clusters$members)

clusters <- clusters %>% 
  mutate(#contig = gsub("_[0-9]*$", "", members), 
    length = as.numeric(gsub(".*length_|_cov.*", "", members)), 
    length = case_when(is.na(length) ~ 9999999, 
                       TRUE ~ length),
    cluster = paste0("cluster_", as.numeric((as.factor(representative)))), 
    origin = case_when(str_detect(members, "NODE") ~ "assembly", 
                       TRUE ~ "refseq")
  )


# Explore data ------------------------------------------------------------
# # how many clusters do we have?
# length(unique(clusters$cluster))
# # quite a lot: 141022
# 
# # how many clusters with more than 1 member?
# clusters %>%
#   group_by(cluster) %>%
#   summarize(count = n()) %>%
#   filter(count > 1) %>%
#   nrow()
# # So about 1/3rds of the clusters have > 1 member. 59,405
# 
# # We don't need clusters that do not contain proteins from our assembly (i.e. only contain REFSEQ proteins). How many of those do we have?
# clusters %>% 
#   # remove protein clusters of size 1
#   group_by(cluster) %>%
#   mutate(count = n()) %>%
#   ungroup() %>% 
#   filter(count > 1) %>%
#   group_by(cluster) %>% 
#   filter(any(origin == "assembly")) %>% 
#   pull(cluster) %>% 
#   unique() %>% 
#   length()
# # so only 5593 protein clusters with at least 1 assembly protein. Lets keep those. 
# 
# 

# Filter ------------------------------------------------------------------
# remove protein clusters of size 1, and groups that contain at least 1 assembly protein
clusters_filt <- clusters %>% 
  group_by(cluster) %>%
  mutate(count = n()) %>%
  ungroup() %>% 
  filter(count > 1) %>%
  group_by(cluster) %>% 
  filter(any(origin == "assembly")) %>% 
  ungroup()

#double-check: are there PCs that DO NOT contain an assembly protein?
contains_assembly <- 
  clusters_filt %>% filter(origin == "assembly") %>% 
  pull(cluster)
  
contains_refseq <- 
  clusters_filt %>% filter(origin == "refseq") %>% 
  pull(cluster)

table(contains_refseq %in% contains_assembly) # all refseq PCs are in the assembly PCs
table(contains_assembly %in% contains_refseq) # not all assembly PCs are in the refseq PCs

# How many REFSEQ geomes do we have that share ZERO protein (clusters) with our contigs?
## not sure, we already lost those by the previous filtering step :)

# 
# # how many refseq references?
# clusters %>% 
#   filter(!str_detect(members, "NODE")) %>% 
# #  filter(length > 9999) %>% 
#   pull(virus) %>% 
#   unique() %>% 
#   length()
# 
# # so 11,442 REFSEQ sequences before filtering
# 
# clusters_filt %>% 
#   filter(!str_detect(members, "NODE")) %>% 
#  # filter(length > 9999) %>% 
#   pull(virus) %>% 
#   unique() %>% 
#   length()
# 
# # only 4375 refseq genomes after filtering
# 
# # how many contigs from assembly?
# clusters_filt %>% 
#   filter(str_detect(members, "NODE")) %>% 
#   filter(length > 9999) %>% 
#   pull(members) %>% 
#   unique() %>% 
#   length()

# 117 contigs > 10,000 bp

# convert to wide format 
for_heatmap <- clusters_filt %>% 
  filter(length > 9999) %>% 
  #filter(str_detect(members, "NODE")) %>% 
  select(-length, -representative, -members, -origin, -count) %>% 
  pivot_wider(names_from = cluster, 
              values_from = cluster, 
              values_fill = 0, 
              values_fn = function(x) 1)

for_heatmap_tdy <- for_heatmap %>% 
  select(-virus)

# We have filtered contigs on size, so some protein clusters are now composed of a single protein:
table(colSums(for_heatmap_tdy) < 2)

# So we need to remove those
for_heatmap_tdy <- for_heatmap_tdy[, -which(colSums(for_heatmap_tdy) < 2)]
table(colSums(for_heatmap_tdy) < 2)


h <-  Heatmap(for_heatmap_tdy, 
              show_column_names = FALSE, 
              col = c("white", "blue"), 
              clustering_distance_columns = "euclidean",
              clustering_distance_rows = "euclidean",
              name = "Protein cluster presence", 
              column_title = "Protein clusters (MMSeqs2)", 
              row_title = paste(nrow(for_heatmap_tdy), "Contigs > 10kbp")
)

pdf("l10k.tidy.heatmap.pdf", width = 12, height = 8)
draw(h)
dev.off()



# remove refseq -----------------------------------------------------------

# convert to wide format 
for_heatmap <- clusters_filt %>% 
  filter(str_detect(members, "NODE"))  %>% 
  filter(length > 9999) %>% 
  select(-length, -representative, -members, -origin, -count) %>% 
  pivot_wider(names_from = cluster, 
              values_from = cluster, 
              values_fill = 0, 
              values_fn = function(x) 1)

# add metadata
checkv <- data.table::fread("/net/mgx/linuxhome/mgx/courses/Viromics_2022/day_4/checkv_5k/quality_summary.tsv", 
                            header = TRUE)

colnames(checkv)[1] <- 'virus'
checkv$virus <- gsub("\\_cov.*$", "", checkv$virus)
checkv <- select(checkv, virus, contig_length, provirus, checkv_quality)

for_heatmap <- right_join(checkv, for_heatmap)
for_heatmap <- for_heatmap %>% 
  mutate(checkv_quality = fct_relevel(as.factor(checkv_quality), "Complete", "High-quality", "Medium-quality", "Low-quality"))

for_heatmap_tdy <- for_heatmap %>% 
  select(-c(virus, contig_length, provirus, checkv_quality))

for_heatmap_tdy <- as.data.frame(for_heatmap_tdy)
# We have filtered contigs on size and origin, so a lot of protein clusters are now composed of a single protein:
table(colSums(for_heatmap_tdy) < 2)

# So we can remove those

for_heatmap_tdy <- for_heatmap_tdy[, -which(colSums(for_heatmap_tdy) < 2)]

# there are contigs with no proteins in clusters >1:
table(rowSums(for_heatmap_tdy) == 0)
table(rowSums(for_heatmap_tdy) == 1)

rownames(for_heatmap_tdy) <- gsub("\\_length.*", "", for_heatmap$virus)


library(ComplexHeatmap)
h <-  Heatmap(for_heatmap_tdy, 
              show_column_names = FALSE, 
              col = c("white", "blue"), 
              clustering_distance_columns = "euclidean",
              clustering_distance_rows = "euclidean",
              name = "Protein cluster presence", 
              column_title = paste(ncol(for_heatmap_tdy), "Protein clusters (MMSeqs2)"), 
              row_title = paste(nrow(for_heatmap_tdy), "assembly contigs > 10kbp"), 
              left_annotation = rowAnnotation(checkv_quality = for_heatmap$checkv_quality, 
                                              provirus = for_heatmap$provirus,
                                              col = list(checkv_quality = c("Complete" = "green", 
                                                                          "High-quality" = "#1e90ff", 
                                                                          "Medium-quality" = "#a5d3ff", 
                                                                          "Low-quality" = "#ffa500"), 
                                                         provirus = c("Yes" = "black", 
                                                                      "No" = "white")
                                                         ),
                                              border = TRUE
                                              ), 
              border = TRUE
              ) +
  rowAnnotation(length = anno_points(for_heatmap$contig_length, pch = 16, size = unit(1, "mm"), 
                                     axis_param = list(at = c(0, 5e4, 10e4, 15e4), 
                                                       labels = c("0kb", "50kb", "100kb", "150kb")),
                                     width = unit(2, "cm"))) 
h

pdf("l10k.tidy.no.refseq.heatmap.pdf", width = 12, height = 8)
draw(h)
dev.off()


library(ComplexHeatmap)
h_nosize <-  Heatmap(for_heatmap_tdy, 
              show_column_names = FALSE, 
              col = c("white", "blue"), 
              clustering_distance_columns = "euclidean",
              clustering_distance_rows = "euclidean",
              name = "Protein cluster presence", 
              column_title = paste(ncol(for_heatmap_tdy), "Protein clusters (MMSeqs2)"), 
              row_title = paste(nrow(for_heatmap_tdy), "assembly contigs > 10kbp"), 
              left_annotation = rowAnnotation(checkv_quality = for_heatmap$checkv_quality, 
                                              provirus = for_heatmap$provirus,
                                              col = list(checkv_quality = c("Complete" = "green", 
                                                                            "High-quality" = "#1e90ff", 
                                                                            "Medium-quality" = "#a5d3ff", 
                                                                            "Low-quality" = "#ffa500"), 
                                                         provirus = c("Yes" = "black", 
                                                                      "No" = "white")
                                              ),
                                              border = TRUE
              ), 
              border = TRUE,
              row_names_gp = gpar(fontsize = 4)
)

pdf("l10k.tidy.no.refseq.no-contig-size.pdf", width = 12, height = 8)
draw(h_nosize)
dev.off()




Heatmap(for_heatmap_tdy, 
        show_column_names = FALSE,
        col = c("white", "blue"),
        clustering_distance_columns = "euclidean",
        clustering_distance_rows = "euclidean",
        name = "Protein cluster presence",
        column_title = paste(ncol(for_heatmap_tdy), "Protein clusters (MMSeqs2)"),
        row_title = paste(nrow(for_heatmap_tdy), "assembly contigs > 10kbp"),
        left_annotation = rowAnnotation(checkv_quality = for_heatmap$checkv_quality,
                                        provirus = for_heatmap$provirus,
                                        col = list(checkv_quality = c("Complete" = "green",
                                                                      "High-quality" = "#1e90ff",
                                                                      "Medium-quality" = "#a5d3ff",
                                                                      "Low-quality" = "#ffa500"),
                                                   provirus = c("Yes" = "black",
                                                                "No" = "white")
                                        ),
                                        border = TRUE
        ),
        border = TRUE
)




# # Filter refseq >5 PCs  --------------------------
set.seed(786)

clusters_wide <- clusters_filt %>%
  #filter(str_detect(members, "NODE"))  %>%
  filter(length > 9999) %>%
  select(-length, -representative, -members, origin, -count) %>%
  pivot_wider(names_from = cluster,
              values_from = cluster,
              values_fill = 0,
              values_fn = function(x) 1)

table(clusters_wide$origin) # 117 aasembly proteins, 4375 refseq proteins.

 
# Add nr of PCs
clusters_wide <- clusters_wide %>%
  mutate(nr_pcs = rowSums(select(., contains("cluster")))) %>%
  select(virus, origin, nr_pcs, everything())

clusters_wide %>% 
  ggplot() + 
  geom_histogram(aes(x = nr_pcs)) + 
  facet_wrap(~origin, scales = "free") + 
  geom_vline(xintercept = 5, colour = "red")


 
# We filtered on size, so there are again PCs with size 1 or 0:
clusters_wide %>%
  select(-virus, -origin, -nr_pcs) %>%
  colSums() %>%
  table()


# Filter genomes
for_heatmap <- clusters_wide %>%
  filter(origin == "assembly" | nr_pcs > 15)

for_heatmap %>% 
  ggplot() + 
  geom_histogram(aes(x = nr_pcs)) + 
  facet_wrap(~origin, scales = "free") + 
  geom_vline(xintercept = 5, colour = "red")


for_heatmap_tdy <- for_heatmap %>%
  select(-virus, -origin, -nr_pcs)

h <- Heatmap(for_heatmap_tdy,
        show_column_names = FALSE,
        col = c("white", "blue"),
        clustering_distance_columns = "euclidean",
        clustering_distance_rows = "euclidean",
        name = "Protein cluster presence",
        column_title = paste(ncol(for_heatmap_tdy), "Protein clusters (MMSeqs2)"),
        row_title = paste(nrow(for_heatmap_tdy), "sequences"),
        left_annotation = rowAnnotation(origin = for_heatmap$origin,
                                        #checkv_quality = for_heatmap$checkv_quality,
                                        #provirus = for_heatmap$provirus,
                                        col = list(origin = c("assembly" = "white",
                                                              "refseq" = "red")
                                        # col = list(checkv_quality = c("Complete" = "green",
                                        #                               "High-quality" = "#1e90ff",
                                        #                               "Medium-quality" = "#a5d3ff",
                                        #                               "Low-quality" = "#ffa500"),
                                        #            provirus = c("Yes" = "black",
                                        #                         "No" = "white")
                                        ),
                                        border = TRUE
        ),#
        border = TRUE, 
        use_raster =TRUE
)

pdf("10k-contig-refseq-15pcs.pdf", width = 12, height = 8)
draw(h)
dev.off()


# so we still have way too many refseq sequences. 
# Are there unique protein profiles?
for_heatmap %>%
  filter(origin == "assembly") %>% 
  mutate(profile = )


# filter smallest distance to assembly contig --------------
# step 1. find closest refseq for 1 contig
# following https://www.datacamp.com/community/tutorials/hierarchical-clustering-R
set.seed(786)

# step 2. for each assembly contig, find the closest refseq sequence. 
# can we just make a matrix with refseq gene content, and then for each contig 
# calculate the minimum distance to this vector?

tmp <- clusters_filt %>% 
  filter(length > 9999) %>% 
  select(-length, -representative, -members, -count) %>% 
  pivot_wider(names_from = cluster, 
              values_from = cluster, 
              values_fill = 0, 
              values_fn = function(x) 1)

library(Rfast)



#longest <- filter(tmp, virus == "NODE_1_length_170947")
refseqs <- tmp %>% 
  filter(!str_detect(virus, "NODE"))




# for each contig, find the closest refseq sequence
contigs <- filter(tmp, origin == "assembly")

selected_refseqs = list()

for(contig in unique(contigs$virus)){
  cat(contig)
  
  focal_contig <- 
    contigs %>% filter(virus == contig) %>% 
    select(-virus, -origin)
  
  
  t <- dista(focal_contig, select(refseqs, -virus, -origin))
  min_d <- which(t == min(t))
  if(length(min_d) > 1) min_d <- min_d[1] # if multiple hits, pick first genome
  selected_refseqs <- c(selected_refseqs, refseqs[min_d,1])
  print(refseqs[min_d,1])
}

length(selected_refseqs)
length(unique(selected_refseqs))

for_plot <- clusters_filt %>% 
  filter(virus %in%  selected_refseqs | origin == "assembly") %>% 
  filter(length > 9999) %>% 
  select(-representative, -members, -count) %>% 
  pivot_wider(names_from = cluster, 
              values_from = cluster, 
              values_fill = 0, 
              values_fn = function(x) 1)
  

top_hits <- Heatmap(select(for_plot, -virus, -origin, -length),
        show_column_names = FALSE,
        col = c("white", "blue"),
        clustering_distance_columns = "euclidean",
        clustering_distance_rows = "euclidean",
        name = "Protein cluster presence",
        column_title = paste(ncol(for_plot)-3, "Protein clusters (MMSeqs2)"),
        row_title = paste(nrow(for_plot), "sequences"),
        left_annotation = rowAnnotation(origin = for_plot$origin,
                                        #checkv_quality = for_heatmap$checkv_quality,
                                        #provirus = for_heatmap$provirus,
                                        col = list(origin = c("assembly" = "white",
                                                              "refseq" = "red")
                                                   # col = list(checkv_quality = c("Complete" = "green",
                                                   #                               "High-quality" = "#1e90ff",
                                                   #                               "Medium-quality" = "#a5d3ff",
                                                   #                               "Low-quality" = "#ffa500"),
                                                   #            provirus = c("Yes" = "black",
                                                   #                         "No" = "white")
                                        ),
                                        border = TRUE
        ),#
        border = TRUE, 
        use_raster =TRUE
)

pdf("10k-contig-closest-refseqs.pdf", width = 12, height = 8)
draw(top_hits)
dev.off()



# step 3. only include those sequences
# do we need to re-cluster with this filtered dataset?




