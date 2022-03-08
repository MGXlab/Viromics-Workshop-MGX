---
title: "Compare Results for four tools"
teaching: 60
exercises: 60
questions:
- "How different are the predictions of the tools per contig?"
- "How sensitive are the different tools we used?" 
objectives:
- "Assess whether the tools agree or disagree on which contigs are viral."
- "Compare the sensitivity of virus detection for the four tools."
- "Find out which tools make the most similar predictions."
keypoints:
- "The different tools often agree, but often disagree on whether a contig is viral. This is to an extent affected by the length of the contig."
- "Even for current state-of-the-art tools, getting a high sensitivity is hard."
- "Some tools make more similar predictions than others."
---

Now that VirSorter has finished, take a look at the results (the main results file is called *VIRSorter_global-phage-signal.csv*. What kind of information can you find there?

If you couldn't run VirSorter because of time or because you couldn't download the database, you can downoad the virsorter results from [here](https://github.com/MGXlab/Viromics-Workshop-MGX/raw/gh-pages/data/day_2/virsorter_results.tar.gz) and unzip it using tar -xzvf.

Because the output of VirSorter looks a lot different compared to the output of the other tools, we will first reformat it into a similar file. Download the script *reformat_virsorter_result.py* from [here](https://raw.githubusercontent.com/MGXlab/Viromics-Workshop-MGX/gh-pages/data/day_2/reformat_virsorter_result.py). This script will read in the VirSorter results, add the contigs that were not predicted as phages, and add an arbitrary score to each prediction. A phage annotation that was predicted as "sure" (categories 1 and 4) gets a score of 1.0, a "somewhat sure" (categories 2 and 5) prediction gets a score of 0.7, and a "not so sure" (categories 3 and 6) prediction gets a score of 0.51. All other sequences get a score of 0. 

Do you think these score represent the predictions well? Why (not)?

This script is used in the format:

~~~
# Format the virsorter result
$ python3 reformat_virsorter_result.py /path/to/virsorter_result_file.csv /path/to/output/file.csv

# This only works if the VirSorter result file is in its original place in the virsorter-results folder
# If you run the script from within the virsorter-results folder, give the filepath as ./VIRSorter_global-phage-signal.csv
~~~
{: .language-bash}

You can now read the new csv file into R, e.g. as *predVirSorter*.

Count how many contigs are predicted to be phages (If you have trouble with this, look back to section 2.5). Can you explain the difference in numbers?


Now, let's compare all the tools directly to each other. Again, all the exercises will be marked as challenges so that you can figure out the code for yourself or use the code we provide.

> ## Challenge: Creating a dataframe of all results
> First, create a data frame that is comprised of the contigs as rows (not as rownames though), and contains a column for each tool.
> Create a data frame that contains 1 if a sequence is annotated as phage by a tool and 0 if not. For VirFinder and DeepVirFinder, use a score of >0.5 as decision boundrary.
>
> > ## Solution
> >
> >
> > ~~~
> > # Create the data frame and rename the column for the contig names
> > > pred<-data.frame(predDeepVirFinder$name)
> > > names(pred)[names(pred) == "predDeepVirFinder.name"] <- "name"
> >  
> > # Add the PPR-Meta results
> > > pred$pprmeta<-predPPRmeta$Possible_source
> >
> > # Change the values in the pprmeta column so that phage means 1 and not a phage means 0
> > > pred$pprmeta[pred$pprmeta =='phage'] <- 1
> > > pred$pprmeta[pred$pprmeta !=1] <- 0
> >
> > # Add the DeepVirFinder and VirFinder Results
> > > pred$virfinder<-predVirFinder$score
> > > pred$virfinder[pred$virfinder >=0.5] <- 1
> > > pred$virfinder[pred$virfinder  <0.5] <- 0
> >
> > > pred$deepvirfinder<-predDeepVirFinder$score
> > > pred$deepvirfinder[pred$deepvirfinder >=0.5] <- 1
> > > pred$deepvirfinder[pred$deepvirfinder  <0.5] <- 0
> > # Add the VirSorter results
> > > pred$virsorter<-predVirSorter$pred
> > ~~~
> >{: .language-r}
> {: .solution}
{: .challenge}

We have seen that some tools annotate more contigs as viral than others. However, that doesn't automatically mean that the contigs that are annotated as viral are the same. In the next step, we will see whether the tools tend to agree on which sequences are viral and which aren't.

> ## Challenge: Visualize the consensus of the tools
> From the data frame, create a heatmap. Since there are thousands of contigs in the data frame, we cannot visualize them all together. Therefore, make at least three different heatmaps of 50 contigs each, choosing the contigs you want to compare. How do you expect, the comparison will vary?
>
> > ## Solution
> >
> >
> > ~~~
> > # Select three ranges of 50 contigs each
> > > pred.long<-pred[1:50,]
> > > pred.medium<-pred[2500:2550,]
> > > pred.short<-pred[8725:8775,]
> >  
> > # Attach the packages necessary for plotting and prepare the data
> > > library(ggplot2)
> > > library(reshape2)
> > > pred.l.melt<-melt(pred.long, id="name")
> > > pred.m.melt<-melt(pred.medium, id="name")
> > > pred.s.melt<-melt(pred.short, id="name")
> >
> > # Plot the three heatmaps, save, and compare
> > > ggplot(pred.l.melt, aes(variable, name, fill=value))+geom_tile()
> > > ggsave('~/ViromicsCourse/day2/results/contigs_large_binary.png', height=7, width=6)
> >
> > > ggplot(pred.m.melt, aes(variable, name, fill=value))+geom_tile()
> > > ggsave('~/ViromicsCourse/day2/results/contigs_medium_binary.png', height=7, width=6)
> >
> > > ggplot(pred.s.melt, aes(variable, name, fill=value))+geom_tile()
> > > ggsave('~/ViromicsCourse/day2/results/contigs_short_binary.png', height=7, width=6)
> >
> > ~~~
> >{: .language-r}
> {: .solution}
{: .challenge}

>## Discussion: Consensus
> Do the tools mostly agree on which sequences are viral? 
>
>How would you explain that?
>
> Is the degree of consensus the same across different contig lengths?
> 
> What is your expectation about the scores for the contigs where the tools agree/disagree?
{: .discussion}

In the next step, do the same as before, but now instead of using a binary measure (each sequence either is annotated as viral or not), use a continuous measure, such as the score. Make sure to use the same rows as before.

> ## Challenge: Visualize the difference in scores
> As in the challenge above, create a data frame with a column that contains contig ids and a column per tool. This time, use the continuous score as measure.
>
> > ## Solution
> >
> >
> > ~~~
> > # Create the data frame of prediction scores
> > > predScores<-pred
> > > predScores$deepvirfinder<-predDeepVirFinder$score
> > > predScores$virfinder<-predVirFinder$score
> > > predScores$pprmeta<-predPPRmeta$phage_score
> > > predScores$virsorter<-predVirSorter$score
> >
> > # Select three ranges of 50 contigs each
> > > predScores.long<-predScores[1:50,]
> > > predScores.medium<-predScores[2500:2550,]
> > > predScores.short<-predScores[8725:8775,]
> >  
> > # Prepare the data for plotting
> > > predScores.l.melt<-melt(predScores.long, id="name")
> > > predScores.m.melt<-melt(predScores.medium, id="name")
> > > predScores.s.melt<-melt(predScores.short, id="name")
> >
> > # Plot the three heatmaps, save, and compare
> > # The color palette in scale_viridis_c is optional. Scale_viridis_c is a continuous colour scale that works well for distinguishing colours
> > # If you prefer a binned colour scale, you can also consider using scale_viridis_b 
> > > ggplot(predScores.l.melt, aes(variable, name, fill=value))+geom_tile()+scale_viridis_c()
> > > ggsave('~/ViromicsCourse/day2/results/contigs_large_continuous.png', height=7, width=6)
> >
> > > ggplot(predScores.m.melt, aes(variable, name, fill=value))+geom_tile()+scale_viridis_c()
> > > ggsave('~/ViromicsCourse/day2/results/contigs_medium_continuous.png', height=7, width=6)
> >
> > > ggplot(predScores.s.melt, aes(variable, name, fill=value))+geom_tile()+scale_viridis_c()
> > > ggsave('~/ViromicsCourse/day2/results/contigs_short_continuous.png', height=7, width=6)
> >
> > ~~~
> >{: .language-r}
> {: .solution}
{: .challenge}

>## Discussion: Differences in Score
> Compare the heatmaps of continuous scores to the binary ones. Focus on the contigs for which the tools disagree. Are the scores more ambiguous for these contigs?
{: .discussion}

Pick out 1-5 contigs that you find interesting based on the tool predictions. Grab their sequences from the contig fasta file and go to the [BLAST website](https://blast.ncbi.nlm.nih.gov/Blast.cgi). Pick out one or two BLAST flavours that you deem appropriate and BLAST the interesting contigs. If you have questions about running BLAST, don't hesitate to ask one of us.
What kind of organisms do you find in your hits?


We might also want to take a look at which tools make the most similar predictions. For this, we will make a distance matrix and a correlation matrix.
> ## Challenge: Distance and Correlation Matrices
> Find out which tools make the most similar predictions by making a euclidean distance matrix and a preason correlation matrix for all four tools.
> 
> **Hint** Don't forget to exclude the first column from the distance and correlation functions.
> 
> > ## Solution
> > ~~~
> > # Make a euclidean distance matrix for binary annotation
> > > pred.t <- t(pred[,2:5])
> > > dist.binary<-dist(pred.t, method="euclidean")
> >
> > # Make a euclidean distance matrix for continuous annotation
> > > predScores.t <- t(predScores[,2:5])
> > > dist.cont<-dist(predScores.t, method="euclidean")
> >
> > # Make a correlation matrix for continuous annotation
> > > dist.corr<-as.dist(cor(predScores[,2:5], method='pearson'))
> >
> > ~~~
> >{: .language-r}
> {: .solution}
{: .challenge}

Finally, let us calculate, for each tool, the sensitivity metric. Sensitivity is a measure for how many of the viral sequences are detected compared to how many viral sequences are in the dataset. So, if True Positives (TP) are correctly annotated viral sequences, and False Negatives (FN) are viral sequences that were not detected by a tool, then:
Sensitivity= TP/(TP+FN)

> ## Challenge: Sensitivity
> Calculate the sensitivity for each tool. Since we are working with a viromics dataset, you can assume all sequences are viral.
> 
> **Hint** For VirFinder and DeepVirFinder, use a score of >0.5.
> 
> > ## Solution
> > ~~~
> > # PPR-Meta
> > > number_of_detected_contigs/number_of_contigs
> > 
> >
> > # VirFinder
> > > number_of_detected_contigs/number_of_contigs
> > 
> >
> > # DeepVirFinder
> > > number_of_detected_contigs/number_of_contigs
> > 
> >
> > # VirSorter: number of sequences annotated as viral 
> > > sum(predVirSorter$pred==1)
> > 
> > > sum(predVirSorter$pred==1)/number_of_contigs
> >
> > ~~~
> >{: .language-r}
> {: .solution}
{: .challenge}


If you have some extra time before our shared discussion, you can make some additional heatmaps for different ranges of contigs.
You can also try and see how the correlation matrix changes when you include only longer/shorter contigs.


**For the second part of this section, we will have a shared discussion about our research projects and how to choose the right tool for our purposes.**


{% include links.md %}
