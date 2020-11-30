context("03-Logistic Margins")

library(dmsepmlr)
library(haven)


dat <- read_dta("http://www.stata-press.com/data/r13/margex.dta")


logMarginsResults <- logisticMargins(formula = outcome ~ treatment + distance,
                                     main_effect = "treatment",
                                     over = FALSE,
                                     data = dat)

labels <- factor(c(
  "MargProb0",
  "MargProb1",
  "RiskDiff(p1-p0)",
  "RelRisk(p1/p0)",
  "OddsRatio"
))

estimates <-
  c(
    0.07911464,
    0.26002036,
    0.18090571,
    3.28662743,
    4.09012207
  )

stdErrs <-
  c(
    0.006945569,
    0.011177181,
    0.013168386,
    0.321460859,
    0.456920235
  )


test_that("display appears as it should", {
  expect_equal(logMarginsResults$Quantity, labels)
  expect_equal(logMarginsResults$Estimate, estimates)
  expect_equal(logMarginsResults$`Delta Method SE`, stdErrs)
})
