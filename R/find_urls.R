#' Find URLs
#'
#' Finds URLs corresponding to specific dates.
#'
#' @param dates
#' A date value or vector in the format 'yyyy-mm-dd'
#' (either of Date or character class), between 04/12/2018 and the present date,
#' both inclusive. When the date is not found, or there is an
#' inconsistency in that days' conference, it throws a warning.
#'
#' @param s_ad_fct
#' A numeric value to adjust the scope of the dates' search through
#' the pages in the main website of the conferences.
#'
#' @return A character vector containing the URLs corresponding to the selected
#' dates.
#' @export
#'
#' @examples
#' urls <- find_urls('2020-10-06')
#' urls <- find_urls(c('2020-10-06','2020-08-19'))
#' dates <- seq(lubridate::ymd('2020-10-01'),
#'              lubridate::ymd('2020-10-16'),
#'              by = 'day')
#' urls <- find_urls(dates)
find_urls <- function(dates = NULL, s_ad_fct = 1.25) {

    urls_list <- list()

    if (!purrr::is_null(dates)) {

        dates <- c(lubridate::ymd(dates))
        in_date <- lubridate::ymd('2018-12-04')
        today <- Sys.Date()
        tm_lp <- as.integer(today - in_date)
        pages <- c()
        dates_final_set <- lubridate::ymd(c())

        for (date_i in as.list(dates)) {

            suppressWarnings(cond1 <- (base::max(dates_final_set) >= date_i & date_i >= base::min(dates_final_set)) | date_i > today)
            if (cond1) {
            } else {

                page <- base::ceiling(s_ad_fct * tm_lp / 15) - base::ceiling(s_ad_fct * as.integer(date_i - in_date) / 15)
                exit <- TRUE

                while (exit) {

                    tryCatch(
                        {
                            url <- glue::glue('https://presidente.gob.mx/secciones/version-estenografica/page/{page}/')
                            if (page == 1) url <- 'https://presidente.gob.mx/secciones/version-estenografica/'

                            html_dates <- xml2::read_html(url) %>%
                                rvest::html_nodes('h2') %>%
                                rvest::html_text() %>%
                                stringr::str_sub(1,8) %>%
                                lubridate::dmy() %>%
                                .[!is.na(.)] %>%
                                .[. >= in_date & . < lubridate::ymd('2024-12-01')]
                        },
                        error = function(e) {}
                    )

                    if (base::max(html_dates) + 7 >= date_i & date_i >= base::min(html_dates) - 7) {
                        exit <- FALSE
                    } else if (base::max(html_dates) < date_i) {
                        page <- page - 1
                    } else if (base::min(html_dates) > date_i) {
                        page <- page + 1
                    }
                }

                pages <- c(pages, page)
                dates_final_set <- unique(c(dates_final_set, html_dates))
            }
        }

        for (p in pages) pages <- c(pages, p - 1, p + 1)
        pages <- sort(unique(pages[pages > 0]))

        urls_list <- unlist(purrr::map(pages, ~ tryCatch(urls_parsing(.),error = function(e) {})))
        return(urls_list[names(urls_list) %in% as.character(dates)])

    } else {

        exit <- TRUE
        page <- 1

        while (exit) {

            urls_list[[page]] <- tryCatch(urls_parsing(page),error = function(e) {exit <<- FALSE})
            page <- page + 1

        }

        return(unlist(urls_list))
    }

    # suppressWarnings(closeAllConnections())
}
