# Tidying data from Smartphone Accelerometers
Maxim Shayduk  
January 16, 2016  

###Initial data-set###
The initial data-set should be downloaded from <http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip> to the working directory. The run_analysis.R scripts will unzip it automatically. For the detailed description of the data-set see README.txt and README.md. The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six Activities wearing a smartphone (Samsung Galaxy S II) on the waist.  The data from the smartphone accelerometers was recorded and processed, resulting in 561-dimensional feature vector. The data set is split into two subsets: train (70% of data) and test (30% of data). The variables in the data-set are:

  * Volunteer's ID (integer in range from 1 to 30)
  * Activity category (6 categories)
  * 561-dimensional feature vector, extracted from accelerometers data (float numbers)

 These variables are recorded in following files:

- './train/subject_train.txt': Volunteer's IDs (30 unique values).
- './train/y_train.txt': Activity categories (6 unique values).
- './train/X_train.txt': Training set (observations of 561 features).

- './test/subject_test.txt': Volunteer's IDs (30 unique values).
- './test/y_test.txt': Activity categories (6 unique values).  
- './test/X_test.txt': Test set (observations of 561 features).

The variables descriptions and names are recorded in following files:

- './features_info.txt': Information about the variables used on the feature vector.
- './features.txt': List of all features (561 features names).
- './activity_labels.txt': Descriptive labels for Activity categories (six number-name pairs).

###Data transformations###

All data processing is done within a single script **run_analysis.R**. To guide the eye the script is divided into several logical blocks named 'READ', 'MERGE', 'EXTRACT' and 'CREATE TIDY'. 
The code within the corresponding block does the following:

####'READ' block:####

  * Reads raw data files with fread(...): observational data for all variables from test and train directories
  * Reads features names from 'features.txt' and Activity labels from 'activity_labels.txt'
  * Assigns descriptive names to all variables with col.names argument of fread(...)
  * Makes factor out of Activity category with levels according to 'activity_labels.txt' 
  * Binds observations of all variables in one data.table.
  
The result of the 'READ' block looks like this (a first 3 observations of first 4 variables (out of 563) is shown):




```
##   subjectID activityLabel tBodyAcc-arCoeff()-Z,3 tGravityAcc-mean()-Z
## 1         1      STANDING             0.49193596            0.1153749
## 2         1      STANDING            -0.01665654            0.1093788
## 3         1      STANDING             0.17386318            0.1018839
```

The units of variables have not changed compared to the original data set. Below the variable names and their units are listed:

| Column| Variable name  | Decription  | Type  | Units  | Range  |
|---|---|---|---|---|---|
|1| subjectID  |  Volunteer's IDs |  int |  # |  [1,30] |
|2| activityLabel | Activity categories | factor | category | 6 levels |
|3| tBodyAcc-mean()-X | 1-st feature , extracted from accelerometer signals | num| dimensionless | [-1,1] |
|4| tBodyAcc-mean()-Y | 2-nd feature , extracted from accelerometer signals | num| dimensionless | [-1,1] |
|...| ... | ... | ...| ... | [-1,1] |
|562| angle(Y,gravityMean) | 560-th feature , extracted from accelerometer signals | num| dimensionless | [-1,1] |
|563| angle(Z,gravityMean) | 561-st feature , extracted from accelerometer signals | num| dimensionless | [-1,1] |

The full name notation of the feature vector can be found in **features_info.txt** file that comes with the original dataset.

####'MERGE' block:####
  * Merges the training and the test sets to one data-set with rbind(...)

####'EXTRACT' block:####
  * Subsets the data-set by the set of features,  containing "-std()" or "-mean()" patterns in their name. 
  * Hierarchically sorts the resulting subset (68 columns) by activityLabel and by subjectID.
  
  The 66 features selected by subsetting are:
  

```
##  [1] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"          
##  [3] "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"           
##  [5] "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"           
##  [7] "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"       
##  [9] "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"        
## [11] "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"        
## [13] "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"      
## [15] "tBodyAccJerk-mean()-Z"       "tBodyAccJerk-std()-X"       
## [17] "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"       
## [19] "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"         
## [21] "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"          
## [23] "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"          
## [25] "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"     
## [27] "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"      
## [29] "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"      
## [31] "tBodyAccMag-mean()"          "tBodyAccMag-std()"          
## [33] "tGravityAccMag-mean()"       "tGravityAccMag-std()"       
## [35] "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"      
## [37] "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"         
## [39] "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"     
## [41] "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"          
## [43] "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"           
## [45] "fBodyAcc-std()-Y"            "fBodyAcc-std()-Z"           
## [47] "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"      
## [49] "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"       
## [51] "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"       
## [53] "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"         
## [55] "fBodyGyro-mean()-Z"          "fBodyGyro-std()-X"          
## [57] "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"          
## [59] "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
## [61] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"  
## [63] "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"     
## [65] "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()"
```
 
    
####'CREATE TIDY' block:####
  * Makes from the sorted data, created in 'EXTRACT' block, a new tidy data-set with the average of each feature variable for each activity and each subject.
  * To avoid periods in variable names when the data will be read in, removes "-", "(" and ")", so that 66 feature names become: "tBodyAccmeanX", "tBodyAccmeanY", "tBodyAccmeanZ"...etc. 
  * Saves the tidy dataset with the write.table(...) function to the space-separated file **UCI_HAR_tidy.txt**.

<br>

