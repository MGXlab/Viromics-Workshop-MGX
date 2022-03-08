---
title: "Metavirome assembly"
teaching: 20
exercises: 40
questions:
- "What is a sequence assembly?"
- "How is different a cross-assembly from a normal assembly?"
objectives:
- "Run a cross-assembly with all the samples."
- "Assemble each sample separately and combine the results."
keypoints:
- "With sequence assembly we get longer, more meaningful genomic fragments from short sequencing reads."
- "In a cross-assembly, reads coming from the same species in different samples are merged into the same contig."
---

## Assembly and cross-assembly

*Sequence assembly* is the reconstruction of long contiguous genomic sequences (called *contigs* or *scaffolds*) from short sequencing reads. Before 2014, a common approach in metagenomics was to compare the short sequencing reads to the genomes of known organisms in the database (and some studies today still take this approach). However, recall that most of the sequences of a metavirome are unknown, meaning that they yield no matches when are compared to the databases. Because of this, we need of database-independent approaches to describe new viral sequences. As bioinformatic tools improved, sequence assembly enabled recovery of longer sequences of the metagenomic datasets. Having a longer sequence means having more information to classify it, so using metagenome assembly helps to characterize complex communities such as the gut microbiome.

In this lesson you will assemble the metaviromes in two different ways.

### Cross-Assembly

In a cross-assembly, **multiple samples are combined and assembled together**, allowing for the discovery of shared sequence elements between the samples. If a virus (or other sequence element) is present in several samples, its sequencing reads from the different samples will be assembled together in one contig. After this we can know which contigs are present in which sample by mapping the sequencing reads from each sample to the cross-assembly.

