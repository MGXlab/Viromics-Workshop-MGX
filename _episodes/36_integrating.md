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

Now it is time to compare the model search with that of the invidual proteins. We will load the HHblits results from the "single" and "cluster" search in R and then join the tables to see the differences. You will have to change the file paths for `hhsearch_results.txt` and `msa_hhsearch_results.txt`.

~~~
library(dplyr)

# First load the original annotation
single.anno <- read.table('hhsearch_results.txt', comment.char = '', sep = '\t', header = T, na.strings = "")

# Load the cluster anno too
cluster.anno <- read.table('msa_hhsearch_results.txt', comment.char = '', sep = '\t', header = T, na.strings = "")

# Now lets clean the tables a bit
single.anno <- single.anno %>% select(protein = query, target, annot, category)
cluster.anno <- cluster.anno %>% select(protein = member, target, annot, category)

# Join them
res <- cluster.anno %>%
  filter(grepl('bin_', protein)) %>%
  left_join(single.anno, by = 'protein', suffix = c('cluster', 'single'))

View(res)
~~~
{: .languare-r}

We will now only look at the "annot" columns, so `annotsingle` and `annotcluster`.

> ## Compare annotations
> - __Was our profile search approach able to annotate proteins that, using the single search, remained unannotated? If so how many?__
> - __How many proteins didn't get annotated in both the single and cluster search?__
{: .challenge}


{% include links.md %}
