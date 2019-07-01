context("virtualNicheR")


real.niche.input<-function(){
     nCoords=10
     min=c(15,0)
     max=c(35,200)
    species1 = list(2.5, c(25, 100), matrix(data=c(9, 60,60, 625), nrow=2, ncol=2, byrow=TRUE))
    species2 = list(5.0, c(28, 110), matrix(data=c(4, -20,
                                                  -20, 500), nrow=2, ncol=2, byrow=TRUE))
    species3 = list(3.0, c(25, 80), matrix(data=c(4, 0,
                                                  0, 150), nrow=2, ncol=2, byrow=TRUE))
    community = list(species1, species2, species3)

    # Define the interactions
    interactions = matrix(data=c(0.0, 0.2,-0.4,
                                -1.0, 0.0,-1.0,
                                -0.6, 0.3, 0.0), nrow=3, ncol=3, byrow = TRUE)

    # Calculate the realised niche values
    niche.XY = niche.grid.coords(mins=min, maxs=max, nCoords=nCoords)
    realNiche = real.niche(niche.XY, community, interactions)
    result=list("realN"=realNiche,"nCoords"=nCoords,"max"=max,"min"=min)
    return(result)
}


test_that("Real niche functions always return non negative values",{
  realNiche=real.niche.input()
  expect_equal(if(all(realNiche$realN >= 0)) print(TRUE),TRUE,info="The real niche result is not normally distributed")
})


test_that("Real Niche result should always equal the number of coordinate raise to the power of the number of min/max value", {

  realNiche<-real.niche.input()
  expectedResult= realNiche$nCoords ** length(realNiche$min)

  expect_equal(expectedResult,length(realNiche$realN[,1]),info="The length of the real niche result is not equal to the expected result")
})


test_that("Real Niche should not work when
          # the interactions is not a square matrix,", {
            species1 = list(2.5, c(25, 100), matrix(data=c(9, 60,
                                                           60, 625), nrow=2, ncol=2, byrow=TRUE))
            species2 = list(5.0, c(28, 110), matrix(data=c(4, -20,
                                                           -20, 500), nrow=2, ncol=2, byrow=TRUE))
            species3 = list(3.0, c(25, 80), matrix(data=c(4, 0,
                                                           0, 150), nrow=2, ncol=2, byrow=TRUE))
            community = list(species1, species2, species3)
            interactions = suppressWarnings(matrix(data=c(0.0, 0.2,-0.4,
                                           -1.0, 0.0,-1.0,
                                           -0.6, 0.3, 0.0,
                                           -0.2, 0.1, 0.2), ncol=3, byrow = TRUE))

            niche.XY = niche.grid.coords(mins=c(15,0), maxs=c(35,200), nCoords=121)


            ## If the interactions is not a square matrix, Real Niche should return an error
            expect_error(real.niche(niche.XY, community, interactions),"The interactions must be a square matrix")
})


test_that("Real Niche should not work when
          # the interactions matrix is not equal to zero on the diagonal,", {
            species1 = list(2.5, c(25, 100), matrix(data=c(9, 60,
                                                           60, 625), nrow=2, ncol=2, byrow=TRUE))
            species2 = list(5.0, c(28, 110), matrix(data=c(4, -20,
                                                           -20, 500), nrow=2, ncol=2, byrow=TRUE))
            species3 = list(3.0, c(25, 80), matrix(data=c(4, 0,
                                                          0, 150), nrow=2, ncol=2, byrow=TRUE))
            community = list(species1, species2, species3)

            interactions = matrix(data=c(0.0, 0.2,-0.4,
                                         -1.0, 0.0,-1.0,
                                         -0.6, 0.3, 0.0), nrow=3, ncol=3, byrow = TRUE)
            diag(interactions) <-2.0
            niche.XY = niche.grid.coords(mins=c(15,0), maxs=c(35,200), nCoords=121)

            ## If the interactions is not a square matrix, Real Niche should return an error
            expect_error(real.niche(niche.XY, community, interactions),"Interactions matrix must be equal to zero on the diagonal")
})


test_that("Real Niche should not work when
          # community size is different from the interactions size,", {
            species1 = list(2.5, c(25, 100), matrix(data=c(9, 60,
                                                           60, 625), nrow=2, ncol=2, byrow=TRUE))
            species2 = list(5.0, c(28, 110), matrix(data=c(4, -20,
                                                           -20, 500), nrow=2, ncol=2, byrow=TRUE))

            community = list(species1, species2)

            interactions = matrix(data=c(0.0, 0.2,-0.4,
                                         -1.0, 0.0,-1.0,
                                         -0.6, 0.3, 0.0), nrow=3, ncol=3, byrow = TRUE)
            niche.XY = niche.grid.coords(mins=c(15,0), maxs=c(35,200), nCoords=121)

            ## If the community size is not the same as the interactions size, Real Niche should return an error
            expect_error(real.niche(niche.XY, community, interactions),"The community size is not the same as the interactions size")
})

