#' Create a fractal landscape using Perlin noise
#'
#' Generates a 2D Perlin-noise surface and returns it either as a matrix
#' (the raw height field) or as a `ggplot2` raster plot.
#'
#' @param n Integer vector of length 2. Dimensions of the landscape
#'   (rows, cols). Default is `c(100, 100)`.
#' @param frequency Numeric. Frequency parameter passed to
#'   [ambient::noise_perlin()]. Default is `0.05`.
#' @param octaves Integer. Number of octaves passed to
#'   [ambient::noise_perlin()]. Default is `5`.
#' @param output Character. One of `"plot"` or `"matrix"`.
#'   If `"plot"`, returns a `ggplot` object. If `"matrix"`, returns the
#'   numeric matrix.
#'
#' @return If `output = "plot"`, a `ggplot2` object.
#'   If `output = "matrix"`, a numeric matrix (height field).
#' @export
#'
#' @examples
#' # Return a plot
#' p <- c_fractal()
#' p
#'
#' # Return the numeric surface
#' m <- c_fractal(output = "matrix", n = c(50, 50))
#' dim(m)
c_fractal <- function(
  n = c(100L, 100L),
  frequency = 0.05,
  octaves = 5L,
  output = c("plot", "matrix")
) {
  output <- match.arg(output)

  # Generate fractal noise (matrix)
  terrain <- ambient::noise_perlin(n, frequency = frequency, octaves = octaves)

  if (output == "matrix") {
    return(terrain)
  }

  # Convert matrix to a long data.frame for ggplot2
  terrain_df <- data.frame(
    y = rep(seq_len(nrow(terrain)), times = ncol(terrain)),
    x = rep(seq_len(ncol(terrain)), each  = nrow(terrain)),
    value = as.vector(terrain)
  )

  ggplot2::ggplot(terrain_df, ggplot2::aes(x = x, y = y, fill = value)) +
    ggplot2::geom_raster() +
    ggplot2::scale_fill_viridis_c(option = "D", direction = -1) +
    ggplot2::coord_equal() +
    ggplot2::labs(
      title = "Fractal Landscape via Perlin Noise",
      x = NULL, y = NULL, fill = "Height"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank()
    )
}
