# This didn't work; even when only using rooted tree, I still get `error in dimnames`. 
# My hypothesis is that the problem is that I have all unrooted trees. So I am going to try to root them, and then try RERconverge again. 
library(ape)
library(RERconverge)

# First, read the trees in as a multiphylo object:
UnrootedTrees <- read.tree(file = "RERInput4610")
RootedTrees <- root.multiPhylo(UnrootedTrees, outgroup = c("dqua"))

UnrootedTrees <- read.tree(file = "Check.txt")
RootedTrees <- root(UnrootedTrees, outgroup = "hsal", resolve.root = TRUE)
UltramericTrees <- force.ultrametric(RootedTrees, method=c("nnls"))
write.tree(RootedTrees, file = "TestRooted", tree.names = TRUE)

