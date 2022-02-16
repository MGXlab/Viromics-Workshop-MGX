---
title: "Introduction"
teaching: 10
exercises: 0
questions:
- "What is _metagenomics_"
- "What do we call _viral dark matter_"
objectives:
- "Understanding what is a metagenomic study"
keypoints:
- "Metagenomics is the culture-independent study of the collection of genomes from different microorganisms present in a complex sample."
- "We call _dark matter_ to the sequences that don't match to any other known sequence in the databases."

---

The emergence of Next Generation Sequencing (NGS) has facilitated the development of metagenomics. In metagenomic studies, DNA from all the organisms in a mixed sample is sequenced in a massively parallel way (or RNA in case of metatranscriptomics). The goal of these studies is usually to identify certain microbes in a sample, or to taxonomically or functionally characterize a microbial community. There are different ways to process and analyze metagenomes, such as the targeted amplification and sequencing of the 16S ribosomal RNA gene (amplicon sequencing, used for taxonomic profiling) or shotgun sequencing of the complete genomes (metagenomics, used for taxonomic and functional profiling).

After primary processing including quality control of the sequencing data (which we will not perform in this exercise), the metagenomic sequences are compared to a reference database composed of genome sequences of known organisms. Sequence similarity indicates that the microbes in the sample are genomically related to the organisms in the database. By counting the sequencing reads that are related to certain taxa, or that encode certain functions, we can get an idea of the ecology and functioning of the sampled metagenome.

When the sample is composed mostly of viruses we talk of *metaviromics*. Viruses are the most abundant entities on earth and the majority of them are yet to be discovered. This means that the fraction of viruses that are described in the databases is a small representation of the actual viral diversity. Because of this, a high percentage of the sequencing data in metaviromic studies show no similarity with any sequence in the databases. We sometimes call this unknown, or at least uncharacterizable fraction *viral dark matter*. As additional viruses are discovered and described and we expand our view of the Virosphere, we will increasingly be able to understand the role of viruses in microbial ecosystems.

In this exercise we will re-analyze original metaviromic sequencing data from 2010 to re-discover the most abundant bacteriophage in the human gut, the [crAssphage](https://en.wikipedia.org/wiki/crAssphage), which owe its name to the _cross-assembly_ procedure that allowed its discovery. Let's get started!


{% include links.md %}
