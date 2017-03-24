# *** References

library(dplyr)


# *** 0: Load the data in RStudio

#file location = "C:/Users/Mark/Documents/R/Data Wrang 1/refine.csv"

#Can I sub in the project location? Either with a placeholder like the Tilde,
#or some kind of variable?

sales <- read.table("~/R/Springboard/DWE 1/refine.csv", header=TRUE, sep=",")

#fix that crappy header name
names(sales)[2] <- "Product_code_number"


# *** 1: Clean up brand names

#Acceptable values are "philips", "akzo", "van houten" and "unilever" (all LC)

#First thought was to [apply] the [sub] function on the column in the DF
#but I think I can just directly sub the column? 

#could this be automated to make it more resilient?
#like, could I step through the members of levels(sales$company) ?

levels(sales$company)
unique(sales$company)

#match "philips"
sales$company <- sub("[FfPp].*[Pp][Ss]", "philips", sales$company)

# once I do this, I no longer have acesss to levels(sales$company) ? (returns null)
levels(sales$company)
unique(sales$company)

#match "akzo"
sales$company <- sub("[Aa][Kk].*", "akzo", sales$company)

#match "van houten"
sales$company <- sub("[Vv][Aa][Nn].*", "van houten", sales$company)

#match "unilever"
sales$company <- sub("[Uu][Nn].*[Ee][Rr]", "unilever", sales$company)

levels(sales$company)
unique(sales$company)


# *** 2: Separate product code and number

#I think I can split the string with text functions, but maybe I should use Regexs

sales <- mutate(sales, 
                ProductCode = sub("[-].*", "", Product_code_number), 
                ProductNumber = sub(".*[-]", "", Product_code_number))


# *** 3: Add product categories

# my first thought was to use a Slecect Case, but I don't think R has that
#can I use regexs? no, becuase multiple replacments dont work?
#either way, build your own function

#build function to convert codes
get_category <- function(prod_code) {
  
  #THIS DOES NOT WORK
  
  if (prod_code == "p"){
    category <- "Smartphone"
  } else if (prod_code == "v") {
    category <- "TV"
  } else if (prod_code == "x") {
    category <- "Laptop"
  } else {
    category <- "Tablet"
  }
  
  return (category)
}

get_category_reg <- function(prod_code){
  
  category <- sub("[p]", "Smartphone", prod_code)
  category <- sub("[v]", "TV", category)
  category <- sub("[x]", "Laptop", category)
  category <- sub("[q]", "Tablet", category)
  
  return (category)
}

#apply function to create new column
sales <- mutate(sales, Category =  get_category_reg(sales$ProductCode))


# *** 4: Add full address for geocoding

# Stitch together threee columns: address   city         country  
sales <- mutate (sales, full_address = paste (address, city, country, sep = ", "))  


# *** 5: Create dummy variables for company and product category

#Add four binary (1 or 0) columns for company: company_philips, company_akzo, company_van_houten and company_unilever.
#Add four binary (1 or 0) columns for product category: product_smartphone, product_tv, product_laptop and product_tablet.

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

#let's see it
sales

#save output
write.table(sales, "~/R/Springboard/DWE 1/refine_clean.csv", row.names = FALSE, sep=",")

#header issue with the outout, I must be missing a switch
# maybe I should be surpressing the automatic index row?
# like slect columns NOT == blank ?
