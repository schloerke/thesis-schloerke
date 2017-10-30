library(dplyr)
library(ggplot2)

dt <- datasauRus::datasaurus_dozen %>%
  filter(dataset %in% c("bullseye", "dino", "dots", "star"))

dt_file <- file.path("figs", "dino.png")
if (TRUE || !file.exists(dt_file)) {
  p <- dt %>%
    ggplot(aes(x, y)) +
    geom_point() +
    facet_wrap(~ dataset, ncol = 2)

  ggsave(dt_file, p, height = 3, width = 3)
}

dt_table_file <- file.path("figs", "dino_table.tex")
if (TRUE || !file.exists(dt_table_file)) {
  dt %>%
    group_by(dataset) %>%
    summarise(
      x_bar = mean(x),
      y_bar = mean(y),
      x_sd = var(x),
      y_sd = var(y),
      cor = cor(x, y)
    ) %>%
    as.data.frame() ->
  a
  rownames(a) <- a[,1]
  a <- as.data.frame(t(a[-1]))
  rownames(a) <- c("mean(x)", "mean(y)", "var(x)", "var(y)", "cor(x,y)")
  ret <- round(a, digits = 2)

  table <- xtable::xtable(ret)
  print(
    table,
    floating = F,
    hline.after = NULL,
    add.to.row = list(pos = list(-1, 0, nrow(ret)),
    command = c("\\toprule\n ", "\\midrule\n  ", "\\bottomrule\n")),
    include.rownames = TRUE,
    file = dt_table_file
  )
}
