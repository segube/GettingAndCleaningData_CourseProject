## The purpose of this script is to collect, work with, and clean the data set.
## The goal of this script is to prepare tidy data to be used for later analysis. 

## The dataset is located at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


## This script (run_analysis.R will perform the following)  
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

## Preparation - Load Packages
## Load packages 
library(data.table) 
library(dplyr) 

## Step  1. Merges the training and the test sets to create one data set.
if(!file.exists("./data")){dir.create("./data")}
if(!file.exists("C:/Users/HP/Documents/data/Course Project")) {dir.create("C:/Users/HP/Documents/data/Course Project")}
setwd("C:/Users/HP/Documents/data/Course Project")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="C:/Users/HP/Documents/data/Course Project/Dataset.zip")
dateDownloaded = as.Date(Sys.time())
unzip("Dataset.zip")
setwd("./UCI HAR Dataset")

## Read Other Data  
activity_labels <- read.table("./activity_labels.txt", header = FALSE); colnames(activity_labels) <- c("activityId","activityType")
features <- read.table("./features.txt", header = FALSE) 

## Read Test Data
features_test <- read.table("./test/X_test.txt", header = FALSE); colnames(features_test) <- features[,2]; 
activity_test <- read.table("./test/y_test.txt", header = FALSE); colnames(activity_test) <- "activityId";
subject_test <- read.table("./test/subject_test.txt", header = FALSE); colnames(subject_test) <- "subjectId"

## Read Train Data
features_train <- read.table("./train/X_train.txt", header = FALSE); colnames(features_train) <- features[,2]
activity_train <- read.table("./train/y_train.txt", header = FALSE); colnames(activity_train) <- "activityId";
subject_train <- read.table("./train/subject_train.txt", header = FALSE); colnames(subject_train) <- "subjectId"



## Merge Test Data
test_dataset = cbind(subject_test,features_test,activity_test) 

## Merge Train Data
train_dataset = cbind(subject_train,features_train,activity_train) 

## Add Test to the Training Data
test_dataset$Type = "Test"

## Add Training to the Training Data
train_dataset$Type = "Training"

## Merge train_dataset and test_dataset 
merged_dataset = rbind(train_dataset,test_dataset)

## Create columns vector to prepare data for subsetting 
columns <- colnames(merged_dataset)

## Step 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

## Create a vector identifying the ID, mean & stddev columns as TRUE 
vector <- (grepl("activity..",columns) | grepl("subject..",columns) | grepl("-mean..",columns) & 
    !grepl("-meanFreq..",columns) & !grepl("mean..-",columns) | grepl("-std..",columns) & !grepl("-std()..-",columns)); 

## Update MergedDataSet based on previously identified columns 
measurement_subset <- merged_dataset[vector==TRUE]; 

## Step 3. Uses descriptive activity names to name the activities in the data set

## Add descriptive activity names to measurement_subset & update columns vector 
measurement_subset <- merge(measurement_subset,activity_labels,by='activityId',all.x=TRUE) 
measurement_subset$activityId <- activity_labels[,2][match(measurement_subset$activityId, activity_labels[,1])]  
  
columns <- colnames(measurement_subset) 
 
## Step 4. Label the data set with descriptive variable names. 

## Tidy column names 
for (i in 1:length(columns)) { 
    columns[i] <- gsub("\\()","",columns[i]) 
    columns[i] <- gsub("-std$","StdDev",columns[i]) 
    columns[i] <- gsub("-mean","Mean",columns[i]) 
    columns[i] <- gsub("^(t)","time",columns[i]) 
    columns[i] <- gsub("^(f)","freq",columns[i]) 
    columns[i] <- gsub("([Gg]ravity)","Gravity",columns[i]) 
    columns[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",columns[i]) 
    columns[i] <- gsub("[Gg]yro","Gyro",columns[i]) 
    columns[i] <- gsub("AccMag","AccMagnitude",columns[i]) 
    columns[i] <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",columns[i]) 
    columns[i] <- gsub("JerkMag","JerkMagnitude",columns[i]) 
    columns[i] <- gsub("GyroMag","GyroMagnitude",columns[i]) 
    }
           
## Update measurement_subset with new descriptive column names 
colnames(measurement_subset) <- columns 

## Remove activityType column 
measurement_subset <- measurement_subset[,names(measurement_subset) != "activityType"] 

## Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## Averaging each activity and each subject as Tidy Data 
tidy_data <- aggregate(measurement_subset[,names(measurement_subset)  
    != c("activityId","subjectId")],by=list 
        (activityId=measurement_subset$activityId, 
            subjectId=measurement_subset$subjectId),mean) 
  
## Export tidy_data set  
setwd("C:/Users/HP/Documents/data/Course Project/")
write.table(tidy_data,"./tidy_data.txt",row.names=FALSE,sep="\t") 

## Restore Working Directory
setwd("C:/Users/HP/Documents")