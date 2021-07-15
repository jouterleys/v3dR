# How to install an R package from GitHub
How do you install a package that’s sitting on GitHub?

1. Install the devtools package. From R install as normal.

```R
install.packages("devtools")
```

2. Attach the devtools package.

```R
library(devtools)
```

3. Try install_github("author/package"). For this package, which exists at github.com/jouterleys/v3dR, you’d type

```R
install_github("jouterleys/v3dR")
```

4. Don't forget to attach the package before use!

```R
library(v3dR)

full_filepath = file.path("C:/ASCII.txt")
df <- v3dR(full_filepath)

```
