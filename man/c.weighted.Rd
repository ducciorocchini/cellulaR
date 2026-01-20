\name{c.weighted}
\alias{c.weighted}
\title{Weighted spread across slopes (terrain-weighted cellular automaton)}
\description{
Simulates a vegetation cellular automaton on a fractal terrain generated via
Perlin noise. Colonization probability depends on local elevation and slope,
and can be tuned using exponents and neighborhood rules.
}
\usage{
c.weighted(
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
  direction = -1L,
  return_model = TRUE,
  seed = NULL
)
}
\arguments{
  \item{num_iterations}{
Integer. Number of iterations to run the simulation.
}
  \item{n_rows}{
Integer. Number of grid rows.
}
  \item{n_cols}{
Integer. Number of grid columns.
}
  \item{frequency}{
Numeric. Spatial frequency passed to \code{\link[ambient]{noise_perlin}}.
Controls terrain roughness (higher values produce finer-scale variation).
}
  \item{octaves}{
Integer. Number of octaves passed to \code{\link[ambient]{noise_perlin}} to add
multi-scale detail.
}
  \item{base_growth}{
Numeric in \eqn{[0,1]}. Baseline growth rate scaling the spatial growth
probability map.
}
  \item{death_prob}{
Numeric in \eqn{[0,1]}. Probability of death per vegetated cell per iteration.
}
  \item{init_n}{
Integer. Number of initially vegetated cells.
}
  \item{alpha_elev}{
Numeric. Exponent controlling how strongly elevation downweights growth via
\eqn{(1 - \mathrm{terrain})^{\alpha_\mathrm{elev}}}.
}
  \item{alpha_slope}{
Numeric. Exponent controlling how strongly slope downweights growth via
\eqn{(1 - \mathrm{slope})^{\alpha_\mathrm{slope}}}.
}
  \item{neighbor_threshold}{
Integer. Minimum number of vegetated neighbors required for colonization.
}
  \item{kernel}{
Character. Neighborhood definition: \code{"moore"} (8-neighbor Moore) or
\code{"von_neumann"} (4-neighbor von Neumann).
}
  \item{plot_n}{
Integer. Number of snapshots displayed in the evolution plot.
}
  \item{direction}{
Integer. Color direction for the viridis palette (\code{1} or \code{-1}).
}
  \item{return_model}{
Logical. If \code{TRUE}, includes a \code{model} element containing terrain,
slope, growth probability map, and the final vegetation grid.
}
  \item{seed}{
Integer or \code{NULL}. If provided, sets a reproducible random seed.
}
}
\value{
A named list with the following elements:
\describe{
  \item{terrain_plot}{A \code{ggplot2} raster plot of terrain elevation.}
  \item{slope_plot}{A \code{ggplot2} raster plot of terrain slope.}
  \item{probability_plot}{A \code{ggplot2} raster plot of growth probability.}
  \item{forest_evolution}{A \code{patchwork} multi-panel plot of vegetation dynamics through time.}
  \item{cover_plot}{A \code{ggplot2} line plot of vegetation cover (\%) over time.}
  \item{cover_data}{A \code{data.frame} with iteration and vegetation cover (\%).}
  \item{model}{(Optional) A list with \code{terrain}, \code{slope}, \code{growth_prob_map}, and \code{final_grid}.}
}
}
\details{
A fractal terrain is generated using \code{\link[ambient]{noise_perlin}} and
normalized to \eqn{[0,1]}. Slope is estimated using finite differences and
normalized to \eqn{[0,1]} when possible. The cell-wise colonization probability
map is computed as:
\deqn{\mathrm{growth\_prob} = \mathrm{base\_growth}\,(1-\mathrm{terrain})^{\alpha_\mathrm{elev}}\,(1-\mathrm{slope})^{\alpha_\mathrm{slope}},}
and is truncated to \eqn{[0,1]}. At each iteration, empty cells can become
vegetated if the number of vegetated neighbors meets \code{neighbor_threshold}
and a uniform random draw is below the local growth probability; vegetated
cells die with probability \code{death_prob}.
}
\examples{
\dontrun{
res <- c.weighted(
  num_iterations = 50,
  n_rows = 50,
  n_cols = 50,
  alpha_slope = 2,
  neighbor_threshold = 2,
  kernel = "moore",
  direction = 1,
  seed = 1
)
res$forest_evolution
res$cover_plot
str(res$model)
}
}
\seealso{
\code{\link[ambient]{noise_perlin}}
}
\author{
Duccio Rocchini
}
