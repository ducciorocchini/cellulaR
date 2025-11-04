# Load required packages
library(ggplot2)
library(patchwork)   # for combining ggplots
library(cellulaR)

# Run the weighted simulation
weighted_sim <- c.weighted()

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
