

test_that("Package contributors", {
    expect_warning(x <- contribs("Biobase"))
    expect_true(inherits(x, "character"))
    expect_true(length(x) == 1L)
    expect_error(ncontribs("Biobase"))
    
    x <- contribs("MSnbase")
    expect_true(inherits(x, "person"))
    expect_identical(length(x), ncontribs("MSnbase"))
    expect_identical(pkgaut("MSnbase"), pkgcre("MSnbase"))

    expect_identical(pkgaut("MSnbase"), pkgrole("MSnbase", "aut"))
    expect_identical(pkgcre("MSnbase"), pkgrole("MSnbase", "cre"))
})
