---
title: "Alpha diversity"
teaching: 30
exercises: 60
questions:
- "What is alpha diversity?"
- "What common alpha diversity indices are there?"
- "How to compare alpha diversity between samples?"
objectives:
- "Running alpha diversity analysis using phyloseq & DivNet."
- "Interpreting alpha diversity measures."
- "Statistical comparison of diversity indices usign hill numbers."
keypoints:
- "Different alpha diversity indices emphasize on different aspects of alpha diversity. Make choices based on your questions and interpret the results based on the methods you choosed."
- "Hill numbers are linear and intuitive while original alpha diversicy index values are not."
---


## Alpha diversity with phlyloseq

Alpha diversity metrics measure species richness and evenness within samples.
Unlike ordination and beta diversity, alpha diversity is a within-sample measure that is
independent from other samples (although you could choose to pool samples by
categories).
The [Diversity Metrics doc](https://github.com/lingyi-owl/jena_workshop/blob/gh-pages/files/Diversity%20metrics.pdf) contains information about all of the diversity indices you’ll
see coming up, as well as how each index treats richness and evenness. For more
thorough explanations, there are a lot of good ecology resources out there.

There is a more thorough breakdown of alpha diversity indices in the Diversity Metrics
doc, but here's a brief rundown because it's important to know how the indices are
calculated when looking through these plots. Chao1 and observed ASVs are similar
and both are different from Shannon and Simpson. Chao1 attempts to estimate the
number of missing species and is sensitive to singletons. Observed ASVs counts the
number ASVs are present in each sample. Therefore, these metrics are only
measuring richness. Shannon and Simpson take into account both richness and
evenness. The Hill numbers, also known as effective number of species, show the
number of perfectly even species that would have to be present to return certain
alpha diversity values. They can be calculated from Shannon, Simpson, and a variety
of other metrics. See [Joust 2006](http://www.loujost.com/Statistics%20and%20Physics/Diversity%20and%20Similarity/JostEntropy%20AndDiversity.pdf) for details on conversions.

Before we get to the plotting, here’s a way to make sure that the samples are plotted
in chronological order.

~~~
# make a vector with the samples in the desired plotting order
sample_order <- c("Oct_1_1", "Oct_1_2", "Oct_1_3", "Oct_1_4",
"Oct_02_1", "Oct_02_2", "Oct_02_3", "Oct_02_4", "Nov_1_1", "Nov_1_2",
"Nov_1_3", "Nov_1_4", "Nov_02_1", "Nov_02_2", "Nov_02_3", "Nov_02_4",
"Dec_1_1", "Dec_1_2", "Dec_1_3", "Dec_1_4", "Dec_02_1", "Dec_02_2",
"Dec_02_3", "Dec_02_4")
# turn the Sample column in the sample metadata into a character within the phyloseq object
pond_phyloseq@sam_data$Sample <- pond_phyloseq@sam_data$Sample %>%
as.character()
# use factor() to apply levels to the Sample column
pond_phyloseq@sam_data$Sample <- factor(pond_phyloseq@sam_data$Sample,
levels = sample_order)
~~~
{: .language-r}

#### Plot alpha diversity using phyloseq
~~~
# make and store a plot of observed otus in each sample
# plot_richness() outputs a ggplot plot object
observed_otus_plot <- plot_richness(pond_phyloseq,
  x = "Sample",
  measures = c("Observed"),
  color = "Month",
  shape = "Fraction") +
  geom_point(size = 3) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(y = "Observed ASVs")
 
observed_otus_plot
~~~
{: .language-r}

>## Challenge: Make alpha diversity plots of Chao1, Shannon, and Simpson
> Change the value in "measures" to plot Chao1, Shannon and Simpson.
{: .challenge}

#### Plot alpha diversity using Hill Numbers
~~~
shannon <- estimate_richness(pond_phyloseq,
measures = c("Shannon"))
hill_shannon <- sapply(shannon, function(x) {exp(x)}) %>% as.matrix()
row.names(hill_shannon) <- row.names(shannon)
# merge the hill numbers with the sample metadata based on their
# rownames
hill_shannon_meta <- merge(hill_shannon, sample_data, by =
"row.names")
colnames(hill_shannon_meta)[colnames(hill_shannon_meta) == "Shannon"] <- "Hill"
hill_shannon_plot <- ggplot(data = hill_shannon_meta) +
  geom_point(aes(x = Sample,
  y = Hill,
  color = Month,
  shape = Fraction),
  size = 3) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Effective Shannon Diversity Index",
  y = "Effective number of species") +
  scale_x_discrete(limits = sample_order)
  
hill_shannon_plot
~~~
{: .language-r}

>## Challenge: Plot alpha diversity using Hill Numbers from Simpson
> 1. get the simpson index values from the phyloseq object and convert to a matrix.
> 2. calculate Hill numbers and convert to a matrix.
> the formula for Hill numbers from Simpson is 1/(1-D).
> 3. give the hill_simpson matrix some row names.
> 4. merge the hill numbers with the sample metadata based on rownames.
> 5. change the name of the column from Simpson to Hill.
> 6. make and store a ggplot of the Simpson Hill numbers
{: .challenge}

#### Arrange all 6 plots on a single grid
You should run that last bit of code (the grid.arrange()) in the R console to get the
plots to appear in the plots tab. From there, you can use the zoom feature to open up
the plots in a new, bigger window.
~~~
grid.arrange(observed_otus_plot,
chao1_plot,
shannon_plot,
simpson_plot,
hill_shannon_plot,
hill_simpson_plot,
ncol = 2)
~~~
{: .language-r}

>## Discussion: 
> What do you see from the plot? What do the results of each index tell you about the diversity of the microbial community in each sample?
{: .discussion}

The observed ASVs and Chao1 measures tell us that the November samples have a
higher richness than the Ocotober samples, followed by the December samples. The
Shannon, Simpson, and derived Hill numbers tell us that the October samples are
more even than the November and December samples. In almost all months, the 1 μm
fraction is more even and richer than the 0.22 μm-1 μm fraction.

#### Plot alpha diversity using phylogenetic information
Phylogenetic trees can also be taken into account when measuring diversity. Faith's
PD (phylogenetic distance) is one such measure and is equal to the sum of the
lengths of the branches of all members of a sample (or other group) on a phylogeny.
We can calculate it using the `pd` function from the package picante.

~~~
faiths <- pd(t(counts), # samples should be rows, ASVs as columns
  tree,
  include.root = F) # our tree is not rooted
  faiths_meta <- merge(faiths, sample_data, by = "row.names")
  faiths_plot <- ggplot(data = faiths_meta) +
  geom_point(aes(x = Sample,
  y = PD,
  color = Month,
  shape = Fraction),
  size = 3) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Faith's phylogenetic distance",
  y = "Faith's PD")

