one_pkg_download_url <- function(pkg) {
    stopifnot(is.character(pkg) && length(pkg) == 1)
    url0 <- "https://bioconductor.org/packages/stats/bioc/"
    url <- paste0(url0, pkg, "/", pkg, "_stats.tab")
    url
}

pkg_from_url <- function(x) 
    strsplit(x, "/")[[1]][7]

##' Given one or more Bioconductor package names, 
##'
##' @title Retrieve download data
##' @param pkg A `character` with Bioconductor package names.
##' @param by Should the monthly downloads (`by = "month"`, default)
##'     or the total per years (`by = "year"`) be downloaded.
##' @param ... Additional arguments passed to
##'     [utils::download.file()].
##' @return A `tibble` with the download data.
##' @author Laurent Gatto
##' @importFrom lubridate ymd
##' @importFrom readr read_delim
##' @importFrom utils download.file
##' @export
##' @examples
##' pkg_download_data("Biobase")
##' pkg_download_data("Biobase", by = "year")
##' pkg_download_data("Biobase", by = "year", quiet = TRUE)
pkg_download_data <- function(pkg, by = c("month", "year"), ...) {
    by <- match.arg(by)
    urls <- lapply(pkg, one_pkg_download_url)
    tmp <- tempfile()
    on.exit(unlink(tmp))
    ans <- lapply(urls, function(url) {
        download.file(url, tmp, ...)
        suppressMessages(dwnl <- read_delim(tmp, delim = "\t"))
        dwnl$package <- strsplit(url, "/")[[1]][7]
        dwnl
    })
    ans <- do.call(rbind, ans)
    sel <- ans$Month == "all"
    if (by == "year") {
        ans <- ans[sel, ]
        ans$Date <- strptime(ans$Year, "%Y")
    } else { ## by month
        ans <- ans[!sel, ]
        ans$Date <-
            strptime(paste(1, ans$Month, ans$Year),
                     "%d %b %Y")
    }
    ans$Date <- ymd(ans$Date) ## to make tibbles work with dplyr
    ans
}
