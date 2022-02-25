---
title: "Exploring data"
teaching: 0
exercises: 60
questions:
- "What are the differences between absulte abundance and relative abundance?"
- "Why is it necessary to filter out low-abundance features?"
objectives:
- "Plotting absolute abundance, relative abundance and centered-log ratio abundance."
- "Filtering ASVs to exclude low-abundance features."
keypoints:
- "Plot absolute abundance, relative abundance and centered-log ratio abundance plots to see the difference of different abundance measures."
- "Picking thresholds for filtering can be tricky. Play with the thresholds to filter data based on your questions and your data."
---

## Data Overview with FeatureTable
FeatureTable is an R package designed to hold and manipulate sequencing data.
FeatureTable makes it very easy to filter data and make abundance plots.

#### Accessing a FeatureTable object

Load the featuretable object we saved before.
~~~
load("data/pond_featuretable.Rdata")
~~~
{: .language-r}

#### Abundance plots with FeatureTable
Let's take a quick look at the data before we get started. Here's how you make a
very basic plot of ASV abundance in each sample:

~~~
pond_ft$plot()
~~~
{: .language-r}

Onto the plot. First off, the x axis labels aren’t very informative right now. We can
replace the axis labels with more meaningful names using `scale_x_discrete()`:

~~~
pond_ft$plot() + scale_x_discrete(labels=pond_ft$sample_data$Sample)
~~~
{: .language-r}


For now, let’s talk about the plot’s appearance. Notice that 
only 8 ASVs were assigned colors, while the rest were lumped into the “Other” category. The FeatureTable default is to
highlight only the top 8 most abundant ASVs.The bars are all different heights because they represent raw ASV counts for
each sample, which makes it hard to see patterns, especially in samples with fewer
reads overall. The samples are also a little jumbled because they’re still sorted
alphabetically by SRA accession, rather than sample name. That’s because the
featuretable automatically plots row names on the x axis, which in our case are the
SRA accessions. We replaced the names, but not the underlying plotting, so the
samples stayed in the same order.

#### Relative Abundance
Let’s view ASVs in terms of relative abundance rather than raw counts. To do this in
FeatureTable, run this code:

~~~
pond_ft$
# applies the relative abundance function to samples before plotting
map_samples(relative_abundance)$
plot() + scale_x_discrete(labels=pond_ft$sample_data$Sample)
~~~
{: .language-r}

Again we apply the FeatureTable plot function to pond_ft, but we have some new
code in there. Now, `pond_ft` is run through the `map_samples(relative_abundance)`
and the output of that function is fed to `plot()`. If you use the built-in help feature
`(?map_samples())`, you’ll see that the `map_samples()` function is a helper function for
the more general `map()` in FeatureTable and is shorthand for `map(ft, "samples",
relative_abundance)`. For example, you could also write
`pond_ft$map_samples(relative_abundance)` as `map(pond_ft, "samples",
relative_abundance)`.

#### Grouping samples for plotting
Let's break the data apart a bit and see if we can identify related metadata. Looking at
the metadata, the obvious divisions of samples are by Month and Fraction. Let's start
with Month:

~~~
pond_ft$
collapse_samples(Month)$
map_samples(relative_abundance)$
# the plot can be customized using ggplot2 functions
plot(num_features = 12, # plot the top 12 features (ASVs)
legend_title = "ASV", # change legend title
xlab = "Month", # change x axis title label
ylab = "Relative Abundance", # change y axis title label
axis.text.x = element_text(angle = 0)) # change x axis text angle
~~~
{: .language-r}

First, we collapse the samples in `pond_ft` by month using `collapse_samples()`.
Then, relative abundance is calculated for each month using `map_samples()`. Finally,
we plot the result.
If you have used ggplot2 before, the arguments in the plot function should be familiar
to you because the FeatureTable plot function is a wrapper for ggplot2. The only
argument that is unique to FeatureTable is `num_features`, which was used to change
the number of highlighted ASVs (i.e. the number of ASVs assigned a color).

The months are out of order, though. Again, we have things in alphabetical order on the x
axis, but in this case we would prefer them to be in chronological order. To fix this, we
can use `scale_x_discrete()` again.

~~~
pond_ft$
collapse_samples(Month)$
map_samples(relative_abundance)$
plot(num_features = 12,
legend_title = "ASV",
xlab = "Month",
ylab = "Relative Abundance",
axis.text.x = element_text(angle = 0)) +
# reorder x axis labels
scale_x_discrete(limits=c("October", "November", "December"))
~~~
{: .language-r}

Make a similar chart for size fraction. Are there possible differences in the microbial
community based on size fraction?

#### Centered-log ratio Abundance
We know that we should transform the raw counts to centered-log ratios when dealing with compositional data analysis.
Now let’s view ASVs in terms of centered-log ratio abundance in the class level and compare the clr abundance distribution with absolute and relative abundance using heatmaps.

~~~
pond_class_absolute <- pond_ft$collapse_features(Class)$data
rownames(pond_class_absolute) <- pond_ft$sample_data$Sample
absolute_heatmap <- Heatmap(pond_class_absolute)

pond_class_relative <- pond_ft$collapse_features(Class)$map_samples(relative_abundance)$data
rownames(pond_class_relative) <- pond_ft$sample_data$Sample
relative_heatmap <- Heatmap(pond_class_relative)

pond_class_clr <- pond_ft$collapse_features(Class)$replace_zeros(use_cmultRepl = TRUE,method = "GBM")$clr()$data
rownames(pond_class_clr) <- pond_ft$sample_data$Sample
clr_heatmap <- Heatmap(pond_class_clr)

absolute_heatmap
relative_heatmap
clr_heatmap
~~~
{: .language-r}


## Filtering ASVs

Filtering is important because low abundance ASVs (e.g. singletons, doubletons) are
more likely than high abundance ASVs to be the result of sequencing errors and are
often "noise". ASVs are more robust to this than OTUs, but are still not perfect.
Additionally, unfiltered ASV and OTU tables are sparse (i.e. they contain many zeros),
which is not ideal for most statistics; It is hard to compare samples based on ASVs that
appear in only a few samples.
Let’s include only taxa with more than 10 reads (on average) in at least 10% samples.

~~~
pond_core_phyloseq <- phyloseq_filter_prevalence(pond_phyloseq, prev.trh = 0.1, abund.trh = 10, abund.type = "mean", threshold_condition = "AND")
print(pond_core_phyloseq) # should have 24 samples and 1842 features
save(pond_core_phyloseq, file = "data/pond_core_phyloseq.Rdata")
~~~
{: .language-r}

In the above examples, I picked 10 for the detection limit (i.e. an ASV with a count of
less than 10 will be removed), but it's an arbitrary cutoff. That being said, any detection
limit is generally arbitrary. The minimum sample proportion is also fairly arbitrary. I
picked it because it was small enough not to exclude an entire month or size fraction
from analysis, but also big enough to filter out rarer OTUs.
Normally, you'd probably want to fiddle around with the detection limit and
minimum sample proportion and see if the data changes too much. 

{% include links.md %}
