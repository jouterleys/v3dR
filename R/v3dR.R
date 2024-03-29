#' @title v3dR
#' @description Import V3D ASCII Txt File To R
#' @param full_filepath Full filepath to txt file
#' @return Dataframe containing txt data in long format
#' @import magrittr
#' @examples
#' full_filepath = file.path("C:/local_repos/github/v3dR/data/L_A.txt")
#' df <- v3dR(full_filepath)


v3dR <- function(full_filepath){

  df <- data.table::fread(file = full_filepath, header = FALSE, stringsAsFactors = F)

  if (length(df) < 2) {
    # Create a data frame if txt is empty with NA values
    df <- data.frame(c3d_name = "NO_DATA", signal_names = "NO_DATA", signal_types = "NO_DATA", signal_folder = "NO_DATA", signal_components = "NO_DATA", instance = NA, item = NA, value = NA
    )

  } else {

    df <- data.table::setDF(df)

    header <- df[c(1:5), c(2:ncol(df))]
    data <- df[c(6:nrow(df)), c(2:ncol(df))]
    item <- df[c(6:nrow(df)), 1]
    header <- t(header)
    data <- t(data)
    df <- cbind(header, data)
    df <- data.table::as.data.table(df)
    new_colNames <- c("c3d_name", "signal_names", "signal_types", "signal_folder", "signal_components", item)

    data.table::setnames(df, colnames(df), new_colNames)

    df <- data.table::melt(df, id.vars = c("c3d_name", "signal_names", "signal_types", "signal_folder", "signal_components"), variable.name = "item", value.name = "value")

    if (is.factor(df$value)) {
      df$value <- as.numeric(levels(df$value))[df$value]
    } else {
      df$value <- as.numeric(df$value)
    }

    df$item <- factor(df$item)
    df$item <- as.numeric(levels(df$item))[df$item]

    df <- df %>% dplyr::group_by(dplyr::across(c(-value))) %>% dplyr::mutate(instance = 1:dplyr::n())

    df <- df %>% dplyr::relocate(instance, .after = signal_components)

    df <- as.data.frame(df)


  }
  return(df)

}



##### Plot Example

# full_filepath = file.path("C:/local_repos/github/v3dR/data/SPORT_JOINT_ANGLES.txt")
# df <- v3dR(full_filepath)
#  df %>%
#    group_by(c3d_name,signal_names,signal_types,signal_folder,signal_components,item,instance) %>%
#    ggplot(aes(x = item, y = value, color = signal_names)) +
#    geom_hline(yintercept=0,color = "black", size=0.25)+
#    stat_summary(fun = mean, geom = "line") +
#    stat_summary(fun.data="mean_sdl", fun.args = list(mult = 1), mapping = aes(color = signal_names, fill = signal_names), geom = "ribbon",alpha = 0.25,colour = NA)+
#    facet_wrap(signal_components ~ signal_names, scales = "free") +
#    theme_minimal()+
#    theme(axis.line = element_line(size=1, colour = "black"),legend.position = "bottom")+
#    scale_x_continuous(expand = c(0, 0))
#
#  ggsave(file.path(dirname(full_filepath),paste(basename(full_filepath),'.tiff',sep = "")),
#         device = "tiff",
#         width = 8, height = 8,dpi=300)
