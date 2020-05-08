library(tidyverse)
library(scales)
library(cowplot)

# Read in the Kinfin data:
KinfinResults <- read_csv("PolyandryFormattedResults.csv")
KinfinResults$LogTransformedPValue <- log10(KinfinResults$`mwu_pvalue(TAXON_1 vs. TAXON_2)`)

# Create the reversed, log scale for the y-axis:
reverselog_trans <- function(base = exp(1)) {
  trans <- function(x) -log(x, base)
  inv <- function(x) base^(-x)
  trans_new(paste0("reverselog-", format(base)), trans, inv, 
            log_breaks(base = base), 
            domain = c(1e-100, Inf))
}

# Make the volcano plot for monoandrous vs. polyandrous species:
VolcanoPlot <- ggplot(data = KinfinResults, mapping = aes(x = `log2_mean(TAXON_1/TAXON_2)`, y = `mwu_pvalue(TAXON_1 vs. TAXON_2)`)) + geom_point(size = 1.5, stroke = 0, shape = 16) + scale_y_continuous(trans = reverselog_trans(10), expand = c(0.005, 0.005), labels = waiver()) + geom_hline(yintercept = 0.05, size = 1, colour = "#FF3721", linetype = "dashed") + geom_hline(yintercept = 0.01, size = 1, colour = "#FFA500", linetype = "dashed") + labs(title = "Orthogroup expansion by queen mating frequency", x = "Fold change of orthogroup size in monandrous vs. polyandrous species", y = "p-value associated with differential orthogroup size") +
  theme_cowplot(12)
theme_set(theme_cowplot())
plot(VolcanoPlot)
ggsave("AndryVolcanoPlot.jpeg", device = "jpeg", units = "in", width = 9, plot = last_plot())

# Make a frequency histogram to go over the volcano plot for monoandrous vs. polyandrous species:
FrequencyHistogram <- ggplot(data = KinfinResults, mapping = aes(x = `log2_mean(TAXON_1/TAXON_2)`)) + geom_histogram(binwidth = 0.05) + scale_y_log10()  + labs(title = "Orthogroup expansion by queen mating frequency", x = "Fold change of orthogroup size in monandrous vs. polyandrous species", y = "Count of orthogroups by size change") + geom_vline(xintercept = 0, size =1, linetype = "dashed") + theme_cowplot(12)
theme_set(theme_cowplot())
plot(FrequencyHistogram)
ggsave("AndryFrequencyHistogram.jpeg", device = "jpeg", units = "in", width = 9, plot = last_plot())


# Read in the data comparing polyandrous species to all background species:
PolyandrousVsBackground <- read_csv("PolyandrousVsBackground.csv")

# Make the volcano plot for polyandrous species vs. background:
PBVolcanoPlot <- ggplot(data = PolyandrousVsBackground, mapping = aes(x = `log2_mean(TAXON/others)`, y = `pvalue(TAXON vs. others)`)) + geom_point(size = 1.5, stroke = 0, shape = 16) + scale_y_continuous(trans = reverselog_trans(10), expand = c(0.005, 0.005), labels = waiver()) + geom_hline(yintercept = 0.05, size = 1, colour = "#FF3721", linetype = "dashed") + geom_hline(yintercept = 0.01, size = 1, colour = "#FFA500", linetype = "dashed") + labs(x = "Fold change of orthogroup size in polyandrous species compared to background", y = "p-value associated with differential orthogroup size") +
  theme_cowplot(12)
theme_set(theme_cowplot())
plot(PBVolcanoPlot)
ggsave("PolyandryVolcanoPlot.jpeg", device = "jpeg", units = "in", width = 9, plot = last_plot())

# Make a frequency histogram to go over the volcano plot for polyandrous species vs. background:
PBFrequencyHistogram <- ggplot(data = PolyandrousVsBackground, mapping = aes(x = `log2_mean(TAXON/others)`)) + geom_histogram(binwidth = 0.1) + scale_y_log10()  + labs(title = "Figure 2: Orthogroup expansion in polyandrous species", x = NULL, y = "Count of orthogroups by size change") + geom_vline(xintercept = 0, size =1, linetype = "dashed") + theme_cowplot(12)
theme_set(theme_cowplot())
plot(PBFrequencyHistogram)
ggsave("PolyandryFrequencyHistogram.jpeg", device = "jpeg", units = "in", width = 9, height = 3, plot = last_plot())

# Plot the volcano plot and histogram together:
PBCombined <- plot_grid(PBFrequencyHistogram, PBVolcanoPlot, ncol = 1, rel_heights = c(0.4, 1))
PBCombined
ggsave("PolyandryCombined.jpeg", device = "jpeg", units = "in", width = 7.5, height = 8, plot = last_plot())

# Read in the data comparing worker-reproducing species to all background species:
WorkerReproductionVsBackground <- read_csv("WorkerReproductionVsBackground.csv")

# Make the volcano plot for worker reproducing species vs. background:
WRBVolcanoPlot <- ggplot(data = WorkerReproductionVsBackground, mapping = aes(x = `log2_mean(TAXON/others)`, y = `pvalue(TAXON vs. others)`)) + geom_point(size = 1.5, stroke = 0, shape = 16) + scale_y_continuous(trans = reverselog_trans(10), expand = c(0.005, 0.005), labels = waiver()) + geom_hline(yintercept = 0.05, size = 1, colour = "#FF3721", linetype = "dashed") + geom_hline(yintercept = 0.01, size = 1, colour = "#FFA500", linetype = "dashed") + labs(x = "Fold change of orthogroup size in worker-reproducing species compared to background", y = "p-value associated with differential orthogroup size") +
  theme_cowplot(12)
theme_set(theme_cowplot())
plot(WRBVolcanoPlot)
ggsave("WorkerReproductionVolcanoPlot.jpeg", device = "jpeg", units = "in", width = 9, plot = last_plot())

# Make a frequency histogram to go over the volcano plot for worker-reproducing species vs. background:
WRBFrequencyHistogram <- ggplot(data = WorkerReproductionVsBackground, mapping = aes(x = `log2_mean(TAXON/others)`)) + geom_histogram(binwidth = 0.1) + scale_y_log10()  + labs(title = "Figure 3: Orthogroup expansion in species with worker reproduction", x = NULL, y = "Count of orthogroups by size change") + geom_vline(xintercept = 0, size =1, linetype = "dashed") + theme_cowplot(12)
theme_set(theme_cowplot())
plot(WRBFrequencyHistogram)
ggsave("WorkerReproductionFrequencyHistogram.jpeg", device = "jpeg", units = "in", width = 9, height = 3, plot = last_plot())

WRBCombined <- plot_grid( WRBFrequencyHistogram, WRBVolcanoPlot, ncol = 1, rel_heights = c(0.4, 1))
WRBCombined
ggsave("WorkerReproductionCombined.jpeg", device = "jpeg", units = "in", width = 7.5, height = 8, plot = last_plot())

title <- ggdraw() + draw_label("Orthogroup Expansion in Species with Reproductive Workers", fontface = 'bold', x = 0, hjust = 0) + theme(plot.margin = margin(0, 0, 0, 7))
WRBCombinedTitled <- plot_grid(title, WRBFrequencyHistogram, WRBVolcanoPlot, ncol = 1, rel_heights = c(0.1, 1, 1))

