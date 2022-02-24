---
title: "Assessing viral contigs completeness and contamination"
teaching: 0
exercises: 30
questions:
- "Which signals can we use to assess how complete and/or contaminated is our viral contig?"
objectives:
- ""

keypoints:
- ""

---

~~~
# Install checkv in the environment
$ conda install -c bioconda checkv

# Download database
$ mkdir checkv_database
$ checkv download_database checkv_database
~~~
{: .language-bash}


Run `checkv end_to_end` for the bins using a _for_ loop in Bash. In the folder
with your bins in FASTA format (`bin_00.fasta`, `bin_01.fasta`...):

~~~
# run checkv for each bin, sequentially
$ mkdir checkv_results
$ for bin in b*.fasta; do checkv end_to_end -d <PATH_TO_DATABASE> -t 7 $bin checkv_results/${bin%.fasta} ; done
~~~
{: .language-bash}

While it is running, have a look at the `quality_summary.tsv` files of the bins
already finished.

- __Is there any contig suspicious of not being a virus?__
- __Is there any bin suspicious of containing more than one species?__


{% include links.md %}
