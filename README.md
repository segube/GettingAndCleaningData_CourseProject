## Getting and Cleaning Data - CourseProject

This repository contains the R script and documentation for the Coursera Data Science Track course Getting & Cleaning Data needed to complete the assignment during Week 4 of the course.

# Purpose and goal

The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

A description of the data can be found at the following address: Repository'(http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The source data can be found at the following address:(https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

The goal of the the project was to create an R script called run_analysis.R that does the following: 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


###Files 'CodeBook.md' contains information on the variables, data set, transformations and work that was done to tidy up the data

'run_analysis.R' is the code for the R script used to complete the project goals

'FinalTidyData.txt' is the output from the 'runAnalysis.R' R script
