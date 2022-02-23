---
start: True
title: "Introduction and setting up"
teaching: 15
exercises: 0
questions:
objectives:
keypoints:

---

## Function annotation
When studying microorganisms we are often interested in what they do, how they do that, and how this relates to what we already know. In this part of the course we will work our way from DNA sequences to proteins with functional annotations. To do so we will first predict genes using [Prodigal](https://github.com/hyattpd/Prodigal), and then assign functions by comparing the sequences to the [PHROG database](https://phrogs.lmge.uca.fr/).

Fist create a directory in your home directory called `day3` (`mkdir day3`). We will work in this directory for the rest of the day.

## Setting up

First we will create a new folder in the home directory, `mkdir day3`, in which we will work for the rest of this day.

We will look in detail at several bins and annotations today and to make the steps below comparable it is important that all of our bins and contigs have the same naming. While everyone should have the same data the naming might not be the same for everyone due to stochasticity in the tools (for example it might be bin1 for someone whereas the same data is in bin2 for someone else).

### Data

I concatenated all the bin sequences (in `all_binned_contigs.fasta`) that we will download from Github (see below).

Make sure we are in `~/day3/` (`cd day3`) then run the code below

~~~
mkdir fasta_bins
cd fasta_bins
wget https://github.com/rickbeeloo/day3-data/raw/main/all_binned_contigs.fasta
wget https://raw.githubusercontent.com/rickbeeloo/day3-data/main/bin_01.fasta
wget https://raw.githubusercontent.com/rickbeeloo/day3-data/main/bin_62.fasta
cd ..
~~~
{: .language-bash}

### Conda

Like you did before we have to activate a conda environment

~~~
wget https://raw.githubusercontent.com/rickbeeloo/day3-data/main/day3_func.yaml
conda env create -f day3.yaml -n day3
conda activate day3
~~~
{: .language-bash}

### Rstudio

While a lot of packages are available on conda not all of them are. In this case we have to install two packages "manually". Open rstudio (type `rstudio` on the command line) and then in the console (bottom of the screen) first type:

`install.packages("bioseq")`

then

`install.packages("insect")`

The installation might take a couple of minutes so in the meantime open a new terminal, activate the same environment (`conda activate day3`) and continue with the next exercise



{% include links.md %}
