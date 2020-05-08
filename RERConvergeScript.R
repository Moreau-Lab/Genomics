# Load packages:
library(tidyverse)
library(RERconverge)
library(ape)

# Make a phylo object of the master phylogeny:
AllSpecies <- read.tree(file = "KnownAntPhylogeny.txt")
# Read in the trees:
Test <- readTrees(file = "RERInput4610", masterTree = AllSpecies)

# Estimate relative evolutionary rates:
  # Make a vector of species we want to use:
  SpeciesToUse <- c("mpha", "aech", "acep", "cflo", "cobs", "hsal", "lhum", "pbar", "sinv", "cbir", "fexs", "veme", "waur", "pgra", "nful", "acol", "ccos","tcur", "dqua", "tcor", "tsep", "tzet")
  RelativeEvolutionaryRates <- getAllResiduals(Test2, useSpecies = names(SpeciesToUse), transform = "sqrt", weighted = T, scale = T)
 
  MammalRERs <- getAllResiduals(MammalToyTrees, transform = "sqrt", weighted = T, scale = T)
  
   # You can save this output if desired by:
  saveRDS(RelativeEvolutionaryRates, file = "RelativeEvolutionaryRates.rds")
  
# Visualizing relative evolutionary rates:
  TestPlot <- treePlotRers(treesObj = Test2, rermat = RelativeEvolutionaryRates, index = "OG12878", type = "c", nlevels = 3)
  
  
  
  
  
  
# Read in phenotype csv:
  AntPhenotypes <- read_csv("AntGenomesPhenotypes428.csv")
  