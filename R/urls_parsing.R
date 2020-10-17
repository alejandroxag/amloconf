urls_parsing <- function(page){

    if (!is.numeric(page)) stop('Please provide an integer value for page argument.')

    tryCatch(
        {
            url <- glue::glue('https://presidente.gob.mx/secciones/version-estenografica/page/{page}/')
            if (page == 1) url <- 'https://presidente.gob.mx/secciones/version-estenografica/'

            html <- xml2::read_html(url) %>%
                rvest::html_nodes('h2')

            dates <- html %>%
                rvest::html_text() %>%
                stringr::str_sub(1,8) %>%
                lubridate::dmy()

            urls_list <- html %>%
                purrr::map(rvest::html_children) %>%
                purrr::map(rvest::html_attrs) %>%
                purrr::set_names(dates) %>%
                unlist() %>%
                purrr::set_names(stringr::str_remove(names(.),'.href'))

            suppressWarnings(closeAllConnections())

            return(urls_list)
        },
        error = function(cond) {
            message('Page not found.')
            message(cond)
        }
    )



}
