#' Set up the Python environment for the newspaper package
#'
#' This function installs [miniconda][reticulate::install_miniconda()] if it is
#' not present, then sets up a [conda environment][reticulate::conda_create()]
#' with the tools needed to run [newspaper_scrape()].
#'
#' @return Invisibly returns `NULL`
#' @export
#'
#' @examples
#' \dontrun{newspaper_install()}

newspaper_install <- function() {
  if (is.null(reticulate::conda_binary())) {reticulate::install_miniconda()}

  system2(
    reticulate::conda_binary(),
    "create --yes -n r_newspaper_pkg -c conda-forge nomkl numpy pandas"
  )

  reticulate::conda_install("r_newspaper_pkg", "newspaper3k")

  return(invisible(NULL))
}
