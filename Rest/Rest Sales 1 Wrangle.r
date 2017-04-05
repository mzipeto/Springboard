# References
library(readr)
library(tidyr)
library(dplyr)


# load file
sales <- read_csv("~/R/Springboard/Rest/Rest Sales 1 Data.csv", col_names = TRUE)
sales <- tbl_df(sales)


# Add week number column. Don't use any systems, since we have whole weeks:
  #just count from 1 to 52 and start over (use modulo)

sales$WeekNum <- sapply(1:nrow(sales), function(x) (((x - 1) %% 52) + 1))


#Convert string dates to dates: first separate into two columns
sales <- separate(sales, Dates, into = c("WeekStartTEXT", "WeekEndTEXT"), sep = "-")

#add blank date columns 
sales$WeekStart <- as.Date("2000-01-01")
sales$WeekEnd <- as.Date("2000-01-01")

#fix the dates: march sequentially through table and fix them
for (i in 1:nrow(sales)){
  
  
  if (sales[i,"WeekNum"] == 1 & grepl("^12/", sales[i,"WeekStartTEXT"])) {
    
    #If It's Week 1, and the Start date is still December (12), use Year - 1 for December
    sales[i,"WeekStart"] <- as.Date(paste((sales[i,"Year"] - 1),
                                          gsub("[/].*", "", sales[i,"WeekStartTEXT"]),
                                          gsub(".*[/]", "", sales[i,"WeekStartTEXT"]), sep = "-"))
    sales[i,"WeekEnd"] <- as.Date(paste(sales[i,"Year"] ,
                                        gsub("[/].*", "", sales[i,"WeekEndTEXT"]),
                                        gsub(".*[/]", "", sales[i,"WeekEndTEXT"]), sep = "-"))
  
    } else if (sales[i,"WeekNum"] == 52 & grepl("^1/", sales[i,"WeekEndTEXT"])){
    
        #If It's Week 52, and the End date is already January (1), use Year + 1 for January
        sales[i,"WeekStart"] <- as.Date(paste(sales[i,"Year"],
                                              gsub("[/].*", "", sales[i,"WeekStartTEXT"]),
                                              gsub(".*[/]", "", sales[i,"WeekStartTEXT"]), sep = "-"))
        sales[i,"WeekEnd"] <- as.Date(paste((sales[i,"Year"] + 1) ,
                                            gsub("[/].*", "", sales[i,"WeekEndTEXT"]),
                                            gsub(".*[/]", "", sales[i,"WeekEndTEXT"]), sep = "-"))
    
  } else {
    
    #just use the Year directly for both
    sales[i,"WeekStart"] <- as.Date(paste(sales[i,"Year"],
                                          gsub("[/].*", "", sales[i,"WeekStartTEXT"]),
                                          gsub(".*[/]", "", sales[i,"WeekStartTEXT"]), sep = "-"))
    sales[i,"WeekEnd"] <- as.Date(paste(sales[i,"Year"],
                                        gsub("[/].*", "", sales[i,"WeekEndTEXT"]),
                                        gsub(".*[/]", "", sales[i,"WeekEndTEXT"]), sep = "-"))
  }

}


#reorder and drop columns
sales <- select(sales, WeekStart, WeekEnd, Year, WeekNum, Sales)


#Output cleaned data
write_csv(sales, "~/R/Springboard/Rest/Rest Sales 1 Data CLEAN.csv")
