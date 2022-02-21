---
title: "Prophage Prediction"
teaching: 20
exercises: 20
questions:
- "How is prophage prediction similar/different from free virus prediction?"
- "How do I find detailed information about my results in several output folders?" 
objectives:
- "Find out how tools detect prophages in a contig and how they indentify the phage-host boundraries."
- "Go through the VirSorter results and find out all the information you can get about a single prophage."
keypoints:
- "Features such as GC-Content changes, or sudden enrichment in viral genes indicate the presence of a prophage in a contig/genome."
- "Results of a tool are sometimes distributed across multiple folders. Make sure to check all output files so that you can get the max out of your experiment."
---

Identifying viral sequences from assembled metagenomes is not limited to entirely viral or entirely microbial sequences. Another important identification use case is detecting prophages. In fact, tools for detecting prophages were some of the first virus identification tools.

>## Discussion: Detecting prophages
> Can you think of reasons why prophages might be easier to detect than free phages?
>
> Look back at the evidence that VirSorter uses to determine whether a contig is viral or not. Which of these types of evidence are also suitable to identify prophages?
{: .discussion}

After you have though about why prophages might be easier to detect that free phages, read the section "Identification of virus-host boundraries" in [this](https://www.nature.com/articles/s41587-020-00774-7) paper. The paper is about a tool called checkV that you will hear more about on Thursday. It estimates completeness and contamination of a viral genome, and it also predicts the boundraries between prophage and host genomes.




>## Challenge: Prophage annotation
>As you have seen in the file *VIRSorter_global-phage-signal.csv*, VirSorter doesn't just determine which contigs are viral, it also detects prophages. Go back to the file and look at the detected prophages (categories 4, 5, and 6). Can you find out whether they are complete or partial prophages? Or where the boundraries are?
>
> > ## Solution
> > 
> > Let's look at category 4 (sure). We will focus on the first 6 columns of this section, for which the headers are:
> >
> > "Contig_id, Nb genes contigs,   Fragment,   Nb genes,Category, Nb phage hallmark genes, Phage gene enrichment sig"
> > 
> > The corresponding values for the first contig are:
> >
> > Contig_id: VIRSorter_NODE_50_length_17040_cov_25_975213
> >
> > Nb genes contigs: 19
> >
> > Fragment: VIRSorter_NODE_50_length_17040_cov_25_975213-gene_4-gene_16
> >
> > Nb genes: 13
> >
> > Category: 1
> >
> > Nb phage hallmark genes: 2
> >
> > Phage gene enrichment sig: gene_4-gene_16:2.21652167838327
> >
> > So, we can see that genes 4-16 show phage gene enrichment and are predicted to be from a prophage. since we know that there are 19 genes that are classified "Nb" (Non-bacterial), we can assume that this phage is complete.
> {: .solution}
>
> Next, try to find out, where the host-phage boundrary is in terms of nucleiotide position. This information is not available from *VIRSorter_global-phage-signal.csv*, so try to find it in the rest of the results. Are all the genes encoded on the same strand? How many nucleotides are between the genes?
>
> > ## Solution
> >
> > This is a little bit complicated. Sometimes we have to dig to get the information that we want. As you have seen, for contig 50, the prophage is predicted to range from gene 4 to gene 16. In the folder "Metric_files", there is a file which contains the coordinates of each gene on the contig. VirSorter recommends to use the coordinates for all the genes plus 50 nucleotides upstream of the most 3' gene and 50 nucleotides downstream of the most 5' gene. In the case of contig NODE_50, this means that the prophage coordinates would be 1014-15338.
> >
> > Out of the 13 genes, in this region, there is only one gene on the "+"-strand, while twelve others are on the "-"-strand.
> >
> > The intergenic spaces between the genes are very short, sometimes they even overlap. If you compare the length of the intergenic regions of the predicted prophage to the lenght of the intergenic regions outside of the predicted prophage, you will see that they are very similar. This is probably due to the fact that our dataset is a virome and so we expect almost all of our contigs to be viral and have short intergenic regions.
> >
> {: .solution}
{: .challenge}

Now, let's see if we can identify the taxonomy of the prophages that VirSorter predicted. Let's try it with a simple BLAST search. In the folder *Predicted_viral_sequences*, you will find fasta files (.fasta) and genbank files (.gb) for each category of phage. The prophages are located in the files for categories 4-6. Run a Megablast (other flavours will overload the BLAST server for contigs of this length) for each category. Do you expect to find results?


> ## Discussion
> Do you think that a BLAST search is the best way to assign taxonomy to viruses? How many viruses do you think you can annotate this way?
>
> Do you have an idea for other ways to assign taxonomy to viruses?
{: .discussion}  

Today, you have learned a few methods for how bioinformatic tools distinguish between viral and non-viral sequences, even if the sequences are not similar to any known viruses. You have seen that homology-based methods are less sensitive than feature-based methods supported by machine learning. You have discussed the applications for more senstitive and less sensitive tools depending on the experiment that is conducted. And you have seen that even the best current tools will sometimes disagree on which sequences are viral and which aren't.

We hope that the insights from today will help you understand the advantages and limitations of using different tools and will help you in choosing the right tool for your puropose in your own research.

Now, the last part of today is to listen to Lingyi's lecture about the benchmarking of virus identification tools.

{% include links.md %}
