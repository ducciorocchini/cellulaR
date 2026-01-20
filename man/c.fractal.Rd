\name{c.fractal}
\alias{c.fractal}
\title{Create a fractal landscape using Perlin noise}
\description{
Generates a two-dimensional fractal landscape using Perlin noise, with options
to control spatial scale, multi-scale detail, value transformation, rescaling,
and graphical appearance.
}
\usage{
c.fractal(
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
)
}
\arguments{
  \item{n}{
Integer vector of length two giving the number of rows and columns of the grid.
}
  \item{frequency}{
Numeric value controlling the spatial frequency (roughness) of the Perlin noise.
Higher values produce finer-scale variation.
}
  \item{octaves}{
Integer specifying the number of noise octaves used to add multi-scale detail.
}
  \item{seed}{
Integer or \code{NULL}. If provided, sets a random seed for reproducibility.
}
  \item{transform}{
Character string specifying a transformation applied to the noise values;
one of \code{"none"}, \code{"sqrt"}, or \code{"log1p"}.
}
  \item{rescale}{
Logical. If \code{TRUE}, rescales the resulting values to the interval \eqn{[0,1]}.
}
  \item{output}{
Character string specifying the output type; either \code{"plot"} or
\code{"matrix"}.
}
  \item{palette}{
Character specifying the viridis palette option used for plotting
(e.g., \code{"A"}, \code{"C"}, \code{"D"}).
}
  \item{direction}{
Integer specifying the color direction of the viridis palette; \code{1} maps
high values to light colors and low values to dark colors, while \code{-1}
reverses this mapping.
}
  \item{title}{
Character string specifying the plot title.
}
}
\value{
If \code{output = "plot"}, a \code{ggplot2} raster plot of the fractal landscape;
if \code{output = "matrix"}, a numeric matrix containing the generated values.
}
\details{
The landscape is generated using \code{\link[ambient]{noise_perlin}}, where
\code{frequency} controls the characteristic spatial scale of variation and
\code{octaves} controls the degree of multi-scale texture. Optional transformations
and rescaling can be applied prior to visualization or return of the matrix.
}
\examples{
# Generate and plot a fractal landscape
c.fractal()

# Return the underlying matrix
mat <- c.fractal(output = "matrix")

# Reproducible landscape with custom appearance
c.fractal(
  seed = 1,
  frequency = 0.03,
  octaves = 6,
  palette = "C",
  direction = 1
)
}
\seealso{
\code{\link[ambient]{noise_perlin}}
}
\author{
Duccio Rocchini
}
