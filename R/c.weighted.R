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
  st
