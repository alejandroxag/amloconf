#' Text extraction from URLs
#'
#' Extracts and formats the stenographic version of the press conferences
#' for a given date, set of dates, URL, set of URLs,
#' or for all the conferences available. The name of
#' the parameter must be specified when calling this function.
#'
#' @param dates
#' A date value or vector in the format 'yyyy-mm-dd'
#' (either of Date or character class), between 04/12/2018 and the present date,
#' both inclusive. When the date is not found, or there is an
#' inconsistency in that days' conference, it throws a warning. Must be set
#' to NULL if urls, start or end arguments are specified.
#'
#' @param urls
#' A string value or vector containing URLs pointing to conferences hosted in
#' the website https://presidente.gob.mx/secciones/version-estenografica/.
#' When the date is not found, or there is an
#' inconsistency in that days' conference, it throws a warning.
#' Must be set to NULL if dates, start or end arguments are specified.
#'
#' @param start
#' A date value in the format 'yyyy-mm-dd' (either of Date or character class),
#' between 04/12/2018 and the present date, both inclusive. The function will retrieve
#' the conferences from that date, inclusive, until the end date, if specified,
#' or until last available, otherwise. Must be set to NULL if dates or urls
#' arguments are specified.
#'
#' @param end
#' A date value in the format 'yyyy-mm-dd' (either of Date or character class),
#' between 04/12/2018 and the present date, both inclusive. The function will retrieve
#' the conferences until that date, inclusive, from the start date, if specified,
#' or from '2020-12-04', otherwise. Must be set to NULL if dates or urls
#' arguments are specified.
#'
#' @return
#' A list containing dialog-formatted lists. Every nested list corresponds to
#' one conference, and every element of it corresponds to an intervention in
#' that conference (the name of the element corresponds to the one of the interlocutor).
#'
#' @export
#'
#' @examples
#' conferences <- text_extraction(dates = c('2020-10-17','2020-10-10'))
#' dates <- seq(lubridate::ymd('2020-10-01'),
#'              lubridate::ymd('2020-10-16'),
#'              by = 'day')
#' urls <- find_urls(dates)
#' conferences <- text_extraction(urls = urls)
#' conferences <- text_extraction(start = '2020-10-10')
#' conferences <- text_extraction(end = '2020-10-17')
#' conferences <- text_extraction(start = '2020-10-10',
#'                                end = '2020-10-17')
#' # conferences <- text_extraction()
text_extraction <- function(dates = NULL, urls = NULL, start = NULL, end = NULL) {

    bool <- FALSE
    if (!purrr::is_null(urls) & (!purrr::is_null(dates) | !purrr::is_null(start) | !purrr::is_null(end))) {
        message('Error: please define either dates (dates/start/end) or urls.')
    } else{

        if (!purrr::is_null(dates) & (!purrr::is_null(start) | !purrr::is_null(end)) & purrr::is_null(urls)) {
            message('Error: please enter either a vector of dates, or start/end dates.')
        } else{

            if (!purrr::is_null(start) & !purrr::is_null(end)) dates <- seq(lubridate::ymd(start),lubridate::ymd(end), by = 'days')
            if (!purrr::is_null(start) & purrr::is_null(end)) dates <- seq(lubridate::ymd(start),Sys.Date(), by = 'days')
            if (purrr::is_null(start) & !purrr::is_null(end)) dates <- seq(lubridate::ymd('2018-12-04'),lubridate::ymd(end), by = 'days')
            if (!purrr::is_null(dates)) urls <- find_urls(dates)
            if (!purrr::is_null(urls)) {
                urls <- c(urls)
                bool <- TRUE
            }
            if (purrr::is_null(dates) & purrr::is_null(urls) & purrr::is_null(start) & purrr::is_null(end)) urls <- find_urls()

            dialogs <- list()
            prev_date <- ''
            count <- 1

            for (url in urls){

                if (purrr::is_null(urls)) count <- 1

                tryCatch(
                    {
                        print(glue::glue('Trying to parse url: {url}'))
                        text_conf <- xml2::read_html(url) %>%
                            rvest::html_nodes('p') %>%
                            rvest::html_text() %>%
                            .[dplyr::if_else(is.na(dplyr::first(which(stringr::str_detect(stringr::str_sub(., 2, 3), '^[:upper:]+$')))),
                                             as.integer(1),
                                             dplyr::first(which(stringr::str_detect(stringr::str_sub(., 2, 3), '^[:upper:]+$')))):(dplyr::last(which(stringr::str_detect(., '---|- - -|Copyright|t.'))) - 1)] %>%
                            purrr::keep(function(x) stringr::str_length(x) > 0) %>%
                            stringr::str_remove('-')

                        if (length(which(stringr::str_detect(stringr::str_sub(text_conf, 1, 2), '^[:upper:]+$'))) == 0) {
                            idxs <- c(1)
                            text_conf[1] <- glue::glue('PRESIDENTE ANDRES MANUEL LOPEZ OBRADOR: {text_conf[1]}')
                        } else {
                            idxs <- which(stringr::str_detect(stringr::str_sub(text_conf, 1, 2), '^[:upper:]+$'))
                        }

                        out_dialog <- purrr::map2(
                            idxs, tidyr::replace_na(dplyr::lead(idxs), length(text_conf) + 1),
                            ~ glue::glue_collapse(text_conf[seq(.x, .y - 1)], '\n')
                        )

                        interlocutors <- out_dialog %>%
                            purrr::map(~ stringr::str_sub(.,
                                                          stringr::str_locate(.,'[:upper:]')[1],
                                                          stringr::str_locate(.,'[:lower:]')[1] - 3)) %>%
                            purrr::map(~ stringr::str_remove_all(.,':')) %>%
                            purrr::map(stringr::str_trim) %>%
                            purrr::map_chr(~ .)

                        names(out_dialog) <- interlocutors
                        if (!bool) {
                            date_url <- names(urls[urls == url])
                            if(prev_date == date_url) count <- count + 1
                            date_name <- paste(date_url, count, sep = '_')
                            dialogs[[date_name]] <- out_dialog
                            prev_date <- date_url
                        } else {
                            dialogs[[count]] <- out_dialog
                            count <- count + 1
                        }
                    },
                    error = function(e){
                        print(e)
                        message(glue::glue('Error: cannot read url {url}'))

                        return(list(failed_to_parse = url))
                    }
                )
            }

            suppressWarnings(closeAllConnections())
            return(dialogs)
        }
    }
}
