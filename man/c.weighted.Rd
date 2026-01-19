\name{c.weighted}
\alias{c.weighted}
\title{Weighted spread across slopes (terrain-weighted cellular automaton)}
\description{
Simulates a vegetation cellular automaton on a fractal terrain generated
via Perlin noise. Colonization probability depends on local elevation
and slope, with higher growth probability in lower and flatter areas.

The function returns diagnostic maps, vegetation dynamics plots, and a
time series of vegetation cover.
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
  seed = NULL
)
}
\arguments{
\item{num_iterations}{Integer. Number of iterations to run the simulation.
Default is \code{100}.}

\item{n_rows}{Integer. Number of grid rows. Default is \code{100}.}

\item{n_cols}{Integer. Number of grid columns. Default is \code{100}.}

\item{frequency}{Numeric. Frequency passed to
\code{\link[ambient:noise_perlin]{ambient::noise_perlin()}}.
Default is \code{0.05}.}

\item{octaves}{Integer. Number of octaves passed to
\code{\link[ambient:noise_perlin]{ambient::noise_perlin()}}.
Default is \code{5}.}

\item{base_growth}{Numeric in \eqn{[0,1]}. Baseline growth rate scaling the
spatial growth probability map. Default is \code{0.1}.}

\item{death_prob}{Numeric in \eqn{[0,1]}. Probability of death per
vegetated cell per iteration. Default is \code{0.02}.}

\item{init_n}{Integer. Number of initially vegetated cells.
Default is \code{200}.}

\item{seed}{Integer or \code{NULL}. If not \code{NULL}, sets a
reproducible random seed.}
}
\value{
A named list with components:
\describe{
  \item{terrain_plot}{Raster plot of terrain elevation.}
  \item{slope_plot}{Raster plot of terrain slope.}
  \item{probability_plot}{Raster plot of vegetation growth probability.}
  \item{forest_evolution}{Multi-panel plot of vegetation dynamics.}
  \item{cover_plot}{Line plot of vegetation cover over time.}
  \item{cover_data}{Data frame with iteration and vegetation cover (\%).}
}
}
\examples{
# Run a smaller simulation for speed
res <- c.weighted(
  num_iterations = 50,
  n_rows = 50,
  n_cols = 50,
  seed = 1
)

res$forest_evolution
res$cover_plot
}
