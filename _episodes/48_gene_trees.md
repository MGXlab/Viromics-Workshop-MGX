---
title: "Phylogeny based on marker genes"
teaching: 10
exercises: 50
questions:
- "Can we use marker genes to infer phylogeny and taxonomy?"
objectives:
- "Make a phylogeny based on terminase large subunit"

keypoints:
- ""

---

As we discussed this morning, we can use the evolutionary history of certain genes to
address questions about the evolution and function of viruses. Although there are no
universal marker genes for all the viruses, but many viral lineages share one or more
marker genes that can be used for to assess relationships between the viruses carrying
them. Our samples were metaviromes from the human gut. Like many biomes, the human gut
virome contains many bacteriophages, and we can use the large subunit of the terminase
(TerL) gene to study how they are related. The TerL
gene, present in all members of the _Caudovirales_, pumps the genome inside an empty
procapsid shell during virus maturation by using both enzymatic activities necessary
for packaging in such viruses: the adenosine triphosphatase (ATPase) that powers
DNA translocation and an endonuclease that cleaves the concatemeric genome at both
initiation and completion of genome packaging.


#### Activate environment
~~~
# Download, create and activate environment
$ wget https://raw.githubusercontent.com/MGXlab/Viromics-Workshop-MGX/gh-pages/code/day4/day4_phyl_env.txt
$ conda create --name day4_phyl --file day4_phyl_env.txt
$ conda activate day4_phyl
~~~
{: .language-bash}

#### TerL sequences from bins and database

Use the script `get_terl_bins.py` to gather the large terminases annotated in the
bins. This script looks at the annotatin table generated on day3, select the proteins
annotated as _terminase_ or _large terminase subunit_, and gets their sequences from
the FASTA file with all the proteins. Have a look at the help message to see the
parameters you need. Save the results in `bins_terl.faa`.

~~~
# Run the script get the bins terminases
$ wget https://raw.githubusercontent.com/MGXlab/Viromics-Workshop-MGX/gh-pages/code/day4/get_terl_genes.py
$ python get_terl_genes.py ...
~~~
{: .language-bash}

As reference set we will use the TerL found in the [ICTV](https://talk.ictvonline.org/)
database. Since this database does not contain _Crassvirales_ (aka crassphages) yet,
we will supplement it with a set of representative _Crassvirales_ sequences. Download
these sequences and merge them with TerL you just extracted from the bins.

~~~
# Download reference set
$ wget https://raw.githubusercontent.com/MGXlab/Viromics-Workshop-MGX/gh-pages/data/day_4/ictv_crass_terl.faa

# merge bins and reference sets
$ cat bins_terl.faa ictv_crass_terl.faa >  bins_ictv_crass_terl.faa
~~~
{: .language-bash}


#### Multiple sequence alignment
Align the sequences using `mafft`. Check the [manual](https://mafft.cbrc.jp/alignment/software/algorithms/algorithms.html) for more information.

> ## Alignment algorithm
> Have a look at the different algorithms available with MAFFT. __Which one do you
> think best fits our data? Can you use one of the most accurate?__
{: .challenge}

Once MAFFT has finished, use `trimal` remove positions in the alignment with gaps in more than
50% of the sequences. Check the help message to know more about the parameters.


### Infer the TerL phylogeny
Use `fasttree` to infer the TerL phylogeny from the multiple sequence alignment. Once
finished, upload the tree to [iToL](https://itol.embl.de/). Add taxonomic annotation
(`itol_ictv_crass_colors.txt`) in the _Datasets_ section for a better understanding of the tree.

~~~
# Download reference set annotation
$ wget https://raw.githubusercontent.com/MGXlab/Viromics-Workshop-MGX/gh-pages/data/day_4/itol_ictv_crass_colors.txt
~~~
{: .language-bash}

> ## Bins in the tree
> - __Where do our (bins) terminases fall?__
{: .challenge}

> ## Viral families in the tree
> - __Do the families cluster, and can you explain why?__
>
> _Check [this taxonomy proposal](https://talk.ictvonline.org/files/proposals/taxonomy_proposals_prokaryote1/m/bact04/12849) from ICTV and [Turner et al., 2021](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8003253/)_
{: .challenge}


{% include links.md %}