faiths_plot
~~~
{: .language-r}

## Alpha diversity with Divnet

The phyloseq package calculates alpha diversity metrics based solely on the numbers
in the ASV table. If you were dealing with true counts obtained from an exhaustive
ecological survey, calculating diversity metrics as above would be completely valid.
Some of the above diversity metrics do try to account for "missing" taxa (e.g. Chao1),
but most are not designed to work with compositional data.

DivNet is compatible with Compositional Data Analysis (CoDA). Like the Chao1 metric,
DivNet uses the existing data to estimate the number of unobserved taxa. But, the
DivNet model is more robust and isn't nearly as reliant on singletons, which are often
the result of sequencing error. DivNet also takes into account that the abundances in
the ASV table are not true counts. DivNet can also leverage sample metadata to
enhance model fitting. For example, the four quadrants sampled in the pond study
are really replicates, leaving size fraction and month as the major sample groups.
With DivNet, we can make that clear to the model and make the diversity estimates
more accurate.

The downside of DivNet is that it's inner-workings are more complicated than other
packages that calculate diversity metrics. The details are in the [DivNet paper](https://academic.oup.com/biostatistics/article/23/1/207/5841114). Briefly,
DivNet uses Monte Carlo estimation to introduce randomness and calculate an
integral for each sample group of interest. DivNet does return plug-in estimates of
diversity measures (the same values you get by treating the ASV abundances as true
counts), but the Monte Carlo estimation allows DivNet to add error bars.

The other downside is that the R version of DivNet has trouble with larger datasets
(like our pond dataset).

In this walkthrough, we’ll collapse our ASVs by taxonomy so we can run DivNet
entirely in R. In a real analysis, you would want to run the Rust version DivNet on the
ASV table. With more than 1000 or so ASVs, the R version of DivNet would take a long
time to finish. With more than ~2500, your R is likely to crash. 

~~~
# Featuretable is easier to use in this case
load("data/pond_featuretable.Rdata")
# build a model matrix for DivNet
mm <- model.matrix(
~ Month + Fraction,
data = pond_ft$sample_data)

pond_class_counts <- pond_ft$collapse_features(Class)$data
rownames(pond_class_counts) <- pond_ft$sample_data$Sample

# setting the seed for the random number generator makes DivNet
# results reproducible
set.seed(20200318)
# run DivNet
divnet <- divnet(W = pond_class_counts, X = mm, tuning = "careful")
~~~~
{: .language-r}

There are a few ways to input data to DivNet. creating a model matrix (like we
did here) might be the easiest path if you want to include more than one independent
variable in your model. Other ways of inputting data are described in the DivNet
vignettes.

You may have noticed that we didn’t include quadrant as a variable in the model
matrix. This is because the quadrants are essentially replicates, as we saw in the
relative abundance plots.

This next command will show you all the diversity metrics that DivNet calculated.

~~~
divnet %>% names
~~~
{: .language-r}

DivNet calculates a lot of different indices, including some beta diversity measures,
but we’ll focus on Shannon and Simpson because they’re common in the literature
and to compare them to the measurements from earlier.

You can make plots with DivNet, but they're not the nicest, so we'll extract the
Shannon and Simpson estimates and combine them with the metadata.

~~~
# get the Shannon estimates as a data frame
shannon_divnet <- divnet$shannon %>% # access the shannon section
# use summary to get just the numbers
summary %>%
# turn the numbers into a data frame
as.data.frame
# change the name of the column with the sample names to match the
# name of the same column from sample_data
names(shannon_divnet)[names(shannon_divnet) == "sample_names"] <-
"Sample"
# if you’re unclear on how this works, try googling how to change the
# name of a single data frame column in R
# merge the Shannon data frame with the sample metadata
shannon_divnet_meta <- merge(shannon_divnet, sample_data, by =
"Sample")
~~~
{: .language-r}

>## Challenge: Calculate simpson diversity using DivNet
> Fill in the same process as above, but for simpson
{: .challenge}


Now, you can make some nice ggplots!
~~~
shannon_divnet_plot <- shannon_divnet_meta %>%
  ggplot(aes(x = Sample,
  y = estimate,
  color = Month,
  shape = Fraction)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = lower,
  ymax = upper),
  width = 0.3) +
  theme_bw() +
  ylab("Shannon Diversity Index (H) Estimate") +
  scale_x_discrete(limits = sample_order) +
  theme(axis.text = element_text(angle = 90, hjust = 1)) 

