# References
library(readr)
#library(tidyr)
#library(dplyr)
library(ggplot2)
library(scales)


# load file
sales <- read_csv("~/R/Springboard/Rest/Rest Sales 1 Data CLEAN.csv", col_names = TRUE)
sales <- tbl_df(sales)

#select data for plot

#build plot 1: sales over time

ggplot(sales, aes(x = WeekStart, y = Sales)) +
  geom_point(size = 1, col = "black") +
  geom_line(col = "black") +
  geom_smooth(method = "lm", se = FALSE, col = "red") +
  coord_cartesian(ylim = c(0,25000)) +
  scale_x_date(name = "Week Start Date") +
  scale_y_continuous(name = "Gross Sales", labels = dollar) +
  ggtitle("Restaurant Sales by Week") +
  geom_vline(xintercept = as.numeric(as.Date(c("2011-10-31", "2012-10-31", "2013-10-31", "2014-10-31"))), alpha = 0.5) 


#build Plot 2: sales, week over week

#ggplot(sales, aes(x = WeekNum, y = Sales, col = factor(Year))) +
#  geom_point(size = 1.5) +
#  geom_smooth(se = FALSE, span = 0.4)

ggplot(sales, aes(x = WeekNum, y = Sales, col = factor(Year))) +
  geom_point(size = 2.5, shape = 21, fill = "grey") + geom_line() + geom_smooth( size = 1.25, se = FALSE, span = 0.35) +
  coord_cartesian(ylim = c(5000,24000)) +
  scale_color_brewer(palette="Set1", name = "Year", guide = guide_legend(reverse=TRUE)) +
  scale_x_continuous(name="Week Number (1 to 52)") +
  scale_y_continuous(name="Gross Sales per Week", labels = dollar) +
  ggtitle("Restaurant Sales, Week over Week ") +
  geom_vline(xintercept = seq(from = 13/24, to = (52 + 13/24), by = (13/3)), alpha = 0.5) +
  annotate(geom = "text", x = 2.6 + 4.35 * (0:11), y = 6000, label = format(ISOdate(2004,1:12,1),"%b"), size = 4) +
  annotate(geom = "rect", xmin = 43.5, xmax = 44.5, ymin = -Inf, ymax = +Inf, fill = "orange", alpha = 0.3)



  