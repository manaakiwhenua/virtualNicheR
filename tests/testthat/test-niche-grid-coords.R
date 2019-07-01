context("virtualNicheR")

test_that("Niche Grid Coordinates produces data frame from all combinations of the supplied vectors or factors which are systematically located
    #' throughout a specified 2 dimension niche space", {
      niche.XY  <- niche.grid.coords(mins=c(15,0), maxs=c(35,200), nCoords=5)
      d1=seq(15,35,length.out = 5)
      d2=seq(0,200,length.out = 5)
      dat = data.frame()
      x=1
      y=1
      total.com= length(d1) * length(d2)
      for (n in c(1:total.com)) {
        dat<-rbind(dat,c(d1[x],d2[y]))
        if(x == length(d1)){
          x<-1
          y<-y+1
        }else{
          x<-x+1
        }

      }
      #remove column name before testing
      names(niche.XY) <-NULL
      names(dat) <-NULL
      #test all columns to determine if they are equal
      for( i in c(1:length(niche.XY))){
        expect_equal(dat[i],niche.XY[i])
      }

})

test_that("Niche Grid Coordinates should not work
          # when Length of mins and maxs differ, ", {
            min=c(15,0,-20)
            max=c(35,200)

            ## Check input data if Length of mins and maxs does not differ, Niche Grid Coordinates should return an error
            expect_error(niche.grid.coords(mins=min, maxs=max, nCoords=5),"Length of mins and maxs differ")
})


test_that("Niche Grid Coordinates should not work
          # when Maximums not greater than minimums in all dimesions, ", {
            max=c(15,0)
            min=c(35,200)

            ## Check input data if Maximums not greater than minimums in all dimesions, Niche Grid Coordinates should return an error
            expect_error(niche.grid.coords(mins=min, maxs=max, nCoords=5),"Maximums not greater than minimums in all dimensions")
})

test_that("Niche Grid Coordinates should not work
          # when Sample size is not greater than one, ", {
            min=c(15,0)
            max=c(35,200)
            Coords=1

            ## Check input data if greather than 1, Niche Grid Coordinates should return an error
            expect_error(niche.grid.coords(mins=min, maxs=max, nCoords=Coords),"Sample size must be greater than one")
})

