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

## Plot Example
```R
full_filepath = file.path("C:/ASCII.txt")
df <- v3dR(full_filepath)
 df %>%
   group_by(c3d_name,signal_names,signal_types,signal_folder,signal_components,item,instance) %>%
   ggplot(aes(x = item, y = value, color = signal_names)) +
   geom_hline(yintercept=0,color = "black", size=0.25)+
   stat_summary(fun = mean, geom = "line") +
   stat_summary(fun.data="mean_sdl", fun.args = list(mult = 1), mapping = aes(color = signal_names, fill = signal_names), geom = "ribbon",alpha = 0.25,colour = NA)+
   facet_wrap(signal_components ~ signal_names, scales = "free") +
   theme_minimal()+
   theme(axis.line = element_line(size=1, colour = "black"),legend.position = "bottom")+
   scale_x_continuous(expand = c(0, 0))

 ggsave(file.path(dirname(full_filepath),paste(basename(full_filepath),'.tiff',sep = "")),
        device = "tiff",
        width = 8, height = 8,dpi=300)
```

## How to update v3dR on my system?

1. Open R or Rstudio (best to close all R or Rstudio sessions first)

2. Use remove.packages()

```R
remove.packages("v3dR")
```
3. Then follow steps 2. and 3. from the Install

```R
# attach devtools library
library(devtools)

# install v3dR from github
install_github("jouterleys/v3dR")
```

