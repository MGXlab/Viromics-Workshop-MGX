---
title: "Binning contigs"
teaching: 15
exercises: 60
questions:
- "How many bins do we obtain?"
objectives:
- ""
keypoints:
- ""
---




One of the drawbacks of the assembly step is that the actual genomes in the sample
are usually split across several contigs. This can be a problem for analyses that
benefit from having as much complete as possible genomes, such as __metabolic pathways
reconstruction or gene sharing analyses (check this)__. With binning we try to
put together in a 'bin' all the contigs that come from the same genome, so we can
have a better representation of it.

As you know from [Arisdakessian et al 2021](https://academic.oup.com/bioinformatics/article/37/18/2803/6211156),
two features are used to bin contigs: nucleotide composition and depth of coverage.
You will use the CoCoNet binning software to bin the set of representative scaffolds
you got in the previous lesson. For the nucleotide composition, CoCoNet computes
the frequency of the k-mers (k=4 by default) in the scaffolds, taking into account both
strands. For the depth of coverage, it counts the number of reads aligning to each
scaffold, which at the end is a representation of the relative abundace of that
sequence in the sample. This means that for the latter we need to provied CoCoNet
with the short-reads aligned to the scaffolds, just as you did in the previous
lesson. This time however you are not aligning all the samples altogether as if they
were only one, but separately, so you should end up with 12 sorted BAM files. You
can use the trick you learned in the previous lesson to process multiple samples
sequentially. Don't forget to index your sorted BAM files at the end.

~~~
# map (separately) all the sample to representative set of scaffolds
$ for sample in F*.fasta; do ... ... ... ; done
~~~
{: .language-bash}

Once you have your BAM files, install and run CoCoNet with default parameters, and save the
results in the `3_binning` folder. It should take 5-10 minutes. Look at questions
below in the meantime.

~~~
# deactivate the conda environment before running coconet
$ conda deactivate

# install coconet
$ pip install --user coconet-binning

# Run coconet. Don't forget to include your username in the command.
$ /home/<USERNAME>/.local/bin/coconet run --output 3_binning ...
~~~
{: .language-bash}

> ## Binning parameters
> CoCoNet incorporates the cutoffs `--min-ctg-len` (minimum length of the contigs)
> and `--min-prevalence` (minimum number of samples containing a given contig). By
> default, the first is set to 2048 nucleotides and the second to 2 samples.
> __How increasing or decreasing these parameters would affect the results?__
{: .discussion}

Binning results should be under `3_binning/bins_0.8-0.3-0.4.csv`. If you have a look
at this file with `head`, each of the lines contains the name of a contig together
with the bin identifier, which is a number. Use the script `create_fasta_bins.py`
to create separate FASTA files for each bin, and save the results in `3_binning/fasta_bins`.

~~~
# activate the environment again
$ conda activate day1_env

# download the python script
$ wget https://raw.githubusercontent.com/MGXlab/Viromics-Workshop-MGX/gh-pages/code/day1/create_fasta_bins.py

# Have a look at options
$ python create_fasta_bins.py -h

# run the script to create the FASTA bins with the correct options
$ python create_fasta_bins.py -o 3_binning/fasta_bins ...
~~~
{: .language-bash}


You will be using these bins for days 3 and 4, so don't forget where they are!

{% include links.md %}
