---
title: "Differential abundance"
teaching: 0
exercises: 30
questions:
- "Which features vary in abundance with categorical variables?"
objectives:
- "use ALDEx2 and ANCOM to perform differential abundance analysis."
keypoints:
- "Use clr transformation to transform the data"
---


#### Load data
We will use the core FeatureTable object we saved earlier for this task.
~~~
load("data/pond_core_featuretable.Rdata")
~~~
{: .language-r}

## Differential abundance
In addition to wondering which ASVs vary in abundance with continuous variables
(e.g. salinity, dissolved oxygen), you probably also want to know which ASVs vary in
abundance with categorical variables (e.g. Month, Fraction).
For differential abundance testing, we'll use ALDEx2 (ANOVA-Like Differential
Expression) here. Another common method you'll see in papers is ANCOM. Both are
CoDA compatible, so long as your counts have been log-ratio transformed. ALDEx2 
will do the transformation for us, so we can feed it an untransformed ASV table.
Unfortunately, ALDEx2 doesn't currently support testing more than two groups at
once, so we'll have to test some combinations by hand. Luckily, the feature table
makes it really easy to select samples based on metadata.

~~~
# October by fraction
oct_one_ft  <-  pond_core_ft$keep_samples(Fraction == "1um" & Month ==
"October")
oct_two_ft <-pond_core_ft$keep_samples(Fraction == "0.2um" & Month ==
"October")
# November by fraction
nov_one_ft <- pond_core_ft$keep_samples(Fraction == "1um" & Month ==
"November")
nov_two_ft <- pond_core_ft$keep_samples(Fraction == "0.2um" & Month ==
"November")
# December by fraction
dec_one_ft <- pond_core_ft$keep_samples(Fraction == "1um" & Month ==
"December")
dec_two_ft <- pond_core_ft$keep_samples(Fraction == "0.2um" & Month ==
"December")
# Fraction
one_ft <- pond_core_ft$keep_samples(Fraction == "1um")
two_ft <- pond_core_ft$keep_samples(Fraction == "0.2um")
# October
oct_ft <- pond_core_ft$keep_samples(Month == "October")
# November
nov_ft <- pond_core_ft$keep_samples(Month == "November")
# December
dec_ft <- pond_core_ft$keep_samples(Month == "December")
~~~
{: .language-r}

Let's start by comparing ASV abundances between the size fractions. We'll stick the
two fraction tables back together, make a conditions vector, and run `ALDEx2`.

~~~
# combine the ASV tables from two fraction feature tables
fraction <- rbind(one_ft$data, two_ft$data)
# make a conditions vector so aldex knows which samples belong in each
# category (there are 12 1 μm samples and 12 0.2 μm samples)
conds_fraction <- c(rep("1um", 12), rep("0.2um", 12))
# run aldex
aldex_fraction <- aldex(t(fraction), # aldex wants samples to be columns
conds_fraction,
test = "t", # use a t-test for diff. abundance
effect = TRUE) # calculate ASV effect size
~~~
{: .language-r}

If you look at the `aldex_fraction` table, you'll notice the columns have sort of weird
names. Here's what they mean:
* rab.all - median clr value for all samples in the feature
* rab.win.0.2um - median clr value for the 0.2μm fraction samples
* rab.win.1um - median clr value for the 1μm fraction samples
* dif.btw - median difference in clr values between fractions
* dif.win - median of the largest difference in clr values within fractions
* effect - median effect size: diff.btw / max(diff.win) for all instances
* overlap - proportion of effect size that overlaps 0 (i.e. no effect)
∗ we.ep - Expected p-value of Welch’s t test
∗ we.eBH - Expected Benjamini-Hochberg corrected p-value of Welch’s t test
∗ wi.ep - Expected p-value of Wilcoxon rank test
∗ wi.eBH - Expected Benjamini-Hochberg corrected p-value of Wilcoxon test
Now, let’s make some plots of the data.

~~~
# plot the results
par(mfrow=c(1,2)) # a graphical parameter that sets up the following plots to line up on one row and in two columns
aldex.plot(aldex_fraction, type = "MA") # Bland-Altman style plot
aldex.plot(aldex_fraction, type = "MW") # Effect plot
~~~
{: .language-r}

The points on the plots can be interpreted in the same way. Each dot is an ASV. Red
dots are ASVs with significantly different abundances in the two groups. Gray dots are
ASVs that are highly abundant, but not significant. Black dots are rare ASVs that are
not significant.
The first plot (`type = "MA"`) is a Bland-Altman or Tukey Mean Difference plot
(different names are used in different fields). The x-axis is the centered log-ratio
abundance of the ASVs and the y-axis is the median difference in abundance of the
ASV in each size fraction. ASVs near the top of the plot are more abundant in the 1μm
fraction and ASVs nearer the bottom are more abundant in the 0.2μm fraction.
The second plot (`type = "MW"`) is an effect plot. It has the same y-axis, but the x-axis
is the "dispersion" of each ASV. The dispersion is really the estimated pooled standard
deviation for each ASV. The gray dotted lines represent an estimated effect size of  1.
Effect size is a measure of the strength of a relationship. The effect size metric used in
`ALDEx2` is more robust than the p-values, so the authors recommend examining
ASVs based on effect size rather than p-value. Specifically, they recommend
examining ASVs with an effect size of ≥1 or ≤-1 to avoid analyzing false positives.
You can make a volcano plot of the data by plotting `dif.btw` (median difference
between groups) on the x-axis and p-value on the y-axis. I’m not really a fan of volcano
plots, but they are common (especially with ANCOM), so I’ll show you how to make
one.

~~~
aldex_fraction %>%
ggplot()+
geom_point(aes(x = diff.btw,
y = we.eBH,
color = ifelse(effect >= 1 | effect <= -1, "Effect size ≥ 1 or ≤ -1", "Effect size  1 and ≥ -1"))) +
geom_hline(yintercept = 0.05,
color = "gray70") +
scale_color_manual(values = c("black", "red")) +
labs(color = "Effect size",
title = "Volcano plot",
x = "Median difference between groups",
y = "Expected BH adjusted p-value") +
theme_bw()
~~~
{: .language-r}

Again, each point represents one ASV. ASVs to the left of x = 0 are more abundant in
the 0.2μm fraction and ASVs to the right are more abundant in the 1μm fraction. The
gray line indicates a p-value of 0.05, so any ASVs below that line returned a significant
p-value. ASVs are colored based on effect size, with red points indicating ASVs with an
effect size of ≥ 1 or ≤ -1. As you can see, some of the ASVs that have significant p-values
but small effect sizes are less likely to be of biological interest.
If you wanted to identify the ASVs in red in the Volcano plot, you can subset the
`ALDEx2` table like this:
~~~
fraction_effective_asvs <- subset(aldex_fraction, effect >= 1 | effect
<= -1)
dim(fraction_effective_asvs) # displays the table dimensions
~~~
{: .language-r}

Looking at the table dimensions, we can see that there are 80 ASVs with an effect size
>= 1 or <= -1 that would warrant further consideration.
As practice, compare ASVs between months and between size fractions within
months. For at least one comparison, construct the plots and do the subsetting. For
Month, you will have to test three combinations: October-November,
October-December, and November-December.
