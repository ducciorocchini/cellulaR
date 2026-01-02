# Cellular Automata in Ecology using `cellulaR`

`cellulaR` is a lightweight R package to explore **cellular automata** for vegetation/species spread under:

* **Neutral landscapes** (all cells equivalent; null model)
* **Heterogeneous landscapes** generated as **fractal surfaces** (Perlin noise)
* **Environment-weighted spread** where local growth depends on terrain and roughness (slope)

The package currently revolves around three main functions: `c.neutral()`, `c.fractal()`, and `c.weighted()`. ([GitHub][1])

---

## Installation

### From GitHub

```r
# install.packages("remotes")
remotes::install_github("ducciorocchini/cellulaR")
```

### Load the package

```r
library(cellulaR)
```

---

## Dependencies

Install these packages to run all examples and plots:

```r
install.packages(c("ambient", "ggplot2", "patchwork", "tidyverse", "viridis"))
```

These are the packages used by the functions for landscape generation and visualization. ([GitHub][1])

---

## Quick start

A minimal workflow:

```r
# 1) Neutral spread (null model)
neutral_plot <- c.neutral(num_iterations = 50, plot_interval = 10)
neutral_plot

# 2) Visualize a fractal landscape (heterogeneity)
c.fractal()

# 3) Spread on a heterogeneous (fractal) landscape
res <- c.weighted(seed = 42)
res$forest_evolution
res$cover_plot
```

This matches the intended workflow described in the repo. ([GitHub][1])

---

## 1. `c.neutral()`

### Purpose

Simulate vegetation (or a generic “occupied/unoccupied” state) spreading on a **neutral landscape**, where all locations are equivalent and dynamics depend only on local neighborhood rules. ([GitHub][1])

### Core idea

* Start from a random grid of occupied/unoccupied cells
* At each iteration:

  * empty cells may become occupied if at least one neighbor is occupied (plus a small random colonization chance)
  * occupied cells may die with a small probability (stress/disturbance)

### Arguments

* `num_iterations` *(default 50)*: number of simulation steps. ([GitHub][1])
* `plot_interval` *(default 10)*: how often the state is plotted through time. ([GitHub][1])

### Returns

* A **multi-panel plot** showing spread through time. ([GitHub][1])

### Example

```r
p <- c.neutral(num_iterations = 80, plot_interval = 10)
p
```

### When to use

Use `c.neutral()` as a **baseline/null expectation** for spread dynamics without environmental heterogeneity. ([GitHub][1])

---

## 2. `c.fractal()`

### Purpose

Generate a **fractal landscape** (heterogeneous surface) to represent spatial variability (e.g., habitat suitability or “elevation-like” gradients) using Perlin noise. ([GitHub][1])

### What it does

* Creates a fractal terrain (in the current version, key parameters are fixed in the function implementation)
* Converts it into a tidy format
* Plots it with `ggplot2` (viridis scale)

### Arguments

* No user-facing parameters in the current version. ([GitHub][1])
  *(Grid size, frequency, and octaves are set internally—edit the function code if you want them configurable.)* ([GitHub][1])

### Returns

* A terrain (fractal) plot. ([GitHub][1])

### Example

```r
c.fractal()
```

### When to use

Use `c.fractal()` to **visualize and reason about landscape heterogeneity** before running a spread process on it. ([GitHub][1])

---

## 3. `c.weighted()`

### Purpose

Simulate spread on a **heterogeneous fractal landscape**, where growth probability varies spatially according to:

* terrain value (e.g., “elevation/suitability”)
* local roughness (slope)

This introduces environmental control over spread, beyond pure neighbor effects. ([GitHub][1])

### Conceptual model (as implemented)

* Generate terrain via Perlin noise
* Compute slope (roughness) and reduce growth on steep/rough areas
* Growth probability follows the rule described in the repo (base growth scaled by terrain and slope) ([GitHub][1])
* Iteratively update occupied/unoccupied state with:

  * neighbor-driven colonization, weighted by local probability
  * stochastic mortality

### Arguments

* `num_iterations` *(default 50)*: number of simulation steps. ([GitHub][1])
* `plot_interval` *(default 10)*: how often to plot intermediate states. ([GitHub][1])
* `n_rows`, `n_cols` *(default 100)*: grid dimensions. ([GitHub][1])
* `frequency`, `octaves`: fractal terrain detail controls. ([GitHub][1])
* `base_growth` *(default 0.1)*: baseline colonization probability. ([GitHub][1])
* `death_prob` *(default 0.02)*: mortality probability. ([GitHub][1])
* `seed` *(optional)*: reproducibility control. ([GitHub][1])

### Returns

A list of plots and data objects, including: ([GitHub][1])

* `terrain_plot`: the fractal terrain
* `slope_plot`: slope/roughness
* `probability_plot`: spatial growth probability surface
* `forest_evolution`: multi-panel spread over time
* `cover_plot`: vegetation cover (%) through time
* `cover_data`: cover values as a data frame

### Example

```r
res <- c.weighted(
  num_iterations = 60,
  plot_interval = 10,
  n_rows = 100, n_cols = 100,
  frequency = 0.05, octaves = 5,
  base_growth = 0.12,
  death_prob = 0.02,
  seed = 123
)

# Explore outputs
res$terrain_plot
res$slope_plot
res$probability_plot
res$forest_evolution
res$cover_plot
head(res$cover_data)
```

### Tips for parameter exploration

* Increase `base_growth` to accelerate spread (but it may saturate quickly).
* Increase `death_prob` to keep dynamics from saturating and to mimic disturbance regimes.
* Tune `frequency` / `octaves` to change the patchiness of the underlying terrain. ([GitHub][1])

---

## Suggested analysis patterns

### Sensitivity analysis

You can explore how outcomes change across parameter grids:

```r
grid <- expand.grid(
  base_growth = c(0.05, 0.10, 0.15),
  death_prob  = c(0.01, 0.02, 0.05),
  frequency   = c(0.03, 0.05),
  octaves     = c(4, 5)
)

out <- lapply(seq_len(nrow(grid)), function(i){
  g <- grid[i, ]
  res <- c.weighted(
    base_growth = g$base_growth,
    death_prob  = g$death_prob,
    frequency   = g$frequency,
    octaves     = g$octaves,
    seed = 1
  )
  data.frame(g, final_cover = tail(res$cover_data$cover, 1))
})

out <- do.call(rbind, out)
out
```
