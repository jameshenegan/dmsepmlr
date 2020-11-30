context("02-Combinations (linear and nonlinear)")

library(dmsepmlr)
library(haven)

dat <- read_dta("http://www.stata-press.com/data/r13/margex.dta")
fit <- fit_logistic_model(outcome ~ treatment + distance, data = dat)
betas <- fit$betas
sigma <- fit$sigma
margins_results <- get_margins(model_data = dat, betas = betas, sigma = sigma, main_effect = "treatment", over = FALSE)

difference_results <- get_estimate_and_se("risk_difference",
                                          margins_results$p0,
                                          margins_results$p1,
                                          sigma = margins_results$sigma_margins
)

ratio_results <- get_estimate_and_se("risk_ratio",
                                     margins_results$p0,
                                     margins_results$p1,
                                     sigma = margins_results$sigma_margins
)

or_results <- get_estimate_and_se("odds_ratio",
                                  margins_results$p0,
                                  margins_results$p1,
                                  sigma = margins_results$sigma_margins
)


test_that("risk difference is correct", {
  expect_equal(difference_results$estimate,  .1809057, tolerance=1e-6)
  expect_equal(difference_results$se, .0131684, tolerance=1e-6)
})


test_that("risk ratio is correct", {
  expect_equal(ratio_results$estimate,   3.286627, tolerance=1e-6)
  expect_equal(ratio_results$se,  .321461 , tolerance=1e-6)
})


test_that("odds ratio is correct", {
  expect_equal(or_results$estimate,    4.090122 , tolerance=1e-6)
  expect_equal(or_results$se,  .4569205  , tolerance=1e-6)
})