simpson_divnet_plot <- simpson_divnet_meta %>%
  ggplot(aes(x = Sample,
  y = estimate,
  color = Month,
  shape = Fraction)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = lower,
  ymax = upper),
  width = 0.3) +
  theme_bw() +
  ylab("Simpson's Index of Diversity (D) Estimate") +
  scale_x_discrete(limits = sample_order) +
  theme(axis.text = element_text(angle = 90, hjust = 1)) 


grid.arrange(shannon_divnet_plot, simpson_divnet_plot, ncol = 2)
~~~
{: .language-r}

Note that I call the values produced by DivNet estimates, because the DivNet
algorithm estimates the number of missing species over many iterations and
calculates the diversity indices over the range of values rather than set values. This is
also why the DivNet plots have error bars.

The Shannon diversity estimates from DivNet are lower than the values calculated by
phyloseq because we ran DivNet at the Class level instead of the ASV level. Overall
though, the results are similar. October has the highest Shannon estimate and
November and December are ower. The 1 μm size fraction samples have a
higher Shannon diversity than the 0.2 μm fraction samples for all months.

Looking at the Simpson plot, however, you'll notice a big difference between the
DivNet and phyloseq results. Some of the difference is due to estimating diversity at
the Class level. But, most of the difference is because the two programs are
calculating slightly different forms of Simpson. phyloseq is calculating Simpson's
Index (D), while DivNet is calculating Simpson's Index of Diversity (aka the
Gini-Simpson Index) (1 - D). If we subtract the DivNet Simpson estimate from 1 during
plotting, we get an answer that looks more like the phyloseq results.

~~~
simpson_divnet_meta %>%
  ggplot(aes(x = Sample,
  y = 1 - estimate, # convert Simpson from D to 1 - D
  color = Month,
  shape = Fraction)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = 1 - lower, # don’t forget to convert
  ymax = 1 - upper), # the error bars!
  width = 0.3) +
  theme_bw() +
  ylab("Simpson's Index of Diversity (1 - D) Estimate") +
  scale_x_discrete(limits = sample_order) +
  theme(axis.text = element_text(angle = 45, hjust = 1))
~~~
{: .language-r}

Now the pattern for Simpson is more similar to the phyloseq result and the Shannon
result from DivNet. According to Simpson's Index of Diversity, the November samples
are more diverse than the December samples from the same size fraction. 

If we want to calculate Hill numbers (effective number of species, or really effective
number of classes in this case) again, we can do it like this:

~~~
shannon_divnet_hill <- shannon_divnet_meta %>%
  ggplot(aes(x = Sample,
  y = exp(estimate),
  color = Month,
  shape = Fraction)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = exp(lower),
  ymax = exp(upper)),
  width = 0.3) +
  theme_bw() +
  labs(title = "Effective Shannon Diversity Estimate",
  y = "Effective Number of Classes") +
  scale_x_discrete(limits = sample_order) +
  theme(axis.text = element_text(angle = 90, hjust = 1))

simpson_divnet_hill <- simpson_divnet_meta %>%
  ggplot(aes(x = Sample,
  y = 1/estimate,
  color = Month,
  shape = Fraction)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = 1/lower,
  ymax = 1/upper),
  width = 0.3) +
  theme_bw() +
  labs(title = "Effective Simpson's Index Estimate",
  y = "Effective Number of Classes") +
  scale_x_discrete(limits = sample_order) +
  theme(axis.text = element_text(angle = 90, hjust = 1))

grid.arrange(shannon_divnet_hill, simpson_divnet_hill, ncol = 2)
~~~
{: .language-r}


#### Significance testing

We can also do significance testing of our DivNet diversity estimates. DivNet is
actually one of two related R packages by the same author. DivNet estimates alpha
and beta diversity and the package breakaway estimates richness. Breakaway also
includes a function, betta(), that can be used to do hypothesis testing of diversity
measures calculated using either of the packages.

betta() is a bit confusing. The package author’s tutorial is [here](https://adw96.github.io/breakaway/articles/diversity-hypothesis-testing.html).

{% include links.md %}
