---
title: "The dataset"
teaching: 15
exercises: 5
questions:
- "What is _metagenomics_?"
- "What do we call _viral dark matter_?"
- "Where does the dataset come from?"
- "What format is the sequencing data?"
objectives:
- "Understanding what is a metagenomic study."
- "Understanding how the samples in the dataset are related."
- "Collecting basic statistics of the dataset."
keypoints:
- "Metagenomics is the culture-independent study of the collection of genomes from different microorganisms present in a complex sample."
- "We call _dark matter_ to the sequences that don't match to any other known sequence in the databases."
- "FASTA format does not contain sequencing quality information."
- "Next Generation Sequencing data is made of short sequences."
---

Before anything else, download the file containing the conda environment file, create
the environment in your machine, and activate it.

~~~
# download the file describing the conda environment
$ wget https://raw.githubusercontent.com/MGXlab/Viromics-Workshop-MGX/gh-pages/code/day1/day1_env_file.txt

# create the environment, call it day1_env
$ conda create --name day1_env --file day1_env_file.txt

# activate the environment
$ conda activate day1_env
~~~
{: .language-bash}


## Metagenomics

The emergence of Next Generation Sequencing (NGS) has facilitated the development of metagenomics. In metagenomic studies, DNA from all the organisms in a mixed sample is sequenced in a massively parallel way (or RNA in case of metatranscriptomics). The goal of these studies is usually to identify certain microbes in a sample, or to taxonomically or functionally characterize a microbial community. There are different ways to process and analyze metagenomes, such as the targeted amplification and sequencing of the 16S ribosomal RNA gene (amplicon sequencing, used for taxonomic profiling) or shotgun sequencing of the complete genomes in the sample.

After primary processing of the NGS data (which we will not perform in this exercise), a common approach is to compare the metagenomic sequencing reads to reference databases composed of genome sequences of known organisms. Sequence similarity indicates that the microbes in the sample are genomically related to the organisms in the database. By counting the sequencing reads that are related to certain taxa, or that encode certain functions, we can get an idea of the ecology and functioning of the sampled metagenome.

When the sample is composed mostly of viruses we talk of *metaviromics*. Viruses are the most abundant entities on earth and the majority of them are yet to be discovered. This means that the fraction of viruses that are described in the databases is a small representation of the actual viral diversity. Because of this, a high percentage of the sequencing data in metaviromic studies show no similarity with any sequence in the databases. We sometimes call this unknown, or at least uncharacterizable fraction as *viral dark matter*. As additional viruses are discovered and described and we expand our view of the Virosphere, we will increasingly be able to understand the role of viruses in microbial ecosystems.

Today we will re-analyze the metaviromic sequencing data from 2010 where the [crAssphage](https://en.wikipedia.org/wiki/crAssphage), the most prevalent bacteriophage in humans, was described for the first time. It was named after the _cross-assembly_ procedure employed in the analysis. Besides replicating the cross-assembly, today we will follow an alternative approach using state-of-the-art bioinformatic tools that will allow us to get the most out of the samples.

## The dataset for the workshop

During this workshop you will re-analyze the metaviromic sequencing data from [Reyes et al., 2010](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2919852/) where the [crAssphage](https://en.wikipedia.org/wiki/crAssphage), the most prevalent bacteriophage among humans, was described for the first time.

In this study, shotgun sequencing was carried out in the [454 platform](https://en.wikipedia.org/wiki/454_Life_Sciences) to produce unpaired (also called _single-end_) reads. Raw sequencing data is usually stored in FASTQ format, which contains the sequence itself and the quality of each base. Check out [this video](https://www.youtube.com/watch?v=sdxVDy0lSAE) to get more insight into the sequencing process and the FASTQ format. To make things quicker, the data you are going to analyze today is in FASTA format, which **does not contain any quality information**. In the FASTA format we call _header_, _identifier_ or just _name_ to the line that precedes the nucleotide or aminoacid sequence. It always start with a `>` symbol and should be unique for each sequence.

Let's get started by downloading and unzipping the file file with the sequencing data in a directory called `0_raw-data`. After this, quickly inspect one of the samples so you can see how a FASTA file looks like.

~~~
# create the directory and move to it
$ mkdir 0_raw-data
$ cd 0_raw-data

# download and unzip
$ wget https://github.com/MGXlab/Viromics-Workshop-MGX/raw/gh-pages/data/day_1/Reyes_fasta.zip
$ unzip Reyes_fasta.zip

# show the first lines of a FASTA file
$ head F1M.fasta
~~~
{: .language-bash}

You will use `seqkit stats` to know how the sequencing data looks like. It calculates basic statistics such as the number of reads or their length. Have a look at the `seqkit stats` help message with the `-h` option. Remember you can analyze all the samples altogether using the star wildcard (`*`) like this `*.fasta`, which literally means _every file ended with '.fasta' in the folder_. **Which are the samples with the maximum and minimum number of sequences? In overall, which are the mean, maximum and minimum lengths of the sequences?**

~~~
# get basic statistics with seqkit
$ seqkit stats 0_raw-data/Reyes_fasta/*.fasta
~~~
{: .language-bash}

Notice how the samples are named. **Can you say if they are related in some way?** Check the paper ([Reyes et al Nature 2010](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2919852/)) to find it out.


{% include links.md %}
