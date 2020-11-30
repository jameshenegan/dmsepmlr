
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

## Example 1

In this example, we will look at a simulated epidemiological dataset
(containing `N=10000` observations) where each observation contains
information on a subject’s `death` status, `disease` status, and `age`.

``` r
library(dmsepmlr); data(epiDat); head(epiDat)
#>   death disease   age
#> 1     0       0 42.38
#> 2     0       0 52.29
#> 3     0       0 63.67
#> 4     0       0 48.65
#> 5     0       0 18.96
#> 6     0       0 86.83
```

Suppose we wish to consider the following model:

``` r
glm(formula = death ~ disease + age,
    family=binomial(link = "logit"),
    data = epiDat)
#> 
#> Call:  glm(formula = death ~ disease + age, family = binomial(link = "logit"), 
#>     data = epiDat)
#> 
#> Coefficients:
#> (Intercept)      disease          age  
#>    -9.32354      0.63888      0.08159  
#> 
#> Degrees of Freedom: 9999 Total (i.e. Null);  9997 Residual
#> Null Deviance:       1129 
#> Residual Deviance: 878.4     AIC: 884.4
```

Then we may use `dmsepmlr::logisticMargins` to obtain the predictive
margins associated with disease values of `0` and `1`, along with
related estimates, for this model as follows:

``` r
logisticMargins(formula = death ~ disease + age,
                main_effect = "disease",
                over = FALSE,
                data = epiDat)
#>          Quantity    Estimate Delta Method SE
#> 1       MargProb0 0.009740075    0.0009832863
#> 2       MargProb1 0.017642796    0.0059259127
#> 3 RiskDiff(p1-p0) 0.007902722    0.0060069545
#> 4  RelRisk(p1/p0) 1.811361504    0.6352947138
#> 5       OddsRatio 1.825933276    0.6514774210
```

Note that

  - the first row of the output provides the predictive margin
    associated with disease value of `0`,
  - the second row of the output provides the predictive margin
    associated with disease value of `1`,
  - the third row of the output provides the risk difference between
    these two margins,
  - the fourth row of the output provides the risk ratio for two
    margins, and
  - the fifth row of the output provides the odds ratio for two margins.

## Comparison with Stata’s `margins` command

Suppose that we have `epiDat` loaded into Stata. Then running `logistic
death i.disease age` followed by `margins disease` would produce the
following results:

    ------------------------------------------------------------------------------
                 |            Delta-method
                 |     Margin   Std. Err.      z    P>|z|     [95% Conf. Interval]
    -------------+----------------------------------------------------------------
         disease |
              0  |   .0097401   .0009833     9.91   0.000     .0078129    .0116673
              1  |   .0176428   .0059259     2.98   0.003     .0060282    .0292574
    ------------------------------------------------------------------------------

Meanwhile, running `lincom _b[1.disease] - _b[0.disease]` would give us
the following:

    ------------------------------------------------------------------------------
                 |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
    -------------+----------------------------------------------------------------
             (1) |   .0079027    .006007     1.32   0.188    -.0038707    .0196761
    ------------------------------------------------------------------------------

Also, running `nlcom (RR: _b[1.disease] / _b[0.disease])` would give us
the following:

    ------------------------------------------------------------------------------
                 |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
    -------------+----------------------------------------------------------------
              RR |   1.811361   .6352954     2.85   0.004     .5662054    3.056517
    ------------------------------------------------------------------------------

Finally, running

    nlcom (OR: (_b[1.disease]/(1-_b[1.disease])) ///
             / (_b[0.disease]/(1-_b[0.disease])) ///
          )

would produce

    ------------------------------------------------------------------------------
                 |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
    -------------+----------------------------------------------------------------
              OR |   1.825933   .6514781     2.80   0.005     .5490597    3.102807
    ------------------------------------------------------------------------------

We see that these results closely resemble the results we obtained from
our `logisticMargins` command.

## Example 2

In this example, we use the same data and the same logistic model as
above.

Now suppose that we ran the following command in Stata

    margins, over(disease)

In this case, we would obtain the following results:

    ------------------------------------------------------------------------------
                 |            Delta-method
                 |     Margin   Std. Err.      z    P>|z|     [95% Conf. Interval]
    -------------+----------------------------------------------------------------
         disease |
              0  |   .0097077   .0009798     9.91   0.000     .0077874    .0116281
              1  |   .0190476   .0064454     2.96   0.003     .0064149    .0316804
    ------------------------------------------------------------------------------

We can obtain these results from `dmsepmlr::logisticMargins` by setting
the `over` option to `TRUE`:

``` r
logisticMargins(formula = death ~ disease + age,
                main_effect = "disease",
                over = TRUE,
                data = epiDat)
#>          Quantity    Estimate Delta Method SE
#> 1       MargProb0 0.009707724    0.0009797998
#> 2       MargProb1 0.019047619    0.0064453915
#> 3 RiskDiff(p1-p0) 0.009339895    0.0065194386
#> 4  RelRisk(p1/p0) 1.962109575    0.6928495929
#> 5       OddsRatio 1.980791314    0.7124808464
```
