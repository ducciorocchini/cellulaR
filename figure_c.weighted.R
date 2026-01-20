# Load required packages
library(ggplot2)
library(patchwork)   # for combining ggplots
library(cellulaR)

# Run the weighted simulation
weighted_sim <- 
c.weighted(
  num_iterations = 100,
  n_rows = 100,
  n_cols = 100,
  frequency = 0.05,
  octaves = 5,
  base_growth = 0.1,
  death_prob = 0.02,
  init_n = 200,
  alpha_elev = 1,
  alpha_slope = 1,
  neighbor_threshold = 1,
  kernel = "moore",
  plot_n = 9,
  direction=-1,
  return_model = TRUE,
  seed = 42
) 

# Extract individual plots
p1 <- weighted_sim$terrain_plot
p2 <- weighted_sim$slope_plot
p3 <- weighted_sim$probability_plot
p4 <- weighted_sim$forest_evolution
p5 <- weighted_sim$cover_plot

# Combine them using patchwork
# Arrange terrain, slope, and probability on top;
# forest evolution and cover on bottom.
multi_plot <- (p1 | p2 | p3)
multiplot

p4

p5

# Display combined figure
multi_plot

# Optionally, save it to a file
ggsave("weighted_outputs.png", multi_plot, width = 12, height = 8, dpi = 300)
