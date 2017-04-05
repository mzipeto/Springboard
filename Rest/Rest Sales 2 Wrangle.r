# References
library(readr)
library(tidyr)
library(dplyr)


# load file
sales <- read_csv("~/R/Springboard/Rest/Rest Sales 2 Data.csv", col_names = TRUE)
sales <- tbl_df(sales)

#Convert string dates to dates
sales$ReportDate <- as.Date(sales$ReportDate, "%m/%d/%Y")


#fix bad week numbers

#Function to create my retail weeks
MZWeek_Num <- function(input_date){
  
#Excel fomula: =MIN(INT((A2-DATE(YEAR(A2),1,1))/7)+1,52)

  first_of_year <- as.Date(format(input_date, format="%Y-01-01"))
  
  week_num <- as.integer((input_date - first_of_year))
  week_num <- as.integer((week_num / 7 )) + 1
  week_num <- min(week_num, 52) 

  return (week_num)
}

#Apply the function to fix the bad weeks
sales$WeekNum <- sapply(sales$ReportDate, MZWeek_Num )


#create function to calculate "year" for the ISO week numbers
ISOweek_year <- function(input_date, input_week){
  
  ifelse((as.numeric(format(input_date, "%m")) == 1 ) & (input_week > 50), +
           (as.numeric(format(input_date, "%Y")) - 1 ), +
           as.numeric(format(input_date, "%Y")))
}  


#create new column for week-year, ISO Year, iso week year
sales <- sales %>%
  mutate(ReportYearISO = ISOweek_year(ReportDate, WeekNumISO)) %>%
  unite("YearWeekNumISO", ReportYearISO, WeekNumISO, sep ="-", remove = FALSE) %>%
  unite("YearWeekNum", ReportYear, WeekNum, sep ="-", remove = FALSE)


#reorder columns
sales <- select(sales, ReportDate, ReportYear, ReportMonth, ReportDay,  
                 WeekNum, YearWeekNum, ReportYearISO, WeekNumISO, YearWeekNumISO,
                 GrossSales, NetSales)


#Output cleaned data
write_csv(sales, "~/R/Springboard/Rest/Rest Sales 2 Data CLEAN.csv")
