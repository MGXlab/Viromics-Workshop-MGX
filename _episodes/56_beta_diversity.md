---
title: "Beta diversity"
teaching: 0
exercises: 30
questions:
- "What is beta diversity?"
- "How to compare beta diversity between samples?"
objectives:
- "Replacing zeros with zCompositions."
- "Centered log-ratio transformation of the count table."
- "Calculating distance/dissimilarity measures with base R, vegan, and phyloseq."
- "Performing PCA with biplotr."
- "Interpreting beta diversity measures through ordination."
keypoints:
- "Understand the similairties and dissimilarites of different beta diversity/distance matrices."
- "Aitchison distance is the distance between samples or features within simplex space. We use Aitchison distance in compositional data analysis."
---

## Beta diversity ordination

We're using PCA here (principal components analysis). PCoA (principal coordinate
analysis) is similar, and even identical with certain distance measures, but is not
compatible with compositional data.
There are introductions to [compositional data](https://github.com/lingyi-owl/jena_workshop/blob/gh-pages/files/Vocabulary.pdf), [ordination](https://github.com/lingyi-owl/jena_workshop/blob/gh-pages/files/Statistical%20methods.pdf), and [beta diversity](https://github.com/lingyi-owl/jena_workshop/blob/gh-pages/files/Diversity%20metrics.pdf) in the docs.

#### Replace zeros with zCompositions and clr transform

zCompositions provides a few methods for handling zeros. Here, I use GBM
(Geometric Bayesian multiplicative), but SQ (square root Bayesian multiplicative) and
CZM (count zero multiplicative) are also fine choices. Notice that before zero
replacement and transformation, we filter out ASVs in at least 25% samples with a
detection limit of 20.
(We didn't perform zero replacement or transform counts in the Getting Started or
Alpha Diversity lessons because we weren't dealing with statistics yet. We were
purely getting a feel for our data.)

~~~
# Include only taxa with more than 10 reads (on average) in at least 10% samples
pond_core_phyloseq <- phyloseq_filter_prevalence(pond_phyloseq, prev.trh = 0.1, abund.trh = 10, abund.type = "mean", threshold_condition = "AND")
print(pond_core_phyloseq) # should have 24 samples and 1842 features
save(pond_core_phyloseq, file = "data/pond_core_phyloseq.Rdata")
pond_core_phyloseq_otu_table <- as.data.frame(phyloseq::otu_table(pond_core_phyloseq))
pond_core_ft <- FeatureTable$new(t(pond_core_phyloseq_otu_table), taxonomy, sample_data)
print(pond_core_ft)
save(pond_core_ft, file = "data/pond_core_featuretable.Rdata")

pond_core_clr <- pond_core_ft$
  # Replace zeros with zCompositions cmultRepl GBM method
  replace_zeros(use_cmultRepl = TRUE,
  method = "GBM")$
  # Then take CLR with base 2
  clr()
~~~
{: .language-r}

#### Perform PCA on the transformed data

Use the $pca_biplot() command to make a PCA from a FeatureTable object:
~~~
# perform PCA using the biplotr package and store it as object p
p <- pond_core_clr$pca_biplot(use_biplotr = TRUE,
# give biplotr access to sample metadata
include_sample_data = TRUE,
# includes or excludes arrows on the plot
arrows = FALSE,
# color points by Month
point_color = "Month")
# plot the PCA you saved above
p$biplot
~~~
{: .language-r}

The biplotr package performs PCA using Euclidean distance. As mentioned in the
[beta diversity](https://github.com/lingyi-owl/jena_workshop/blob/gh-pages/files/Diversity%20metrics.pdf) doc, 
Euclidean distance based on log-ratio transformed
abundances is equivalent to Aitchison distance based on untransformed values.
Aitchison distance is the distance between samples or features within simplex space.
Right now, we’re interested in looking at how the samples are related based on the
community matrix. At this time, we’re not necessarily interested in the individual
ASVs, which is why we excluded the arrows. If you set arrows to TRUE, 1658 arrows will
appear on the plot, one for each ASV that passed the filtering criteria. We will be
taking a look at ASVs in the next lessons.
Our plot isn’t very pretty, so let’s make it nicer! We can also add a way to distinguish
samples from different fractions in addition to the month divisions. The biplotr
creates a ggplot2 object, which will make this easy for us. Ggplot2 is very well
documented, so you should have an easy time looking up any of the commands you
don’t understand.

### Modify plots
~~~
# access the PCA plot itself from the saved object
p$plot_elem$biplot_chart_base +
  # plot the first and second principal components and
  # color the points by month and change the shape to indicate size
  # fraction
  geom_point(aes(x = PC1, y = PC2, color = Month, shape = Fraction),
  size = 3) +
  # set the colors to the first three values in the Kelly color
  # palette
  scale_color_manual(values = featuretable:::ft_palette$kelly[1:3]) +
  # change the ggplot2 theme
  theme_classic() +
  # change the plot title (to nothing, in this case)
  ggtitle("PCA of clr-transformed abundances")
~~~
{: .language-r}

>## Discussion: 
> What do you see from the plot? What does the PCA plot of clr-transformed abundances tell you about the microbial community diversity between samples?
{: .discussion}

Samples separate first by month, and then by size
fraction. PC1, which explains the most variation in the data, seems to be correlated
with month. November occurs between October and December on PC1, indicating a gradient of change over time.

#### PCA of Bray-Curtis
Bray-Curtis dissimilarity is a commonly used distance metric in microbial ecology
literature. Bray-Curtis dissimilarity cannot be calculated with negative values, so we
will use the raw, untransformed counts to calculate it. Bray-Curtis distance is
therefore not CoDA friendly, but it's something you'll see a lot and will usually have
the same general result as an Aitchison distance PCA.

~~~
# Bray-Curtis can't be performed with negative numbers, so we need the
# untransformed abundance values
counts <- pond_core_ft$
  data
  # calculate Bray-Curtis dissimilarity and turn it into a matrix
  dist_bc_mat <- vegdist(counts, method = "bray") %>% as.matrix()
  # use the biplotr package to perform PCA
  bc_pca <- pca_biplot(data = dist_bc_mat,
  arrows = FALSE)
  
bc_pca$biplot
~~~
{: .language-r}

The `vegdist()` command comes from the vegan package and can be used to
calculate many types of distances (try `?vegdist()`).

The reason this first plot does not have any color is because the Bray-Curtis distances
we gave to biplotr were not connected to any metadata, unlike when we were using a
FeatureTable object. Let’s clean up this PCA as well, though this time we will have to
work slightly harder to unite all of the data.

~~~
# join sample metadata with the principal component scores
# the row names will match, so we can merge on those
bc_pca_data <- merge(bc_pca$biplot$data,
  pond_core_ft$sample_data,
  by = "row.names")
# use ggplot2 to plot the scores with metadata
bc_pca_data %>%
  ggplot() +
  geom_point(aes(x = PC1, y = PC2, color = Month, shape = Fraction),
  size = 3) +
  scale_color_manual(values = featuretable:::ft_palette$kelly[1:3]) +
  theme_classic() +
 # add labels for the percentage of variance explained by each axis
  ggtitle("Bray-Curtis PCA")
~~~
{: .language-r}

You may have noticed that the Bray-Curtis PCA axes explain more of the variation in
the data than the axes in the euclidean/Aitchison PCA. That's a side effect of having
performed the PCA on a distance matrix for the Bray-Curtis plot rather than
performing PCA on the count table as we did for the Aitchison plot. A PCA performed
on a distance matrix will always show more variation explained than a PCA performed
on a count table because there are fewer variables.

#### PCA of UniFrac

Aitchisin and Bray-Curtis distances only take ASV abundance into account. UniFrac
(Unique Fraction metric) incorporates phylogenetic relatedness and the weighted
version includes ASV abundance. Unweighted UniFrac only considers ASVs in terms
of presence/absence. Therefore, unweighted UniFrac is CoDA-compatible, but the
weighted version is not.
We'll use the phyloseq package to calculate UniFrac distance. F we’ll use the distance() function from `phyloseq` to calculate weighted and unweighted
UniFrac:

~~~
# calculate weighted unifrac, convert to matrix, and save result
weighted <- distance(pond_core_phyloseq,
  method = "wunifrac") %>%
  as.matrix()
# calculate unweighted unifrac, convert to matrix, and save result
unweighted <- distance(pond_core_phyloseq,
  method = "uunifrac") %>%
  as.matrix()
~~~
{: .language-r}

And now we can perform PCA on the UniFrac distances using biplotr and make some
nice looking plots:

~~~
weighted_pca <- pca_biplot(weighted, arrows = F)
unweighted_pca <- pca_biplot(unweighted, arrows = F)
# join sample metadata with the principal component scores
weighted_pca_data <- merge(weighted_pca$biplot$data,
  pond_ft$sample_data,
  by = "row.names")
unweighted_pca_data <- merge(unweighted_pca$biplot$data,
  pond_ft$sample_data,
  by = "row.names")
# use ggplot2 to plot the scores with metadata
weighted_pca_data %>%
  ggplot() +
  geom_point(aes(x = PC1, y = PC2, color = Month, shape = Fraction),
  size = 3) +
  scale_color_manual(values = featuretable:::ft_palette$kelly[1:3]) +
  theme_classic() +
  ggtitle("Weighted UniFrac")

unweighted_pca_data %>%
  ggplot() +
  geom_point(aes(x = PC1, y = PC2, color = Month, shape = Fraction),
  size = 3) +
  scale_color_manual(values = featuretable:::ft_palette$kelly[1:3]) +
  theme_classic() +
  ggtitle("Unweighted UniFrac")
~~~
{: .language-r}

>## Discussion: 
> What do you see from the plot? What does the PCA plot of weighted and unweighted Unifract tell you about the microbial community diversity between samples?
{: .discussion}

Weighted and unweighted UniFrac are noticeably different. In
both cases, samples from the same Month and Fraction group together, but the
Month as a whole groups more tightly on the weighted chart. PC1 on the weighted
UniFrac chart seems to represent the difference between October and the other two
months, whereas PC2 differentiates November and December. In the unweighted
chart, Month seems to drive separation on PC1, the weighted UniFrac PCA more closely resembles the Aitchison and
Bray-Curtis PCAs. This makes sense, because Aitchison and Bray-Curtis distances are
also based in ASV abundance (though they do not take phylogeny into account).
