# *** References
library(tidyr)
library(dplyr)
library(readr)

# *** 0: Load the data in RStudio

#Save the data set as a CSV file called titanic_original.csv and load it in RStudio into a data frame.

titan <- read_csv("~/R/Springboard/DWE 2/titanic_original.csv", col_names = TRUE)
titan <- tbl_df(titan)

# *** 1: Port of embarkation
#The embarked column has some missing values, which are known to correspond to passengers who actually embarked at Southampton.
#Find the missing values and replace them with S. (Caution: Sometimes a missing value might be read into R as a blank or empty string.)
#unique(titan$embarked)
#count ( filter(titan, titan$embarked == "S"))

titan$embarked <- replace(titan$embarked, list = is.na(titan$embarked), values = "S")
#titan$embarked[is.na(titan$embarked)] <- "S" 

#unique(titan$embarked)
#count ( filter(titan, titan$embarked == "S"))


# *** 2: Age
#You’ll notice that a lot of the values in the Age column are missing.
#While there are many ways to fill these missing values, using the mean
#or median of the rest of the values is quite common in such cases.
#Calculate the mean of the Age column and use that value to populate the missing values

#Think about other ways you could have populated the missing values in the age column. 
#Why would you pick any of those over the mean (or not)?

  #By defintion, you can't replace the nulls without altering the data, so the question becomes, how do you want to effect the data?
  #so... what do you want to use the data for? that should inform your selection of a replacement.  
  
  #replacing Null values with the Mean will keep the mean constant, and replacing them with the Median will keep the median constant.
  #Using either will also: decrease variance/Standard Deviation, the extremes will be unchanged,
  #and the shape of the graph will be smoothed (muted).
  
  #you could pick values based on regression (or other simple models), but that will just flatten out the curve even more.
  #I'm sure there are more complicated models for estimating/reproducing missing values, but I've never used them.


#count ( filter(titan, is.na(titan$age)))
mean(titan$age, na.rm = TRUE )
median(titan$age, na.rm = TRUE )

#titan$age <- replace(titan$age, list = is.na(titan$age), values = mean(titan$age, na.rm = TRUE ))
titan$age[is.na(titan$age)] <- mean(titan$age, na.rm = TRUE )

#count ( filter(titan, is.na(titan$age)))  
mean(titan$age, na.rm = TRUE )
median(titan$age, na.rm = TRUE )


# *** 3: Lifeboat
#You’re interested in looking at the distribution of passengers in different lifeboats, but as we know,
#many passengers did not make it to a boat :-( This means that there are a lot of missing values in the
#boat column. Fill these empty slots with a dummy value e.g. the string 'None' or 'NA'

#count ( filter(titan, is.na(titan$boat)))
titan$boat[is.na(titan$boat)] <- "None"
#count ( filter(titan, is.na(titan$boat)))


# *** 4: Cabin
#You notice that many passengers don’t have a cabin number associated with them.
#Does it make sense to fill missing cabin numbers with a value?
#What does a missing value here mean?
#You have a hunch that the fact that the cabin number is missing might be a useful indicator of survival
#Create a new column has_cabin_number which has 1 if there is a cabin number, and 0 otherwise.
titan <-  mutate(titan, has_cabin_number = as.numeric(!is.na(titan$cabin)))

#save output
write_csv(titan, "~/R/Springboard/DWE 2/titanic_clean.csv", 
          na = "", append = FALSE, col_names = TRUE)