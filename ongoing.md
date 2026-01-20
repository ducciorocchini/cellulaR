# Parameters in c.fractal() and c.weighted()

## 1) `c.fractal()` → ongoing new parameters

### What I will add

* `palette` and `direction` (control visual appearance)
* `title` (custom plot title)
* `seed` (reproducibility)
* `transform` (log / sqrt / none to modify contrast)
* `rescale` (always rescale values to `[0,1]`)

### Updated version (dot-style function name)

```r
#' Create a fractal landscape using Perlin noise
#'
#' @param n Integer vector length 2. (rows, cols).
#' @param frequency Numeric. Passed to [ambient::noise_perlin()].
#' @param octaves Integer. Passed to [ambient::noise_perlin()].
#' @param seed Integer or NULL. Reproducible seed.
#' @param transform Character. One of "none", "sqrt", "log1p".
#' @param rescale Logical. If TRUE, rescale values to [0,1].
#' @param output Character. "plot" or "matrix".
#' @param palette Character. Viridis palette option (e.g., "D", "C", "A").
#' @param direction Integer. 1 or -1. Color direction for viridis.
#' @param title Character. Plot title.
#'
#' @return A `ggplot2` object (output = "plot") or a numeric matrix.
#' @export
c.fractal <- function(
  n = c(100L, 100L),
  frequency = 0.05,
  octaves = 5L,
  seed = NULL,
  transform = c("none", "sqrt", "log1p"),
  rescale = TRUE,
  output = c("plot", "matrix"),
  palette = "D",
  direction = -1L,
  title = "Fractal Landscape via Perlin Noise"
) {
  output <- match.arg(output)
  transform <- match.arg(transform)
  if (!is.null(seed)) set.seed(seed)

  terrain <- ambient::noise_perlin(n, frequency = frequency, octaves = octaves)

  if (transform == "sqrt") terrain <- sqrt(pmax(terrain, 0))
  if (transform == "log1p") terrain <- log1p(terrain - min(terrain))

  if (isTRUE(rescale)) {
    rng <- range(terrain, na.rm = TRUE)
    if (diff(rng) > 0) terrain <- (terrain - rng[1]) / diff(rng)
  }

  if (output == "matrix") return(terrain)

  df <- data.frame(
    y = rep(seq_len(nrow(terrain)), times = ncol(terrain)),
    x = rep(seq_len(ncol(terrain)), each  = nrow(terrain)),
    value = as.vector(terrain)
  )

  ggplot2::ggplot(df, ggplot2::aes(x = x, y = y, fill = value)) +
    ggplot2::geom_raster() +
    viridis::scale_fill_viridis(option = palette, direction = direction) +
    ggplot2::coord_equal() +
    ggplot2::labs(title = title, x = NULL, y = NULL, fill = "Height") +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank()
    )
}
```

---

## 2) `c.weighted()` → new ongoing parameters

Here the model can be made genuinely **tunable** by introducing ecological and topographic parameters.

### What I will add

* `alpha_elev` and `alpha_slope`: relative importance of elevation and slope in growth
* `neighbor_threshold`: number of vegetated neighbors required for colonization (1–8)
* `kernel`: 4-neighborhood vs 8-neighborhood (von Neumann vs Moore)
* `plot_n`: number of snapshots to display (instead of always 9)
* `return_grid`: optionally return the final grid (useful for analysis)

### Modification

Below is an updated version consistent with your existing code, **with the new arguments included**.

