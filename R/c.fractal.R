#' Create a fractal landscape using Perlin noise
#'
#' @param n Integer vector length 2. (rows, cols).
#' @param frequency Numeric. Passed to [ambient::noise_perlin()].
#' @param octaves Integer. Passed to [ambient::noise_perlin()].
#' @param seed Integer or NULL. Reproducible seed.
#' @param transform Character. One of "none", "sqrt", "log1p".
#' @param rescale Logical. If TRUE, rescale values to [0,1].
#' @param output Character. "plot" or "matrix".
#' @param palette Character. Viridis palette option (e.g., "D", "C", "A").
#' @param direction Integer. 1 or -1. Color direction for viridis.
#' @param title Character. Plot title.
#'
#' @return A `ggplot2` object (output = "plot") or a numeric matrix.
#' @export
c.fractal <- function(
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
) {
  output <- match.arg(output)
  transform <- match.arg(transform)
  if (!is.null(seed)) set.seed(seed)

  terrain <- ambient::noise_perlin(n, frequency = frequency, octaves = octaves)

  if (transform == "sqrt") terrain <- sqrt(pmax(terrain, 0))
  if (transform == "log1p") terrain <- log1p(terrain - min(terrain))

  if (isTRUE(rescale)) {
    rng <- range(terrain, na.rm = TRUE)
    if (diff(rng) > 0) terrain <- (terrain - rng[1]) / diff(rng)
  }

  if (output == "matrix") return(terrain)

  df <- data.frame(
    y = rep(seq_len(nrow(terrain)), times = ncol(terrain)),
    x = rep(seq_len(ncol(terrain)), each  = nrow(terrain)),
    value = as.vector(terrain)
  )

  ggplot2::ggplot(df, ggplot2::aes(x = x, y = y, fill = value)) +
    ggplot2::geom_raster() +
    viridis::scale_fill_viridis(option = palette, direction = direction) +
    ggplot2::coord_equal() +
    ggplot2::labs(title = title, x = NULL, y = NULL, fill = "Height") +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank()
    )
}
