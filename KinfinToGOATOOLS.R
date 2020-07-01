# Converting Kinfin results to GOATOOLS inputs:
  # Load packages:
  library(tidyverse)

# Import and process the GO term annotation results files:
  GOAnnotationsFull <- read_tsv("./Kinfin/kinfin_results/cluster_domain_annotation.GO.txt")
  # Subset the columns of the GO term annotations results to include only cluster ID, domain source, domain ID, and domain description:
  GOAnnotations <- select(GOAnnotationsFull, '#cluster_id', domain_source, domain_id, domain_description)
  # Now I need a column that says something like "GOTerm1, GOTerm2, GOTerm3,"
  GOAnnotations$ID <- make.unique(GOAnnotations$`#cluster_id`, sep = "_")
  GOAnnotations <- separate(GOAnnotations, ID, into = c(NA, 'number'), sep = "_")
  GOAnnotations <- unite(GOAnnotations, occurence, 'domain_source', 'number', sep = "_", remove = TRUE, na.rm = FALSE)
  # Turn this into wide format:
  GOAnnotationsWide <- unite(GOAnnotations, AnnotationInformation, -'#cluster_id', -'occurence', sep = "_")
  GOAnnotationsWide <- spread(GOAnnotationsWide, 'occurence', 'AnnotationInformation')
  
  
# Read in the phenotype-correlation results:
  
# Any polyandry:
      PhenotypeResultsPolyandry <- read_tsv("./Kinfin/kinfin_results/ANYPOLYANDRY/ANYPOLYANDRY..cluster_metrics.txt")
  # Merge the annotation results and the phenotype-correlation results by orthogroup:
    PhenotypeOrthogroupAnnotations <- merge(PhenotypeResultsPolyandry, GOAnnotationsWide, by.x = '#cluster_id', by.y = '#cluster_id')
  # Create GOATOOLS inputs:
    # For GOATOOLS, we first need to produce a list of all orthogroups and their corresponding GO terms:
      OrthogroupsGOTerms <- read_tsv("./Kinfin/kinfin_results/cluster_domain_annotation.GO.txt")
      OrthogroupsGOTerms <- select(OrthogroupsGOTerms, `#cluster_id`, domain_source, domain_id)
      OrthogroupsGOTerms$ID <- make.unique(OrthogroupsGOTerms$`#cluster_id`, sep = "_")
      OrthogroupsGOTerms <- separate(OrthogroupsGOTerms, ID, into = c(NA, 'number'), sep = "_")
      OrthogroupsGOTerms <- unite(OrthogroupsGOTerms, occurence, 'domain_source', 'number', sep = "_", remove = TRUE, na.rm = FALSE)
      OrthogroupsGOTerms <- spread(OrthogroupsGOTerms, 'occurence', 'domain_id')
      OrthogroupsGOTerms <- unite(OrthogroupsGOTerms, GOTerms, c(GO_1, GO_10, GO_11, GO_12, GO_13, GO_14, GO_15, GO_2, GO_3,       GO_4,  GO_5,  GO_6,  GO_7,  GO_8,  GO_9,  GO_NA, ), sep = ";", na.rm = TRUE, remove = TRUE)
    write_tsv(OrthogroupsGOTerms, path = "./data/KinfinGOATOOLS/associationPolyandry", col_names = FALSE)
    # Next we need a list of focal orthogroup IDs:
    #### I'll want to think here- do I actually want to have just the signficantly enriched/depleted orthogroups when I'm then AGAIN testing for signficance of GO term enrichment? Or do I just want to look at GO term enrichment in all enriched vs. all depleted orthogroups?
    SignficantPhenotypeOrthogroupAnnotations <- filter(PhenotypeOrthogroupAnnotations, PhenotypeOrthogroupAnnotations$`pvalue(TAXON vs. others)` < 0.05)
      FocalOrthogroups <- SignficantPhenotypeOrthogroupAnnotations$`#cluster_id`
      FocalOrthogroups <- as.data.frame(FocalOrthogroups)
      write_tsv(FocalOrthogroups, path = "./data/KinfinGOATOOLS/studyPolyandry", col_names = FALSE)
    # And finally we need a list of all orthogroup IDs:
      BackgroundOrthogroups <- PhenotypeOrthogroupAnnotations
      BackgroundOrthogroups <- BackgroundOrthogroups$`#cluster_id`
      BackgroundOrthogroups <- as.data.frame(BackgroundOrthogroups)
      write_tsv(BackgroundOrthogroups, path = "./data/KinfinGOATOOLS/populationPolyandry", col_names = FALSE)
      

    
    
