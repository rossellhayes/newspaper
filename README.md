
<!-- README.md is generated from README.Rmd. Please edit that file -->

# newspaper

<!-- badges: start -->
<!-- [![](https://www.r-pkg.org/badges/version/newspaper?color=brightgreen)](https://cran.r-project.org/package=newspaper) -->

[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![License:
MIT](https://img.shields.io/badge/license-MIT-blueviolet.svg)](https://cran.r-project.org/web/licenses/MIT)
<!-- [![R build status](https://github.com/rossellhayes/newspaper/workflows/R-CMD-check/badge.svg)](https://github.com/rossellhayes/newspaper/actions) -->
<!-- [![](https://codecov.io/gh/rossellhayes/newspaper/branch/main/graph/badge.svg)](https://codecov.io/gh/rossellhayes/newspaper) -->
<!-- [![CodeFactor](https://www.codefactor.io/repository/github/rossellhayes/newspaper/badge)](https://www.codefactor.io/repository/github/rossellhayes/newspaper) -->
<!-- [![Dependencies](https://tinyverse.netlify.com/badge/newspaper)](https://cran.r-project.org/package=newspaper) -->
<!-- badges: end -->

**newspaper** provides an interface for scraping online news articles,
powered by the [**newspaper** Python
package](https://newspaper.readthedocs.io/en/latest/).

## Installation

You can install the the development version of **newspaper** from
[GitHub](https://github.com/rossellhayes/incase) with:

``` r
# install.packages("pak")
pak::pkg_install("rossellhayes/newspaper")
```

To setup **newspaper**’s Python dependencies, use

``` r
library(newspaper)
newspaper_install()
```

## Usage

``` r
newspaper_scrape("https://www.businessinsider.com/what-is-web-scraping")
#> # A tibble: 1 x 4
#>   title                        authors  publish_date text                       
#>   <chr>                        <chr>    <date>       <chr>                      
#> 1 What is web scraping? Here'~ Dave Jo~ 2021-01-14   "Web scraping is the proce~
```

You can specify specific fields if you don’t need all the information
provided:

``` r
newspaper_scrape(
  "https://www.businessinsider.com/what-is-web-scraping",
  fields = c("title", "text")
)
#> # A tibble: 1 x 2
#>   title                                   text                                  
#>   <chr>                                   <chr>                                 
#> 1 What is web scraping? Here's what you ~ "Web scraping is the process of using~
```

**newspaper** will return `NA` values if an article cannot be located:

``` r
newspaper_scrape("http://invalid.example")
#> # A tibble: 1 x 4
#>   title authors publish_date text 
#>   <lgl> <lgl>   <date>       <lgl>
#> 1 NA    NA      NA           NA
```

or if certain metadata is missing:

``` r
newspaper_scrape("https://www.nature.com/articles/d41586-020-02558-0")
#> # A tibble: 1 x 4
#>   title                   authors  publish_date text                            
#>   <chr>                   <list>   <date>       <chr>                           
#> 1 How we learnt to stop ~ <chr [8~ NA           "Build your own webscraping too~
```

You can pass a vector of URLs to scrape multiple articles at once.

``` r
newspaper_scrape(
  c(
    "https://www.businessinsider.com/what-is-web-scraping",
    "https://www.nature.com/articles/d41586-020-02558-0",
    "http://invalid.example"
  )
)
#> # A tibble: 3 x 4
#>   title                        authors  publish_date text                       
#>   <chr>                        <list>   <date>       <chr>                      
#> 1 What is web scraping? Here'~ <chr [1~ 2021-01-14   "Web scraping is the proce~
#> 2 How we learnt to stop worry~ <chr [8~ NA           "Build your own webscrapin~
#> 3 <NA>                         <lgl [1~ NA            <NA>
```

------------------------------------------------------------------------

Please note that **newspaper** is released with a [Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
