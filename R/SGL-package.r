#' Dates and times made easy with lubridate.
#'
#' Lubridate provides tools that make it easier to parse and 
#' manipulate dates. These tools are grouped below by common 
#' purpose. More information about each function can be found in 
#' its help documentation.
#'
#' Parsing dates
#'
#' Lubridate's parsing functions read strings into R as POSIXct 
#' date-time objects. Users should choose the function whose name 
#' models the order in which the year ('y'), month ('m') and day 
#' ('d') elements appear the string to be parsed: 
#' \code{\link{dmy}}, \code{\link{myd}}, \code{\link{ymd}}, 
#' \code{\link{ydm}}, \code{\link{dym}}, \code{\link{mdy}}, 
#' \code{\link{ymd_hms}}). 
#' 
#' ...
#' 
#' @references Garrett Grolemund, Hadley Wickham (2011). Dates and Times
#'   Made Easy with lubridate. Journal of Statistical Software, 40(3),
#'   1-25. \url{http://www.jstatsoft.org/v40/i03/}.
#' @docType package
#' @name SGL
NULL