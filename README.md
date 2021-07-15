How to install a package from GitHub
How do you install a package that’s sitting on GitHub?

First, you need to install the devtools package. You can do this from CRAN. Invoke R and then type

install.packages("devtools")
Load the devtools package.

library(devtools)
In most cases, you just use install_github("author/package"). For example, with this v3dR package, which exists at github.com/jouterleys/v3dR, you’d type

install_github("jouterleys/v3dR")