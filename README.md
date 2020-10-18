
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
#>                                                                                                                                                           2020-09-02 
#>                          "https://presidente.gob.mx/02-09-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/" 
#>                                                                                                                                                           2020-08-31 
#>                          "https://presidente.gob.mx/31-08-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/" 
#>                                                                                                                                                           2020-08-28 
#>                                                 "https://presidente.gob.mx/28-08-20-version-estenografica-acciones-de-mejoramiento-urbano-desde-reynosa-tamaulipas/" 
#>                                                                                                                                                           2020-08-28 
#> "https://presidente.gob.mx/28-08-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador-desde-reynosa-tamaulipas/" 
#>                                                                                                                                                           2020-08-27 
#>                     "https://presidente.gob.mx/27-08-20-version-estenografica-rehabilitacion-del-sistema-nacional-de-refinacion-desde-cadereyta-jimenez-nuevo-leon/" 
#>                                                                                                                                                           2020-08-27 
#> "https://presidente.gob.mx/27-08-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador-desde-apodaca-nuevo-leon/" 
#>                                                                                                                                                           2020-08-26 
#>   "https://presidente.gob.mx/26-08-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador-desde-torreon-coahuila/" 
#>                                                                                                                                                           2020-08-25 
#>                          "https://presidente.gob.mx/25-08-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/" 
#>                                                                                                                                                           2020-08-24 
#>                          "https://presidente.gob.mx/24-08-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/" 
#>                                                                                                                                                           2020-08-21 
#>     "https://presidente.gob.mx/21-08-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador-desde-aguascalientes/" 
#>                                                                                                                                                           2020-08-20 
#>                                "https://presidente.gob.mx/20-08-20-version-estenografica-rescate-del-campo-y-autosuficiencia-alimentaria-desde-zacatecas-zacatecas/" 
#>                                                                                                                                                           2020-08-20 
#>          "https://presidente.gob.mx/20-08-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador-desde-zacatecas/" 
#>                                                                                                                                                           2020-08-19 
#>          "https://presidente.gob.mx/19-08-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador-desde-queretaro/" 
#>                                                                                                                                                           2020-08-18 
#>                          "https://presidente.gob.mx/18-08-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/" 
#>                                                                                                                                                           2020-08-17 
#>                          "https://presidente.gob.mx/17-08-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/"
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
#>                                                                                                                                          2020-10-16 
#>   "https://presidente.gob.mx/16-10-20-version-estenografica-avance-del-programa-nacional-de-reconstruccion-desde-santo-domingo-tehuantepec-oaxaca/" 
#>                                                                                                                                          2020-10-16 
#>         "https://presidente.gob.mx/16-10-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/" 
#>                                                                                                                                          2020-10-15 
#>         "https://presidente.gob.mx/15-10-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/" 
#>                                                                                                                                          2020-10-14 
#>         "https://presidente.gob.mx/14-10-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/" 
#>                                                                                                                                          2020-10-13 
#>         "https://presidente.gob.mx/13-10-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/" 
#>                                                                                                                                          2020-10-12 
#>     "https://presidente.gob.mx/12-10-20-version-estenografica-graduacion-15a-generacion-del-curso-de-formacion-del-servicio-de-proteccion-federal/" 
#>                                                                                                                                          2020-10-12 
#>         "https://presidente.gob.mx/12-10-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/" 
#>                                                                                                                                          2020-10-11 
#>                          "https://presidente.gob.mx/11-10-20-version-estenografica-acciones-de-mejoramiento-urbano-desde-solidaridad-quintana-roo/" 
#>                                                                                                                                          2020-10-11 
#>                                   "https://presidente.gob.mx/11-10-20-version-estenografica-supervision-de-obra-del-tren-maya-desde-tinum-yucatan/" 
#>                                                                                                                                          2020-10-10 
#>                                  "https://presidente.gob.mx/10-10-20-version-estenografica-supervision-de-obra-del-tren-maya-desde-kopoma-yucatan/" 
#>                                                                                                                                          2020-10-10 
#>                                        "https://presidente.gob.mx/10-10-20-version-estenografica-supervision-de-obra-del-tren-maya-desde-campeche/" 
#>                                                                                                                                          2020-10-09 
#>                                        "https://presidente.gob.mx/09-10-20-version-estenografica-supervision-del-tren-maya-desde-palenque-chiapas/" 
#>                                                                                                                                          2020-10-09 
#>         "https://presidente.gob.mx/09-10-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/" 
#>                                                                                                                                          2020-10-08 
#>                                    "https://presidente.gob.mx/08-10-20-version-estenografica-conmemoracion-de-los-80-anos-de-el-colegio-de-mexico/" 
#>                                                                                                                                          2020-10-08 
#>          "https://presidente.gob.mx/08-1020-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/" 
#>                                                                                                                                          2020-10-07 
#>         "https://presidente.gob.mx/07-10-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/" 
#>                                                                                                                                          2020-10-06 
#>         "https://presidente.gob.mx/06-10-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/" 
#>                                                                                                                                          2020-10-05 
#>         "https://presidente.gob.mx/05-10-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/" 
#>                                                                                                                                          2020-10-04 
#>                                 "https://presidente.gob.mx/04-10-20-version-estenografica-programa-de-mejoramiento-urbano-desde-hermosillo-sonora/" 
#>                                                                                                                                          2020-10-03 
#>                    "https://presidente.gob.mx/03-10-20-version-estenografica-informe-de-avances-a-la-comunidad-de-la-region-sierra-alta-de-sonora/" 
#>                                                                                                                                          2020-10-02 
#> "https://presidente.gob.mx/02-10-20-version-estenografica-inicio-de-construccion-de-la-unidad-de-medicina-familiar-no-12-desde-agua-prieta-sonora/" 
#>                                                                                                                                          2020-10-02 
#>                           "https://presidente.gob.mx/02-10-20-version-estenografica-programa-de-mejoramiento-urbano-desde-ciudad-juarez-chihuahua/" 
#>                                                                                                                                          2020-10-02 
#>         "https://presidente.gob.mx/02-10-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/" 
#>                                                                                                                                          2020-10-01 
#>         "https://presidente.gob.mx/01-10-20-version-estenografica-de-la-conferencia-de-prensa-matutina-del-presidente-andres-manuel-lopez-obrador/"
```

### `text_extraction`

`text_extraction` retrieves the text corresponding to the conferences
specified in the arguments, in a dialog-formatted list. See
`text_extraction` for further details. This function is the main of this
package, since it can be used to retrieve the conferences in
ready-to-use format.

``` r
# conferences <- text_extraction(start = '2020-10-12', end = '2020-10-16')
# conferences
```
