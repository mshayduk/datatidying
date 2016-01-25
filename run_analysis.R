library(data.table)
suppressWarnings(library(dplyr))

setwd("~/Work/Developer/Coursera/DataScience/Getting_and_Cleaning_Data/")
if(file.exists("UCI HAR Dataset.zip")){
    unzip("./UCI HAR Dataset.zip")
}else{
    stop("File `UCI HAR Dataset.zip` not found. Please, download the file to your working directory.")
}
setwd("./UCI HAR Dataset/")

#*****************************************************************************************************
# READ data
# Reading activity labels and features names
activityLabels <- fread("activity_labels.txt", sep = " ", header = FALSE, data.table = F)
activityLabels <- activityLabels[, 2]
featuresNames <- fread("features.txt", sep = " ", header = FALSE, data.table = F)
featuresNames <- featuresNames[, 2]

# This function reads the data from files in  "dataset" subdirectory and: 
# 1. Binds data by columns:  the subject, the activity and the rawdata (561-dim feature vector).
# 2. Returns data.table with descriptive column names: "subjectID", "activityLabel", c(featuresNames)
readData <- function(dataset = "train")
{
    # reading data with specified colNames parameter!
    subjectID <- fread(paste("./", dataset, "/subject_", dataset, ".txt", sep=""), col.names = "subjectID", header = F)
    rawdata <- fread(paste("./", dataset, "/X_", dataset, ".txt", sep=""), sep=" ", col.names = featuresNames, header = F)
    activity <- fread(paste("./", dataset, "/y_", dataset, ".txt", sep=""), col.names = "activityLabel", header = F)
    # merging observations IDs and variables
    dt <- data.table(subjectID, activity, rawdata)
    # making factors out of categorical variables
    dt$activityLabel <- factor(dt$activityLabel, labels = activityLabels)
    dt
}
# Reading train and test datasets 
traindata <- readData("train");
testdata <- readData("test");


#*****************************************************************************************************
# MERGE the training and the test sets to create one data set.
# Binding sets by rows 
dataMerged <- rbind(traindata, testdata)


#*****************************************************************************************************
# EXTRACT only the measurements on the mean and standard deviation for each measurement.
# selecting mean() and std() related variables
subsetColInd <- c(grep("-mean\\(\\)|-std\\(\\)|meanFreq", colnames(dataMerged)))
# subsetting by columns with dplyr and sort by activity and subject
dataSubset <- select(dataMerged, c(subjectID, activityLabel, subsetColInd))
dataSubset <- dataSubset[order(activityLabel, subjectID), ]


#******************************************************************************************************
# CREATE TIDY independent data set with the average of each variable for each activity and each subject.
# getting new indicies of columns (subsetColInd <- c(3:68) can be used as well):
subsetColInd <- c(grep("-mean\\(\\)|-std\\(\\)|meanFreq", colnames(dataSubset)))
# averaging columns c(meanColInd, stdColInd) by subject for every activityLabel separately
tidyData <- dataSubset[, lapply(.SD, mean), by=list(subjectID, activityLabel), .SDcols = subsetColInd]
# to avoid periods in variable names when the data will be read in, remove "-", "(", ")"
# colnames(tidyData) <- gsub("-|\\(|\\)","", colnames(tidyData))

write.table(tidyData, "../UCI_HAR_tidy.txt", row.names = F)
