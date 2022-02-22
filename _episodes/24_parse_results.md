---
title: "Comparing Virus Identification Tools"
teaching: 15
exercises: 15
questions:
- "How can we compare the results of different virus identification tools?"
- "Which tool finds more phages?"
- "Why would the tools disagree?"
objectives:
- "Read the results so far into data frames."
- "Find out how many viral sequences each tool has predicted."
- "Discuss how moving the decision boundrary in VirFinder and DeepVirFinder affects your result."
keypoints:
- "Despite out data being almost exclusively viral, the tools identify max. 2/3 of the sequences as viral."
- "Making the decision boundrary less strict will include more sequences, which might seem like an advantage in this case. However, if we were working with a mixed metagenomic dataset, this would mean that we would falsely annotate microbial sequences as viral."
---

Before we run the final tool over lunch, we will shortly inspect the results of the three tools we have run so far. The following steps are marked as challenges, so that you can try for yourself if you already have experience with R. If you do not have experience with R or you don't have a lot of time before lunch, feel free to use the solution to continue.

The results of VirFinder should already be in your R workspace in a dataframe called *predVirFinder*. If you have closed RStudio after the last section, load the VirFinder results into R from the csv file that you have created in the last section, the same way as the others.

> ## Challenge: Loading the results of DeepVirFinder and PPR-Meta into R
> You have successfully run two tools apart from VirFinder, which have produced a comma-separated file (DeepVirFinder) and a tab-separated file (PPR-Meta). Load them into your R workspace.
>
> **Hint**: Make sure your working directory is set correctly
>
> > ## Solution
> >
> >
> > ~~~
> > # Load DeepVirFinder results
> > > predDeepVir <- read.csv('~/ViromicsCourse/day2/results/scaffolds_over_300_deepvirfinder.csv')
> >  
> > # Load PPR-Meta results
> > > predPPRmeta <- read.table('~/ViromicsCourse/day2/results/scaffolds_over_300_pprmeta.txt', header=T)
> > ~~~
> >{: .language-r}
> {: .solution}
{: .challenge}


>## Discussion: Comparing Tools
> Look at the three data frames you have created. What kind of information can you find in there? Is it clear to you what each of the values mean?
> 
> Think of ways to compare the results of the three tools. How would you decide which of these three tools is best suited for your research?
{: .discussion}

> ## Challenge: Counting phage annotations
> One way to compare tools would be to compare how many sequences are annotated as phages. Do that for DeepVirFinder, PPR-Meta, and VirFinder. Given what you know about the dataset: How many sequences do you expect to be viral? How many of the scaffolds are annotated as viral by each tool?
>
> > ## Solution
> >
> >For PPR-Meta, counting the number of sequences annotated as phages is the most straightforward.
> > ~~~
> > # Sum up all the rows that are annotated as a phage
> > > sum(predPPRmeta$Possible_source =='phage')
> >
> > ~~~
> >{: .language-r}
> > 
> > For VirFinder and DeepVirFinder, counting the number of sequences annotated as phages is more complicated. The simplest way would be to count how many sequences have a score above 0.5.
> > ~~~
> > # Sum up all the rows that have a score above 0.5
> > > sum(predDeepVirFinder$score > 0.5)
> > 
> > > sum(predVirFinder$score > 0.5)
> > 
> > ~~~
> >{: .language-r}
> >
> > However, you might have seen that there is also a p-value available for the VirFinder and DeepVirFinder results. You might want to use them instead to decide whether you test your prediction.
> > ~~~
> > # Sum up all the rows that have a p-value of max 0.05
> > > sum(predDeepVirFinder$pvalue <= 0.05)
> > 
> > > sum(predVirFinder$pvalue <= 0.05)
> > 
> >
> > # Or, you might want to be even stricter and count only sequences with a p-value of max 0.01
> > > sum(predDeepVirFinder$pvalue <= 0.01)
> > 
> > > sum(predVirFinder$pvalue <= 0.01)
> > 
> > ~~~
> >{: .language-r}
> {: .solution}
{: .challenge}


>## Discussion: Decision boundraries
> With VirFinder and DeepVirFinder, you have seen that the decision boundrary is somewhat up to the user. How will moving the decision boundrary "up" (i.e. making it stricter) or "down" affect the results? 
>
>If instead of a viromic dataset you were looking at a gut microbiome dataset, how would that affect your choice for the decision boundrary?
>
>Can you already tell which of these three tools is the best?
{: .discussion}

{% include links.md %}
