#' Fit a Logistic Regression Model
#'
#' A helper function used to fit a logistic regression model.
#'
#' @param formula The formula for the model.
#' @param data The data that will be used to fit the model.
#' @return The beta coefficients and the variance-covariance matrix for the model fit.
#'

fit_logistic_model <- function(formula, data){
  fit <- stats::glm(formula = formula, family = "binomial", data = data)

  model_data <- fit$data
  betas <- fit$coefficients
  sigma <- stats::vcov(fit)

  to_return = list(
    betas = betas,
    sigma = sigma
  )

  return(to_return)
}
