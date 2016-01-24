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

All data processing is done within a single scripts **run_analysis.R**. To guide the eye the script is divided into several logical blocks named 'READ', 'MERGE', 'EXTRACT' and 'CREATE TIDY'. 
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


####'MERGE' block:####
  * Merges the training and the test sets to one data-set with rbind(...)

####'EXTRACT' block:####
  * Subsets the data-set by the certain set of variables.
  * Sorts the resulting data.
    
####'CREATE TIDY' block:####
  * Makes from the sorted data, created in 'EXTRACT' block, a new tidy data-set with the average of each variable for each activity and each subject.
  * Saves the tidy dataset to the file **UCI_HAR_tidy.txt**

###Tidy dataset####