You will perform a cross-assembly as in [Dutilh et al., 2014](https://www.nature.com/articles/ncomms5498/). For this, merge the sequencing reads from all the samples into one single file called `all_samples.fasta`. We will use the assembler program SPAdes ([Bankevich et al., 2012](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3342519/)), which is based on de Bruijn graph assembly from kmers and allows for uneven depths, making it suitable for metagenome assembly. As stated above, this cross-assembly will combine the metagenomic sequencing reads from all twelve viromes into contigs. Because of the data we have, we will run SPAdes with parameters `--iontorrent` and `--only-assembler`, and parameters `-s` and `-o` for the input and output. Look at the help message with `spades.py -h` to know more details about the parameters. Look at the questions below while the command is running (around 10 minutes).

~~~
# merge the sequences
$ cat *.fasta > all_samples.fasta

# create a folder for the output cross-assembly
$ mkdir -p 1_assemblies/cross_assembly

# complete the spades command and run it
$ spades.py -o 1_assemblies/cross_assembly ...
~~~
{: .language-bash}

Ion Torrent is a sequencing platform, as well as 454, the platform used to sequence the data you are using. Note well we used `--iontorrent` parameter when running SPAdes. This is because there is not a parameter `--454` to accommodate for the peculiarities of this platform, and the most similar is Ion Torrent. Specifically, both platforms are prone to errors in **homopolymeric regions**. Have a look at [this video](https://www.youtube.com/watch?v=sdxVDy0lSAE) from minute 06:50, and explain **what is an homopolymeric region, and how exactly the Ion Torrent and 454 platforms fail on them**.

Regarding the `--only-assembler` parameter, we use it to avoid the read error correction step, where the assembler tries to correct single base errors in the reads by looking at the k-mer frequency and quality scores. **Why are we skipping this step?**

### Separate assemblies

The second approach consists on performing separate assemblies for each sample and merging the resulting contigs at the end. Note well if a species is present in several samples, this final set will contain multiple contigs representing the same sequence, each of them coming from one sample. Because of this, we will further de-replicate the final contigs to get representative sequences.

If you wouldn't know how to run the 12 assemblies sequentially with one command, check block below. Else, create a folder `1_assemblies/separate_assemblies` and put each sample's assembly there (ie. `1_assemblies/separate_assemblies/F1M`). Use the same parameters as in the cross-assembly.

> ## Process multiple samples sequentially
> Sometimes you need to do the same analysis for different samples. For those cases,
> instead of waiting for one sample to finish to start off with the next one, you
> can set a command to process all of them sequentially.
>
> First you need to define a variable (ie. SAMPLES) with the name of your samples.
> Then, you can use a `for` loop to iterate the samples and repeat the analysis command,
> which is everything between `;do` and the `;done`. Note well the sample name is just the suffix
> of the input and output and you still need to add the proper directory and file extension.
>
> Let's say you have sequencing reads in the files `sample1.fastq`, `sample2.fastq`
> and `sample3.fastq`, each of them representing a sample. You want to align them
> to a given genome using bowtie2 and save the output to `alignments/sample1_aligned.sam`,
> `alignments/sample2_aligned.sam` and `alignments/sample3_aligned.sam`. You could
> do this:
> ~~~
> # define a variable with the names of the samples
> export SAMPLES="sample1 sample2 sample3"
>
> # iterate the sample names in SAMPLES
> for sample in $SAMPLES; do bowtie2 -x genome_index -1 ${sample}.fastq -S alignments/${sample}_aligned.sam ; done
> ~~~
> {: .language-bash}
{: .objectives}

Once the assemblies had finished, you will combine their scaffolds in a single file.
The identifier of a contig/scaffold from SPAdes has the following format (from the [SPAdes manual](https://cab.spbu.ru/files/release3.15.2/manual.html)): _>NODE_3_length_237403_cov_243.207_, where _3_ is the number of the contig/scaffold, _237403_ is the sequence length in nucleotides and _243.207_ is the k-mer coverage.
It might happen that 2 contigs from different samples' assemblies have the same identifier, and
recall from earlier this morning that
So, just in case, we will add the sample identifier at the beginning of the scaffolds identifiers
to make sure they are different between samples. Use the Python script `rename_scaffolds.py`
for this, which will create a `scaffolds_renamed.fasta` file for each sample's assembly. Then,
merge the results into `1_assemblies/separate_assemblies/all_samples_scaffolds.fasta`.

~~~
# download the python script
$ wget https://raw.githubusercontent.com/MGXlab/Viromics-Workshop-MGX/gh-pages/code/day1/rename_scaffolds.py

# include sample name in scaffolds names
$ python rename_scaffolds.py -d 1_assemblies/separate_assemblies

# merge renamed scaffolds
$ cat 1_assemblies/separate_assemblies/*/scaffolds_renamed.fasta > 1_assemblies/separate_assemblies/all_samples_scaffolds.fasta
~~~
{: .language-bash}

To de-replicate the scaffolds, you will cluster them at 95% Average Nucleotide Identify (ANI) over 85% of the length of the shorter sequence, cutoffs often used to cluster viral genomes at the species level. For further analysis, we will use the longest sequence of the cluster as a representative of it. Then, with this approach we are:

- Clustering complete viral genomes at the species level
- Clustering genome fragments along with very similar and longer sequences

Look at the [CheckV](https://bitbucket.org/berkeleylab/checkv/src/master/) website and follow the steps under _Rapid genome clustering based on pairwise ANI_ section to perform this clustering.

~~~


# create a blast database with all the scaffolds
$ makeblastdb ...

# compare the scaffolds all vs all using blastn
$ blastn ...

# download anicalc.py and aniclust.py scripts
$ wget https://raw.githubusercontent.com/MGXlab/Viromics-Workshop-MGX/gh-pages/code/day1/anicalc.py
$ wget https://raw.githubusercontent.com/MGXlab/Viromics-Workshop-MGX/gh-pages/code/day1/aniclust.py

# calculate pairwise ANI
$ python anicalc.py ...

# cluster scaffolds at 95% ANI and 85% aligned fraction of the shorter
$ python aniclust.py -o 1_assemblies/separate_assemblies/my_clusters.tsv ...
~~~
{: .language-bash}


The final output, called `my_clusters.tsv`, is a two-columns tabular file with the representative sequence of the cluster in the first column, and all the scaffolds that are part of the cluster in the second column. Using `cut` and its `-f` parameter to put all the representatives names in one file called `my_clusters_representatives.txt`. Then, use `seqtk subseq` to grab the sequences of the scaffolds listed in `my_clusters_representatives.txt` and save them to `my_clusters_representatives.fasta`.

~~~
# put the representatives names in 'my_clusters_representatives.txt'
$ cut ... > 1_assemblies/separate_assemblies/my_clusters_representatives.txt

# extract the representatives sequences using seqtk
$ seqtk subseq ... > 1_assemblies/separate_assemblies/my_clusters_representatives.fasta
~~~
{: .language-bash}

> ## Scaffolding in SPAdes
> Previously this morning you saw how, using paired-end reads information, contigs
> can be merged in scaffolds. However, we have been using the scaffolds during this  
> lesson.
> Identify a scaffold with clear evidence of merged contigs, and explain how is that
> possible if we are using single-end reads.
> > ## Solution
> > Not the solution, but a hint ;) check the [SPAdes manual](http://cab.spbu.ru/files/release3.15.3/manual.html)
> {: .solution}
{: .challenge}


{% include links.md %}
