##' This function returns the current release and devel Bioconductor
##' version numbers by parsing the
##' \code{"http://www.bioconductor.org/js/versions.js"} page.
##'
##' @title Bioconductor version numbers
##' @return A named \code{character} of length two with the
##'     \code{release} and \code{devel} version numbers (in that
##'     order).
##' @author Laurent Gatto
##' @export
##' @examples
##' biocVersions()
biocVersions <- function() {
    v <- readLines("http://www.bioconductor.org/js/versions.js")[1:2]
    v <- gsub("^.+= *\\\"([[:digit:]]+\\.[[:digit:]]+)\\\";", "\\1", v)
    v <- sort(v)
    names(v) <- c("release", "devel")
    v
}


##' A set of functions to retrieve the version number from packages
##' available in Bioconductor or on Github. The version numbers are
##' extracted from the Bioconductor package landing page and the
##' Github master branch, irrespective or the package's local
##' version or availability.
##'
##' @title Gets the package version numbers
##' @param pkg The name of the package(s) or, for `githubpkgversion`,
##'     if `user` is `NULL` (default) the username and pkg formatted
##'     as `"user/package"`.
##' @param which Either of `"release"` (default) or `"devel"`.
##' @param ... additional parameters passed to `sapply`, in particular
##'     `simplify` (default is `TRUE`) and `USE.NAMES` (default is
##'     `TRUE`).
##' @param type One of `"software"`, `"experiment"` or `"annotation"`,
##'     defining the type of Bioconductor package is to be queried.
##' @return A `vector` of length equal to the length of `pkg`
##'     containing the respective version numbers. By default, the
##'     return value is named (`USE.NAMES = TRUE`) and simplified to a
##'     `character` vector (`simplify = TRUE`).
##' @author Laurent Gatto
##' @export
##' @md
##' @rdname pkgversion
##' @examples
##' biocpkgversion("MSnbase", "release")
##' biocpkgversion("MSnbase", USE.NAMES = FALSE)
##' biocpkgversion("MSnbase", "devel")
##' biocpkgversion(c("MSnbase", "pRoloc"))
##' biocpkgversion(c("MSnbase", "pRoloc"), USE.NAMES = FALSE)
##' githubpkgversion("lgatto/MSnbase")
##' githubpkgversion("MSnbase", "lgatto")
##' githubpkgversion("lgatto/MSnbase", USE.NAMES = FALSE)
##' githubpkgversion(c("lgatto/MSnbase", "lgatto/pRoloc"))
##' cranpkgversion(c("sequences", "MALDIquant"))
biocpkgversion <- function(pkg, which = c("release", "devel"),
                           type = c("software", "experiment",
                                    "annotation"), ...) {
    which <- match.arg(which)
    type <- match.arg(type)
    urls <- switch(type,
                   software = paste0("https://bioconductor.org/packages/",
                                     which, "/bioc/html/", pkg, ".html"),
                   experiment = paste0("https://bioconductor.org/packages/",
                                       which , "/data/experiment/html/", pkg,
                                       ".html"),
                   annotation = paste0("https://bioconductor.org/packages/",
                                       which, "/data/annotation/html/", pkg,
                                       ".html"))           
    sapply(urls,
           function(url) {
               x <- tryCatch(readLines(url), error = function(e) {
                   warning("Package URL not found.")
                   return(NULL)
               })
               if (is.null(x)) {
                   v <- NA
               } else {
                   v <- x[grep("Version", x) + 1]
                   v <- sub("^ +<td>([0-9\\.]+)</td>", "\\1", v, fixed = FALSE)
               }
               return(v)               
           }, ...)
    }

##' @rdname pkgversion
##' @export
##' @param user the Github user or organisation where to find the
##'     package repository. Default is `NULL` and ignored. Otherwise,
##'     the packge name is constructed by concatenating to
##'     `"user/pkg"`.
githubpkgversion <- function(pkg, user = NULL, ...) {
    if (!is.null(user))
        pkg <- paste(user, pkg, sep = "/")
    urls <- paste0("https://raw.githubusercontent.com/", pkg,
                  "/master/DESCRIPTION")
    sapply(urls,
           function(url) {
               x <- readLines(url)
               v <- x[grep("Version", x)]
               sub("Version: ", "", v)
           }, ...)
}

##' @rdname pkgversion
##' @export
cranpkgversion <- function(pkg, ...) {
    urls <- paste0("https://cran.r-project.org/package=", pkg)

    sapply(urls,
           function(url) {
               x <- readLines(url)
               v <- x[grep("Version", x) + 1]
               sub("^ *<td>([0-9\\.]+)</td>", "\\1", v, fixed = FALSE)               
           }, ...)    

}
