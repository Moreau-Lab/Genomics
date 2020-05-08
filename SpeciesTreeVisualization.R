# Making a nice visualization of my species tree:
install.packages("ape")
install.packages("phangorn")
install.packages("phytools")
install.packages("geiger")
install.packages("ggtree")
install.packages("BiocManager")
library(BiocManager)
BiocManager::install("ggtree")

library(ape)
library(phangorn)
library(phytools)
library(geiger)
library(tidyverse)
library(ggtree)
library(ggrepel)

# Read in the species tree from OrthoFinder:
OrthoFinderSpeciesTree <- read.tree(file = "SpeciesTree_rooted_node_labels.txt")

# Plot the tree:
ggtree(OrthoFinderSpeciesTree, branch.length = "none") + coord_cartesian(clip = 'off') + geom_tiplab(aes(mapping = "Species"), geom = "label", size = 2.5, label.size = 0) +  theme_tree2(plot.margin=margin(6, 120, 6, 6)) + ggtitle("OrthoFinder-inferred Phylogeny of\nStudy Species")
ggsave("OrthoFinderSpeciesTree.jpeg", device = "jpeg", units = "in", width = 3.6, plot = last_plot())
# plot(OrthoFinderSpeciesTree, no.margin=TRUE, edge.width=2)


# Plot the known ant phylogeny:
AntKnownPhylogeny <- read.tree(file = "SpeciesTreeKnown.txt")
  # Try this later for better title alignment: https://stackoverflow.com/questions/52396763/how-do-i-left-align-a-title-with-a-linebreak
ggtree(AntKnownPhylogeny, branch.length = "none") + coord_cartesian(clip = 'off') + geom_tiplab(aes(mapping = "Species"), geom = "label", size = 2.5, label.size = 0, hjust = 1) +  theme_tree2(plot.margin=margin(6, 6, 6, 120)) + scale_x_reverse() + ggtitle("Literature-based\nPhylogeny of\nStudy Species", subtitle = "Used for Hypothesis Testing") 
ggsave("AntKnownPhylogeny.jpeg", device = "jpeg", units = "in", width = 3.62, plot = last_plot())
# plot(AntKnownPhylogenyTree, no.margin=TRUE, edge.width=2, title(main = "Known Relationships between Species"))

