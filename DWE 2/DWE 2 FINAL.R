# References
library(dplyr)
library(readr)


# 0: Load the data in RStudio
titan <- read_csv("~/R/Springboard/DWE 2/titanic_original.csv", col_names = TRUE)
titan <- tbl_df(titan)


# 1: Port of embarkation [replace NULL values with "S"]
titan$embarked <- replace(titan$embarked, list = is.na(titan$embarked), values = "S")


# 2: Age [replace NULL values with the mean value]
titan$age[is.na(titan$age)] <- mean(titan$age, na.rm = TRUE )

#Think about other ways you could have populated the missing values in the age column. 
#Why would you pick any of those over the mean (or not)?

  #By defintion, you can't replace the nulls without altering the data, so the question becomes, how do you want to effect the data?
  #so... what do you want to use the data for? that should inform your selection of a replacement.  
  
  #replacing Null values with the Mean will keep the mean constant, and replacing them with the Median will keep the median constant.
  #Using either will also: decrease variance/Standard Deviation, the extremes will be unchanged,
  #and the shape of the graph will be smoothed (muted).
  
  #you could pick values based on regression (or other simple models), but that will just flatten out the curve even more.
  #I'm sure there are more complicated models for estimating/reproducing missing values, but I've never used them.


# 3: Lifeboat [replace NULL values with text string "None"]
titan$boat[is.na(titan$boat)] <- "None"


# 4: Cabin [add binary column where cabin number NULL values = 0]
titan <-  mutate(titan, has_cabin_number = as.numeric(!is.na(titan$cabin)))


# 5: Save Output
write_csv(titan, "~/R/Springboard/DWE 2/titanic_clean.csv", 
          na = "", append = FALSE, col_names = TRUE)