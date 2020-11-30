context("01-Predictive Margins")

library(dmsepmlr)
library(haven)

dat <- read_dta("http://www.stata-press.com/data/r13/margex.dta")
fit <- fit_logistic_model(formula = outcome ~ treatment + distance, data = dat)
betas <- fit$betas
sigma <- fit$sigma
margins <- get_margins(model_data = dat, betas = betas, sigma = sigma, main_effect = "treatment", over = FALSE)

test_that("predictive margins are correct", {
  expect_equal(margins$p0, .0791146, tolerance=1e-6)
  expect_equal(margins$p1, .2600204, tolerance=1e-6)
})

test_that("standard errors for predictive margins are correct", {
  expect_equal(margins$se0, .0069456, tolerance=1e-6)
  expect_equal(margins$se1, .0111772, tolerance=1e-6)
})
