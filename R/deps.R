full_pkg_dep_graph <- function(which = c("BioCsoft", "BioCann", "BioCexp", "CRAN")) {
    which <- match.arg(which)
    biocUrl <- BiocInstaller::biocinstallRepos()[which]
    pkgDepTools::makeDepGraph(biocUrl, type = "source", dosize = FALSE)
}

subset_pkg_dep_graph <- function(pkgs, g) {
    deps <- unlist(sapply(graph::acc(g, pkgs), names))
    pkgs <- unique(c(pkgs, deps))
    graph::subGraph(pkgs, g)
}

##' This function takes a list of packages and build the their
##' dependency graph using all packages of a repository (for example
##' all Bioconductor software or CRAN packages). The packages of
##' interest and all their dependencies are used to create the graph.
##'
##' @title Build the package dependency graph
##' @param pkgs The name of the package(s) to plot the dependency
##'     graph of.
##' @param which What package repository to use to calculate
##'     dependency graphs. One of `"BioCsoft"`(default, Bioconductor
##'     software packages), `"BioCann"` (Bioconductor annotation
##'     packages), `"BioCexp"` (Bioconductor experiment packages) or
##'     `"CRAN"` (CRAN packages).
##' @return An object of class `graphNEL`
##' @export
##' @author Laurent Gatto
##' @examples
##' ## pp <- RforProteomics::proteomicsPackages()
##' ppn <- rownames(pp)
##' ppn <- ppn[1:20]
##' g <- pkg_dep_graph(pkgs = ppn)
##' plot_dep_graph(g, pkgs = ppn, fs = "75")
pkg_dep_graph <- function(pkgs,
                          which = c("BioCsoft", "BioCann", "BioCexp", "CRAN")) {
    g <- full_pkg_dep_graph(which)
    if (!missing(pkgs) & is.character(pkgs))
        g <- subset_pkg_dep_graph(pkgs, g)
    return(g)
}


##' @export
set_graph_pars <- function()
    graph.par(list(edges = list(col = "grey", lty = "dotted", lwd = .5),
                   nodes = list(lwd = .5, cex = 5, fontsize = 2, cex = 1)))

##' @export
set_edge_colours <- function(gr, pkgs, colour = "steelblue", 
                             names = FALSE) {
    if (length(colour) > 1) stopifnot(is.list(pkgs))
    else pkgs <- list(pkgs)
    stopifnot(length(pkgs) == length(colour))
    x <- nodes(gr)
    ans <- rep("white", length(x))
    for (i in seq_along(pkgs)) {
        .col <- colour[i]
        .pkgs <- pkgs[[i]]
        ans[x %in% .pkgs] <- .col
    }
    ## ans[x %in% mypks] <- "red"
    if (names) names(ans) <- x
    ans
}

##' @export
plot_pkg_dep_graph <- function(gr, sz = 20, fs = "95",
                               pkgs, colour = "steelblue",
                           edge_colour = "#00000040") {
    if (missing(pkgs)) {
        nn <- makeNodeAttrs(gr,
                            height = sz, width = sz,
                            fontsize = fs)
    } else {
        nn <- makeNodeAttrs(gr,
                            height = sz, width = sz,
                            fontsize = fs,
                            fillcolor = set_edge_colours(gr, pkgs, colour))
    }
    plot(gr, nodeAttrs = nn,
         attrs = list(edge = list(color = edge_colour)))

}




## gr <- graph_from_graphnel(g)
## igraph_layouts <- 'fr'
## lout <- create_layout(gr, layout = i)
## lout$my <- lout$name %in% ppn
## p <- ggraph(lout) +
##     geom_edge_link(arrow = arrow()) +
##     geom_node_point(aes(colour = my, alpha = 0.5), size = 10) +
##     ggtitle(paste0('Layout: ', i)) + 
##     theme_graph(foreground = 'steelblue', fg_text_colour = 'white')
## plot(p)