# Any polygyny
    PhenotypeResultsPolygyny <- read_tsv("./Kinfin/kinfin_results/ANYPOLYGYNY/ANYPOLYGYNY.0.cluster_metrics.txt")
  # Merge the annotation results and the phenotype-correlation results by orthogroup:
    PhenotypeOrthogroupAnnotations <- merge(PhenotypeResultsPolygyny, GOAnnotationsWide, by.x = '#cluster_id', by.y = '#cluster_id')
# Create GOATOOLS inputs:
  # For GOATOOLS, we first need to produce a list of all orthogroups and their corresponding GO terms:
    OrthogroupsGOTerms <- read_tsv("./Kinfin/kinfin_results/cluster_domain_annotation.GO.txt")
    OrthogroupsGOTerms <- select(OrthogroupsGOTerms, `#cluster_id`, domain_source, domain_id)
    OrthogroupsGOTerms$ID <- make.unique(OrthogroupsGOTerms$`#cluster_id`, sep = "_")
    OrthogroupsGOTerms <- separate(OrthogroupsGOTerms, ID, into = c(NA, 'number'), sep = "_")
    OrthogroupsGOTerms <- unite(OrthogroupsGOTerms, occurence, 'domain_source', 'number', sep = "_", remove = TRUE, na.rm = FALSE)
    OrthogroupsGOTerms <- spread(OrthogroupsGOTerms, 'occurence', 'domain_id')
    OrthogroupsGOTerms <- unite(OrthogroupsGOTerms, GOTerms, c(GO_1, GO_10, GO_11, GO_12, GO_13, GO_14, GO_15, GO_2, GO_3,       GO_4,  GO_5,  GO_6,  GO_7,  GO_8,  GO_9,  GO_NA, ), sep = ";", na.rm = TRUE, remove = TRUE)
    write_tsv(OrthogroupsGOTerms, path = "./data/KinfinGOATOOLS/associationPolygyny", col_names = FALSE)
  # Next we need a list of focal orthogroup IDs:
    #### I'll want to think here- do I actually want to have just the signficantly enriched/depleted orthogroups when I'm then AGAIN testing for signficance of GO term enrichment? Or do I just want to look at GO term enrichment in all enriched vs. all depleted orthogroups?
    SignficantPhenotypeOrthogroupAnnotations <- filter(PhenotypeOrthogroupAnnotations, PhenotypeOrthogroupAnnotations$`pvalue(TAXON vs. others)` < 0.05)
    FocalOrthogroups <- SignficantPhenotypeOrthogroupAnnotations$`#cluster_id`
    FocalOrthogroups <- as.data.frame(FocalOrthogroups)
    write_tsv(FocalOrthogroups, path = "./data/KinfinGOATOOLS/studyPolygyny", col_names = FALSE)
  # And finally we need a list of all orthogroup IDs:
    BackgroundOrthogroups <- PhenotypeOrthogroupAnnotations
    BackgroundOrthogroups <- BackgroundOrthogroups$`#cluster_id`
    BackgroundOrthogroups <- as.data.frame(BackgroundOrthogroups)
    write_tsv(BackgroundOrthogroups, path = "./data/KinfinGOATOOLS/populationPolygyny", col_names = FALSE)

    
