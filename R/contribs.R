##' These functions extract information about package contributors.
##'
##' @title Getting package contributors
##' @param pkg The name of the package.
##' @return An instance of class `person` or the `character` with the
##'     author information and a warning (`contribs`) or an error
##'     (other functions) when `Authors@R` is not present in the
##'     package's `DESCRIPTION`. For `ncontribs` an `integer`.
##' @author Laurent Gatto
##' @export
##' @importFrom utils packageDescription
##' @examples
##' contribs("MSnbase")
##' contribs("Biobase")
##' ncontribs("MSnbase")
##' pkgcre("MSnbase")
##' ## same as
##' pkgrole("MSnbase", "cre")
##' pkgaut("rols")
##' ## same as
##' pkgrole("rols", "aut")
contribs <- function(pkg) {
    authr <- packageDescription(pkg)[["Authors@R"]]
    if (!is.null(authr)) eval(parse(text = authr))
    else {
        warning("Authors@R not available for ", pkg)        
        packageDescription("Biobase")[["Author"]]
    }
}

##' @rdname contribs
##' @export
ncontribs <- function(pkg) {
    stopifnot(inherits(suppressWarnings(x <- contribs(pkg)), "person"))
    length(x)
}

##' @rdname contribs
##' @param role. The role to be searched for. See `?person` for
##'     details.
##' @export
pkgrole <- function(pkg, role.) {
    stopifnot(inherits(suppressWarnings(x <- contribs(pkg)), "person"))    
    p <- contribs(pkg)
    i <- which(sapply(p, function(x) role. %in% x$role))
    p[i]
}

##' @rdname contribs
##' @export
pkgaut <- function(pkg) 
    pkgrole(pkg, "aut")

##' @rdname contribs
##' @export
pkgcre <- function(pkg) 
    pkgrole(pkg, "cre")

