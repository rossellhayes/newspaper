#' Scrape articles
#'
#' Scrape articles from online news sources using the
#' [newspaper Python package](https://newspaper.readthedocs.io/en/latest/).
#'
#' Use [newspaper_install()] to set up the Python environment needed to run
#' this function.
#'
#' @param url A character vector of URLs to scrape.
#' @param fields A character vector of fields to extract from each article.
#'   A combination of `"title"`, `"authors"`, `"publish_date"`, and `"text"`.
#'
#' @return A [tibble][tibble::tibble()] with rows containing `fields` for
#'   each `url`.
#' @importFrom rlang %||%
#' @export
#'
#' @examples
#' newspaper_scrape(
#'   "https://www.businessinsider.com/what-is-web-scraping"
#' )
#'
#' newspaper_scrape(
#'   "https://www.nature.com/articles/d41586-020-02558-0",
#'   fields = c("title", "text")
#' )
#'
#' newspaper_scrape(
#'   "http://invalid.example"
#' )
#'
#' newspaper_scrape(
#'   c(
#'     "https://www.businessinsider.com/what-is-web-scraping",
#'     "https://www.nature.com/articles/d41586-020-02558-0",
#'     "http://invalid.example"
#'   )
#' )


newspaper_scrape <- function(
  url, fields = c("title", "authors", "publish_date", "text")
) {
  # Stop if Python environment is not configured correctly
  if (!isTRUE(try("r_newspaper_pkg" %in% reticulate::conda_list()$name))) {
    abort(
      "The {.code newspaper3k} Python environment is not available.",
      "*" = "Try running {.code newspaper::newspaper_install()}."
    )
  }

  # Import Python function
  reticulate::use_condaenv(condaenv = "r_newspaper_pkg", required = TRUE)
  newspaper <- reticulate::import("newspaper")

  # If article cannot be scraped (e.g. website can't be found), return NA
  invalid             <- rep(list(list(NA)), length(fields))
  names(invalid)      <- fields
  scrape_article_safe <- purrr::possibly(scrape_article, otherwise = invalid)

  # Run `scrape_article_safe()` on each URL
  articles <- purrr::map_dfr(url, scrape_article_safe, fields, newspaper)

  # Turn columns that don't need to be lists into vectors
  non_list <- purrr::map_lgl(articles, ~ identical(unique(lengths(.)), 1L))
  articles[, non_list] <- purrr::map(articles[, non_list], unlist)

  # Convert dates
  if ("publish_date" %in% names(articles)) {
    articles$publish_date <- as_date(articles$publish_date)
  }

  articles
}

scrape_article <- function(url, fields, newspaper) {
  article <- newspaper$Article(url)
  article$download()
  article$parse()

  data <- purrr::map(
    fields,
    purrr::possibly(~ list(article[.] %||% NA), list(NA))
  )
  names(data) <- fields
  data
}

as_date <- function(publish_date) {
  as.Date(as.POSIXct(publish_date, origin = "1970-01-01"))
}

abort <- function(...) {
  rlang::abort(cli::format_error(c(...)))
}
