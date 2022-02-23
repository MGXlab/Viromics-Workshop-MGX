---
title: "Homology based search"
teaching: 0
exercises: 30
questions:
- "Can we classify viral sequences with Blast?"
objectives:
- "Run megablast on viral contigs"
keypoints:
- "Only in a very limited number of cases will direct sequence searches result in good hits. This is because majority of uncultivated viral sequences have not been previously described. You might hit nothing at all, or perhaps hit different viral (or bacterial) sequences with low query coverage."
- "Sometimes you might find a good hit, for example for the crAssphage bins. Of course, back when crAssphage was discovered these sequences weren't present in the database!"
- "We need more sophisticated search strategies for assigning taxonomy to novel viral sequences"
---
After you've assembled metagenomes (day 1) and identified putative viral contigs (day 2), you probably want to know which viruses you've recovered -- that is, assign taxonomy.
The first thing you might want to do is check whether it is a known virus by searching for highly similar viruses in any of the databases. From day 2 you might remember that homology-based searches will only get you so far for identifying uncultivated viral sequences, as a large part of the virosphere is still uncharted. But if your virus has been sequenced & described before you probably want to know that, because it can save you a lot of time.

Blast a few of the binned contigs (from day 1) with [Blast](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome) by opening the file in a text editor and copying (part) of the fasta sequence in the browser in the field marked 'Enter Query Sequence' (see figure "A"). Another option is to use the terminal and select & copy the sequence from the terminal:

```
# go to folder containing bins from day 1
cd /path/to/bins/from/day1

# check which files are present
ls

# pick a bin (e.g. bin_03.fasta) and look at the first 150 lines of that file
head -100 bin_03.fasta

# or use a combination of 'head' and 'tail' to look at a part somewhere in the middle:
head -4000 bin_03.fasta | tail -250

# Note:
# bins typically contains multiple contigs, so make sure that the part you copy
# doesn't extend into another contig. In that case it will contain a header line
# (starts with ">") in the middle of your sequence, and Blast won't like that.

# Note:
# If the sequence you blast is very long, blast might take too long to finish or
# not finish at all.
```
![Image]({{ page.root }}/fig/day4/blast.png)


For "Database" (B) select `Nucleotide collection (nr/nt)` or `RefSeq Genome database`. For 'Programs selection' (C) choose `Megablast`.  
Click the blue "Blast" button and wait for the results.


>## Question: Blast results
>Inspect the "Descriptions", "Graphic summary" and "Taxonomy" tabs to answer the following questions:  
>- What is the top hit? Do you have a single good hit or multiple hits?
>- What is the length of aligned region in the query and target?
>- What is the percent identity?
>- Can you assign the contig to a taxonomic group? Why (not)?
>
>Try a few different sequence parts of the bin, and try a few other bins.
>Discuss what you find with your neighbour.
{: .challenge}

{: .discussion}




{% include links.md %}
