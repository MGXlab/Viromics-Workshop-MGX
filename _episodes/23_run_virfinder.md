---
title: "Setup and Run VirFinder"
teaching: 15
exercises: 15
questions:
- "How do we run VirFinder and how is it different from the other tools?"
objectives:
- "Setup and Run VirFinder"
keypoints:
- "Logistic Regression is another type of Machine Learning than can be used to distinguish between viral and non-viral sequences"
- ""
---

Before we start analyzing the results from DeepVirFinder and PPR-Meta, we will run a third tool: VirFinder ([Ren et al. 2017](https://microbiomejournal.biomedcentral.com/articles/10.1186/s40168-017-0283-5)). As you might be able to tell from the name, VirFinder is DeepVirFinder's predecessor. VirFinder uses a different type of machine learning to identify viruses: logistic regression. Logistic regression is best used for qualitative prediction, that is, to decide which of two classes an object belongs to. VirFinder does this using kmer frequencies. So, VirFinder looks at each kmer of length 8 within each sequence and builds a matrix of which kmers were found and how frequently. Based on the comparison between this kmer matrix and the training data, VirFinder makes a prediction of whether a sequence belongs to a virus or a microbe.

Based on your experience so far, will this method be faster or slower than the tolls that you have run before?

To setup VirFinder, first create the conda environment from *virfinder.yaml* (don't forget to deactivate the pprmeta environment if you are still using it).

If you had trouble running it before lunch, you can download the updated environment [here](https://raw.githubusercontent.com/MGXlab/Viromics-Workshop-MGX/gh-pages/data/day_2/virfinder.yaml)

Then, within the virfinder environment run rstudio. 

~~~
# Run rstudio GUI within the virfinder environment
$ rstudio
~~~
{: .language-bash}


The next few commands will be in R.

~~~
# Attach the VirFinder package
> library("VirFinder")

# Run VirFinder on our dataset
> predVirFinder <- VF.pred('~/ViromicsCourse/day2/scaffolds_over_300.fasta')

# Save the resulting data frame as a comma-separated textfile
> write.csv(predResult, "~/ViromicsCourse/day2/results/scaffolds_over_300_virfinder.csv", row.names=F)
~~~
{: .language-r}

>## Discussion: Logistic Regression
> Is VirFinder faster or slower than you predicted? What could be the reason for why it is so fast?
> 
> Where would you draw the decision boundrary?
{: .discussion}

Stay in RStudio for the next section.

{% include links.md %}