```r
#' Weighted spread across slopes (terrain-weighted cellular automaton)
#'
#' Simulates a vegetation cellular automaton on a fractal terrain generated
#' via Perlin noise. Colonization probability depends on local elevation and
#' slope (lower + flatter areas have higher growth probability), and can be
#' tuned via exponents and neighborhood rules.
#'
#' The function returns diagnostic maps (terrain, slope, growth probability),
#' a multi-panel plot of vegetation dynamics, a time series of vegetation cover,
#' and (optionally) a full model object including terrain/slope/probability and
#' the final vegetation grid.
#'
#' @param num_iterations Integer. Number of iterations to run the simulation.
#'   Default is `100`.
#' @param n_rows Integer. Number of grid rows. Default is `100`.
#' @param n_cols Integer. Number of grid columns. Default is `100`.
#' @param frequency Numeric. Frequency passed to [ambient::noise_perlin()].
#'   Default is `0.05`.
#' @param octaves Integer. Octaves passed to [ambient::noise_perlin()].
#'   Default is `5`.
#' @param base_growth Numeric in `[0,1]`. Baseline growth rate scaling the
#'   spatial growth probability map. Default is `0.1`.
#' @param death_prob Numeric in `[0,1]`. Probability of death per vegetated cell
#'   per iteration. Default is `0.02`.
#' @param init_n Integer. Number of initially vegetated cells. Default is `200`.
#' @param alpha_elev Numeric. Exponent controlling how strongly elevation
#'   downweights growth: `(1 - terrain)^alpha_elev`. Default is `1`.
#' @param alpha_slope Numeric. Exponent controlling how strongly slope
#'   downweights growth: `(1 - slope)^alpha_slope`. Default is `1`.
#' @param neighbor_threshold Integer. Minimum number of vegetated neighbors
#'   required for colonization. Default is `1`.
#' @param kernel Character. Neighborhood definition: `"moore"` (8 neighbors) or
#'   `"von_neumann"` (4 neighbors). Default is `"moore"`.
#' @param plot_n Integer. Number of snapshots displayed in the evolution plot.
#'   Default is `9`.
#' @param direction Integer. Color direction for the viridis palette: `1` maps
#'   high values to yellow and low values to violet, while `-1` reverses this.
#'   Default is `1`.
#' @param return_model Logical. If `TRUE`, returns a `model` element containing
#'   terrain, slope, growth probability, and the final vegetation grid.
#'   Default is `TRUE`.
#' @param seed Integer or `NULL`. If not `NULL`, sets a reproducible random seed.
#'   Default is `NULL`.
#'
#' @return A named list with:
#' \describe{
#'   \item{terrain_plot}{A `ggplot2` raster plot of terrain elevation.}
#'   \item{slope_plot}{A `ggplot2` raster plot of terrain slope.}
#'   \item{probability_plot}{A `ggplot2` raster plot of growth probability.}
#'   \item{forest_evolution}{A `patchwork` multi-panel plot of vegetation through time.}
#'   \item{cover_plot}{A `ggplot2` line plot of vegetation cover (%) over time.}
#'   \item{cover_data}{A `data.frame` with iteration and vegetation cover (%).}
#'   \item{model}{(Optional) A list with `terrain`, `slope`, `growth_prob_map`,
#'                and `final_grid` if `return_model = TRUE`.}
#' }
#' @export
#'
#' @examples
#' \dontrun{
#' res <- c.weighted(
#'   num_iterations = 50, n_rows = 50, n_cols = 50,
#'   alpha_slope = 2, neighbor_threshold = 2,
#'   kernel = "moore", direction = 1, seed = 1
#' )
#' res$forest_evolution
#' res$cover_plot
#' str(res$model)
#' }
c.weighted <- function(
  num_iterations = 100L,
  n_rows = 100L,
  n_cols = 100L,
  frequency = 0.05,
  octaves = 5L,
  base_growth = 0.1,
  death_prob = 0.02,
  init_n = 200L,
  alpha_elev = 1,
  alpha_slope = 1,
  neighbor_threshold = 1L,
  kernel = c("moore", "von_neumann"),
  plot_n = 9L,
  direction = 1L,
  return_model = TRUE,
  seed = NULL
) {
  # ---- checks ----
  stopifnot(length(num_iterations) == 1, num_iterations >= 0)
  stopifnot(length(n_rows) == 1, n_rows >= 1)
  stopifnot(length(n_cols) == 1, n_cols >= 1)
  stopifnot(base_growth >= 0, base_growth <= 1)
  stopifnot(death_prob  >= 0, death_prob  <= 1)
  stopifnot(init_n >= 0, init_n <= n_rows * n_cols)
  stopifnot(alpha_elev >= 0)
  stopifnot(alpha_slope >= 0)
  stopifnot(neighbor_threshold >= 0)
  stopifnot(plot_n >= 2)
  stopifnot(direction %in% c(-1L, 1L))

  kernel <- match.arg(kernel)
  if (!is.null(seed)) set.seed(seed)

  # ---- 1) terrain ----
  terrain <- ambient::noise_perlin(c(n_rows, n_cols), frequency = frequency, octaves = octaves)
  terrain <- (terrain - min(terrain)) / (max(terrain) - min(terrain))  # normalize [0,1]

  # ---- 2) slope (finite differences) ----
  get_slope <- function(mat) {
    slope <- matrix(0, nrow = nrow(mat), ncol = ncol(mat))
    if (nrow(mat) < 3 || ncol(mat) < 3) return(slope)

    for (i in 2:(nrow(mat) - 1)) {
      for (j in 2:(ncol(mat) - 1)) {
        dx <- (mat[i, j + 1] - mat[i, j - 1]) / 2
        dy <- (mat[i + 1, j] - mat[i - 1, j]) / 2
        slope[i, j] <- sqrt(dx^2 + dy^2)
      }
    }

    if (max(slope) > min(slope)) {
      slope <- (slope - min(slope)) / (max(slope) - min(slope))
    }
    slope
  }
  slope <- get_slope(terrain)

  # ---- 3) growth probability map (tunable) ----
  growth_prob_map <- base_growth * (1 - terrain)^alpha_elev * (1 - slope)^alpha_slope
  growth_prob_map[growth_prob_map < 0] <- 0
  growth_prob_map[growth_prob_map > 1] <- 1

  # ---- 4) init grid ----
  grid <- matrix(0L, nrow = n_rows, ncol = n_cols)
  if (init_n > 0) grid[sample.int(n_rows * n_cols, size = init_n)] <- 1L

  # ---- 5) neighborhood + update rules ----
  get_neighbors <- function(row, col, grid) {
    vals <- integer(0)
    for (i in -1:1) for (j in -1:1) {
      if (i == 0 && j == 0) next

      # von Neumann: only N/S/E/W
      if (kernel == "von_neumann" && (abs(i) + abs(j) != 1)) next

      rr <- row + i
      cc <- col + j
      if (rr >= 1 && rr <= nrow(grid) && cc >= 1 && cc <= ncol(grid)) {
        vals <- c(vals, grid[rr, cc])
      }
    }
    vals
  }

  update_grid <- function(grid, prob_map) {
    new_grid <- grid
    for (row in seq_len(nrow(grid))) {
      for (col in seq_len(ncol(grid))) {

        if (grid[row, col] == 0L) {
          nb <- get_neighbors(row, col, grid)
          if (sum(nb) >= neighbor_threshold && stats::runif(1) < prob_map[row, col]) {
            new_grid[row, col] <- 1L
          }
        } else {
          if (stats::runif(1) < death_prob) {
            new_grid[row, col] <- 0L
          }
        }

      }
    }
    new_grid
  }

  # ---- 6) plot helpers ----
  plot_raster <- function(mat, title, legend_label) {
    df <- expand.grid(x = seq_len(ncol(mat)), y = seq_len(nrow(mat)))
    df$value <- as.vector(mat)

    ggplot2::ggplot(df, ggplot2::aes(x = x, y = y, fill = value)) +
      ggplot2::geom_raster() +
      viridis::scale_fill_viridis(option = "C", direction = direction) +
      ggplot2::labs(title = title, fill = legend_label) +
      ggplot2::coord_equal() +
      ggplot2::theme_minimal() +
      ggplot2::theme(
        axis.text = ggplot2::element_blank(),
        axis.ticks = ggplot2::element_blank(),
        panel.grid = ggplot2::element_blank(),
        plot.title = ggplot2::element_text(hjust = 0.5)
      )
  }

  plot_grid <- function(grid, prob_map, title = "") {
    df <- expand.grid(x = seq_len(ncol(grid)), y = seq_len(nrow(grid)))
    df$value <- as.vector(grid)
    df$prob  <- as.vector(prob_map)

    ggplot2::ggplot(df, ggplot2::aes(x = x, y = y)) +
      ggplot2::geom_raster(ggplot2::aes(fill = ifelse(value == 1, prob, NA_real_))) +
      viridis::scale_fill_viridis(option = "C", na.value = "white", direction = direction) +
      ggplot2::labs(title = title, fill = "Prob.") +
      ggplot2::coord_equal() +
      ggplot2::theme_minimal() +
      ggplot2::theme(
        axis.text = ggplot2::element_blank(),
        axis.ticks = ggplot2::element_blank(),
        panel.grid = ggplot2::element_blank(),
        plot.title = ggplot2::element_text(hjust = 0.5, size = 8),
        legend.title = ggplot2::element_text(size = 8),
        legend.text  = ggplot2::element_text(size = 6),
        legend.key.size = grid::unit(0.4, "cm")
      )
  }

  # ---- 7) run simulation + snapshots ----
  plots <- list()
  cover <- numeric(num_iterations + 1L)
  cover[1] <- sum(grid) / (n_rows * n_cols)

  plot_iterations <- unique(round(seq(0, num_iterations, length.out = plot_n)))

  for (i in 0:num_iterations) {
    if (i > 0) {
      grid <- update_grid(grid, growth_prob_map)
      cover[i + 1L] <- sum(grid) / (n_rows * n_cols)
    }
    if (i %in% plot_iterations) {
      plots[[length(plots) + 1L]] <- plot_grid(grid, growth_prob_map, paste("Iteration", i))
    }
  }

  forest_evolution <- patchwork::wrap_plots(plots, ncol = 3)

  # ---- 8) cover time series ----
  cover_df <- data.frame(
    iteration = 0:num_iterations,
    vegetation_cover = cover * 100
  )

  cover_plot <- ggplot2::ggplot(cover_df, ggplot2::aes(x = iteration, y = vegetation_cover)) +
    ggplot2::geom_line(color = "forestgreen", linewidth = 1.2) +
    ggplot2::geom_point(color = "darkgreen") +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      title = "Vegetation Cover Over Time",
      x = "Iteration",
      y = "Vegetation Cover (%)"
    ) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

  # ---- 9) diagnostic maps ----
  terrain_plot <- plot_raster(terrain, "Fractal Terrain (Elevation)", "Elevation")
  slope_plot   <- plot_raster(slope, "Slope (Steepness)", "Slope")
  prob_plot    <- plot_raster(growth_prob_map, "Probability of Vegetation Growth", "Growth Probability")

  # ---- 10) return ----
  out <- list(
    terrain_plot = terrain_plot,
    slope_plot = slope_plot,
    probability_plot = prob_plot,
    forest_evolution = forest_evolution,
    cover_plot = cover_plot,
    cover_data = cover_df
  )

  if (isTRUE(return_model)) {
    out$model <- list(
      terrain = terrain,
      slope = slope,
      growth_prob_map = growth_prob_map,
      final_grid = grid
    )
  }

  out
}
```


