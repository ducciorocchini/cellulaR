#' Generate a fractal landscape using Perlin noise
#'
#' Creates a fractal (heterogeneous) landscape, typically used as an
#' environmental template for spatial ecological simulations. The landscape is
#' generated using Perlin noise and returned/visualized as a raster-like plot.
#'
#' @details
#' In the current version, grid size and noise parameters may be fixed in the
#' code; if you later expose them as arguments, add them to the \code{@param}
#' section.
#'
#' @return A plot representing the fractal terrain (e.g., elevation or
#'   suitability).
#'
#' @seealso \code{\link{c.neutral}}, \code{\link{c.weighted}}
#'
#' @importFrom ambient noise_perlin
#' @importFrom ggplot2 ggplot aes geom_raster coord_equal labs theme_minimal theme
#' @importFrom viridis scale_fill_viridis
#' @export
c.fractal <- function() {
  # ...
}
