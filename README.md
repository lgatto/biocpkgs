---
output:
  md_document:
    variant: markdown_github
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



# The `biocdownloads` package

The goal of `biocdownloads` is to download Bioconductor packages
download data.

## Installation


```r
library("devtools")
install_github("lgatto/biocdownloads")
```

## Example


```r
library("biocdownloads")
dl <- pkg_download_data(c("MSnbase", "rpx"))
dl
#> # A tibble: 132 x 6
#>     Year Month Nb_of_distinct_IPs Nb_of_downloads package       Date
#>    <int> <chr>              <int>           <int>   <chr>     <date>
#>  1  2017   Jan                684            1209 MSnbase 2017-01-01
#>  2  2017   Feb                660            1152 MSnbase 2017-02-01
#>  3  2017   Mar                705            1452 MSnbase 2017-03-01
#>  4  2017   Apr                697            1407 MSnbase 2017-04-01
#>  5  2017   May               1087            2040 MSnbase 2017-05-01
#>  6  2017   Jun                805            1445 MSnbase 2017-06-01
#>  7  2017   Jul                  0               0 MSnbase 2017-07-01
#>  8  2017   Aug                  0               0 MSnbase 2017-08-01
#>  9  2017   Sep                  0               0 MSnbase 2017-09-01
#> 10  2017   Oct                  0               0 MSnbase 2017-10-01
#> # ... with 122 more rows
```


```r
library("ggplot2")
ggplot(dl, aes(x = Date, y = Nb_of_distinct_IPs,
                group = package, colour = package)) + geom_line()
```

![plot of chunk plotex](README-plotex-1.png)
