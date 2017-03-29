# *** References
library(tidyr)
library(dplyr)
library(readr)

# *** 0: Load the data in RStudio
  #Load the training and test data sets into RStudio, each in their own data frame.

#Get activity Labels
act_labels <- read_delim("~/R/Springboard/DWE 3/UCI HAR Dataset/activity_labels.txt", 
                       delim = " ", col_names = c("act_num", "act_label"), 
                       col_types = list(act_num = col_integer(), act_label = col_character()))
#act_labels <- act_labels$label

#Get features
feats <- read_delim("~/R/Springboard/DWE 3/UCI HAR Dataset/features.txt", 
                         delim = " ", col_names = c("index", "feature"), 
                         col_types = list(index = col_integer(), feature = col_character()))
#feats <- feats$feature


# ** Train

# * Load files
# get People
subjects <- read_csv("~/R/Springboard/DWE 3/UCI HAR Dataset/train/subject_train.txt",
                       col_names = "subjects", col_types = "i")
# get activities
acts <- read_csv("~/R/Springboard/DWE 3/UCI HAR Dataset/train/y_train.txt",
                     col_names = "act_num", col_types = "i")

#pull in test data
test_data <- read_csv("~/R/Springboard/DWE 3/UCI HAR Dataset/train/x_train.txt",
                      col_names = "alldata", col_types = "c")

#parse test data into columns
test_data <- separate(test_data, alldata, feats$feature,
                      sep = "[ ]{1}[ ]?", remove = TRUE, convert = TRUE )

# * Start Data Frame
train <- data_frame(subjects = subjects$subjects, act_num = acts$act_num)
train <- tbl_df(train)

#pull in activity labels
train <- left_join(train, act_labels, by = "act_num")

#mark data source
train <- mutate(train, data_source = "TRAIN")

#pull in test_data
train <- bind_cols(train, test_data)







# 1: Merge data sets
#Merge the training and the test sets to create one data set.

# 2: Mean and standard deviation
#Create two new columns, containing the mean and standard deviation for each measurement respectively. Hint: Since some feature/column names are repeated, you may need to use the make.names() function in R.

# 3: Add new variables
#Create variables called ActivityLabel and ActivityName that label all observations with the corresponding activity labels and names respectively

#4: Create tidy data set
#From the data set in step 3, creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


#5: Submit on github
#Put all of your code for steps 1-4 above in a single R script file called run_analysis.R. In a single github repository, add the following:

#  The tidy data set which is the result of steps 1-4
#Your run_analysis.R script
#A code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md.
#A README.md file, that explains how all of the scripts work and how they are connected. 
#Submit a link to your github repository containing all of these 4 deliverables.