---
title: "Cross-assembly"
teaching: 15
exercises: 20
questions:
- "What is a sequence assembly?"
- "How is different a cross-assembly from a normal assembly?"
objectives:
- "Run a cross-assembly with all the samples."
- "Understand the parameters used during the cross-assembly."
keypoints:
- "With sequence assembly we get longer, more meaningful genomic fragments from short sequencing reads."
- "In a cross-assembly, reads coming from the same species in different samples are merged into the same scaffold."
---

*Sequence assembly* is the reconstruction of long contiguous genomic sequences (called *contigs* or *scaffolds*) from short sequencing reads. Before 2014 a common approach in metagenomics was to compare the short sequencing reads to the genomes of known organisms in the database (and some studies today still take this approach). However, recall that most of the sequences of a metavirome are unknown, meaning that they yield no hits when comparing them to the databases. Because of this we need of database-independent approaches to describe new viral sequences. As bioinformatics tools improved, sequence assembly enabled recovery of longer sequences of the metagenomic datasets. Having a longer sequence means having more information to classify it, so using metagenome assembly helps to characterize the complex communities such as the gut microbiome.

In a cross-assembly, **multiple samples are combined and assembled together**, allowing the discovery of shared sequence elements between the sample. In the _de novo_ cross-assembly that we are going to do, if a virus (or other sequence element) is present in several different samples, its sequencing reads from the different samples will be joined into one scaffold. We will look for viruses that are present in many people (samples).

First thing you need to do is concatenating the reads from all twelve samples into one file called `all_samples.fasta` so they can be assembled as one single sample. We will use the `cat` command for this. Note well `fna` and `fasta` are both valid extensions for a FASTA file.

~~~
# merge the sequences
$ cat 0_raw-data/*.fna > all_samples.fasta
~~~
{: .bash}

> ## Challenge: Number of sequences in `all_samples.fasta`
> You just concatenated the 12 FASTA files, one per sample, into one sigle FASTA file. To be sure that everything went well, count the number of sequences in this new file using the command line.
>
>
> **Hint**
> ~~~
> # prints a count of matching lines for each input file.
> $ grep -c
> ~~~
>
> > ## Solution
> >
> >
> > ~~~
> > $ grep -c '>' all_samples.fasta
> >  1143453
> > ~~~
> {: .solution}
{: .challenge}


We will use the assembler program SPAdes ([Bankevich et al J Comput Biol 2012](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3342519/)), which is based on de Bruijn graph assembly from kmers and allows for uneven depths, making it suitable for metagenome assembly and assembly of randomly amplified datasets. As stated above, this cross-assembly will combine the metagenomic sequencing reads from all twelve viromes into contigs/scaffolds. Because of the data we have, we will run SPAdes with parameters `--iontorrent` and `--only-assembler`, and parameters `-s` and `-o` for the input and output. While the command is running (around 10 minutes) try to solve questions below.

~~~
# create a directory to store the SPAdes output and run the (cross)assembly step
$ mkdir 1_cross-assembly
$ spades.py -s all_samples.fasta -o 1_cross-assembly/spades_output --iontorrent --only-assembler
~~~

Ion Torrent is a sequencing platform, same as 454, the platform used to sequence the data you are using. Note well we used `--iontorrent` parameter when running SPAdes. This is because there is not a parameter `--454` to accommodate for the peculiarities of this platform, and the most similar is Ion Torrent. Specifically, both platforms are prone to errors in **homopolymeric regions**. Watch [this video](https://www.youtube.com/watch?v=sdxVDy0lSAE) (if you did not in previous chapter) from minute 06:50, and explain **what is an homopolymeric region, and how exactly the Ion Torrent and 454 platforms fail on them**.

Regarding the `--only-assembler` parameter, we use it to avoid the read error correction step, where the assembler tries to correct single base errors in the reads by looking at the k-mer frequency and quality scores. **Why are we skipping this step?**

If the cross-assembly finished, final scaffolds should be under `1_cross-assembly/spades_output/scaffolds.fasta`. We will move and rename the file using `mv` and get some statistics with the python script `fasta_statistics.py`. **How many scaffolds were assembled? How long are the longest and shortest?**

~~~
$ mv 1_cross-assembly/spades_output/scaffolds.fasta 1_cross-assembly/cross-scaffolds.fasta
$ python python_scripts/fasta_statistics.py -i 1_cross-assembly/
~~~

This is the result of assembling the reads from all samples together. But we don't know (yet) which is the source sample for each scaffold. Could there be one scaffold coming from multiple samples?

{% include links.md %}
