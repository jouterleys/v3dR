#' @title v3dR
#' @description Import V3D ASCII Txt File To R
#' @param full_filepath Full filepath to txt file
#' @return Dataframe containing txt data in long format
#' @import magrittr
#' @examples
#' full_filepath = file.path("C:/local_repos/github/v3dR/data/L_A.txt")
#' df <- v3dR(full_filepath)


v3dR <- function(full_filepath){

  df <- read.delim(file = full_filepath, header=FALSE, stringsAsFactors = F)

  header <- df[c(1:5),c(2:ncol(df))]

  data <- df[c(6:nrow(df)),c(2:ncol(df))]

  item <- df[c(6:nrow(df)),1]

  header <- data.frame(t(header))

  data <- data.frame(t(data))

  df <- cbind(header,data)

  new_colNames <- c("c3d_name","signal_names","signal_types","signal_folder","signal_components",item)

  data.table::setnames(df, colnames(df), new_colNames)

  df <- tidyr::pivot_longer(df, cols = -c("c3d_name","signal_names","signal_types","signal_folder","signal_components"),
                            names_to = "item",
                            values_to = "value")


  if (is.factor(df$value)) {
    df$value <- as.numeric(levels(df$value))[df$value]
  } else {
    df$value <- as.numeric(df$value)
  }

  df$item <- factor(df$item)
  df$item <- as.numeric(levels(df$item))[df$item]


  df <- df %>%
    dplyr::group_by(dplyr::across(c(-value))) %>%
    dplyr::mutate(step_num = 1:dplyr::n())

  df <- df %>%
    dplyr::relocate(step_num, .after = signal_components)

  return(df)

}



##### Plot Example

#full_filepath = file.path("C:/local_repos/github/v3dR/data/SPORT_JOINT_ANGLES.txt")

#df <- v3dR(full_filepath)

# df %>%
#   group_by(c3d_name,signal_names,signal_types,signal_folder,signal_components,item,step_num) %>%
#   ggplot(aes(x = item, y = value, color = signal_names)) +
#   geom_hline(yintercept=0,color = "black", size=0.25)+
#   stat_summary(fun = mean, geom = "line") +
#   stat_summary(fun.data="mean_sdl", fun.args = list(mult = 1), mapping = aes(color = signal_names, fill = signal_names), geom = "ribbon",alpha = 0.25,colour = NA)+
#   facet_wrap(signal_components ~ signal_names, scales = "free") +
#   theme_minimal()+
#   theme(axis.line = element_line(size=1, colour = "black"),legend.position = "bottom")+
#   scale_x_continuous(expand = c(0, 0))
#
# ggsave(file.path(dirname(full_filepath),paste(basename(full_filepath),'.tiff',sep = "")),
#        device = "tiff",
#        width = 8, height = 8,dpi=300)
