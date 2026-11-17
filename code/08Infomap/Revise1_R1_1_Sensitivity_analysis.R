library(ggplot2)

data_dir <- "HMIModularity/NewHMIModularity/revised1/HMI_Infomap_Result"
output_dir <- file.path("HMIModularity/NewHMIModularity/revised1/")

network_counts <- c(PHP = 87L, PPH = 45L, TemNet = 10L, SpaNet = 9L)
network_labels <- c(PHP = "PHP", PPH = "PPH", TemNet = "TemNet", SpaNet = "SpaNet")
partition_labels <- c(monolayer = "Monolayer partitions",
                      multilayer = "Multilayer partitions")

read_hmi <- function(type, partition, suffix = "") {
  path <- file.path(data_dir, sprintf("HMI_%s_total_%s_Raw%s.csv", partition, type, suffix))
  raw <- read.csv(path, header = FALSE)
  hmi <- raw[[6L]]
  hmi
}

pair_hmi <- function(type, partition) {
  x <- read_hmi(type, partition)
  y <- read_hmi(type, partition, "_Infomap")
  data.frame(NetworkType = type, Partition = partition, NetworkID = seq_along(x),
             Louvain = x, Infomap = y, Difference = y - x,
             Absolute_difference = abs(y - x))
}

summarize_pairs <- function(d) {
  delta <- d$Difference
  distance <- d$Absolute_difference
  x <- d$Louvain
  y <- d$Infomap
  rho <- if (length(unique(x)) > 1L && length(unique(y)) > 1L) {
    cor(x, y, method = "spearman")
  } else {
    NA_real_
  }
  quartiles <- quantile(distance, c(0.25, 0.75), names = FALSE)
  
  data.frame(NetworkType = d$NetworkType[1L], Partition = d$Partition[1L],
             N = nrow(d), Mean_Louvain = mean(x), Mean_Infomap = mean(y),
             Mean_difference = mean(delta),
             Mean_absolute_difference = mean(distance),
             Median_absolute_difference = median(distance),
             Q1_absolute_difference = quartiles[1L],
             Q3_absolute_difference = quartiles[2L],
             Max_absolute_difference = max(distance), Spearman_rho = rho,
             Infomap_lower = sum(delta < 0),
             Equal_at_exported_precision = sum(delta == 0),
             Infomap_higher = sum(delta > 0),
             Louvain_equal_one = sum(x == 1), Infomap_equal_one = sum(y == 1),
             Both_equal_one = sum(x == 1 & y == 1))
}

groups <- do.call(c, lapply(names(partition_labels), function(partition) {
  lapply(names(network_counts), pair_hmi, partition = partition)
}))

DeleteID_PHP <- c(6, 16, 22, 23, 47, 48, 60)
DeleteID_PPH <- c(1, 3, 4, 11, 12, 13, 15, 16, 17, 25, 28, 31, 33, 34, 35, 41, 42, 43)

groups <- lapply(groups, function(df) {
  df %>% 
    filter(
      !(
        (NetworkType == "PHP" & NetworkID %in% DeleteID_PHP) |
          (NetworkType == "PPH" & NetworkID %in% DeleteID_PPH)
      )
    )
})

pairs <- do.call(rbind, groups)
summary_results <- do.call(rbind, lapply(groups, summarize_pairs))

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
write.csv(pairs, file.path(output_dir, "HMI_paired_values.csv"), row.names = FALSE)
write.csv(summary_results, file.path(output_dir, "HMI_sensitivity_summary.csv"),
          row.names = FALSE, na = "NA")

for (partition in names(partition_labels)) {
  d <- pairs[pairs$Partition == partition, ]
  network_counts <- c(PHP = 80L, PPH = 27L, TemNet = 10L, SpaNet = 9L)
  counts <- network_counts[names(network_labels)]
  panel_labels <- sprintf("%s (n = %d)", network_labels, counts)
  d$Network <- factor(network_labels[d$NetworkType],
                      levels = unname(network_labels), labels = panel_labels)
  
  p <- ggplot(d, aes(Louvain, Infomap)) +
    geom_abline(intercept = 0, slope = 1, linetype = "dashed", colour = "grey55") +
    geom_count(colour = "#176F82", alpha = 0.85) +
    scale_size_area(max_size = 8, name = "Networks per point",
                    breaks = c(1, 5, 15, 30, 60)) +
    scale_x_continuous(breaks = seq(0, 1, 0.25)) +
    scale_y_continuous(breaks = seq(0, 1, 0.25)) +
    coord_fixed(xlim = c(-0.06, 1.06), ylim = c(-0.06, 1.06), expand = FALSE) +
    facet_wrap(~ Network, ncol = 2) +
    labs(title = "",
         x = "HMI from generalized Louvain", y = "HMI from Infomap") +
    theme_bw(base_size = 12) +
    theme(panel.grid = element_blank(),
          panel.grid.minor = element_blank(),
          strip.background = element_rect(fill = "white"),
          strip.text = element_text(face = "bold"),
          legend.position = "bottom")
  p
  basename <- file.path(output_dir, paste0("HMI_", partition, "_scatter"))
  ggsave(paste0(basename, ".tif"), p, device="tiff",width = 18, height = 20, bg = "white",units = "cm", dpi = 600, compression="lzw")
}