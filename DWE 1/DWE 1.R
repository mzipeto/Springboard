# *** References
library(tidyr)
library(dplyr)


# *** 0: Load the data in RStudio

sales <- read.table("~/R/Springboard/DWE 1/refine.csv", header=TRUE, sep=",")
sales <- tbl_df(sales)


# *** 1: Clean up brand names

#Acceptable values are "philips", "akzo", "van houten" and "unilever" (all LC)
sales$company <- sales$company %>%
  sub(pattern = "[FfPp].*[Pp][Ss]", replacement = "philips" ) %>%
  sub(pattern = "[Aa][Kk].*", replacement = "akzo" ) %>%
  sub(pattern = "[Vv][Aa][Nn].*", replacement = "van houten" ) %>%
  sub(pattern = "[Uu][Nn].*[Ee][Rr]", replacement = "unilever" )


# *** 2: Separate product code and number

sales <- mutate(sales, 
                ProductCode = sub("[-].*", "", Product.code...number), 
                ProductNumber = sub(".*[-]", "", Product.code...number))


# *** 3: Add product categories

#function to convert codes to categories with regex
get_category <- function(prod_code){

  category <- prod_code %>%
    sub(pattern = "[p]", replacement = "Smartphone") %>%
    sub(pattern = "[v]", replacement = "TV") %>%
    sub(pattern = "[x]", replacement = "Laptop") %>%
    sub(pattern = "[q]", replacement = "Tablet")
    
  return (category)
}

#apply function to create new column
sales <- mutate(sales, Category =  get_category(sales$ProductCode))


# *** 4: Add full address for geocoding
sales <- unite(sales, "full_address", address, city, country, sep = ", ", remove = FALSE)  


# *** 5: Create dummy variables for company and product category

sales <- mutate(sales,
                company_philips = as.numeric(sales$company == "philips" ), 
                company_akzo = as.numeric(sales$company == "akzo" ), 
                company_van_houten = as.numeric(sales$company == "van_houten" ), 
                company_unilever = as.numeric(sales$company == "unilever" ))

sales <- mutate(sales,
                product_smartphone = as.numeric(sales$Category == "Smartphone" ), 
                product_tv = as.numeric(sales$Category == "TV" ), 
                product_laptop = as.numeric(sales$Category == "Laptop" ), 
                product_tablet = as.numeric(sales$Category == "Tablet" ))


#save output
write.table(sales, "~/R/Springboard/DWE 1/refine_clean.csv", row.names = FALSE, sep=",")