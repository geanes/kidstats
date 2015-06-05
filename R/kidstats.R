#' kidstats: Shiny application to make sub-adult age and sex estimations.
#'
#' \code{kidstats} Shiny application to make sub-adult age and sex estimations
#' based on long-bone measurements using MARS models.
#'
#' @details
#' This package contains the following datasets:
#' \itemize{
#'   \item \code{salb_za}: Sub-adult long bone length measurements
#'    (South Africa)
#' }
#'
#' and the following functions:
#' \itemize{
#'   \item \code{kidstats}: Runs the kidstats shiny app.
#' }
#'
#' @docType package
#' @name kidstats
NULL

#' @import shiny
NULL

#' Kidstats shiny app call
#' @examples
#' kidstats()
#' @export
kidstats <- function(){
  shiny::runApp(system.file('ksapp', package = 'kidstats'), launch.browser = TRUE)
}
