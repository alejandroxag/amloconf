#' URLs Parsing
#'
#' The website https://presidente.gob.mx/secciones/version-estenografica/
#' stores the URLs pointing to the stenographic versions of the presidential
#' conferences in several pages.
#' URLs stored in the page n, will be retrieved from the URL
#' https://presidente.gob.mx/secciones/version-estenografica/page/n/
#'
#' @param page
#' An numeric value to be passed to call
#' glue::glue('https://presidente.gob.mx/secciones/version-estenografica/page/\{page\}/').

#'
#' @return urls_list, a character vector containing all the urls stored in the selected page.
#' @export urls_parsing
#' @examples
#' # To retrieve all the URLs located in the page five in
#' # 'https://presidente.gob.mx/secciones/version-estenografica/page/5/',
#' # call:
#'
#' urls_parsing(5)

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

            return(urls_list)
        },
        error = function(cond) {
            message('Page not found.')
            message(cond)
        }
    )
    suppressWarnings(closeAllConnections())
}
