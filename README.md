Comparative Genomic Analysis Workflow
================
Megan Barkdull

## 1\. Introduction

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

## 2\. Getting input files:

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

It may also be a good idea at this point to give all of the downloaded
input files logical and consistent names; for example
`species1_proteinsequence.fa` and `species1_transcript.fa`.

### Ensuring Consistency in Gene Names:

When Ben Rubin’s pipeline is converting OrthoFinder outputs to
RERconverge inputs, it will be crucial that the nucleotide sequence
files and the amino acid sequence files contain the exact same gene
names- and this probably will not be the case in the raw, downloaded
files.

To deal with this issue, you can just translate the transcript files to
amino acids yourself, and then use those translated files as the input
for Orthofinder. To do this, we will use the script
`TranscriptFilesTranslateScript.py`.

#### Using TranscriptFilesTranslateScript.py

To use this script, your working directory needs to contain:

  - All of the downloaded transcript files, in .fasta format
  - The script TranscriptFilestranslateScript.py
  - a parameters .txt file that specifies the path to all of transcript
    files that you want to translate

Then simply run the script with the command:

`python ./TranscriptFilestranslateScript.py ParametersFile.txt`

This should produce translated versions of each transcript file, with
the file suffix “translated.fasta”. You will want to use these for input
to RERconverge.

## 3\. Identifying orthologous genes with Orthofinder:

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
words, the **translated transcript files** produced as described
[above](https://github.com/Moreau-Lab/Genomics#ensuring-consistency-in-gene-names).
This is important, so that the OrthoFinder outputs can be easily
converted into RERconverge inputs by Ben Rubin’s pipeline.

#### Cleaning Up Input Files

It is likely that your translated transcript files will contain many
different transcripts per gene; running Orthofinder on all of these
transcripts will greatly increase the time it takes and may lower the
accuracy. Orthofinder comes with a script to extract just the longest
transcript per gene, thus avoiding this problem.

Run the clean-up script
    with:

    for f in *[common file ending of the protein sequence files.file extension- e.g., translated.fasta] ; do python ~/orthofinder_tutorial/OrthoFinder/tools/primary_transcript.py $f ; done

Change `[common file ending of the protein sequence files.file
extension]` to reflect the file names of your translated transcript
files, which by default should be `translated.fasta`. You may also have
to alter the path to `primary_transcript.py` depending on where you have
installed Orthofinder.

#### Running Orthofinder

To run Orthofinder on your cleaned protein sequence files, simply use
the command

    orthofinder -f primary_transcripts/

Results will be sent to the directory
`./primary_transcripts/OrthoFinder/Results_[DATE]/`.

## 4\. Converting Orthofinder Output to RERconverge Input

For this step, please check out [this
ReadMe](https://github.com/mbarkdull/ComparativeGenomics/blob/devel/README.md).

You will want to copy the final RER inputs file to the working directory
where you will run RERconverge, if it is not the same as the working
directory for this step.

## 5\. Using RERconverge

RERconverge is an R package that identifies genomics elements that have
convergent (faster or slower) rates of evolution in species with
convergent phenotypes (either binary or continuous phenotypes).

### Citing RERconverge:

Please cite RERconverge as follows:

  - **Description of software:**
      - Kowalczyk A, Meyer WK, Partha R, Mao W, Clark NL, Chikina M.
        RERconverge: an R package for associating evolutionary rates
        with convergent traits. Pre-print at bioRxiv:
        <https://doi.org/10.1101/451138>
  - **Detailed description of latest methods:**
      - Partha R, Kowalczyk A, Clark N, Chikina M. Robust methods for
        detecting convergent shifts in evolutionary rates. In press, Mol
        Biol Evol. Pre-print at bioRxiv:
        <https://doi.org/10.1101/457309>
  - **The following are the first demonstrations of analyses using the
    methods in RERconverge:**
      - **In coding sequences:**
          - Chikina M, Robinson JD, Clark NL. Hundreds of Genes
            Experienced Convergent Shifts in Selective Pressure in
            Marine Mammals. Mol Biol Evol. 2016;33: 2182–92.
            <doi:10.1093/molbev/msw112>
      - **For conserved non-coding sequences:**
          - Partha R, Chauhan B, Ferreira Z, Robinson J, Lathrop K,
            Nischal K, et al. Subterranean mammals show convergent
            regression in ocular genes and enhancers, along with
            adaptation to tunneling. eLife 2017;6:e25884.
            <https://doi.org/10.7554/eLife.25884>

### Installing RERconverge:

Refer to the [RERconverge install
page](https://github.com/nclark-lab/RERconverge/wiki/Install) for
detailed instructions on installation.

### Using RERconverge:

#### Required Inputs

RERconverge requires two types of data:

1.  **Phylogenetic trees** for every genomic element being examined.
      - Trees should be in Newick format, with tip labels and without
        node labels.
      - Trees should have branch lengths that represent element-specific
        evolutionary rates.
      - Tree topologies must all be subsets of the same species tree
        topology (no gene tree-species tree incongruence is allowed).
2.  **Vectors of phenotypic values** for each species.
      - Species labels must match the tip labels in the genomic element
        trees.
      - If you are examining a **continuous trait**, you should supply a
        named numeric vector of trait values.
      - If you are examing a **binary trait**, you should supply either:
          - A vector of the foreground species names
          - A Newick tree with background branches of length 0 and
            foreground branches of length 1
          - Or you can specify the foreground branches via an
            interactive tool within RERconverge.

#### Using RERconverge within RStudio:

##### Set your working directory:

RERconverge is an R package, so we will be running it within R. First,
be sure that your working directory in RStudio is [set to the working
directory you are
using](https://support.rstudio.com/hc/en-us/articles/200711843-Working-Directories-and-Workspaces)
for your project. The best way to do this is probably to [create an R
Project](https://support.rstudio.com/hc/en-us/articles/200526207) and
associate it with that working directory.

#### Using RERconverge:
