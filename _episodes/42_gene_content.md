---
title: "Clustering contigs based on shared protein clusters"
teaching: 0
exercises: 60
questions:
- "Can we cluster viral contigs based on shared protein clusters?"
objectives:
- "Identify protein clusters (PCs) that are shared between contigs"
- "Infer taxonomy of contig clusters by adding RefSeq genomes with known taxonomy"
keypoints:
- ""

---
### Clustering sequences based on Gene content

#### Preparations
We provide an R script `day4_clustering.R` for today's analysis in `LOCATION OF SCRIPTS`. However if you are familiar with making heatmaps and clustering data in R (or any other language), please feel free to make your own script: we only provide a script to allow you focus on the underlying biology without being bogged down by boring programming.

For this part of the workshop you are going to use Rstudio and a number of packages ([Tidyverse](https://www.tidyverse.org/), [ComplexHeatmap](https://jokergoo.github.io/ComplexHeatmap-reference/book/]). These have been installed in the `day4_clustering` conda environment, so we first activate it:

~~~
# Activate the conda environment
$ conda activate day4_rstudio

# Create a directory to keep your files and move to it
$ mkdir day4
$ cd day4

# Start Rstudio
$ rstudio &
~~~
{: .bash}

Open the `code/day4/clustering.R` script and follow the steps below.

#### Step 1. Data exploration
First, load the libraries and read the data from `annotated_clusters.txt` in R. Take a moment to look at what was in that file. What's in each of the different columns?

#### Step 2. Cluster contigs based on gene content
Follow the steps in the script to explore and clean up the data (up to line 40). Finally, cluster the assembled contigs based on protein clusters (PCs).   

>## Question: Clustering contigs based on shared protein clusters
> Try a few different length cutoffs. Explain what you see
>
>{: .discussion}

**Q: explain what you see?**  
A:
- Sparse clustering indicates high viral diversity. Contigs share only a very limited set of proteins.
- There are small clusters of sequences that share genes. Are these viral families? Genera? Let's try to find out!

To annotate our contigs, we need to **add sequences with known taxonomy**.

#### Step 3. Add RefSeq Genomes ####
Now add the selected reference sequences with known taxonomy to your heatmap. Can we infer the taxonomy for some of our contigs?

(Note: here we need to add the reference set, which is still to be determined by Dani.
Previously I made a selection of RefSeq sequences by finding for each contig the closest RefSeq sequence (euclidean distance based on shared proteins, from the total set of protein clusters that are included in the heatmap. I can include that as a back-up plan, but we decided to use the same set of RefSeq sequences for the heatmap and the gene tree.

Observations:
- most sequences do not cluster with a RefSeq sequence. So most viral diversity is uncharted and cannot be annotated in this way: there are no closely related sequences in RefSeq, or perhaps our clusterin method isn't sensitive enough.
**Q:** can you think of a way to improve this?  

#### Step 4. Add gene annotations ####
Although there are no marker genes that are shared across all viruses or even bacteriophages (like 16S for prokaryotes), for some taxonomic groups there are (sets) of marker genes that can be used to reconstruct the phylogeny. For *caudovirales* there are three such genes: portal, major capsid protein, and the terminase large subunit.

**Challenge:**
Find out of the terminase large subunit proteins are all in a single PC, or if they are split across many different PCs, for example by examining the clusters or annotating the heatmap columns (take a look at the [ComplexHeatmap documentation](https://jokergoo.github.io/ComplexHeatmap-reference/book/) to see how to do this). How does this influence the gene sharing approach we use here?


**TO DO**
- add conda environment (Jeroen)
- add solution code to annotation challenge
- add binning information (Jeroen)

## Dropped because we switched to using bins instead of contigs:
**Q:** What potential technical problems do you see with this approach?
- contigs could be **genome fragments** rather than complete genomes, which would limit clustering (not true if using bins)  
- protein clustering could not be sensitive enough, e.g. homologous proteins (such as terminase large subunit) could be split across different PCs, which would display as a lack of clustering.

**Discussion point:**
How does the diversity within protein families (clusters) relate to viral taxonomy (and the sparseness of sampling of viral diversity)?


#### Challenge: add CheckV completeness estimations to the heatmap (checkv doesn't work on bins)####
On day 1, you ran [CheckV](https://www.nature.com/articles/s41587-020-00774-7) to estimate the completeness of viral contigs. Add this data as a column annotation to the heatmap. Consult the [ComplexHeatmap documentation](https://jokergoo.github.io/ComplexHeatmap-reference/book/) if necessary.

--> we see that there are a few complete or high quality genomes, but most of the sequences appear to be incomplete.




{% include links.md %}
