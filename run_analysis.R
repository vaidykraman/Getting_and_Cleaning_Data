### Acknowledgement of dataset used for the data analysis.
### License:
### ========
### Use of this dataset in publications must be acknowledged by referencing the following publication [1] 
###
### [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity 
### Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. 
### International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
### 
### This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the 
### authors or their institutions for its use or misuse. Any commercial use is prohibited.
### 
### Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.


###  
### Reading the Activity List from the file while assigning meaningful column names
###  

activityList <- read.table("activity_labels.txt",header=FALSE,sep=" ",col.names=c('Activity_Code','Activity_Type'),stringsAsFactor=FALSE)

###  
### Reading the Feature List which is set of measurements collected for each subject
### 

featureList <- read.table("features.txt",header=FALSE,sep=" ",col.names=c('Measure_Code','Measurement_Name'),stringsAsFactor=FALSE)
featureList

### 
### Compiling the test data
###
### Test data is distributed in 3 files. 
### 
### test\subject_test.txt stores the identifier of volunteers that participated in this test
### 
### test\X_test.txt stores the measurements collected from the training. List of measurements are 
### stored in featureList data frame listed above.
### 
### test\Y_test.txt stores the activity corresponding to each set of measurement in X_test.txt 
### 
### All the 3 files listed above will be read and combine the data frames. 
###
### As per the project requirements, only the mean and standard deviatiotn for each feature be
### extracted from test\X_test.txt. This is done by searching for string "mean()" and "std()"
### from featureList dataframe and identifying the associated "Measure_code". This "measure_code" will be
### used as the column number to be extracted from the "test\X_test.txt"

reqdMeasurement <- featureList[c(grep("mean()",featureList$Measurement_Name,fixed=TRUE),grep("std()",featureList$Measurement_Name,fixed=TRUE)) , ]

### Formatting the column name to be meaningful names for easy readability

reqdMeasurement$Measurement_Name <- sub(" ","",reqdMeasurement$Measurement_Name,fixed=TRUE)
reqdMeasurement$Measurement_Name <- gsub("-","_",reqdMeasurement$Measurement_Name,fixed=TRUE)
reqdMeasurement$Measurement_Name <- sub("std()","StandardDeviation",reqdMeasurement$Measurement_Name,fixed=TRUE)
reqdMeasurement$Measurement_Name <- sub("mean()","Mean",reqdMeasurement$Measurement_Name,fixed=TRUE)
reqdMeasurement$Measurement_Name <- sub("tBody","timeBody",reqdMeasurement$Measurement_Name,fixed=TRUE)
reqdMeasurement$Measurement_Name <- sub("fBody","frequencyBody",reqdMeasurement$Measurement_Name,fixed=TRUE)
reqdMeasurement$Measurement_Name <- sub("Acc","Acceleration",reqdMeasurement$Measurement_Name,fixed=TRUE)
reqdMeasurement$Measurement_Name <- sub("Mag","Magnitude",reqdMeasurement$Measurement_Name,fixed=TRUE)
reqdMeasurement$Measurement_Name <- sub("BodyBody","Body",reqdMeasurement$Measurement_Name,fixed=TRUE)
reqdMeasurement$Measurement_Name <- sub("tGravity","timeGravity",reqdMeasurement$Measurement_Name,fixed=TRUE)

##
## Width for reading the fixed width format file
##
widthList <- rep(c(-1,15),561)

testMeasurements <- read.fwf("test\\X_test.txt", widths = widthList, header=FALSE,dec=".",col.names=featureList$Measurement_Name,buffersize=100,colClasses="numeric",stringsAsFactor=FALSE)

testVolunteerList <- read.table("test\\subject_test.txt",header=FALSE,sep=" ",colClasses="character",col.names=c("Volunteer_ID"),stringsAsFactor=FALSE)

testVolActivityList <- read.table("test\\Y_test.txt",header=FALSE,sep=" ",colClasses="character",col.names=c("Activity_Code"),stringsAsFactor=FALSE)

## Extract the required measurements based on the filter mean() and std() as listed above

reqdTestMeasureList <- testMeasurements[,reqdMeasurement$Measure_Code]
colnames(reqdTestMeasureList) <- reqdMeasurement$Measurement_Name

## Combining all the dataframes - Subject list, Activity List and the measurements

library(plyr)
testMeasureList <- cbind(testVolunteerList,join(testVolActivityList,activityList,by="Activity_Code",type="left", match="first"), reqdTestMeasureList)

### 
### Compiling the training data
###
### Training data is distributed in 3 files. 
### 
### train\subject_train.txt stores the identifier of volunteers that participated in this training
### 
### train\X_train.txt stores the measurements collected from the training. List of measurements are 
### stored in featureList data frame listed above.
### 
### test\y_train.txt stores the activity corresponding to each set of measurement in X_test.txt 
### 
### All the 3 files listed above will be read and combine the data frames. 
###
### As per the project requirements, only the mean and standard deviatiotn for each feature be
### extracted from train\X_train.txt. This is done by searching for string "mean()" and "std()"
### from featureList dataframe and identifying the associated "Measure_code". This "measure_code" will be
### used as the column number to be extracted from the "train\X_train.txt"

trainMeasurements <- read.fwf("train\\X_train.txt", widths = widthList, header=FALSE,dec=".",col.names=featureList$Measurement_Name,buffersize=100,colClasses="numeric",stringsAsFactor=FALSE)

trainVolunteerList <- read.table("train\\subject_train.txt",header=FALSE,sep=" ",colClasses="character",col.names=c("Volunteer_ID"),stringsAsFactor=FALSE)

trainVolActivityList <- read.table("train\\y_train.txt",header=FALSE,sep=" ",colClasses="character",col.names=c("Activity_Code"),stringsAsFactor=FALSE)


## Extract the required measurements based on the filter mean() and std() as listed above

reqdTrainMeasureList <- trainMeasurements[,reqdMeasurement$Measure_Code]
colnames(reqdTrainMeasureList) <- reqdMeasurement$Measurement_Name

## Combining all the dataframes - Subject list, Activity List and the measurements

trainMeasureList <- cbind(trainVolunteerList,join(trainVolActivityList,activityList,by="Activity_Code",type="left", match="first"), reqdTrainMeasureList)

###
### Final List for processing tidy data 
### Combine the rows of Test and Training measurements from all the subjects
### The dataframe is reshaped so that all the measurements are listed as variables against
### the value. This is possible using the reshape::melt function
###
### dcase function is used to calculate the mean of all the measurements by each subject and Activity combination
###
### A flat file is created using the write.table function. Using the tab separater for easy readability of data.

library(reshape2)
finalMeasureList <- melt(rbind(testMeasureList,trainMeasureList),id=c("Volunteer_ID","Activity_Type"), measure.vars=reqdMeasurement$Measurement_Name)

finalResult <- dcast(finalMeasureList,Volunteer_ID + Activity_Type ~ variable,mean)

write.table(finalResult,"final_Result_Summary.txt",sep="\t",row.names=FALSE)

