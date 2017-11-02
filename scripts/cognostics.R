

xtable <- function(x, file = "", ...){
  table <- xtable::xtable(x, ...)
  print(table, floating = F, hline.after = NULL,
    add.to.row = list(
      pos = list(-1,0, nrow(x)),
      command = c('\\toprule\n ','\\midrule\n  ','\\bottomrule\n')
    ),
    include.rownames = FALSE,
    file = file
  )
}


tex_save_files <- file.path("figs", c("intro_cogs_1.tex", "intro_cogs_2.tex"))
plot_save_file <- file.path("figs", "intro_cogs.png")

if (
  # TRUE ||
  !all(file.exists(c(tex_save_files, plot_save_file)))
) {
  library(dplyr)
  library(ggplot2)

  gapminder::gapminder %>%
    group_by(continent) %>%
    do(
      panel = qplot(lifeExp, data = ., geom = "histogram", binwidth = I(1)) + labs(x = "life expectancy", title = "Americas")
    )  ->
  continent_hists
  americas_pos <- which(continent_hists$continent == "Americas")
  p <- continent_hists$panel[[americas_pos]]

  ggsave(plot_save_file, p, width = 6, height = 4)

  continent_hists_cogs <- autocogs::add_panel_cogs(continent_hists)

  am_cogs <- continent_hists_cogs[americas_pos, 3:6]
  lapply(names(am_cogs), function(am_cog_name) {
    cogs_ <- am_cogs[[am_cog_name]][[1]]
    cbind(
      reshape::melt.list(cogs_),
      L2 = am_cog_name,
      stringsAsFactors = FALSE
    )
  }) %>%
    bind_rows() %>%
    select(group = L2, cog = L1, value) %>%
    filter(!is.na(value)) ->
  cog_table

  cog_table %>%
    mutate(
      group = ifelse(!duplicated(group), group, "")
    # ) %>%
    # mutate(
    #   group = stringr::str_replace_all(group, c("^_" = "", "_" = " ")),
    #   cog = stringr::str_replace_all(cog, c("_" = " ")),
    ) ->
  cog_table


  save_tex <- function(x, skip_locs, save_file) {
    bigskip <- "BIGSKIP"
    left <- rep("", nrow(x))
    left[skip_locs] <- bigskip

    x %>%
      mutate(group = paste(left, group)) %>%
      xtable(file = save_file)

    # fix the backslash and make the header regular text
    readLines(save_file) %>%
      gsub(bigskip, "\\bigskip", ., fixed = TRUE) %>%
      gsub("group & cog & value", "\\textnormal{group} & \\textnormal{cog} & \\textnormal{value}", ., fixed = TRUE) %>%
      writeLines(save_file)
  }

  cog_table[1:10, ] %>%
    save_tex(5, tex_save_files[1])

  cog_table[11:18, ] %>%
    rbind(data.frame(group = c("", ""), cog = NA, value = NA)) %>%
    save_tex(6, tex_save_files[2])

}
