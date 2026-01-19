\name{c.neutral}
\alias{c.neutral}
\title{Neutral cellular automaton (toy vegetation dynamics)}
\description{
Simulates a simple neutral cellular automaton on a 2D grid where
vegetation (1) can colonize empty cells (0) near existing vegetation,
and can also die off with a small probability.

The function returns a multi-panel plot showing the grid state at
iteration 0 and at regular intervals.
}
\usage{
c.neutral(
  num_iterations = 50L,
  plot_interval = 10L,
  n_rows = 50L,
  n_cols = 50L,
  init_n = 100L,
  p_grow = 0.1,
  p_die = 0.02,
  seed = NULL
)
}
\arguments{
\item{num_iterations}{Integer. Number of iterations to run the model.
Default is \code{50}.}

\item{plot_interval}{Integer. Save a plot every \code{plot_interval}
iterations. Default is \code{10}.}

\item{n_rows}{Integer. Number of grid rows. Default is \code{50}.}

\item{n_cols}{Integer. Number of grid columns. Default is \code{50}.}

\item{init_n}{Integer. Number of initially vegetated cells.
Default is \code{100}.}

\item{p_grow}{Numeric in \eqn{[0,1]}. Probability of vegetation growth
into an empty cell that has at least one vegetated neighbor.
Default is \code{0.1}.}

\item{p_die}{Numeric in \eqn{[0,1]}. Probability of vegetation dying
per iteration. Default is \code{0.02}.}

\item{seed}{Integer or \code{NULL}. If not \code{NULL}, sets a
reproducible random seed.}
}
\value{
A \code{patchwork} object consisting of multiple \code{ggplot2}
tile plots showing vegetation dynamics over time.
}
\examples{
# Run default simulation
p <- c.neutral()
p

# Reproducible run with more iterations
p2 <- c.neutral(num_iterations = 100, plot_interval = 20, seed = 1)
p2
}
