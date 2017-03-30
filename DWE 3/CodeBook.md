List of variables used:

act_names <- A lookup for Activities: relates strings (ActivityName) to integers (ActivitityLabel)
  Read in from: "/UCI HAR Dataset/activity_labels.txt"
                       
feats <- a Vector of Column Names for the 651 Features available (precalculated data, based on the raw data)
  Read in from: "/UCI HAR Dataset/features.txt"
  Table contains 84 column names with redundant names; processed to modify names to be unique where required.
  
train_set 
test_set

Main data frames, both have same structure.

subjects  ActivityLabel ActivityName  data_source [DataColumn] x 86 total data columns 
<int>     <int>         <chr>         <chr>             <dbl> 
1         5             STANDING       TRAIN         0.2885845

