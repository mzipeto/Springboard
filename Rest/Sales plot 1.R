# References
library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)


# load file
sales <- read_csv("~/R/Springboard/Rest/Rest Sales Data CLEAN.csv", col_names = TRUE)
sales <- tbl_df(sales)


#select data for plot

#remove outliers: first full week of busines began, 9/13/2016
#, last one ends, 3/15/2017
sales
sales_plot <- filter(sales, ReportDate >= as.Date("2016-09-16")) # & ReportDate <= as.Date("2017-03-15"))
sales_plot

#choose columns, then GROUP BY WeekNum, Year, and add up the values
sales_plot <- sales_plot %>%
  select(ReportDate, ReportYear, WeekNum, YearWeekNum, NetSales) %>%
  group_by(ReportYear, WeekNum) %>%
  summarise(EndOfWeek = max(ReportDate), YearWeekNum = last(YearWeekNum), NetSales = sum(NetSales))


#build plot
ggplot(sales_plot, aes(x = EndOfWeek, y = NetSales)) +
  geom_point(shape = 21, size = 3, col = "black", fill = "red") +
  geom_smooth(se = FALSE, span = 0.4) +
  coord_cartesian(ylim = c(5000,15000))
