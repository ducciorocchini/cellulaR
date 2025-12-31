#' Neutral cellular automaton on a homogeneous landscape
#'
#' Simulates vegetation (or species) spread on a neutral landscape where all
#' locations are equivalent. At each iteration, local neighborhood rules drive
#' colonization and (optionally) mortality, producing a visual summary of
#' spatial dynamics over time.
#'
#' @param num_iterations Integer. Number of simulation steps/iterations.
#' @param plot_interval Integer. Frequency (in iterations) at which the
#'   intermediate states are plotted.
#'
#' @details
#' The function is intended as a baseline (neutral) cellular automaton. Output
#' is typically a multi-panel plot showing the spatial state at selected time
#' steps.
#'
#' @return A plot (typically a multi-panel figure) visualizing vegetation spread
#'   through time.
#'
#' @seealso \code{\link{c.fractal}}, \code{\link{c.weighted}}
#'
#' @importFrom ggplot2 ggplot aes geom_raster coord_equal labs theme_minimal theme
#' @importFrom patchwork wrap_plots
#' @export
c.neutral <- function(num_iterations = 50, plot_interval = 10) {
  # ...
}
