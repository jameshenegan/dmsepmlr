#' Perform marginal analysis for a logistic regression model
#'
#' For a logistic regression model with a binary main effect, obtain predicitive margins
#' along with their corresponding risk ratio, relative risk, odds ratio, and standard errors.
#'
#' @param formula The formula for the logistic regression model
#' @param main_effect The variable name of the main effect in your model.
#' @param over A Boolean variable.  If \code{TRUE}, compute the equivalent of the Stata command \code{margins, over(var_name)}.
#' If \code{FALSE}, compute the equivalent of \code{margins var_name}.
#' @param data The data that will be used to fit the logistic regression model.
#'
#' @return A \code{data.frame} containing the predictive margins, a risk ratio, a relative risk, an odds ratio, and their standard errors.
#' @export

logisticMargins <- function(formula, main_effect, over, data){

  # Fit the logistic model
  fit <- fit_logistic_model(formula = formula, data = data)

  # Destructure the results
  betas <- fit$betas
  sigma <- fit$sigma

  # Obtain the predictive margins
  margins <- get_margins(model_data = data,
                         betas = betas,
                         sigma = sigma,
                         main_effect = main_effect,
                         over = over)

  # Destructure the results
  p1 <- margins$p1
  p0 <- margins$p0
  sigma_margins <- margins$sigma_margins

  # Get estimates using predictive margins
  diff_results <- get_estimate_and_se("risk_difference", p0, p1 ,sigma_margins)
  ratio_results <- get_estimate_and_se("risk_ratio", p0, p1 ,sigma_margins)
  odds_ratio_results_delta <- get_estimate_and_se("odds_ratio", p0, p1 ,sigma_margins)

  # Get estimates using beta coefficients
  odds_ratio_results <- get_or_from_beta(betas = betas,
                                         sigma = sigma,
                                         main_effect = main_effect)

  # Organize All of the Results
  logisticMarginsList = list(
    margins = margins,
    diff_results = diff_results,
    ratio_results = ratio_results,
    odds_ratio_results = odds_ratio_results,
    odds_ratio_results_delta = odds_ratio_results_delta
  )

  # Prepare some labels for the result
  labels <- c(
    "MargProb0",
    "MargProb1",
    "RiskDiff(p1-p0)",
    "RelRisk(p1/p0)",
    "OddsRatio"
  )

  # Organize the estimates
  estimates <- c(
    logisticMarginsList$margins$p0,
    logisticMarginsList$margins$p1,
    logisticMarginsList$diff_results$estimate,
    logisticMarginsList$ratio_results$estimate,
    logisticMarginsList$odds_ratio_results_delta$estimate
  )

  # Organize the standard errors
  std_errs <- c(
    logisticMarginsList$margins$se0,
    logisticMarginsList$margins$se1,
    logisticMarginsList$diff_results$se,
    logisticMarginsList$ratio_results$se,
    logisticMarginsList$odds_ratio_results_delta$se
  )

  dat <- data.frame(labels, estimates, std_errs)
  colnames(dat) <- c("Quantity", "Estimate", "Delta Method SE")
  return(dat)
}
