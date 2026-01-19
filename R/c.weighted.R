#' Weighted spread across slopes (terrain-weighted cellular automaton)
#'
#' Simulates a simple vegetation cellular automaton on a fractal terrain
#' generated via Perlin noise. The probability of colonization depends on
#' local elevation and slope (lower + flatter areas have higher growth
#' probability).
#'
#' The function returns diagnostic maps (terrain, slope, growth probability),
#' a multi-panel plot of vegetation dynamics, and a time series of vegetation
#' cover.
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
#' }
#' @export
#'
#' @examples
#' # Run the simulation (may take a bit depending on grid size)
#' res <- c_weighted(num_iterations = 50, n_rows = 50, n_cols = 50, seed = 1)
#' res$forest_evolution
#' res$cover_plot
c_weighted <- function(
  num_iterations = 100L,
  n_rows = 100L,
  n_cols = 100L,
  frequency = 0.05,
  octaves = 5L,
  base_growth = 0.1,
  death_prob = 0.02,
  init_n = 200L,
  seed = NULL
) {
  # Basic checks
  stopifnot(length(num_iterations) == 1, num_iterations >= 0)
  stopifnot(length(n_rows) == 1, n_rows >= 1)
  stopifnot(length(n_cols) == 1, n_cols >= 1)
  stopifnot(base_growth >= 0, base_growth <= 1)
  stopifnot(death_prob  >= 0, death_prob  <= 1)
  stopifnot(init_n >= 0, init_n <= n_rows * n_cols)

  if (!is.null(seed)) set.seed(seed)

  # --- 1. Generate fractal terrain ---
  terrain <- ambient::noise_perlin(c(n_rows, n_cols), frequency = frequency, octaves = octaves)
  terrain <- (terrain - min(terrain)) / (max(terrain) - min(terrain))  # normalize [0,1]

  # --- 2. Compute slope (simple finite differences) ---
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

  # --- 3. Spatial growth probability map ---
  growth_prob_map <- base_growth * (1 - terrain) * (1 - slope)

  # --- 4. Initialize vegetation grid ---
  grid <- matrix(0L, nrow = n_rows, ncol = n_cols)
  if (init_n > 0) {
    grid[sample.int(n_rows * n_cols, size = init_n)] <- 1L
  }

  # --- 5. Neighborhood + update rules ---
  get_neighbors <- function(row, col, grid) {
    vals <- integer(0)
    for (i in -1:1) {
      for (j in -1:1) {
        if (!(i == 0 && j == 0)) {
          rr <- row + i
          cc <- col + j
          if (rr >= 1 && rr <= nrow(grid) && cc >= 1 && cc <= ncol(grid)) {
            vals <- c(vals, grid[rr, cc])
          }
        }
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
          if (sum(nb) > 0 && stats::runif(1) < prob_map[row, col]) {
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

  # --- 6. Plot helpers ---
  plot_raster <- function(mat, title, legend_label) {
    df <- expand.grid(x = seq_len(ncol(mat)), y = seq_len(nrow(mat)))
    df$value <- as.vector(mat)

    ggplot2::ggplot(df, ggplot2::aes(x = x, y = y, fill = value)) +
      ggplot2::geom_raster() +
      viridis::scale_fill_viridis(option = "C", direction = -1) +
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
      viridis::scale_fill_viridis(option = "C", na.value = "white", direction = -1) +
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

  # --- 7. Run simulation and store plots ---
  plots <- list()
  cover <- numeric(num_iterations + 1L)
  cover[1] <- sum(grid) / (n_rows * n_cols)

  plot_iterations <- round(seq(0, num_iterations, length.out = 9))

  for (i in 0:num_iterations) {
    if (i > 0) {
      grid <- update_grid(grid, growth_prob_map)
      cover[i + 1] <- sum(grid) / (n_rows * n_cols)
    }

    if (i %in% plot_iterations) {
      plots[[length(plots) + 1L]] <- plot_grid(grid, growth_prob_map, paste("Iteration", i))
    }
  }

  final_plot <- patchwork::wrap_plots(plots, ncol = 3)

  # --- 8. Vegetation cover time series ---
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

  # --- 9. Diagnostic maps ---
  terrain_plot <- plot_raster(terrain, "Fractal Terrain (Elevation)", "Elevation")
  slope_plot   <- plot_raster(slope, "Slope (Steepness)", "Slope")
  prob_plot    <- plot_raster(growth_prob_map, "Probability of Vegetation Growth", "Growth Probability")

  list(
    terrain_plot = terrain_plot,
    slope_plot = slope_plot,
    probability_plot = prob_plot,
    forest_evolution = final_plot,
    cover_plot = cover_plot,
    cover_data = cover_df
  )
}
