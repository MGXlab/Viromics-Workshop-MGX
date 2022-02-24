---
title: "Installing and running Vcontact2"
teaching: 0
exercises: 30
questions:
- "How do we install and run Vcontact2?"

objectives:
- "Install & Run Vcontact2"

keypoints:
- "We're running vContact2 over lunch because it takes around an hour to finish"

---
Another way to visualise genome similarity based on gene sharing is by graphing
them as networks. [Vcontact2](https://www.nature.com/articles/s41587-019-0100-8)
is a popular tool perform taxonomic classification that uses gene sharing
networks.

In short, Vcontact2 uses a two step clustering approach to first cluster proteins
into protein clusters (PCs, similar to what you did in day 3) and then
clusters genomes based on how many PCs they share. It then applies parameterised
cut-offs to decide whether genomes are similar enough to be considered as belonging to the same genus.
For more information please read the [Vcontact2 paper ](https://www.nature.com/articles/s41587-019-0100-8)
or [repository](https://bitbucket.org/MAVERICLab/vcontact2/).

We will start vContact2 before lunch because it takes ~1 hour to run for our dataset. In the afternoon we will analyse the output.


### 0. Install Vcontact2
Installing vcontact2 is a bit of a mess due to some dependencies, so we will create
a separate conda environment. Open a new terminal and do the following:

```
# create a new conda environment
$ conda create --name vContact2 python=3.7
$ conda activate vContact2

# pandas need to be 0.25.3
$ conda install pandas=0.25.3
$ conda install -c bioconda vcontact2
$ conda install -c bioconda -y mcl blast diamond

# Downgrade Numpy
$ conda install -c bioconda numpy=1.19.5

# Install ClusterONE
# Please remember where you put it, as you need to specify the path to cluster one when running vcontact2.
# cd /path/to/viromics/folder
wget --no-check-certificate https://paccanarolab.org/static_content/clusterone/cluster_one-1.0.jar
```

Next we are going to run vContact2. Vcontact2 comes with a test dataset to verify if
it installed correctly, but because running this test takes ~1 hour we are going to
skip it and directly test by analysing our own dataset.

> ## Task 1: Create vContact2 input files
> Read the [Vcontact2 manual](https://bitbucket.org/MAVERICLab/vcontact2/wiki/Home). What input do you need?
Can you create these files?
> > ## solution
> > You need two files:
> > 1. A FASTA-formatted amino acid file.
> > 2. A "gene_to_genome" mapping file, in either tsv (tab)- or csv (comma)-separated format.
> > ~~~
> > echo "protein_id,contig_id,keywords" >> gene_to_genome.csv
> > cat proteins_bins.faa | grep ">" | cut -f 1 -d " "  | sed 's/^>//g' > protein_ids.csv
> > cat protein_ids.csv | sed 's/_[0-9]*$//g' >contig_ids.csv
> > paste -d , protein_ids.csv contig_ids.csv >> gene_to_genome.csv 
> > ~~~
> {: .solution}
{: .challenge}


> ## Task 2: run Vcontact2
> Check the [Vcontact2 manual](https://bitbucket.org/MAVERICLab/vcontact2/wiki/Home) to find out how to do this.
> > ## solution
> > From within the vcontact environment, run:
> > ```
> > vcontact2 --raw-proteins /path/to/proteinfile.faa --rel-mode 'Diamond' --proteins-fp /path/to/gene_to_genome.csv --db 'ProkaryoticViralRefSeq94-Merged' --pcs-mode MCL --vcs-mode ClusterONE --c1-bin /path/to/clusterone --output-dir /path/to/output/dir
> >```
> {: .solution}
{: .challenge}

Now that vContact2 is running enjoy your lunch break!
{% include links.md %}
