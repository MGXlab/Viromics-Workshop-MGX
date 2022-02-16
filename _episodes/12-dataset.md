---
title: "The dataset"
teaching: 10
exercises: 10
questions:
- "Where does the dataset come from?"
- "What format is the sequencing data?"
objectives:
- "Understanding how the samples in the dataset are related."
- "Collect basic statistics about the dataset."
keypoints:
- "FASTA format does not contain sequencing quality information."
- "Next Generation Sequencing data is made of short sequences."
---
Today you will analyze viral metagenomes derived from twelve human gut samples ([Reyes et al Nature 2010](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2919852/)). In this study, shotgun sequencing was carried out in the [454 platform](https://en.wikipedia.org/wiki/454_Life_Sciences) to produce unpaired (also called _single-end_) reads.

Raw sequencing data is usually stored in FASTQ format, which contains the sequence itself and the quality of each base. Check out [this video](https://www.youtube.com/watch?v=sdxVDy0lSAE) to get more insight into the sequencing process and the FASTQ format. To make things quicker, the data you are going to analyze today is in FASTA format, which **does not contain any quality information**. In the FASTA format we call _header_, _identifier_ or just _name_ to the line that precedes the nucleotide or aminoacid sequence. It always start with the `>` symbol and should be unique for each sequence.

Let's get started by downloading and unzipping the file file with the sequencing data in a directory called `0_raw-data`. After this, quickly inspect one of the samples so you can see how a FASTA file looks like.

~~~
# create the directory and move to it
$ mkdir 0_raw-data
$ cd 0_raw-data

# download and unzip
$ wget https://github.com/MGXlab/Viromics-Workshop-2022/raw/gh-pages/data/day_1/Reyes_fasta.zip
$ unzip Reyes_fasta.zip

# show the first lines of a FASTA file
$ head F1M.fasta
~~~
{: .language-bash}

To know how the samples look like, you will use `seqkit stats`. It will calculate basic statistics such as the number of reads or their length.


Have a look at the `seqkit stats` help message with the `-h` option. Remember you can analyze all the samples altogether using the star wildcard (`*`) like this `*.fasta`, which literally means _every file ended with '.fasta' in the folder_.

**Which are the samples with the maximum and minimum number of sequences? In overall, which are the mean, maximum and minimum lengths of the sequences?**

> ## Challenge: Basic statistics
> Have a look at the `seqkit stats` help message with the `-h` option. Remember you can analyze all the samples altogether using the star wildcard (`*`) like this `*.fasta`, which literally means _every file ended with '.fasta' in the folder_.
>
> **Which are the samples with the maximum and minimum number of sequences? In overall, which are the mean, maximum and minimum lengths of the sequences?**
>
> {: .source}
>
> > ## Solution
> >
> > Within the folder with the samples, run `seqkit stats` like this:
> >
> > ~~~
> > $ seqkit stats *.fasta
> > ~~~
> > {: .language-bash}
> > Output will be displayed in the terminal:
> > ~~~
> > file        format  type  num_seqs     sum_len  min_len  avg_len  max_len
> >F1M.fasta   FASTA   DNA     71,971  17,747,892       60    246.6      335
> >F1T1.fasta  FASTA   DNA     65,603  15,786,688       60    240.6      337
> >F1T2.fasta  FASTA   DNA    129,690  31,339,631       60    241.7      352
> >F2M.fasta   FASTA   DNA    152,785  37,404,808       60    244.8      361
> >F2T1.fasta  FASTA   DNA    154,716  38,074,766       60    246.1      358
> >F2T2.fasta  FASTA   DNA    116,737  28,321,957       60    242.6      342
> >F3M.fasta   FASTA   DNA     61,726  15,007,608       60    243.1      331
> >F3T1.fasta  FASTA   DNA     67,471  16,467,396       60    244.1      320
> >F3T2.fasta  FASTA   DNA    114,324  27,516,148       60    240.7      339
> >F4M.fasta   FASTA   DNA     93,077  22,691,459       60    243.8      349
> >F4T1.fasta  FASTA   DNA     58,544  14,186,427       60    242.3      346
> >F4T2.fasta  FASTA   DNA     56,809  13,772,615       60    242.4      351
> > ~~~
> > {: .output}
> > The average length of the reads is ~240 nucleotides for all the samples, while minimum and maximum
> > lengths are 60 and ~340, respectively. The sample containing the highest amount of reads
> > is F2T1, while F3M contains the lowest.
> {: .solution}
{: .challenge}


Notice how the samples are named. **Can you say if they are related in some way?** Check the paper ([Reyes et al Nature 2010](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2919852/)) to find it out.


{% include links.md %}
