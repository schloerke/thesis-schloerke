

if (packageVersion("cranlogs") < "2.1.1") {
  devtools::install_github("metacran/cranlogs")
}
library(cranlogs)

library(dplyr)
library(lubridate)

# down <- cranlogs::cran_downloads("R", from = "2012-01-01", to = "2017-06-30")
down <- cranlogs::cran_downloads("GGally", from = "2012-01-01", to = "2017-06-30")
down <- as_data_frame(down)

down %>%
  mutate(
    year = year(date),
    month = month(date)
  ) %>%
  group_by(
    year, month
    # , os
  ) %>%
  # count() %>%
  tally(count) %>%
  mutate(
    date = ymd(paste0(year, "-", month, "-1"))
  ) %>%
  print() ->
dt

sum(dt$n)

library(ggplot2)
# qplot(date, n, data = dt, geom = c("line", "point"), color = os)
qplot(date, n, data = dt, geom = c("line", "point"))
