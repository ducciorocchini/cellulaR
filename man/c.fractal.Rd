\name{c.fractal}
\alias{c.fractal}
\title{Create a fractal landscape using Perlin noise}
\description{
Generates a 2D Perlin-noise surface and returns it either as a matrix
(the raw height field) or as a \code{ggplot2} raster plot.
}
\usage{
c.fractal(
  n = c(100L, 100L),
  frequency = 0.05,
  octaves = 5L,
  output = c("plot", "matrix")
)
}
\arguments{
\item{n}{Integer vector of length 2. Dimensions of the landscape
(rows, cols). Default is \code{c(100, 100)}.}

\item{frequency}{Numeric. Frequency parameter passed to
\code{\link[ambient:noise_perlin]{ambient::noise_perlin()}}.
Default is \code{0.05}.}

\item{octaves}{Integer. Number of octaves passed to
\code{\link[ambient:noise_perlin]{ambient::noise_perlin()}}.
Default is \code{5}.}

\item{output}{Character. One of \code{"plot"} or \code{"matrix"}.
If \code{"plot"}, returns a \code{ggplot} object.
If \code{"matrix"}, returns the numeric matrix.}
}
\value{
If \code{output = "plot"}, a \code{ggplot2} object.
If \code{output = "matrix"}, a numeric matrix representing the height field.
}
\examples{
# Return a plot
p <- c.fractal()
p

# Return the numeric surface
m <- c.fractal(output = "matrix", n = c(50, 50))
dim(m)
}
