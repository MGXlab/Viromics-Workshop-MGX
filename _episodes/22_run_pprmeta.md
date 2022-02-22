---
title: "Setup and run PPR-Meta"
teaching: 10
exercises: 20
questions:
- "How do we install and run PPR-Meta?"
- "How are PPR-Meta and DeepVirFinder different?"
objectives:
- "Create the PPR-Meta conda environment"
- "Run PPR-Meta"
keypoints:
- "Setting up the right conda environment for a tool can be tricky."
- "PPR-Meta runs much faster than DeepVirFinder."
---

In the lecture you have heard what different strategies tools can use to detect viral sequences from assembled metagenomes. The overall objective of today is to test how these different strategies affect which sequences are annotated as viral and which ones are not.

The second tool we are going to run is called PPR-Meta ([Fang et al. 2019](https://academic.oup.com/gigascience/article/8/6/giz066/5521157)). Like DeepVirFinder, PPR-Meta uses deep learning neural networks to annotate sequences as bacterial, viral, or plasmid. Both PPR-Meta and DeepVirFinder initially encode DNA sequences the same way: as a list of binary vectors. This means that each nucleotide is encoted as a binary vector, for example: A=[1,0,0,0], C=[0,1,0,0], and so on. This type of recoding categorical data in a binary way is known as [one hot encoding](https://stackoverflow.com/questions/34263772/how-to-generate-one-hot-encoding-for-dna-sequences). In DeepVirFinder, this encoding is used to learn genomic patterns. In essence, DeepVirFinder learns how often certain DNA motifs appear in each sequence by "sliding" a 10-nucleotide window over the sequence. The window is then compared to known motifs pre-trained model to decide whether a sequence should be classified as bacterial or phage. PPR-Meta is a little simpler: The DNA is encoded in the manner mentioned above. Then, PPR-Meta does the same thing for codons - in this case, the binary vectors each have a length of 64, as there are 64 different possible codons. The two resulting matrices are the input for the prediction of phage/plasmid/microbial sequence.

Getting PPR-Meta to run is a little more work than DeepVirFinder. First, deactivate the dvf conda environment if you haven't already. 

~~~
# deactivate deepvir
(dvf)$ conda deactivate
$
~~~
{: .language-bash}


Then, create a conda environment for pprmeta from the file *pprmeta.yaml* (If you cannot remember how to do this, look back to the previous lesson) and activate the new environment. Afterwards, you have to download the MATLAB Runtime from [this](https://nl.mathworks.com/products/compiler/matlab-runtime.html) website. Make sure that you download the linux version and specifically, version 9.4.

~~~
# unzip MCR
(pprmeta)$ unzip MCR_R2018a_glnxa64_installer.zip

# install MCR into the tools folder
(pprmeta)$ ./install -mode silent -agreeToLicense yes -destinationFolder ~/ViromicsCourse/day2/tools
~~~
{: .language-bash}

The installation will take a little while. In the meantime, to better understand the differences between the tools, read the description of how they work in their publications.

[PPR-Meta](https://academic.oup.com/gigascience/article/8/6/giz066/5521157) - Read at least the sections **Dataset construction** and **Mathematical model of DNA sequences**

[DeepVirFinder](https://link.springer.com/article/10.1007/s40484-019-0187-4) - Read the sections **DeepVirFinder: viral sequences prediction using convolutional neural networks**, **Determining the optimal model for DeepVirFinder**, and the first two paragraphs of section **Predicting viral sequences using convolutional neural networks** (don't worry about the math to much).


Next, download PPR-Meta and make the main script into an executable.

~~~
# download PPR-Meta
(pprmeta)$ git clone https://github.com/zhenchengfang/PPR-Meta.git
(pprmeta)$ cd PPR-Meta

# make main script into an executable
(pprmeta)$ chmod u+x ./PPR-Meta
~~~
{: .language-bash}


Finally, we have to edit the so-called LD_LIBRARY_PATH, a variable that contains a list of filepaths. This list helps PPR-Meta to find the MCR files that it needs to run, as the program doesn't "know" where MCR is installed. PPR-Meta provides a small sample dataset that you can test the installation on.

~~~
# Add MCR folders to LD_LIBRARY_PATH
# Note: If you have another version of MCR installed in your conda version, you might need to unset the library path first using: unset LD_LIBRARY_PATH
(pprmeta)$ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/ViromicsCourse/day2/tools/v94/runtime/glnxa64
(pprmeta)$ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/ViromicsCourse/day2/tools/v94/bin/glnxa64
(pprmeta)$ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/ViromicsCourse/day2/tools/v94/sys/os/glnxa64
(pprmeta)$ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/ViromicsCourse/day2/tools/v94/extern/bin/glnxa64

# You can test whether PPR-Meta is running correctly by running
(pprmeta)$ cd ~/ViromicsCourse/day2/tools/PPR-Meta
(pprmeta)$ ./PPR-Meta example.fna results.csv
~~~
{: .language-bash}


If the test run finishes successfully, then you can run PPR-Meta on the truncated contig file.

~~~
# Run PPR-Meta on contigs
(pprmeta)$ ./PPR-Meta ../../scaffolds_over_300.fasta ../../results/scaffolds_over_300_pprmeta.csv
~~~
{: .language-bash}

PPR-Meta is very fast - your run should only take a couple of minutes. When it's finished, move on to the next section. If you don't have the database for virsorter on your computer yet, you can start the download in the background now. You can download the data [here](https://zenodo.org/record/1168727/files/virsorter-data-v2.tar.gz) and unzip it after the download.


{% include links.md %}
