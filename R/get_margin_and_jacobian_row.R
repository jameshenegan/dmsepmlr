#' Get an Estimated Predictive Margin and a Row of the Jacobian Matrix for a Logistic Regression Model
#'
#' Helper function for \code{get_margins_results}.
#'
#' @param model_data The data used to fit the Logistic Regression model
#' @param betas The beta coefficients obtained from fitting the Logistic Regression model
#' @param main_effect The name of the variable corresponding to the main effect in your model.
#' @param value 0 or 1, corresponding the value of \code{main_effect} at this margin.
#' @param over A Boolean variable.  If \code{TRUE}, compute the equivalent of the Stata command \code{margins, over(var_name)}.
#' If \code{FALSE}, compute the equivalent of \code{margins var_name}.
#'
#' @return The mean of the predicted probabilities and the corresponding row of the Jacobian matrix.

get_margin_and_jacobian_row <- function(model_data, betas, main_effect, value, over){

  # The standard logistic function
  logistic <- function(x){
    exp(x)/(1+exp(x))
  }

  ############################
  # Create the prediction data
  ############################

  # Rename for clarity
  pred_dat <- model_data

  # Are we computing margins, over(variable)?

  if(over){
    # filter down to observations with the selected value
    pred_dat['_filter_var'] <- pred_dat[main_effect]
    pred_dat <- pred_dat[pred_dat$`_filter_var` == value,]
  } else {
    # just set all values of the main_effect to given value
    pred_dat[main_effect] <- value
  }

  # add an "intercept" column to our prediction data
  pred_dat["(Intercept)"] <- 1

  # order the prediction data to correspond to our beta estimates
  X <- pred_dat[names(betas)]

  # convert to a matrix
  X <- as.matrix(X)

  # convert the beta estimates to a matrix
  betas <- as.matrix(betas)

  # create our predictions on a linear scale
  linear_predictions <- X %*% betas

  # make the probabilities
  predicted_probs <- logistic(linear_predictions)

  # find the means
  predicted_mean <- mean(predicted_probs)

  # compute the Jacobian row
  dpdxb <- predicted_probs * (1-predicted_probs)
  N <- nrow(pred_dat)
  Jacobian_row <- (t(dpdxb) %*% X)/N

  # Prepare to return the results
  to_return <- list(Jacobian_row = Jacobian_row, pred_mean = predicted_mean)
  return(to_return)
}
