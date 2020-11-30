#' Get the Odds Ratio using the Beta Estimate
#'
#' If \code{beta_mar_var} is the Beta Estimate for the marginal variable \code{mar_var}
#' obtained after fitting a Logistic regression model, then this function returns
#' the Odd Ratio obatined by exponentiating this Beta Estimate: \code{epx(beta_mar_var)}.
#' For reference, this is the the Odds Ratio that would be obtained
#' by using the \code{logistic} command in Stata( \code{logistic outcome mar_var ...}).
#'
#' @param betas The beta coefficients obtained from fitting the Logistic Regression model
#' @param sigma The variance-covariance matrix obtained from fitting the Logistic Regression model
#' @param main_effect The variable name of the main effect in your model.


get_or_from_beta <- function(betas, sigma, main_effect){
  beta_estimate <- betas[main_effect]
  odds_ratio <- exp(beta_estimate)
  var_beta <- sigma[main_effect, main_effect]
  se <- sqrt(odds_ratio^2 * var_beta)
  to_return <- list(odds_ratio = unname(odds_ratio), se = unname(se))
  return(to_return)
}

