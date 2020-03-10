Comparative Genomic Analysis Workflow
================
Megan Barkdull

## Introduction

This repository hosts the workflow for a comparative genomics analysis.
The general overview is: ![the workflow begins with downloading sequence
files, then you identify orthologous genes with Orthofinder, then you
test your hypotheses](./ComparativeGenomicsWorkflow.png)

Currently, all of the steps of the workflow are found in
[AntComparativeGenomicsScript.txt](https://github.com/Moreau-Lab/Genomics/blob/master/AntComparativeGenomicsScript.txt).
Please note that this is very much a work in progress\!

For the step where you must convert the outputs of OrthoFinder to be
inputs for RERConverge, please see the [Comparative Genomics
repository](https://github.com/mbarkdull/ComparativeGenomics)

## Downloading sequence files:

You can download sequence files from any source, as needed by your
project. For this workflow, you will need:

1.  **Transcript files** that contain gene names followed by the
    nucleotide sequence for the gene.
2.  **Protein sequence files** that contain gene names followed by the
    amino acid sequence for the protein.

You can download them by opening a Bash shell and using `wget` or a
similar command like `curl`. For example, to download the *Nasonia
vitripennis* transcript and protein sequence
    files:

    wget https://antgenomes.org/downloads/transcripts/Nasonia_vitripennis/Nvit_OGSv1.2_rna.fa.gz
    wget https://antgenomes.org/downloads/proteins/Nasonia_vitripennis/Nvit_OGSv1.2_pep.fa.gz

Then be sure to unzip the files:

    gunzip *.fa.gz

## Identifying orthologous genes with Orthofinder:

[Orthofinder](https://davidemms.github.io/) is a tool that infers groups
of orthologous genes using gene trees. David Emms has a [great
tutorial](https://davidemms.github.io/menu/tutorials.html) to walk you
through using Orthofinder; my workflow is described below.

### Citing Orthofinder

Please be sure to cite the tools you use\!

  - OrthoFinder’s orthogroup and ortholog inference are described here:
      - Emms, D.M., Kelly, S. OrthoFinder: solving fundamental biases in
        whole genome comparisons dramatically improves orthogroup
        inference accuracy. Genome Biol 16, 157 (2015)
      - Emms, D.M., Kelly, S. OrthoFinder: phylogenetic orthology
        inference for comparative genomics. Genome Biol 20, 238 (2019)
  - If you use the OrthoFinder species tree then also cite:
      - Emms D.M. & Kelly S. STRIDE: Species Tree Root Inference from
        Gene Duplication Events (2017), Mol Biol Evol 34(12): 3267-3278
      - Emms D.M. & Kelly S. STAG: Species Tree Inference from All Genes
        (2018), bioRxiv <https://doi.org/10.1101/267914>

### Using Orthofinder

First, [install
Orthofinder](https://davidemms.github.io/orthofinder_tutorials/downloading-and-running-orthofinder.html).

#### Required Inputs

Orthofinder requires input files that contain the amino acid sequences
for all of the protein coding genes in your taxa of interest- in other
words, the **protein sequence files** described in the Downloading
Sequence Files section.
