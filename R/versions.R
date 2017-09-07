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
##' version of availability.
##'
##' @title Gets the package version numbers
##' @param pkg The name of the package(s) or, for `githubpkgversion`,
##'     the username and pkg formatted as `"user/package"`.
##' @param which Either of `"release"` (default) or `"devel"`.
##' @param ... additional parameters passed to `sapply`, in particular
##'     `simplify` (default is `TRUE`) and `USE.NAMES` (default is
##'     `TRUE`).
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
##' githubpkgversion("lgatto/MSnbase", USE.NAMES = FALSE)
##' githubpkgversion(c("lgatto/MSnbase", "lgatto/pRoloc"))
biocpkgversion <- function(pkg, which = c("release", "devel"), ...) {
    which <- match.arg(which)
    urls <- paste0("https://bioconductor.org/packages/", which,
                  "/bioc/html/", pkg, ".html")
    sapply(urls,
           function(url) {
               x <- readLines(url)
               v <- x[grep("Version", x) + 1]
               sub("^ +<td>([0-9\\.]+)</td>", "\\1", v, fixed = FALSE)
           }, ...)
}

##' @rdname pkgversion
##' @export
githubpkgversion <- function(pkg, ...) {
    urls <- paste0("https://raw.githubusercontent.com/", pkg,
                  "/master/DESCRIPTION")
    sapply(urls,
           function(url) {
               x <- readLines(url)
               v <- x[grep("Version", x)]
               sub("Version: ", "", v)
           }, ...)
}
