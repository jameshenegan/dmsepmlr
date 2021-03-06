% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_estimate_and_se.R
\name{get_estimate_and_se}
\alias{get_estimate_and_se}
\title{Get an Estimate Based on Computed Marginal Probabilities}
\usage{
get_estimate_and_se(estimate_type, p0, p1, sigma_margins)
}
\arguments{
\item{estimate_type}{One of either "risk_difference", "risk_ratio", or "odds_ratio".}

\item{p0}{The marginal probability corresponding to the case where the main effect equals 0.}

\item{p1}{The marginal probability corresponding to the case where the main effect equals 1.}

\item{sigma_margins}{The variance-covariance matrix for the margins \code{p0} and \code{p1}.}
}
\value{
The requested estimate and its standard error.
}
\description{
Use marginal probabilities to compute either the risk difference, risk ratio, or odds ratio.
}
