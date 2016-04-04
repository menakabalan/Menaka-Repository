
##Get the list of files in the UHI HAR Dataset Directory
path_rf <- file.path("./data" , "UCI HAR Dataset")

files<-list.files(path_rf, recursive=TRUE)

files


##Load data from files to Variables
dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)

dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)

dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)

dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)


##View data in Variables.
str(dataActivityTest)

str(dataActivityTrain)

str(dataSubjectTrain)

str(dataSubjectTest)

str(dataFeaturesTest)

str(dataFeaturesTrain)


##1.Merges the training and the test sets to create one data set.
###Concatenate data tables
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)

dataActivity<- rbind(dataActivityTrain, dataActivityTest)

dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

###Set Names
names(dataSubject)<-c("subject")

names(dataActivity)<- c("activity")

dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)

names(dataFeatures)<- dataFeaturesNames$V2

### Combine Datasets
dataCombine <- cbind(dataSubject, dataActivity)

Data <- cbind(dataFeatures, dataCombine)

##2.Extracts only the measurements on the mean and standard deviation for each measurement.
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )

Data<-subset(Data,select=selectedNames)

str(Data)

##3.Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

Data$activity<-factor(Data$activity)

Data$activity<- factor(Data$activity,labels=as.character(activityLabels$V2))


##4.Appropriately labels the data set with descriptive variable names.
names(Data)<-gsub("^t", "time", names(Data))

names(Data)<-gsub("^f", "frequency", names(Data))

names(Data)<-gsub("Acc", "Accelerometer", names(Data))

names(Data)<-gsub("Gyro", "Gyroscope", names(Data))

names(Data)<-gsub("Mag", "Magnitude", names(Data))

names(Data)<-gsub("BodyBody", "Body", names(Data))


##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)

Data2<-aggregate(. ~subject + activity, Data, mean)

Data2<-Data2[order(Data2$subject,Data2$activity),]

write.table(Data2, file = "tidydata.txt",row.name=FALSE)

