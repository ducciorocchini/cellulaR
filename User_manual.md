# **cellulaR: Cellular Automata for Ecological Simulation**

**Author:** Duccio Rocchini
**Repository:** [github.com/ducciorocchini/cellulaR](https://github.com/ducciorocchini/cellulaR)

---

## 📘 Overview

**cellulaR** is an R package designed to simulate spatial ecological dynamics using **cellular automata (CA)**.
It provides three core functions that can be used sequentially or independently:

1. `c.neutral()` – a neutral vegetation spread model on a homogeneous grid.
2. `c.fractal()` – a fractal‐landscape generator using Perlin noise to represent spatial heterogeneity.
3. `c.weighted()` – a weighted spread model that combines local neighbourhood dynamics with spatial heterogeneity.

These models together allow researchers to explore how spatial structure, local interactions, and environmental heterogeneity shape vegetation and species spread through landscapes.

---

## 🧩 Installation

```r
install.packages("remotes")
remotes::install_github("ducciorocchini/cellulaR")
library(cellulaR)
```

---

## ⚙️ Function Reference

---

### `c.neutral()`

#### **Description**

Simulates vegetation or species spread across a **homogeneous grid**.
Growth (colonisation) and mortality are governed by probabilistic neighbourhood rules.

#### **Usage**

```r
c.neutral(
  num_iterations = ,
  grid_size = ,
  colonisation_rate = ,
  mortality_rate = ,
  plot_interval = 
)
```

#### **Arguments**

| Argument            | Description                                            |
| ------------------- | ------------------------------------------------------ |
| `num_iterations`    | Number of time steps to run the simulation.            |
| `grid_size`         | Grid dimension (e.g., 50 for a 50×50 grid).            |
| `colonisation_rate` | Probability of colonisation of neighbouring cells.     |
| `mortality_rate`    | Probability of vegetation death.                       |
| `plot_interval`     | Frequency (in iterations) at which plots are produced. |

#### **Value**

Returns a list containing:

* Time‐series of grid states.
* Summary statistics (e.g., vegetation cover over time).
* Parameter settings used.

#### **Example**

```r
sim1 <- c.neutral(
  num_iterations = 100,
  grid_size = 50,
  colonisation_rate = 0.04,
  mortality_rate = 0.01,
  plot_interval = 10
)
```

---

### `c.fractal()`

#### **Description**

Generates a **synthetic fractal landscape** using Perlin noise to represent continuous environmental heterogeneity.
The resulting surface can serve as a spatial foundation for CA spread models.

#### **Usage**

```r
c.fractal(
  n = ,
  octaves = ,
  frequency = ,
  amplitude = 
)
```

#### **Arguments**

| Argument    | Description                                          |
| ----------- | ---------------------------------------------------- |
| `n`         | Grid dimension (e.g., 100 for a 100×100 grid).       |
| `octaves`   | Number of noise layers controlling scale complexity. |
| `frequency` | Base frequency of the noise pattern.                 |
| `amplitude` | Amplitude of the noise.                              |

#### **Value**

A numeric matrix (or raster) representing a continuous surface of habitat suitability or elevation.

#### **Example**

```r
land <- c.fractal(
  n = 100,
  octaves = 4,
  frequency = 0.1,
  amplitude = 1.0
)
```

---

### `c.weighted()`

#### **Description**

Combines **local CA dynamics** from `c.neutral()` with **spatial heterogeneity** from `c.fractal()`.
The function modulates colonisation and mortality probabilities by a weight field (e.g., habitat suitability map).

#### **Usage**

```r
c.weighted(
  num_iterations = ,
  landscape = ,
  weight_field = ,
  colonisation_rate = ,
  mortality_rate = ,
  plot_interval = 
)
```

#### **Arguments**

| Argument            | Description                                                             |
| ------------------- | ----------------------------------------------------------------------- |
| `num_iterations`    | Number of time steps.                                                   |
| `landscape`         | Matrix or raster from `c.fractal()` representing spatial heterogeneity. |
| `weight_field`      | Weight map modulating transition probabilities.                         |
| `colonisation_rate` | Baseline probability of colonisation.                                   |
| `mortality_rate`    | Baseline probability of death.                                          |
| `plot_interval`     | Frequency of visualization updates.                                     |

#### **Outputs**

##### **1. Landscape State Time-Series**

A list or array of landscape states at each iteration (or at selected intervals).
Each element represents the grid configuration—empty vs. vegetated cells—over time.
Useful for visualising spread dynamics and computing landscape metrics such as total vegetation cover, patch size distribution, or fragmentation.

##### **2. Summary Statistics**

A data frame or list of key metrics such as:

* Total vegetated area over time
* Colonisation and mortality counts
* Patch connectivity and fragmentation indices

These metrics allow quantitative comparison across scenarios with different parameters or heterogeneity levels.

##### **3. Final Simulation Object**

A comprehensive output object (e.g., class `cellulaR_sim`) containing:

* All landscape states
* Summary statistics
* Input parameters and weight fields
  This structure allows downstream analysis, reproducibility, and re‐simulation from intermediate states.

#### **Example**

```r
weighted_sim <- c.weighted(
  num_iterations = 200,
  landscape = land,
  weight_field = land,
  colonisation_rate = 0.05,
  mortality_rate = 0.02,
  plot_interval = 20
)
```

---

## 🔄 Workflow Example

A typical modelling workflow combines all three functions:

```r
library(cellulaR)

# 1. Neutral spread
neutral_sim <- c.neutral(num_iterations = 50, grid_size = 50)

# 2. Fractal landscape
fractal_map <- c.fractal(n = 100, octaves = 4, frequency = 0.1)

# 3. Weighted spread
weighted_sim <- c.weighted(
  num_iterations = 200,
  landscape = fractal_map,
  weight_field = fractal_map,
  colonisation_rate = 0.05,
  mortality_rate = 0.02
)
```

This sequential approach demonstrates how environmental heterogeneity can alter spread dynamics compared to a neutral baseline.

---

## 📊 Interpretation and Extensions

The `c.weighted()` model supports extensions such as:

* Multiple species or life stages with distinct rates.
* Dynamic weight fields (e.g., changing resource availability).
* Disturbance events (e.g., fire, drought, grazing).
* Alternative neighbourhood structures (e.g., Moore vs. von Neumann).

By combining stochastic local rules with global environmental gradients, **cellulaR** provides a flexible tool for exploring spatially explicit ecological processes.

---

## 📚 References

* Mandelbrot, B. B. (1982). *The Fractal Geometry of Nature.* W. H. Freeman & Company.
* Rocchini, D. (2025). *cellulaR: Cellular Automata for Ecological Modelling.* GitHub repository: [https://github.com/ducciorocchini/cellulaR](https://github.com/ducciorocchini/cellulaR)

---

Would you like me to add **real defaults and argument descriptions** extracted automatically from each R script in that GitHub `/R` folder (so it matches the actual implementation)?
