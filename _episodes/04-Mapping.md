---
title: "Mapping"
teaching: 15
exercises: 30
questions:
- "What does a read aligning to a scaffold indicate?"
objectives:
- "Map the reads back to the cross-assembled scaffolds."
keypoints:
- "Mapping reads back to the cross-assembly we can know which scaffolds/species are present in the samples."
---

To know if a given genomic sequence (a scaffold) obtained via cross-assembly was present in a sample we need to align its sequencing reads back to the cross-assembly. A read aligning to a scaffold indicates that it was used, along with other sequences, to reconstruct this longer fragment. Notice that scaffolds represent genomes' species, so a read aligning to a scaffold ultimately means that a given species is present in the sample.

After aligning and counting the reads we can get a table like this. **In which samples would you say that is present each of the scaffolds?**

|            	| Sample A 	| Sample B 	| Sample C 	|
|:----------:	|:--------:	|:--------:	|:--------:	|
| Scaffold 1 	|     0    	|     631    	|     13    	|
| Scaffold 2 	|     16    	|     17    	|     57    	|
| Scaffold 3 	|     89    	|     0    	|     0    	|

We usually call **mapping** to the process of aligning millions of short sequencing reads to a set of longer sequences, such as genomes or scaffolds. We will use the short read aligner Bowtie2 ([Langmead and Salzberg Nature Methods 2012](https://pubmed.ncbi.nlm.nih.gov/22388286/)). First we will index the reference for the mapping, ie. the cross-scaffolds, which allows the program to access the information very fast. Then we will map the sequences to this index using parameters `-f` to indicate that our reads are in fasta format, and `-x`, `-U` and `-S` for the index, input sequences and output file respectively. Altogether it should take around 10 minutes. While it is running, go to the *Discussion* block below.

~~~
# create another directory for the mapping
$ mkdir 2_mapping

# index the reference
$ bowtie2-build 1_cross-assembly/cross-scaffolds.fasta 2_mapping/cross_scaffolds.index

# map the reads
$ bowtie2 -x 2_mapping/cross_scaffolds.index -f -U all_samples.fasta -S 2_mapping/all_samples_cross.sam
~~~

>## Discussion: Number of reads aligned
> Table above shows different numbers of reads aligning to a scaffold depending on the sample. Which do you think is the reason? How the length of the scaffold affects to these numbers? And the total number of sequences in the sample?
{: .challenge}

Before analyzing the results, look at what Bowtie printed in the terminal: *68.45% overall alignment rate*. **Can you think of a reason for ~30% of unmapped reads?**

Bowtie2 results are provided in **SAM** (Sequence Alignment/Map) format, one of the most widely used alignment formats. You can know more about it [here](https://samtools.github.io/hts-specs/SAMv1.pdf). Briefly, it is a plain, TAB-delimited text format containing information of the mapping references and how the reads aligned to them. SAM files have two readily differentiable sections: the header and the alignments sections. Let's have a look at them with `head` and `tail`. **Which information is provided in the header?**

~~~
# header, at the beginning of the SAM file
$ head 2_mapping/all_samples_cross.sam

# alignments, at the end of the SAM file
$ tail 2_mapping/all_samples_cross.sam
~~~

What a mess the alignments section, isn't it? Important columns for us are column 1 or `QNAME`, with the read identifier; column 2 or `FLAG`, describing the nature of mapping and read; column 3 or `RNAME`, with the reference where the read aligned; column 4 or `POS`, with the position where the reads aligned in the reference; and column 5 or `MAPQ`, with an estimation of how likely is the alignment.

Now we are going to convert the SAM file to its more efficient, binary form, the **BAM** format. This binary form is required in downstream analyses to quickly access the huge amount of information in the file. Furthermore, the reads must be sorted by the position where they map in the references. We will use the Samtools ([Li H et al., 2009](https://academic.oup.com/bioinformatics/article/25/16/2078/204688)) suite for this, specifically, its `view` and `sort` programs. During the conversion we will use parameters `-h` to keep the header and `-F 4` to discard unmapped reads, flagged with a `4` in the `FLAG` column. Last, BAM files need to be indexed, we will use the `index` program for it.

~~~
# convert to BAM
$ cd 2_mapping/
$ samtools view -h -F 4 -O BAM -o all_samples_cross.bam all_samples_cross.sam

# sort the alignments in the BAM file
$ samtools sort -o all_samples_cross_sorted.bam all_samples_cross.bam

# index the final BAM file
$ samtools index all_samples_cross_sorted.bam
~~~  


At this point we have a BAM file with each read aligned to one scaffold, as in the table at the beginning of the section. In the next section we will create such table and investigate how the the scaffolds are distributed across the samples.

{% include links.md %}