# Any worker reproduction:
    PhenotypeResultsAnyWorkerReproduction <- read_tsv("./Kinfin/kinfin_results/ANYWORKERREPRODUCTION/ANYWORKERREPRODUCTION..cluster_metrics.txt")
    # Merge the annotation results and the phenotype-correlation results by orthogroup:
    PhenotypeOrthogroupAnnotations <- merge(PhenotypeResultsAnyWorkerReproduction, GOAnnotationsWide, by.x = '#cluster_id', by.y = '#cluster_id')
    # Create GOATOOLS inputs:
    # For GOATOOLS, we first need to produce a list of all orthogroups and their corresponding GO terms:
    OrthogroupsGOTerms <- read_tsv("./Kinfin/kinfin_results/cluster_domain_annotation.GO.txt")
    OrthogroupsGOTerms <- select(OrthogroupsGOTerms, `#cluster_id`, domain_source, domain_id)
    OrthogroupsGOTerms$ID <- make.unique(OrthogroupsGOTerms$`#cluster_id`, sep = "_")
    OrthogroupsGOTerms <- separate(OrthogroupsGOTerms, ID, into = c(NA, 'number'), sep = "_")
    OrthogroupsGOTerms <- unite(OrthogroupsGOTerms, occurence, 'domain_source', 'number', sep = "_", remove = TRUE, na.rm = FALSE)
    OrthogroupsGOTerms <- spread(OrthogroupsGOTerms, 'occurence', 'domain_id')
    OrthogroupsGOTerms <- unite(OrthogroupsGOTerms, GOTerms, c(GO_1, GO_10, GO_11, GO_12, GO_13, GO_14, GO_15, GO_2, GO_3,       GO_4,  GO_5,  GO_6,  GO_7,  GO_8,  GO_9,  GO_NA, ), sep = ";", na.rm = TRUE, remove = TRUE)
    write_tsv(OrthogroupsGOTerms, path = "./data/KinfinGOATOOLS/associationAnyWorkerReproduction", col_names = FALSE)
    # Next we need a list of focal orthogroup IDs:
    #### I'll want to think here- do I actually want to have just the signficantly enriched/depleted orthogroups when I'm then AGAIN testing for signficance of GO term enrichment? Or do I just want to look at GO term enrichment in all enriched vs. all depleted orthogroups?
    SignficantPhenotypeOrthogroupAnnotations <- filter(PhenotypeOrthogroupAnnotations, PhenotypeOrthogroupAnnotations$`pvalue(TAXON vs. others)` < 0.05)
    FocalOrthogroups <- SignficantPhenotypeOrthogroupAnnotations$`#cluster_id`
    FocalOrthogroups <- as.data.frame(FocalOrthogroups)
    write_tsv(FocalOrthogroups, path = "./data/KinfinGOATOOLS/studyAnyWorkerReproduction", col_names = FALSE)
    # And finally we need a list of all orthogroup IDs:
    BackgroundOrthogroups <- PhenotypeOrthogroupAnnotations
    BackgroundOrthogroups <- BackgroundOrthogroups$`#cluster_id`
    BackgroundOrthogroups <- as.data.frame(BackgroundOrthogroups)
    write_tsv(BackgroundOrthogroups, path = "./data/KinfinGOATOOLS/populationAnyWorkerReproduction", col_names = FALSE)
    
    
    
