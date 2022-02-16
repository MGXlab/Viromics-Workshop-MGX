---
title: "Metavirome assembly"
teaching: 15
exercises: 20
questions:
- "What is a sequence assembly?"
- "How is different a cross-assembly from a normal assembly?"
objectives:
- "Run a cross-assembly with all the samples."
- "Assemble each sample separately and combine the results."
- "Assess the differences between the two approaches."
keypoints:
- "With sequence assembly we get longer, more meaningful genomic fragments from short sequencing reads."
- "In a cross-assembly, reads coming from the same species in different samples are merged into the same scaffold."
---

## Assembly and cross-assembly

*Sequence assembly* is the reconstruction of long contiguous genomic sequences (called *contigs* or *scaffolds*) from short sequencing reads. Before 2014, a common approach in metagenomics was to compare the short sequencing reads to the genomes of known organisms in the database (and some studies today still take this approach). However, recall that most of the sequences of a metavirome are unknown, meaning that they yield no results when comparing them to the databases. Because of this, we need of database-independent approaches to describe new viral sequences. As bioinformatics tools improved, sequence assembly enabled recovery of longer sequences of the metagenomic datasets. Having a longer sequence means having more information to classify it, so using metagenome assembly helps to characterize complex communities such as the gut microbiome.

In a cross-assembly, **multiple samples are combined and assembled together**, allowing the discovery of shared sequence elements between the samples. If a virus (or other sequence element) is present in several samples, its sequencing reads from the different samples will be joined into one scaffold. After this we can know which scaffolds are present in which sample by mapping the sequencing reads from each sample to the cross-assembly. The first crAssphage, one of the most prevalent bacteriophages in the human gut, was discovered following this assembly approach in the same samples you are analyzing ([Dutilh et al 2014](https://www.nature.com/articles/ncomms5498/)).

We will follow two different assembly strategies and assess the differences.

### Cross-Assembly

You will perform a cross-assembly as in [Dutilh et al 2014](https://www.nature.com/articles/ncomms5498/). For this, merge the sequencing reads from all the samples into one single file called `all_samples.fasta`. We will use the assembler program SPAdes ([Bankevich et al J Comput Biol 2012](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3342519/)), which is based on de Bruijn graph assembly from kmers and allows for uneven depths, making it suitable for metagenome assembly and assembly of randomly amplified datasets. As stated above, this cross-assembly will combine the metagenomic sequencing reads from all twelve viromes into contigs/scaffolds. Because of the data we have, we will run SPAdes with parameters `--iontorrent` and `--only-assembler`, and parameters `-s` and `-o` for the input and output. Look at the help message with `spades.py -h` to know more details about the parameters. Look at the questions below while the command is running (around 10 minutes).

~~~
# merge the sequences
$ cat *.fasta > all_samples.fasta

# create a folder for the output cross-assembly
$ mkdir -p 1_assemblies/cross_assembly

# complete the spades command and run it
$ spades.py -o 1_assemblies/cross_assembly ...
~~~
{: .language-bash}

Ion Torrent is a sequencing platform, as well as 454, the platform used to sequence the data you are using. Note well we used `--iontorrent` parameter when running SPAdes. This is because there is not a parameter `--454` to accommodate for the peculiarities of this platform, and the most similar is Ion Torrent. Specifically, both platforms are prone to errors in **homopolymeric regions**. Watch [this video](https://www.youtube.com/watch?v=sdxVDy0lSAE) (if you did not in previous chapter) from minute 06:50, and explain **what is an homopolymeric region, and how exactly the Ion Torrent and 454 platforms fail on them**.

Regarding the `--only-assembler` parameter, we use it to avoid the read error correction step, where the assembler tries to correct single base errors in the reads by looking at the k-mer frequency and quality scores. **Why are we skipping this step?**

### Separate assemblies

The second approach will consist on performing separate assemblies for each sample and merging the results in a final set of scaffolds. Note well if a species is present in several samples, this final set will contain multiple scaffolds representing the same sequence, each of them coming from one sample. Because of this, we will further de-replicate the final scaffolds to get representative sequences.

If you wouldn't know how to run the 12 assemblies sequentially with one command, check block below. Else, create a folder `1_assemblies/separate_assemblies` and put the assembly of each sample there (ie. `1_assemblies/separate_assemblies/F1M`). Use the same parameters as in the cross-assembly.

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

Once the assemblies had finished, run the python script `rename_scaffolds.py` and merge all the renamed scaffolds from `1_assemblies/separate_assemblies/<SAMPLE>/scaffolds_renamed.fasta` into one single file `1_assemblies/separate_assemblies/all_samples_scaffolds.fasta`. We change the name of the scaffolds in each assembly to avoid duplicated names in the final set of scaffolds.

~~~
# include sample name in scaffolds names
$ python rename_scaffolds.py -d 1_assemblies/separate_assemblies

# merge renamed scaffolds
$ cat 1_assemblies/separate_assemblies/*/scaffolds_renamed.fasta > 1_assemblies/separate_assemblies/all_samples_scaffolds.fasta
~~~
{: .language-bash}

To de-replicate the scaffolds, you will cluster them at 95% Average Nucleotide Identify (ANI) over 85% of the length of the shorter sequence. Look at the [CheckV](https://bitbucket.org/berkeleylab/checkv/src/master/) website, _Rapid genome clustering based on pairwise ANI_ section, to do so.

~~~
# create a blast database with all the scaffolds
$ makeblastdb ...

# compare the scaffolds all vs all using blastn
$ blastn ...

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


### Assemblies assessment

Now we will measure some basic aspects of the assemblies, such as the fragmentation degree and the percentage of the raw data they contain. Ideally, the assembly would contain a single and complete contig for each species in the sample, and would represent 100% of the sequencing reads.

#### Fragmentation

Use the QUAST program ([Gurevich et al., 2013](https://pubmed.ncbi.nlm.nih.gov/23422339/)) to assess how fragmented are the assemblies. Have a look at the possible parameters with `quast -h`. You will need to run it two times, one per assembly, and save the results to different folders (ie. `quast_crossassembly` and `quast_separate`)

~~~
# create a folder for the assessment
$ mkdir 1_assemblies/assessment

# run quast two times, one per assembly
$ quast -o 1_assemblies/assessment/<OUTPUT_FOLDER> ...
~~~
{: .language-bash}

#### Raw data representation

You can know the amount of raw data represented by the assemblies by mapping the reads back to them and quantifying the percentage or reads that could be aligned. For this, use the BWA ([cite]()) and Samtools ([cite]()) programs. BWA is a short-read aligner, while Samtools is a suite of programs intended to work with mapping results. Mapping step requires you to first index the assemblies with `bwa index` so BWA can quickly access them. After it, use `bwa mem` to align the sequences to the assemblies and save the results in a SAM format file (ie. `crossassembly.sam` and `separate.sam`). Then use `samtools view` to convert the SAM files to BAM format (ie. `crossassembly.bam` and `separate.bam`), which is the binary form of the SAM format. Once you have the BAM files, sort them with `samtools sort` (output could be `crossassembly_sorted.bam` and `separate_sorted.bam`). Last, index the sorted BAM files to allow for an efficient processing, and get basic stats of the mapping using `samtools flagstats`.

~~~
# index the assemblies
$ bwa index <ASSEMBLY_FASTA>

# map the reads to each assembly
$ bwa mem ... > 1_assemblies/assessment/<OUTPUT_SAM>

# convert SAM file to BAM file
$ samtools view ...

# sort the BAM file
$ samtools sort ...

# index the sorted BAM file
$ samtools index ...

# get mapping statistics
$ samtools flagstats ...
~~~
{: .language-bash}

> ## Compare both assemblies
> So far you have calculated some metrics to assess the quality of the assemblies, but bare in mind there also exist also others we can check for this, such as the number of ORFs or the depth of coverage across the contigs.
> In the report generated by Quast, look at metrics regarding scaffolds length, such as the N50. Can you explain the difference between both assemblies? Regarding the raw data containment, how different are both assemblies?
{: .discussion}



{% include links.md %}
