#' Get an Estimate Based on Computed Marginal Probabilities
#'
#' Use marginal probabilities to compute either the risk difference, risk ratio, or odds ratio.
#'
#' @param estimate_type One of either "risk_difference", "risk_ratio", or "odds_ratio".
#' @param p0 The marginal probability corresponding to the case where the main effect equals 0.
#' @param p1 The marginal probability corresponding to the case where the main effect equals 1.
#' @param sigma_margins The variance-covariance matrix for the margins \code{p0} and \code{p1}.
#'
#' @return The requested estimate and its standard error.

get_estimate_and_se <- function(estimate_type, p0, p1, sigma_margins){
  estimate <-
    switch(estimate_type,
           "risk_ratio" = p1/p0,
           "odds_ratio" = (p1/(1-p1))/(p0/(1-p0)),
           "risk_difference" = p1 - p0)
  dgdp <-
    switch(estimate_type,
           "risk_ratio" = list(dgdp0 =  -p1/p0^2, dgdp1 = 1/p0),
           "odds_ratio" = list(dgdp0 = -p1/((1-p1)*p0^2), dgdp1 = (1-p0)/((p0)*(1-p1)^2)),
           "risk_difference" = list(dgdp0 = 1, dgdp1 = -1))

  gradient <- matrix(data = c(dgdp$dgdp0, dgdp$dgdp1), nrow = 1)
  se <- sqrt(gradient %*% sigma_margins %*% t(gradient))
  se <- se[1,1]
  return(list(estimate = estimate, se = se))
}
