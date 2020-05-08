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
  - The script TranscriptFilesTranslateScript.py
  - a parameters .txt file that specifies the path to all of transcript
    files that you want to translate

Then simply run the script with the command:

`python ./TranscriptFilesTranslateScript.py ParametersFile.txt`

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

When Ben Rubin’s pipeline is converting OrthoFinder outputs to
RERconverge inputs, it will be crucial that all of the gene names start
with the taxon abbreviation that you are going to use.

To do this, navigate to the `/primary_transcripts` directory:

`cd ./primary_transcripts`

Now use `sed` to append the four-character code to the beginning of each
gene name. This command replaces `>` at the beginning of each gene name
with `>CODE_`. This still has to be done one species at a time- I’ll try
to come up with a better solution. The parameters in this command are:

  - `-i` means save in place, overwriting the original file
  - `s` means substitute
  - `g` means global, so search and replace all.
  - The two single quotes are probably not necessary on the BioHPC Linux
    machines.

So, for each translated transcript file, use the command:

`sed -i '' 's/>/>CODE_/g' TranslatedTranscriptFile.fasta`

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

## 5\. Assessing relative evolutionary rates with RERconverge

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

#### Running RERconverge:

## 6\. Analyzing orthogroups with Kinfin:

Kinfin is a Python 2 package that helps you explore the results of your
orthogroup analysis. Kinfin can produce a number of things:

  - Visualizations of ortholog clustering, both in terms of orthogroup
    size and taxon membership in each orthogroup.
      - Kinfin creates a network diagram where nodes represent taxa and
        edges are scaled to represent the number of times two taxa
        co-occur in the same orthogroup.
  - Analyses that compare user-defined sets of taxa based on their
    membership in each orthogroup; for example, you could classify all
    your taxa as herbivorous/nonherbivorous and identify orthogroups
    that are enriched and depleted in the herbivores.
      - Kinfin produces volcano plots to help you visualize these
        results, but included in this Github repository is a
        [script](https://github.com/Moreau-Lab/Genomics/blob/master/VolcanoPlot.R)
        to allow you to generate your own, custom volcano plots.
  - Classification of orthogroups into:
      - *Present* for all members of a taxon set or for a particular
        taxon
      - *Absent* for all members of a taxon set or for a particular
        taxon
      - *Singleton*
      - *Specific* to a particular taxon set
      - *Shared* between taxon sets
  - Identification of “fuzzy” single-copy orthogroups (i.e. orthogroups
    with just one locus per species)
  - Rarefaction curves
  - Analyses based on functional annotation of the proteins and on
    protein length
  - Analysis of clusters that contain user-defined genes of interest

### Citing Kinfin:

Please cite Kinfin as follows:

  - Laetsch DR and Blaxter ML, 2017. KinFin: Software for Taxon-Aware
    Analysis of Clustered Protein Sequences. G3: Genes, Genomes,
    Genetics. <Doi:10.1534/g3.117.300233>

### Installing Kinfin:

Follow the [instructions](https://kinfin.readme.io/docs/getting-started)
for installation. Note that this is a Python 2.7 application, so you’ll
need to be using Python 2.7 when running Kinfin. This can generally be
achieved by installing a local copy of Python 2 with something like
Homebrew, and then adding the path to that version of Python to your
path variable. If you are on a Mac, I would suggest following [these
instructions](https://medium.com/@yangnana11/installing-python-2-on-mac-os-x-d0f1c9c4d808).

### Using Kinfin:

#### Required inputs:

Kinfin will require:

  - The `Orthogroup.txt` file created by Orthofinder.
  - The `SequenceIDs.txt` file created by Orthofinder.
  - The `SpeciesIDs.txt` file created by Orthofinder.
  - A `config.txt` file
      - This can be created by executing the following Bash commands
        once the above three files are in your working directory:
          - `echo '#IDX,TAXON' > config.txt`
          - `sed 's/: /,/g' SpeciesIDs.txt | \ cut -f 1 -d"." \ >>
            config.txt`
      - This will generate a two-column config file with one column for
        taxon number and one column for taxon ID (the four letter
        abbreviations that you have been using).
      - You can then manually add columns to define your own taxon sets
        (herbivores/nonherbivores, tropical/nontropical, etc.), giving
        each taxon a 1 or 0 to define membership in the taxon set.
  - There are other, optional input files if you want to run some of the
    more involved analyses (regarding orthogroup function, for example).

#### Running Kinfin:

To run Kinfin, use the
    command:

    /PATHTOTHEKINFININSTALLATION/kinfin/kinfin --cluster_file Orthogroups.txt --config_file config.txt --sequence_ids_file SequenceIDs.txt 

Change the path to the Kinfin installation to match your setup.

#### Analyzing Kinfin outputs:

I have created a
[script](https://github.com/Moreau-Lab/Genomics/blob/master/VolcanoPlot.R)
so that you can customize the volcano plots produced by Kinfin.
