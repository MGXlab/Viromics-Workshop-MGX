---
title: "Profiles correlation"
teaching: 15
exercises: 10
questions:
- "How does including more samples affect the binning step?"
objectives:
- "Find which scaffolds have similar depth profiles to the ubiquitous scaffold you have chosen."
keypoints:
- "Adding more samples with similar species diversity but different abundances increases the binning resolution."
---

From the previous section we know there are some scaffolds present in almost all samples, and that we can bin them looking at their abundances or depths in a sample. However, we can achieve a better binning resolution by taking all the samples into account.

Look at the table below, with the mean depth of coverage for each scaffold in each sample. Looking only at sample A, we would say that scaffolds 1,2,4,5 and 6 come from the same genome because they have the same depth. However, looking at Samples B and C we can see that there are indeed 3 bins: [2,5,6], [1,4] and [3,7]. By adding more samples to the binning step we can discern which scaffolds, with the same depth, come from the same species.

|            	| Sample A 	| Sample B 	| Sample C 	|
|:----------:	|:--------:	|:--------:	|:--------:	|
| Scaffold 1 	|    4x    	|    15x   	|    0x    	|
| Scaffold 2 	|    4x    	|    3x    	|    9x    	|
| Scaffold 3 	|    0x    	|    7x    	|    6x    	|
| Scaffold 4 	|    4x    	|    15x   	|    0x    	|
| Scaffold 5 	|    4x    	|    3x    	|    9x    	|
| Scaffold 6 	|    4x    	|    3x    	|    9x    	|
| Scaffold 7 	|    0x    	|    7x    	|    6x    	|

Now we are going to bin our scaffolds, but not all of them: we will focus on those that are present in most of the samples, and look for others with a similar abundance profile, ie. a similar pattern of abundance across the samples. For this, you will select one of the most ubiquitous scaffolds printed in the terminal in the previous section, and use the script `profiles_correlation.py` to find other scaffolds with highly correlating depth profiles (>0.9 Pearson). **Those highly correlated with the scaffold you selected are likely to be part of the same bin**.

Script `bam_to_profile.py` from previous section also gave you a file called `profiles_depth_length_corrected.txt`, with the number of reads aligned to each scaffold in each sample, normalized by the length of the scaffolds and the number of sequencing reads in the sample. We will use these normalized abundances as input for the script `profiles_correlation.py`, along with the identifier of the scaffold of your choice via the parameter `-s`. Output file will be a tabular file called `scaffolds_corr_90.txt` with two columns, the first containing the scaffolds IDs and the second the correlation score. We will dump the first column to the file `scaffolds_corr90_ids.txt` using `cut`, and use the `seqtk` program to grab their sequences from the original cross-assembly.

~~~
# find which scaffolds correlate well with yours
$ python python_scripts/profiles_correlation.py -p 3_profiles/profiles_depth_length_corrected.txt -o 3_profiles/ -s <YOUR_SCAFFOLD_ID>

# get the first column of the output file
$ cut -f1 3_profiles/scaffolds_corr_90.txt > 3_profiles/scaffolds_corr_90_ids.txt

# how many scaffolds do we have in the bin?
$ wc -l 3_profiles/scaffolds_corr_90.txt

# extract the sequence of the scaffolds
$ seqtk subseq 1_cross-assembly/cross_scaffolds.fasta 3_profiles/scaffolds_corr_90_headers.txt > 3_profiles/scaffolds_corr_90.fasta
~~~

>## Challenge: BLAST one of the scaffolds
> BLAST (Basic Local Alignment Search Tool) has become so important in bioinformatics that has its own verb, _to blast_ something. In its [online version](https://blast.ncbi.nlm.nih.gov/Blast.cgi) you can check if there is any sequence similar to your scaffolds in the public databases. Choose one of them and _blast_ it. Is there any hit? If so, to which organism?
{: .challenge}

So, we have a set of scaffolds that seem to come from the same genome. In the next section we will try to reconstruct it.

{% include links.md %}
