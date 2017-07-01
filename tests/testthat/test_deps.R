context("Package dependencies")

test_that("No subsetting gives same as full graph", {
    ## use BioCexp, as smaller/faster
    g0 <- biocpkgs:::full_pkg_dep_graph("BioCexp")
    g1 <- pkg_dep_graph(which = "BioCexp")
    expect_identical(g0, g1)
})


test_that("Graph subsetting", {
    expect_warning(gr <- pkg_dep_graph(c("msdata", "foo"),
                                       which = "BioCexp"))
    expect_identical(graph::nodes(gr), "msdata")

    g0 <- pkg_dep_graph(which = "BioCexp")
    g1 <- pkg_dep_graph("foo", which = "BioCexp")
    expect_identical(g0, g1)
})


test_that("Package deps plotting", {
    gr <- pkg_dep_graph("pRolocdata", which = "BioCexp")
    pl <- plot_pkg_dep_graph(gr, fs = 10, sz = 2)
    expect_true(inherits(pl, "Ragraph"))
})
