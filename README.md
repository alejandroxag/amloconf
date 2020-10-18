
<!-- README.md is generated from README.Rmd. Please edit that file -->

# amloconf

<!-- badges: start -->

![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)
![](https://img.shields.io/badge/last%20change-October%2018,%202020-yellowgreen.svg)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The purpose of `amloconf` is to provide a tool to retrieve the
stenographic versions of the conferences given by the Mexican President,
Andrés Manuel López Obrador, in handy-dialog-formatted lists.

This tool could be useful to carry out text mining and sentiment
analysis on the Mexican President’s press conferences.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages('devtools')
# devtools::install_github('alejandroxag/amloconf')
library(amloconf)
```

## Usage

The `amloconf` package includes three functions: `urls_parsing`,
`find_urls`, and `text_extraction`.

### `urls_parsing`

`urls_parsing(page)` passes `page` as an argument to the function
`glue::glue('https://presidente.gob.mx/secciones/version-estenografica/page/{page}/')`,
and parses all URLs pointing to a conference, within that specific
page’s URL. It mainly serves as an auxiliary function to `find_urls`,
but could be useful to retrieve URLs subsets with unclear start or end
dates, so the argument `page` can be used instead.

``` r
n <- 5
urls <- urls_parsing(page = n)
urls
```

### `find_urls`

`find_urls(dates)` returns all the URLs pointing to conferences hosted
on the specified `dates`. It mainly serves as an auxiliary function to
the `text_extraction` function. However, it can be useful if the URLs
associated with a specific date or group of dates want to be consulted
directly in the browser. Since the main website hosting the press
conferences has many pages, it’s faster to get the URLs using this
function than clicking the next/previous buttons at the bottom of the
website.

``` r
dates <- seq(lubridate::ymd('2020-10-01'),
             lubridate::ymd('2020-10-16'),
             by = 'day')
urls <- find_urls(dates = dates)
urls
```

### `text_extraction`

`text_extraction` retrieves the text corresponding to the conferences
specified in the arguments, in a dialog-formatted list. See
`text_extraction` for further details. This function is the main of this
package, since it can be used to retrieve the conferences in
ready-to-use format.

``` r
conferences <- text_extraction(dates = '2020-10-16')
conferences
```