# Queenright worker reproduction:
    PhenotypeResultsQueenrightWorkerReproduction <- read_tsv("./Kinfin/kinfin_results/QUEENRIGHTWORKERREPRODUCTION/QUEENRIGHTWORKERREPRODUCTION.0.cluster_metrics.txt")
    # Merge the annotation results and the phenotype-correlation results by orthogroup:
    PhenotypeOrthogroupAnnotations <- merge(PhenotypeResultsQueenrightWorkerReproduction, GOAnnotationsWide, by.x = '#cluster_id', by.y = '#cluster_id')
    # Create GOATOOLS inputs:
    # For GOATOOLS, we first need to produce a list of all orthogroups and their corresponding GO terms:
    OrthogroupsGOTerms <- read_tsv("./Kinfin/kinfin_results/cluster_domain_annotation.GO.txt")
    OrthogroupsGOTerms <- select(OrthogroupsGOTerms, `#cluster_id`, domain_source, domain_id)
    OrthogroupsGOTerms$ID <- make.unique(OrthogroupsGOTerms$`#cluster_id`, sep = "_")
    OrthogroupsGOTerms <- separate(OrthogroupsGOTerms, ID, into = c(NA, 'number'), sep = "_")
    OrthogroupsGOTerms <- unite(OrthogroupsGOTerms, occurence, 'domain_source', 'number', sep = "_", remove = TRUE, na.rm = FALSE)
    OrthogroupsGOTerms <- spread(OrthogroupsGOTerms, 'occurence', 'domain_id')
    OrthogroupsGOTerms <- unite(OrthogroupsGOTerms, GOTerms, c(GO_1, GO_10, GO_11, GO_12, GO_13, GO_14, GO_15, GO_2, GO_3,       GO_4,  GO_5,  GO_6,  GO_7,  GO_8,  GO_9,  GO_NA, ), sep = ";", na.rm = TRUE, remove = TRUE)
    write_tsv(OrthogroupsGOTerms, path = "./data/KinfinGOATOOLS/associationQueenrightWorkerReproduction", col_names = FALSE)
    # Next we need a list of focal orthogroup IDs:
    #### I'll want to think here- do I actually want to have just the signficantly enriched/depleted orthogroups when I'm then AGAIN testing for signficance of GO term enrichment? Or do I just want to look at GO term enrichment in all enriched vs. all depleted orthogroups?
    SignficantPhenotypeOrthogroupAnnotations <- filter(PhenotypeOrthogroupAnnotations, PhenotypeOrthogroupAnnotations$`pvalue(TAXON vs. others)` < 0.05)
    FocalOrthogroups <- SignficantPhenotypeOrthogroupAnnotations$`#cluster_id`
    FocalOrthogroups <- as.data.frame(FocalOrthogroups)
    write_tsv(FocalOrthogroups, path = "./data/KinfinGOATOOLS/studyQueenrightWorkerReproduction", col_names = FALSE)
    # And finally we need a list of all orthogroup IDs:
    BackgroundOrthogroups <- PhenotypeOrthogroupAnnotations
    BackgroundOrthogroups <- BackgroundOrthogroups$`#cluster_id`
    BackgroundOrthogroups <- as.data.frame(BackgroundOrthogroups)
    write_tsv(BackgroundOrthogroups, path = "./data/KinfinGOATOOLS/populationQueenrightWorkerReproduction", col_names = FALSE)
    
    
    
