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
- "Run python scripts."
keypoints:
- "FASTA format does not contain sequencing quality information."
- "Next Generation Sequencing data is made of short sequences."
---
Today you will analyze viral metagenomes derived from twelve human gut samples in ([Reyes et al Nature 2010](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2919852/)). In this study, shotgun sequencing was carried out in the [454 platform](https://en.wikipedia.org/wiki/454_Life_Sciences) to produce unpaired (also called _single-end_) reads.

Raw sequencing data is usually stored in FASTQ format, which contains the sequence itself and the quality of each base. Check out [this video](https://www.youtube.com/watch?v=sdxVDy0lSAE) to get more insight into the sequencing process and FASTQ format. To make things quicker, the data you are going to analyze today is in FASTA format, which **does not contain any quality information**. In the FASTA format we call _header_, _identifier_ or just _name_ to the line that precedes the nucleotide or aminoacid sequence. It always start with the `>` symbol and should be unique for each sequence.

Let's get started by downloading and unzipping the file file with the sequencing data in a directory called `0_Raw-data`. Then we will quickly inspect one of the samples so you can see how a FASTA file looks like.

~~~
# create the directory and move to it
$ mkdir 0_raw-data
$ cd 0_raw-data

# download and unzip
$ wget https://tbb.bio.uu.nl/dutilh/courses/CABBIO/Reyes_fasta.tgz
$ tar zxvf Reyes_fasta.tgz

# show the first lines of a FASTA file
$ head F1M.fna
~~~
{: .bash}

We have prepared a python script for you to get basic statistics about the sequencing data, such as the number of reads per sample, or their maximum and minimum length. Run the script as indicated below. **Which are the samples with the maximum and minimum number of sequences? In overall, which are the mean, maximum and minimum lengths of the sequences?**

~~~
# move to the root directory
$ cd ..

# run the pytho script. Remember you can access the help message of this script doing `python3 fasta_statistics.py -h`
$ python python_scripts/fasta_statistics.py -i 0_raw-data/
~~~

Look at how the samples are named. **Can you say if they are related in some way?** Check the paper ([Reyes et al Nature 2010](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2919852/)) to find it out.

Next step is to put together all these short sequences to reconstruct larger genomic fragments in a process called **assembly**. More specifically, we will be do a **cross-assembly**.

{% include links.md %}
