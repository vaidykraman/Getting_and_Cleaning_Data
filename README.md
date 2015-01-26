# Getting_and_Cleaning_Data
This is the repository for Data Science Specialization course offered by John Hopkins University - Getting and Cleaning Data

Background:
This Repository contains R Script, run_analysis.R that was used to create Tidy dataset. The Raw data was provided from an experimental study in the "Wearable Computing". The experimental study engaged 30 volunteer who were provided with the wearable. All their activities were captured to do further research on improving the product.

Data was obtained from the following site.

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Raw Data was made available for this project at :

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# How does the script work: 
      The comments in the run_analysis.R provides detailed description of the logic used to prepare the tiny data set. I am outlining the summary of the logic used to prepare the dataset here.

1. The script read two set of data files : Training and Test. For each set, the following data files are available.
    - Identifier for volunteers that participated in the test. (train_subject.txt & test_subject.txt)
    - List of Activity that each of the volunteers engaged in while wearing the wearable device. (activity_labels.txt)
    - List of features that were measured by the device (features.txt)
    - Measurements captured by the device (X_test.txt, X_train.txt)
    - Activity that Volunteers engaged in (y_test.txt, y_train.txt)

2. All the above files are loaded into a dataframe.
3. The objective of this exercise is to summarize the mean and standard deviation of various measurements.
4. The measures that are required to summarize were filtered (from features.txt) and the data associated with measures were filtered (X_test.txt and X_train.txt).
5. The test and train data set were combined.
6. Reshaping function reshape2::melt was used to convert all the measurement columns into key, value pairs for every Volunteer(Subject) and Activity.
7. Reshaping function reshape2::dcast was used to find the mean of all the measure for every Volunteer(Subject) and Activity.
8. The tidy data set was written to a text file using data.table() function.
9. The details list of variables captured and the summary information is available in codebook.md
