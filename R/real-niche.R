#-------------------------------------------------------------

#' @title Realised Niche

#' @description Calculates the \code{n}-dimensional realised niche for a community
#' of \code{s} species at \code{m} coordinates in niche space.
#'
#' @param niche.coords A \code{m}-by-\code{n} matrix of niche coordinates.
#' @param community List of length \code{s} containing definitions of the
#' fundamental niches of species in the community.
#' @param interactions A \code{s}-by-\code{s} matrix that defines the \code{species}
#' interspecific interactions.
#'
#' @details The first step in calculating the realised niches is to calculate a
#' fundamental niche for each species in the \code{community} list.  This is done
#' using the \code{\link{fund.niche}} function, so see there for a full description
#' of how to define a the species fundamental niches.
#'
#' The \code{interactions} matrix defines the form of the ecological interaction
#' between each of the species in the community.  These interactions can be either
#' positive (+) or negative (-) in effect, and as the interactions can be
#' asymmetrical there are a range of possible interspecific species interactions:
#' competition (--), predator-prey or parasite-host (+-), commensalism (+0),
#' amensalism (-0), or mutualism (++).  When building the interactions matrix
#' row 1 column 2 is the effects of species 2 on species 1, and conversely row 2
#' column 1 is the effects of species 1 on species 2, etc.
#'
#' Please note that this function assumes that the species are consistently
#' ordered in the community list and interactions matrix, and that no species effects
#' itself so the diagonal of the interactions matrix has values equal to zero.
#'
#' @return Returns a \code{m}-by-\code{s} matrix realised niche value for each species at
#' each of the input niche space coordinates.
#'
#' @seealso Uses \code{\link{fund.niche}}
#'
#' @references
#' Etherington TR, Omondiagbe OP (2019) virtualNicheR: generating virtual fundamental and realised niches
#' for use in virtual ecology experiments. Journal of Open Source Software 4:1661 \url{https://doi.org/10.21105/joss.01661}
#'
#' @examples
#' # Define the community
#' species1 = list(2.5, matrix(c(25, 100)), matrix(data=c(9, 60,
#'                                                        60, 625), nrow=2, ncol=2, byrow=TRUE))
#' species2 = list(5.0, matrix(c(28, 110)), matrix(data=c(4, -20,
#'                                                       -20, 500), nrow=2, ncol=2, byrow=TRUE))
#' species3 = list(3.0, matrix(c(25, 80)), matrix(data=c(4, 0,
#'                                                       0, 150), nrow=2, ncol=2, byrow=TRUE))
#' community = list(species1, species2, species3)
#'
#' # Define the interactions
#' interactions = matrix(data=c(0.0, 0.2,-0.4,
#'                             -1.0, 0.0,-1.0,
#'                             -0.6, 0.3, 0.0), nrow=3, ncol=3, byrow = TRUE)
#'
#' # Calculate the realised niche values
#' niche.XY = niche.grid.coords(mins=c(15,0), maxs=c(35,200), nCoords=121)
#' realNiche = real.niche(niche.XY, community, interactions)
#'
#' # Plot the realised niche for species 1
#' realNiche1 = matrix(realNiche[,1], nrow=length(unique(niche.XY[,1])))
#' nContour = 10
#' filled.contour(unique(niche.XY[,1]), unique(niche.XY[,2]), realNiche1,
#'                levels = seq(0, 5, 5/nContour),
#'                col=colorRampPalette(c("gold", "firebrick"))(nContour),
#'                xlab=expression(paste("Temperature (", degree, "C)")),
#'                ylab="Rainfall (mm)",
#'                main ="Realised niche",
#'                key.title = title(main = expression(lambda)))
#'
#' @export
real.niche <- function(niche.coords, community, interactions) {

  # Check the input data
  if (ncol(interactions) != nrow(interactions)) {
    stop("The interactions must be a square matrix")
  }
  if (FALSE %in% (diag(interactions) == 0)) {
    stop("Interactions matrix must be equal to zero on the diagonal")
  }
  if (length(community) != nrow(interactions)) {
    stop("The community size is not the same as the interactions size")
  }

  # Calculate fundamental niche for each species and convert to matrix
  fundNiches = c()
  for (species in community) {
    fundNiches = c(fundNiches, fund.niche(niche.coords, species))
  }
  fundNiches = matrix(fundNiches, ncol=length(community))

  # Calculate the realised niches
  realNiches = fundNiches * exp(t(apply(fundNiches, MARGIN=1, FUN="%*%", t(interactions))))
  return(realNiches)

}

#-------------------------------------------------------------
