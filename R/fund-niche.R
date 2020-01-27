#-------------------------------------------------------------

#' @title Fundamental Niche

#' @description Calculates the \code{n}-dimensional fundamental niche at \code{m}
#' coordinates in niche space.
#'
#' @param niche.coords A \code{m}-by-\code{n} matrix of niche coordinates.
#' @param species Ordered list of: maximum finite rate of increase, a means vector, and
#' variance-covariance matrix that together define the fundamental niche of the
#' species.
#'
#' @details Fundamental niche values are calculated on the basis of a multi-variate
#' normal distribution, and hence are unimodal and convex in shape.  The
#' \code{niche.coords} can either be coordinates of specific interest, such as for
#' mapping niche suitability for a study area, or for visualisation in niche space a grid
#' of systematic coordinates as can be generated using
#' \code{\link{niche.grid.coords}}.  The \code{species} ordered list should contain:
#'
#' \itemize{
#'   \item maximum finite rate of increase, the species' maximum finite rate of
#'   increase at the fundamental niche optimum,
#'   \item a \code{n}-by-\code{1} column vector of means that gives the optimum location of the
#'   niche in each dimension, and
#'   \item a \code{n}-by-\code{n} variance-covariance matrix, that gives the size and orientation of the
#'   niche in each dimension.
#' }
#'
#' @return Returns a vector of length \code{m} containing the fundamental niche
#' value for each of the input niche space coordinates.
#'
#' @seealso Used internally by \code{\link{real.niche}}
#'
#' @references
#' Etherington TR, Omondiagbe OP (2019) virtualNicheR: generating virtual fundamental and realised niches
#' for use in virtual ecology experiments. Journal of Open Source Software 4:1661 \url{https://doi.org/10.21105/joss.01661}
#'
#' @examples
#' # Create coordinates across niche space
#' niche.XY = niche.grid.coords(mins=c(15,0), maxs=c(35,200), nCoords=121)
#' # Define a species as a function of the maximum finite rate of increase,
#' # a means vector, and covariance matrix
#' lambdaMax = 2.5
#' meansVector = matrix(c(25, 100))
#' covarMatrix = matrix(data=c(9, 60,
#'                             60, 625), nrow=2, ncol=2, byrow = TRUE)
#' species = list(lambdaMax, meansVector, covarMatrix)
#' # Calculate the fundamental niche
#' fundNiche = fund.niche(niche.XY, species)
#' # Plot the fundamental niche
#' fundNicheMatrix = matrix(fundNiche, nrow=length(unique(niche.XY[,1])))
#' nContour = 10
#' filled.contour(unique(niche.XY[,1]), unique(niche.XY[,2]), fundNicheMatrix,
#'                levels = seq(0, lambdaMax, lambdaMax/nContour),
#'                col=colorRampPalette(c("gold", "firebrick"))(nContour),
#'                xlab=expression(paste("Temperature (", degree, "C)")),
#'                ylab="Rainfall (mm)",
#'                main ="Fundamental niche",
#'                key.title = title(main = expression(lambda)))
#'
#' # Map the potential niche given maps of environmental variables
#' # Convert matrices of variables into columns
#' temp1D = matrix(temperatureMap, ncol=1)
#' rain1D = matrix(rainfallMap, ncol=1)
#' data.XY = cbind(temp1D, rain1D)
#' # Calculate the potential niche and form back in a 2D map
#' poteNiche = fund.niche(data.XY, species)
#' poteNiche2D = matrix(poteNiche, ncol=100)
#' filled.contour(z=poteNiche2D,
#'                levels = seq(0, lambdaMax, lambdaMax/nContour),
#'                col=colorRampPalette(c("gold", "firebrick"))(nContour),
#'                asp=1, plot.axes = {}, frame.plot=FALSE,
#'                main ="Map of the potential niche",
#'                key.title = title(main = expression(lambda)))
#' @importFrom stats mahalanobis
#' @export

fund.niche <- function(niche.coords, species) {

  lambdaMax = species[[1]]
  meansVector = species[[2]]
  covarMatrix = species[[3]]

  # Check the input data
  if (!isSymmetric(covarMatrix)) {
    stop("Covariance matrix is not symmetric")
  }
  if (length(meansVector) != nrow(covarMatrix)) {
    stop("Dimensions of means vector does not match covariance matrix")
  }
  if (ncol(niche.coords) != length(meansVector)) {
    stop("Dimensions of niche space does not match dimensions of defined niche")
  }

  # Calculate the fundamental niche
  return(lambdaMax * exp(-0.5 * mahalanobis(niche.coords, meansVector, covarMatrix)))

}

#-------------------------------------------------------------
