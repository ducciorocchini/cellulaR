#' Neutral cellular automaton (toy vegetation dynamics)
#'
#' Simulates a simple neutral cellular automaton on a 2D grid where
#' vegetation (1) can colonize empty cells (0) near existing vegetation,
#' and can also die off with a small probability.
#'
#' The function returns a multi-panel plot showing the grid state at
#' iteration 0 and at regular intervals.
#'
#' @param num_iterations Integer. Number of iterations to run the model.
#'   Default is `50`.
#' @param plot_interval Integer. Save a plot every `plot_interval` iterations.
#'   Default is `10`.
#' @param n_rows Integer. Number of grid rows. Default is `50`.
#' @param n_cols Integer. Number of grid columns. Default is `50`.
#' @param init_n Integer. Number of initially vegetated cells. Default is `100`.
#' @param p_grow Numeric in `[0,1]`. Probability of vegetation growth into an
#'   empty cell that has at least one vegetated neighbor. Default is `0.1`.
#' @param p_die Numeric in `[0,1]`. Probability of vegetation dying in a
#'   vegetated cell per iteration. Default is `0.02`.
#' @param seed Integer or `NULL`. If not `NULL`, sets a reproducible random seed.
#'   Default is `NULL`.
#'
#' @return A `patchwork` object (multi-panel plot). Each panel is a `ggplot2`
#'   tile plot of the grid at a given iteration.
#' @export
#'
#' @examples
#' # Run default simulation and display multi-panel plot
#' p <- c_neutral()
#' p
#'
#' # More iterations, reproducible seed
#' p2 <- c_neutral(num_iterations = 100, plot_interval = 20, seed = 1)
#' p2
c_neutral <- function(
  num_iterations = 50L,
  plot_interval = 10L,
  n_rows = 50L,
  n_cols = 50L,
  init_n = 100L,
  p_grow = 0.1,
  p_die = 0.02,
  seed = NULL
) {
  # Basic checks (lightweight but helpful for reviewers)
  stopifnot(length(num_iterations) == 1, num_iterations >= 0)
  stopifnot(length(plot_interval) == 1, plot_interval >= 1)
  stopifnot(length(n_rows) == 1, n_rows >= 1)
  stopifnot(length(n_cols) == 1, n_cols >= 1)
  stopifnot(init_n >= 0, init_n <= n_rows * n_cols)
  stopifnot(p_grow >= 0, p_grow <= 1)
  stopifnot(p_die  >= 0, p_die  <= 1)

  if (!is.null(seed)) set.seed(seed)

  # Initialize the grid with random vegetation
  grid <- matrix(0L, nrow = n_rows, ncol = n_cols)
  if (init_n > 0) {
    grid[sample.int(n_rows * n_cols, size = init_n)] <- 1L
  }

  get_neighbors <- function(row, col, grid) {
    vals <- integer(0)
    for (i in -1:1) {
      for (j in -1:1) {
        if (!(i == 0 && j == 0)) {
          rr <- row + i
          cc <- col + j
          if (rr >= 1 && rr <= nrow(grid) && cc >= 1 && cc <= ncol(grid)) {
            vals <- c(vals, grid[rr, cc])
          }
        }
      }
    }
    vals
  }

  update_grid <- function(grid) {
    new_grid <- grid
    for (row in seq_len(nrow(grid))) {
      for (col in seq_len(ncol(grid))) {

        if (grid[row, col] == 0L) {
          nb <- get_neighbors(row, col, grid)
          if (sum(nb) > 0 && stats::runif(1) < p_grow) {
            new_grid[row, col] <- 1L
          }
        } else {
          if (stats::runif(1) < p_die) {
            new_grid[row, col] <- 0L
          }
        }

      }
    }
    new_grid
  }

  plot_grid <- function(grid, title = "Vegetation Growth") {
    df <- expand.grid(x = seq_len(ncol(grid)), y = seq_len(nrow(grid)))
    df$value <- as.vector(grid)

    ggplot2::ggplot(df, ggplot2::aes(x = x, y = y, fill = factor(value))) +
      ggplot2::geom_tile() +
      ggplot2::scale_fill_manual(values = c("white", "green")) +
      ggplot2::theme_minimal() +
      ggplot2::theme(
        axis.text = ggplot2::element_blank(),
        axis.ticks = ggplot2::element_blank(),
        plot.title = ggplot2::element_text(hjust = 0.5)
      ) +
      ggplot2::labs(title = title, fill = "Vegetation")
  }

  plots <- list(plot_grid(grid, "Iteration 0"))

  for (i in seq_len(num_iterations)) {
    grid <- update_grid(grid)

    if (i %% plot_interval == 0) {
      plots[[length(plots) + 1]] <- plot_grid(grid, paste("Iteration", i))
    }
  }

  patchwork::wrap_plots(plots, ncol = 3)
}
