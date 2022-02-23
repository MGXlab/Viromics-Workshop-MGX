---
title: "Integrating annotations"
teaching: 30
exercises: 30
questions:
- ""
objectives:
- ""
keypoints:

---

Now it is time to compare the model search with that of the invidual proteins. We will load the HHblits results from the "single" and "cluster" search in R and then join the tables to see the differences. 

Our anotation files (for both "single" and "cluster/msa") only contain information for a protein when there actually was a match found. However, we are also interested in all the proteins that didn't get annotated either way. Hence we will first grep those from the proteins.faa file. Being in the `day3` folder the command can look like this:

~~~
grep "^>" prodigal_default/proteins.faa | cut -f 2 -d ">" | cut -f 1 -d " " > all_prodigal_genes.txt
~~~
{: .languare-bash}


And then you can use R code like this to look at the differences and similarities, again change the file paths.

~~~
library(dplyr)

# Load all the proteins we have
all.proteins <- read.table('all_prodigal_genes.txt') %>% pull(V1)

# First load the original annotation
single.anno <- read.table('hhsearch_results.txt', comment.char = '', sep = '\t', header = T, na.strings = "")

# Load the cluster anno too
cluster.anno <- read.table('msa_hhsearch_results.txt', comment.char = '', sep = '\t', header = T, na.strings = "")

# Now lets clean the tables a bit
single.anno <- single.anno %>% select(protein = query, target, annot, category)
cluster.anno <- cluster.anno %>% select(protein = member, target, annot, category, cluster.ref = reference)

# Change datatype
single.anno$annot <- as.character(single.anno$annot)
cluster.anno$annot <- as.character(cluster.anno$annot)

# Join them
res <- cluster.anno %>%
  filter(grepl('bin_', protein)) %>%
  left_join(single.anno, by = 'protein', suffix = c('cluster', 'single')) %>%
  mutate(protein = as.vector(protein))

# Cluster search found things that were not found by single
cluster.better <- res %>% filter(is.na(annotsingle) & !is.na(annotcluster))

# Both did find a result but it's an "unknown function"
both.uknowns <- res %>% filter(is.na(annotsingle) & is.na(annotcluster))

# Different annotation
dif.annot <- res %>%
  filter(!is.na(annotsingle) & is.na(annotcluster)) %>%
  filter(annotsingle != annotcluster)

# Consensus annotation
conc.annot <- res %>%
  mutate(annot = case_when(
    is.na(annotsingle) & !is.na(annotcluster) ~ annotcluster,
    is.na(annotcluster) & !is.na(annotsingle) ~ annotsingle,
    !is.na(annotcluster) & !is.na(annotsingle) ~ annotsingle,
    TRUE ~ 'NA'
  ))

# What did we actually annotate (including unknown)
annotated.proteins <- conc.annot %>% filter(!is.na(annot)) %>% pull(protein)


# You might have noticed that this only includes clusters that
# were actually mapped to a PHROG annotation (even though that might be "unknown")
# in either the single protein search or cluster search, but it does not include
# proteins that did not get any hit for both searches. To get all proteins
# that were not annotated at all we get the difference between `all_proteins`
# and annotated.proteins
not.annotated <- setdiff(all.proteins, annotated.proteins)
~~~
{: .languare-r}

We will now only look at the "annot" columns, so `annotsingle` and `annotcluster`. Use `View` to view several of the dataframes we created with the above code, such as the `both.unknowns` and `not.annotated`.

> ## Compare annotations
> - __Was our profile search approach able to annotate proteins that, using the single search, remained unannotated? If so how many?__
> - __How many proteins didn't get annotated in both the single and cluster search?__
{: .challenge}


{% include links.md %}
