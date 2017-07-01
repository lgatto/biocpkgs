test_that("url to/from package", {
    pkg0 <- "MSnbase"
    url <- biocpkgs:::one_pkg_download_url(pkg0)
    pkg <- biocpkgs:::pkg_from_url(url)
    expect_identical(pkg, pkg0)
})

test_that("monthy download data", {
    pkgs <- c("MSnbase", "rols")
    xy <- pkg_download_data(pkgs, quiet = TRUE)
    x <- pkg_download_data(pkgs[1], quiet = TRUE)
    y <- pkg_download_data(pkgs[2], quiet = TRUE)
    expect_identical(xy, rbind(x, y))
})

test_that("yearly download data", {
    pkgs <- c("MSnbase", "rols")
    xy <- pkg_download_data(pkgs, by = "year", quiet = TRUE)
    x <- pkg_download_data(pkgs[1], by = "year", quiet = TRUE)
    y <- pkg_download_data(pkgs[2], by = "year", quiet = TRUE)
    expect_identical(xy, rbind(x, y))
})
