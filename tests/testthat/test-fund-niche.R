context("virtualNicheR")


fund.niche.input<-function(){
  nCoords=5
  min=c(15,0)
  max=c(35,200)
  niche.XY  <- niche.grid.coords(mins=min, maxs=max, nCoords=nCoords)
  lambdaMax = 2.5
  meansVector = c(25, 100)
  covarMatrix = matrix(data=c(9, 60,
                              60, 625), nrow=2, ncol=2, byrow = TRUE)

  species = list(lambdaMax, meansVector, covarMatrix)
  fundNiche = fund.niche(niche.XY, species)
  result=list("fundN"=fundNiche,"nCoords"=nCoords,"max"=max,"min"=min,"lambdaMax"=lambdaMax,"meansVector"=meansVector,"covarMatrix"=covarMatrix)

  return(result)
}

test_that("Fundamental Niche result should always equal the number of coordinate raise to the power of the number of min/max value", {

  fundNiche<-fund.niche.input()
  expectedResult= fundNiche$nCoords ** length(fundNiche$min)


  expect_equal(expectedResult,length(fundNiche$fundN),info="The length of the fundamental niche result is not equal to the expected result")
})

test_that("Fundamental Niche produces values which are normally distributed", {

  fundNiche<-fund.niche.input()
  test.result=shapiro.test(fundNiche$fundN)

  expect_equal(if(0.1 > test.result$p.value)print(TRUE),TRUE,info="The fundamental niche result is not normally distributed")
})


test_that("Fundamental Niche multivariate normal distribution is correctly centered on the means", {
  fundNiche<-fund.niche.input()
  species = list(fundNiche$lambdaMax,  fundNiche$meansVector,  fundNiche$covarMatrix)
  fundNicheMeans = fund.niche(matrix(fundNiche$meansVector, ncol = ncol(fundNiche$covarMatrix)), species)
  expect_equal(if(all(fundNicheMeans >= fundNiche$fundN)) print(TRUE),TRUE,info="Fundamental Niche multivariate normal distribution is not correctly centered on the means")

})


test_that("fundamental niche functions always return non negative values",{
  fundNiche<-fund.niche.input()

  expect_equal(if(all(fundNiche$fundN >= 0)) print(TRUE),TRUE,info="The fundamental niche result is not unimodal")
})



test_that("Fundamental Niche produces vector of length equal to the number of row in the inputted niche space coordinates", {
  niche.XY  <- niche.grid.coords(mins=c(15,0), maxs=c(35,200), nCoords=5)
  lambdaMax = 2.5
  meansVector = c(25, 100)
  covarMatrix = matrix(data=c(9, 60,
                              60, 625), nrow=2, ncol=2, byrow = TRUE)
  species = list(lambdaMax, meansVector, covarMatrix)
  fundNiche = fund.niche(niche.XY, species)
  expect_equal(length(niche.XY [[2]]),length(fundNiche),info = "The fundamental niche length is not equal to the length of the grid niche space")
})


test_that("Fundamental Niche should not work
          # when the covariance matrix is not symmetric", {

  niche.XY  <- niche.grid.coords(mins=c(15,0), maxs=c(35,200), nCoords=5)
  lambdaMax = 2.5
  meansVector = c(25, 100)
  covarMatrix = matrix(data=c(195, 60,
                              60, 625,23,45), nrow=3, ncol=3, byrow = TRUE)
  species = list(lambdaMax, meansVector, covarMatrix)

  ## If covariance matrix is not symmetric, Fundamental Niche should return an error
  expect_error(fund.niche(niche.XY, species),"Covariance matrix is not symmetric")
})


test_that("Fundamental Niche should not work when
          # the length of meansVector is not equal to the number of rows of covarMatrix",{

  niche.XY  <- niche.grid.coords(mins=c(15,0), maxs=c(35,200), nCoords=5)
  lambdaMax = 2.5
  meansVector = c(25, 100,300)
  covarMatrix = matrix(data=c(195, 60,
                              60, 625), nrow=2, ncol=2, byrow = TRUE)
  species = list(lambdaMax, meansVector, covarMatrix)

  ## If Dimensions of means vector does not match covariance matrix, Fundamental Niche should return an error
  expect_error(fund.niche(niche.XY, species),"Dimensions of means vector does not match covariance matrix")
})


test_that("Fundamental Niche should not work when the  number of column
          # of the niche.coords is not equal to the length of meansVector", {

  niche.XY  <- niche.grid.coords(mins=c(15,5,25), maxs=c(35,200,400), nCoords=5)
  lambdaMax = 2.5
  meansVector = c(25, 100)
  covarMatrix = matrix(data=c(195, 60,
                              60, 625), nrow=2, ncol=2, byrow = TRUE)
  species = list(lambdaMax, meansVector, covarMatrix)

  ## If the number of column of the niche.coords not equal to length of meansVector, Fundamental Niche should return an error
  expect_error(fund.niche(niche.XY, species),"Dimensions of niche space does not match dimensions of defined niche")
})
