---
title: "Gene prediction"
teaching: 30
exercises: 15
questions:
objectives:
keypoints:

---

We will use [Prodigal](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2848648/) , a tool for "prokaryotic gene recognition and translation initiation site identification", to identiy putative protein coding genes in our phage contigs. I purposely quoted the title as this hints that the tool is not specificallly built for phage gene predcition but for prokaryotes instead.

> Why would Prodigal still perform well for phages?

For prodigal to be able to predict genes it has to be trained, for which it uses several sequence charcteristics, among others:


*   Start codon usage (ATG, GTG, TTG)
*   Ribosomal binding site (RBS) motif usage
*   GC bias
*   hexamer coding statistics


> ## Prodigal algorithm
> Have a look at the [2010 paper](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-11-119)
> for a more detailed explanation of the algorithm.
> - __What does prodigal do when there is no so called "Shine Dalgarno" motif?__
> - __Why is verifying the predictions difficult?__
> - __What start codon(s) does prodigal use in its search?__
>
> Now we have a rough idea of how Prodigal works, go to the "metagenomes" section in the [prodigal wiki](https://github.com/hyattpd/prodigal/wiki/Advice-by-Input-Type#metagenomes)
> - __What would be the best approach for our dataset?__
{: .challenge}


> ## Contigs length
> The manual states: _Isolated, short sequences (<100kbp) such as plasmids, phages, and viruses should generally be analyzed using Anonymous Mode_. As a note, "Anonymous mode" was previously called "meta" mode. **Are our phages shorter than 100kb? how long is the longest contig?** Use `bioawk` to find that out.
> > ## Solution
> > ~~~
> > bioawk -c fastx '{ print $name, length($seq) }' fasta_bins/all_binned_contigs.fasta
> > ~~~
> > {: .language-bash}
> {: .solution}
{: .challenge}

### Running Prodigal

Lets run -p meta on all our contigs. Make sure we are in the day3 folder, then run the code below

~~~
mkdir prodigal_default
cd prodigal_default
prodigal -i ../fasta_bins/all_binned_contigs.fasta -a proteins.faa -o genes.txt -f sco -p meta
cd ..
~~~
{: .language-bash}

> - __How many proteins did we predict? (use `grep` for example)__
> - __That we did not predict proteins does not mean they are not there. In what case do you think prodigal will miss proteins?__






{% include links.md %}
