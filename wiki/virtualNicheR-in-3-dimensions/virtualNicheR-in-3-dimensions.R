# --------------------------------------------------------------

# R version 3.5.3 (2019-03-11) -- "Great Truth"
# Platform: x86_64-w64-mingw32/x64 (64-bit)

library(virtualNicheR) # version 1.0
library(rgl) # version 0.100.30
library(misc3d) # version 0.8-4
library(magick) # version 2.2

# --------------------------------------------------------------

# Create coordinates across niche space
dim = 121
xMax = 50
yMax = 150
zMax = 80
niche.XY = niche.grid.coords(mins=c(0,0,0), maxs=c(xMax,yMax,zMax), nCoords=dim)

# Define species as a function of the maximum finite rate of increase,
# a means vector, and covariance matrix
species1 = list(2.5, matrix(c(25, 100, 50)), matrix(data=c(25, 0, 0,
                                                           0, 500, 0,
                                                           0, 0, 100), nrow=3, ncol=3, byrow=TRUE))
species2 = list(5, matrix(c(30, 60, 50)), matrix(data=c(25, 0, 0,
                                                        0, 100, 0,
                                                        0, 0, 60), nrow=3, ncol=3, byrow=TRUE))
# Create a community and define the interactions
community = list(species1, species2)
interactions = matrix(data=c(0.0, 0.4,
                            -2.0, 0.0), nrow=2, ncol=2,byrow = TRUE)

# Calculate the fundamental niches
fundNiche1 = fund.niche(niche.XY, community[[1]])
fundNicheArray1 = aperm(array(fundNiche1, dim=c(dim,dim,dim)), perm=c(1,2,3))
fundNiche2 = fund.niche(niche.XY, community[[2]])
fundNicheArray2 = aperm(array(fundNiche2, dim=c(dim,dim,dim)), perm=c(1,2,3))

# Calculate the realised niche values
realNiches = real.niche(niche.XY, community, interactions)
realNiche1 = aperm(array(realNiches[,1], dim=c(dim,dim,dim)), perm=c(1,2,3))
realNiche2 = aperm(array(realNiches[,2], dim=c(dim,dim,dim)), perm=c(1,2,3))

# --------------------------------------------------------------

# Plot the niches
rgl.open() # Open a new RGL device
par3d(windowRect = c(0, 0, 500, 500)) # left, top, right, bottom of window in pixels
rgl.bg(color = "white") # Set background colour
aspect3d(1,1,1) # Define aspect ratio as equal
rgl.viewpoint(zoom = 1) # Set up viewpoint

contour3d(fundNicheArray1, level=1,
          x=seq(0, xMax, by=((xMax - 0)/(dim - 1))), 
          y=seq(0, yMax, by=((yMax - 0)/(dim - 1))),
          z=seq(0, zMax, by=((zMax - 0)/(dim - 1))),
          color = "green", alpha = 0.5, add = TRUE)
contour3d(fundNicheArray2, level=1,
          x=seq(0, xMax, by=((xMax - 0)/(dim - 1))), 
          y=seq(0, yMax, by=((yMax - 0)/(dim - 1))),
          z=seq(0, zMax, by=((zMax - 0)/(dim - 1))),
          color = "grey", alpha = 0.5, add = TRUE)
contour3d(realNiche1, level=1,
          x=seq(0, xMax, by=((xMax - 0)/(dim - 1))),
          y=seq(0, yMax, by=((yMax - 0)/(dim - 1))),
          z=seq(0, zMax, by=((zMax - 0)/(dim - 1))),
          color = "orange", alpha = 0.5, add = TRUE)
contour3d(realNiche2, level=1,
          x=seq(0, xMax, by=((xMax - 0)/(dim - 1))),
          y=seq(0, yMax, by=((yMax - 0)/(dim - 1))),
          z=seq(0, zMax, by=((zMax - 0)/(dim - 1))),
          color = "yellow", alpha = 0.5, add = TRUE)

# Add plot extras
rgl.lines(c(0, xMax), c(0, 0), c(0, 0), color = "black")
rgl.lines(c(0, 0), c(0, yMax), c(0, 0), color = "black")
rgl.lines(c(0, 0), c(0, 0), c(0, zMax), color = "black")

text3d(x = xMax, y = 0, z = 0, "x", adj = c(0.5,-1), col="black", family="sans",  cex=1.5)
text3d(x = 0, y = yMax, z = 0, "y", adj = c(0.5,1), col="black", family="sans",  cex=1.5)
text3d(x = 0, y = 0, z = zMax, "z", adj = c(0.5,-1), col="black", family="sans",  cex=1.5)

# --------------------------------------------------------------

# Create a movie
dir.create("movie")
movie3d(spin3d(axis = c(0, 1, 0), rpm=10), duration = 6,
        dir = "movie")
rgl.close()

# --------------------------------------------------------------
