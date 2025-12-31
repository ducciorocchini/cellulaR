#' Weighted cellular automaton on a heterogeneous (fractal) landscape
#'
#' Simulates vegetation (or species) spread on a heterogeneous landscape where
#' local colonization probability is modulated by environmental heterogeneity
#' (e.g., terrain/elevation) and local roughness (slope). The function produces
#' diagnostic maps (terrain, slope, growth probability) and temporal summaries
#' of vegetation spread and cover.
#'
#' @param num_iterations Integer. Number of simulation steps/iterations.
#' @param plot_interval Integer. Frequency (in iterations) at which intermediate
#'   states are plotted.
#' @param n_rows Integer. Number of grid rows.
#' @param n_cols Integer. Number of grid columns.
#' @param frequency Numeric. Frequency parameter controlling Perlin noise detail.
#' @param octaves Integer. Number of noise octaves controlling fractal complexity.
#' @param base_growth Numeric in [0,1]. Baseline colonization probability.
#' @param death_prob Numeric in [0,1]. Probability of local mortality.
#' @param seed Optional integer. Random seed for reproducibility.
#'
#' @details
#' The output includes multiple visualization layers and summaries, typically:
#' terrain, slope, growth probability, vegetation evolution, and vegetation cover
#' through time.
#'
#' @return A named list with components such as:
#' \describe{
#'   \item{terrain_plot}{Plot of the fractal terrain.}
#'   \item{slope_plot}{Plot of terrain slope/roughness.}
#'   \item{probability_plot}{Plot of spatial growth probability.}
#'   \item{forest_evolution}{Multi-panel plot showing vegetation spread over time.}
#'   \item{cover_plot}{Line plot of vegetation cover (\%) over time.}
#'   \item{cover_data}{Data frame with vegetation cover over time.}
#' }
#'
#' @seealso \code{\link{c.neutral}}, \code{\link{c.fractal}}
#'
#' @importFrom ambient noise_perlin
#' @importFrom ggplot2 ggplot aes geom_raster coord_equal labs theme_minimal theme geom_line
#' @importFrom patchwork wrap_plots
#' @importFrom viridis scale_fill_viridis
#' @export
c.weighted <- function(num_iterations = 50, plot_interval = 10,
                       n_rows = 100, n_cols = 100,
                       frequency = 0.05, octaves = 5,
                       base_growth = 0.1, death_prob = 0.02,
                       seed = NULL) {
  # ...
}
