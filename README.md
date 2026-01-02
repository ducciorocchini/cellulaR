
# Cellular Automata in Ecology using `cellulaR`

This document summarizes three key functions used to model species or vegetation spread on neutral and heterogeneous landscapes.

<p align="center">
  <img 
    src="https://github.com/user-attachments/assets/d6c6b8a4-66b4-4ebc-9c4e-eaf899eea38f"
    alt="cellulaR"
    width="300"
  />
</p>

---

## 1. `c.neutral()`

**Purpose:**  
Simulates vegetation (or species) spread on a **neutral landscape**—all locations are equivalent, and spread occurs via simple local neighborhood rules.

**Key Features:**
- Random initialization of vegetation in a grid
- Growth occurs if at least one neighboring cell is vegetated
- 10% chance for empty cells to become vegetated
- 2% chance of vegetated cells dying (environmental stress)
- Visualizes growth over iterations using `ggplot2` and `patchwork`

**Inputs / Parameters:**
- `num_iterations` (default 50): Number of simulation steps
- `plot_interval` (default 10): Frequency of plots to visualize evolution

**Outputs:**
- Multi-panel plot showing vegetation spread over time

---

## 2. `c.fractal()`

**Purpose:**  
Generates a **fractal landscape** to represent heterogeneous spatial patterns using Perlin noise.

**Key Features:**
- Creates a 100×100 fractal landscape
- Uses multiple octaves to produce realistic variability
- Converts matrix to tidy format for plotting
- Visualizes using `ggplot2` with reversed `viridis` color scale

**Inputs / Parameters:**  
- No explicit parameters in current version (grid size, frequency, and octaves are fixed, but can be modified in the code)

**Outputs:**
- Fractal terrain plot representing elevation or suitability

---

## 3. `c.weighted()`

**Purpose:**  
Simulates vegetation (or species) spread on a **heterogeneous fractal landscape**, where growth probability depends on both elevation and local slope.

**Key Features:**
- Generates a fractal terrain using Perlin noise
- Computes slope (roughness) to adjust growth probability
- Growth probability = `base_growth * (1 - terrain) * (1 - slope)`
- Vegetation spread depends on neighbors and local probability
- Includes vegetation death probability
- Produces multiple visualization layers:
  - Fractal terrain (elevation)
  - Slope (steepness)
  - Growth probability map
  - Vegetation evolution over time
  - Vegetation cover over time (line chart)
  
**Inputs / Parameters:**
- `num_iterations` (default 50): Number of simulation steps
- `plot_interval` (default 10): Frequency of plots
- `n_rows`, `n_cols` (default 100): Grid dimensions
- `frequency`, `octaves`: Controls fractal terrain detail
- `base_growth` (default 0.1): Base growth probability
- `death_prob` (default 0.02): Probability of vegetation dying
- `seed` (optional): For reproducibility

**Outputs:**
- List of plots and data:
  - `terrain_plot`: Fractal terrain
  - `slope_plot`: Terrain slope
  - `probability_plot`: Spatial growth probability
  - `forest_evolution`: Vegetation spread over time (multi-panel)
  - `cover_plot`: Vegetation cover (%) over time
  - `cover_data`: Vegetation cover data frame

---

## Workflow Example

```r
# 1. Neutral spread
neutral_plot <- c.neutral(num_iterations = 50, plot_interval = 10)

# 2. Generate fractal landscape
c.fractal()  # Produces a plot of terrain (fractal heterogeneity)

# 3. Weighted spread on fractal landscape
weighted_results <- c.weighted(
  num_iterations = 50,
  plot_interval = 10,
  n_rows = 100, n_cols = 100,
  frequency = 0.05, octaves = 5,
  base_growth = 0.1, death_prob = 0.02,
  seed = 42
)

# Access outputs
weighted_results$terrain_plot
weighted_results$slope_plot
weighted_results$probability_plot
weighted_results$forest_evolution
weighted_results$cover_plot
weighted_results$cover_data
```

## Notes

* `c.neutral()` represents a **baseline null model** without environmental heterogeneity.
* `c.fractal()` allows exploration of **landscape heterogeneity**.
* `c.weighted()` integrates **terrain and slope** effects into species or vegetation spread, providing realistic ecological simulations.
* The workflow can be adapted for sensitivity analysis by adjusting:

  * Fractal terrain parameters (`frequency`, `octaves`)
  * Growth and death probabilities
  * Grid size and simulation duration

# Dependencies
Install the following packages to properly run `cellulaR` functions:

+ ambient
+ ggplot2
+ patchwork
+ tidyverse
+ viridis


