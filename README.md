
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dmsepmlr

<!-- badges: start -->

<!-- badges: end -->

**D**elta **M**ethod **S**tandard **E**rrors for various quantities
related to the **P**redictive **M**argins of a **L**ogistic
**R**egression model with a binary main effect and any number of
adjustors.

This package estimates predictive margins, along with their delta method
standard errors, for a logistic regression model having a binary main
effect and any number of adjustors. The margins are then used to produce
additional estimates, including an “adjusted risk difference” and an
“adjusted risk ratio.”

## Installation

You can install the development version of dmsepmlr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jameshenegan/dmsepmlr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(dmsepmlr)
library(haven)
dat <- read_dta("http://www.stata-press.com/data/r13/margex.dta")
logMarginsResults <- logisticMargins(formula = outcome ~ treatment + distance,
                                     main_effect = "treatment",
                                     over = FALSE,
                                     data = dat)
logMarginsResults
#>          Quantity   Estimate Delta Method SE
#> 1       MargProb0 0.07911464     0.006945569
#> 2       MargProb1 0.26002036     0.011177181
#> 3 RiskDiff(p1-p0) 0.18090571     0.013168386
#> 4  RelRisk(p1/p0) 3.28662743     0.321460859
#> 5       OddsRatio 4.09012207     0.456920235
```
