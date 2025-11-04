Here’s a clear **Markdown summary** of the three functions and their workflow for your ecological cellular automata scenario:

````markdown
# Cellular Automata in Ecology using `cellulaR`

This document summarizes three key functions used to model species or vegetation spread on neutral and heterogeneous landscapes.

---

## 1. `c.neutral.R`

**Purpose:**  
Simulates the spread of a variable (e.g., forest cover) on a neutral landscape with no spatial heterogeneity.

**Typical Parameters:**
- `grid_size`: dimensions of the landscape (rows × columns)
- `initial_seeds`: starting locations of the variable
- `timesteps`: number of iterations for the spread
- `spread_rule`: probability or neighbourhood for propagation

**Output:**  
Matrix or raster representing the neutral spread pattern.

---

## 2. `c.fractal.R`

**Purpose:**  
Generates a fractal landscape to represent spatial heterogeneity (e.g., patchiness, suitability).

**Typical Parameters:**
- `grid_size`: landscape dimensions
- `fractal_dimension`: controls patchiness/heterogeneity
- `value_range`: minimum and maximum suitability values
- `variance` (optional): controls roughness of the landscape

**Output:**  
Matrix/raster of heterogeneity values to use as a weighted surface.

---

## 3. `c.weighted.R`

**Purpose:**  
Simulates spread of a species or variable on a **weighted landscape** using the fractal surface from `c.fractal.R`.

**Typical Parameters:**
- `fractal_surface`: input matrix from `c.fractal.R`
- `initial_seeds`: starting locations of the variable
- `spread_rule`: neighbourhood definition for propagation
- `weighting_function`: how heterogeneity influences spread probability
- `timesteps`: number of iterations

**Output:**  
Matrix/time series showing spread over the heterogeneous landscape.

---

## Workflow Example

1. **Neutral baseline:**  
```r
neutral_land <- c.neutral.R(grid_size = c(50, 50), initial_seeds = 10, timesteps = 20)
````

2. **Create heterogeneous surface:**

```r
fractal_surface <- c.fractal.R(grid_size = c(50, 50), fractal_dimension = 1.5)
```

3. **Weighted spread on fractal landscape:**

```r
weighted_spread <- c.weighted.R(fractal_surface = fractal_surface,
                                initial_seeds = 10,
                                timesteps = 20)
```

4. **Compare results:**

* Neutral vs weighted spread patterns
* Sensitivity analysis by varying fractal dimension or weighting

---

**Notes:**

* `c.neutral.R` represents a null model of spread.
* `c.fractal.R` allows exploration of landscape heterogeneity effects.
* `c.weighted.R` integrates landscape structure into ecological spread simulations.

```

---

If you want, I can also **enhance this Markdown** with **figures/diagrams** showing neutral vs fractal landscapes and weighted spread patterns for a fully illustrated workflow. This would make it much easier to present in reports or publications. Do you want me to do that?
```
