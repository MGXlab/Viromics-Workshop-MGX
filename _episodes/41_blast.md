---
title: "Blast searching viral contigs"
teaching: 0
exercises: 30
questions:
- "What are the challenges of viral taxonomy"
- "Can we classify viral sequences with Blast?"
objectives:
- "Run megablast on assembled viral contigs"
keypoints:
- "Only in a very limited number of cases will direct sequence searches result in hits with high query coverage, because the majority of uncultivated viral sequences have not been previously described. You might hit nothing at all, or perhaps different viral (or bacterial) sequences with low query coverage."
- "We need more sophisticated search strategies for assigning taxonomy to novel viral sequences"
---

### Part 1. Blast

Blast a few of the larger contigs (e.g. larger than 10kb) with [Megablast](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome) by copying the fasta sequence or making a new file containing a single contig and uploading that.
For "Database" select `Nucleotide collection (nr/nt)` or `RefSeq Genome database`

Do you get any close hits? Do you get any viral hits at all? What does that mean?


{% include links.md %}
