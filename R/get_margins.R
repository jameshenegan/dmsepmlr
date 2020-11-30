#' Get Marginal Probabilities for a Logistic Regression Model
#'
#' For a logistic regression model that includes one main effect
#' and zero or more adjustors, obtain marginal probalities for
#' the outcome variable with respect to the main effect.
#' This reproduces the behavior of running \code{margins x} after
#' fitting the logistic regression model in Stata.
#'
#' @param model_data The data used to fit the Logistic Regression model
#' @param betas The beta coefficients obtained from fitting the Logistic Regression model
#' @param sigma The variance-covariance matrix obtained from fitting the Logistic Regression model
#' @param main_effect The name of the variable corresponding to the main effect in your model.
#' @param over A Boolean variable.  If \code{TRUE}, compute the equivalent of the Stata command \code{margins, over(var_name)}.
#' If \code{FALSE}, compute the equivalent of \code{margins var_name}.
#'
#' @return The marginal probabilities, their standard errors, and their variance-covariance matrix.

get_margins <- function(model_data, betas, sigma, main_effect, over){

  # model_data, betas, main_effect, value, over
  # Get the rows of the Jacobian matrix along with marginal probabilities
  results0 <- get_margin_and_jacobian_row(model_data, betas, main_effect, 0, over)
  results1 <- get_margin_and_jacobian_row(model_data, betas, main_effect, 1, over)

  # Make the Jacobian Matrix
  Jacobian <- rbind(results0$Jacobian_row, results1$Jacobian_row)

  # Get the Variance-Covariance matrix for the predicted probabilities
  sigma_margins <- Jacobian %*% sigma %*% t(Jacobian)

  # Prepare results for response

  # Marginal probability for variable == 0
  p0 <- results0$pred_mean
  # Marginal probability for variable == 1
  p1 <- results1$pred_mean

  # Standard Error for variable == 0
  se0 <- sqrt(sigma_margins[1,1])
  # Standard Error for variable == 1
  se1 <- sqrt(sigma_margins[2,2])

  to_return <- list(
    p0 = p0,
    se0 = se0,
    p1 = p1,
    se1 = se1,
    sigma_margins = sigma_margins
  )

  return(to_return)
}