# Workers dimorphic:
    PhenotypeResultsWorkersDimorphic <- read_tsv("./Kinfin/kinfin_results/WORKERDIMORPHIC/WORKERDIMORPHIC.0.cluster_metrics.txt")
    # Merge the annotation results and the phenotype-correlation results by orthogroup:
    PhenotypeOrthogroupAnnotations <- merge(PhenotypeResultsWorkersDimorphic, GOAnnotationsWide, by.x = '#cluster_id', by.y = '#cluster_id')
    # Create GOATOOLS inputs:
    # For GOATOOLS, we first need to produce a list of all orthogroups and their corresponding GO terms:
    OrthogroupsGOTerms <- read_tsv("./Kinfin/kinfin_results/cluster_domain_annotation.GO.txt")
    OrthogroupsGOTerms <- select(OrthogroupsGOTerms, `#cluster_id`, domain_source, domain_id)
    OrthogroupsGOTerms$ID <- make.unique(OrthogroupsGOTerms$`#cluster_id`, sep = "_")
    OrthogroupsGOTerms <- separate(OrthogroupsGOTerms, ID, into = c(NA, 'number'), sep = "_")
    OrthogroupsGOTerms <- unite(OrthogroupsGOTerms, occurence, 'domain_source', 'number', sep = "_", remove = TRUE, na.rm = FALSE)
    OrthogroupsGOTerms <- spread(OrthogroupsGOTerms, 'occurence', 'domain_id')
    OrthogroupsGOTerms <- unite(OrthogroupsGOTerms, GOTerms, c(GO_1, GO_10, GO_11, GO_12, GO_13, GO_14, GO_15, GO_2, GO_3,       GO_4,  GO_5,  GO_6,  GO_7,  GO_8,  GO_9,  GO_NA, ), sep = ";", na.rm = TRUE, remove = TRUE)
    write_tsv(OrthogroupsGOTerms, path = "./data/KinfinGOATOOLS/associationWorkersDimorphic", col_names = FALSE)
    # Next we need a list of focal orthogroup IDs:
    #### I'll want to think here- do I actually want to have just the signficantly enriched/depleted orthogroups when I'm then AGAIN testing for signficance of GO term enrichment? Or do I just want to look at GO term enrichment in all enriched vs. all depleted orthogroups?
    SignficantPhenotypeOrthogroupAnnotations <- filter(PhenotypeOrthogroupAnnotations, PhenotypeOrthogroupAnnotations$`pvalue(TAXON vs. others)` < 0.05)
    FocalOrthogroups <- SignficantPhenotypeOrthogroupAnnotations$`#cluster_id`
    FocalOrthogroups <- as.data.frame(FocalOrthogroups)
    write_tsv(FocalOrthogroups, path = "./data/KinfinGOATOOLS/studyWorkersDimorphic", col_names = FALSE)
    # And finally we need a list of all orthogroup IDs:
    BackgroundOrthogroups <- PhenotypeOrthogroupAnnotations
    BackgroundOrthogroups <- BackgroundOrthogroups$`#cluster_id`
    BackgroundOrthogroups <- as.data.frame(BackgroundOrthogroups)
    write_tsv(BackgroundOrthogroups, path = "./data/KinfinGOATOOLS/populationWorkersDimorphic", col_names = FALSE)
    
    
    # Workers continuous:
    PhenotypeResultsWorkersContinuous <- read_tsv("./Kinfin/kinfin_results/WORKERSCONTINUOUS/WORKERSCONTINUOUS.0.cluster_metrics.txt")
    # Merge the annotation results and the phenotype-correlation results by orthogroup:
    PhenotypeOrthogroupAnnotations <- merge(PhenotypeResultsWorkersContinuous, GOAnnotationsWide, by.x = '#cluster_id', by.y = '#cluster_id')
    # Create GOATOOLS inputs:
    # For GOATOOLS, we first need to produce a list of all orthogroups and their corresponding GO terms:
    OrthogroupsGOTerms <- read_tsv("./Kinfin/kinfin_results/cluster_domain_annotation.GO.txt")
    OrthogroupsGOTerms <- select(OrthogroupsGOTerms, `#cluster_id`, domain_source, domain_id)
    OrthogroupsGOTerms$ID <- make.unique(OrthogroupsGOTerms$`#cluster_id`, sep = "_")
    OrthogroupsGOTerms <- separate(OrthogroupsGOTerms, ID, into = c(NA, 'number'), sep = "_")
    OrthogroupsGOTerms <- unite(OrthogroupsGOTerms, occurence, 'domain_source', 'number', sep = "_", remove = TRUE, na.rm = FALSE)
    OrthogroupsGOTerms <- spread(OrthogroupsGOTerms, 'occurence', 'domain_id')
    OrthogroupsGOTerms <- unite(OrthogroupsGOTerms, GOTerms, c(GO_1, GO_10, GO_11, GO_12, GO_13, GO_14, GO_15, GO_2, GO_3,       GO_4,  GO_5,  GO_6,  GO_7,  GO_8,  GO_9,  GO_NA, ), sep = ";", na.rm = TRUE, remove = TRUE)
    write_tsv(OrthogroupsGOTerms, path = "./data/KinfinGOATOOLS/associationWorkersContinuous", col_names = FALSE)
    # Next we need a list of focal orthogroup IDs:
    #### I'll want to think here- do I actually want to have just the signficantly enriched/depleted orthogroups when I'm then AGAIN testing for signficance of GO term enrichment? Or do I just want to look at GO term enrichment in all enriched vs. all depleted orthogroups?
    SignficantPhenotypeOrthogroupAnnotations <- filter(PhenotypeOrthogroupAnnotations, PhenotypeOrthogroupAnnotations$`pvalue(TAXON vs. others)` < 0.05)
    FocalOrthogroups <- SignficantPhenotypeOrthogroupAnnotations$`#cluster_id`
    FocalOrthogroups <- as.data.frame(FocalOrthogroups)
    write_tsv(FocalOrthogroups, path = "./data/KinfinGOATOOLS/studyWorkersContinuous", col_names = FALSE)
    # And finally we need a list of all orthogroup IDs:
    BackgroundOrthogroups <- PhenotypeOrthogroupAnnotations
    BackgroundOrthogroups <- BackgroundOrthogroups$`#cluster_id`
    BackgroundOrthogroups <- as.data.frame(BackgroundOrthogroups)
    write_tsv(BackgroundOrthogroups, path = "./data/KinfinGOATOOLS/populationWorkersContinuous", col_names = FALSE)
    
    
    
    # Workers continuous:
    PhenotypeResultsWorkersMonomorphic <- read_tsv("./Kinfin/kinfin_results/WORKERSMONOMORPHIC/WORKERSMONOMORPHIC.0.cluster_metrics.txt")
    # Merge the annotation results and the phenotype-correlation results by orthogroup:
    PhenotypeOrthogroupAnnotations <- merge(PhenotypeResultsWorkersMonomorphic, GOAnnotationsWide, by.x = '#cluster_id', by.y = '#cluster_id')
    # Create GOATOOLS inputs:
    # For GOATOOLS, we first need to produce a list of all orthogroups and their corresponding GO terms:
    OrthogroupsGOTerms <- read_tsv("./Kinfin/kinfin_results/cluster_domain_annotation.GO.txt")
    OrthogroupsGOTerms <- select(OrthogroupsGOTerms, `#cluster_id`, domain_source, domain_id)
    OrthogroupsGOTerms$ID <- make.unique(OrthogroupsGOTerms$`#cluster_id`, sep = "_")
    OrthogroupsGOTerms <- separate(OrthogroupsGOTerms, ID, into = c(NA, 'number'), sep = "_")
    OrthogroupsGOTerms <- unite(OrthogroupsGOTerms, occurence, 'domain_source', 'number', sep = "_", remove = TRUE, na.rm = FALSE)
    OrthogroupsGOTerms <- spread(OrthogroupsGOTerms, 'occurence', 'domain_id')
    OrthogroupsGOTerms <- unite(OrthogroupsGOTerms, GOTerms, c(GO_1, GO_10, GO_11, GO_12, GO_13, GO_14, GO_15, GO_2, GO_3,       GO_4,  GO_5,  GO_6,  GO_7,  GO_8,  GO_9,  GO_NA, ), sep = ";", na.rm = TRUE, remove = TRUE)
    write_tsv(OrthogroupsGOTerms, path = "./data/KinfinGOATOOLS/associationWorkersMonomorphic", col_names = FALSE)
    # Next we need a list of focal orthogroup IDs:
    #### I'll want to think here- do I actually want to have just the signficantly enriched/depleted orthogroups when I'm then AGAIN testing for signficance of GO term enrichment? Or do I just want to look at GO term enrichment in all enriched vs. all depleted orthogroups?
    SignficantPhenotypeOrthogroupAnnotations <- filter(PhenotypeOrthogroupAnnotations, PhenotypeOrthogroupAnnotations$`pvalue(TAXON vs. others)` < 0.05)
    FocalOrthogroups <- SignficantPhenotypeOrthogroupAnnotations$`#cluster_id`
    FocalOrthogroups <- as.data.frame(FocalOrthogroups)
    write_tsv(FocalOrthogroups, path = "./data/KinfinGOATOOLS/studyWorkersMonomorphic", col_names = FALSE)
    # And finally we need a list of all orthogroup IDs:
    BackgroundOrthogroups <- PhenotypeOrthogroupAnnotations
    BackgroundOrthogroups <- BackgroundOrthogroups$`#cluster_id`
    BackgroundOrthogroups <- as.data.frame(BackgroundOrthogroups)
    write_tsv(BackgroundOrthogroups, path = "./data/KinfinGOATOOLS/populationWorkersMonomorphic", col_names = FALSE)

# Now we have GOATOOLS inputs for each phenotype examined. ./data/KinfinGOATOOLS/ can now be zipped and moved to the BioHPC to run GOATOOLS.  