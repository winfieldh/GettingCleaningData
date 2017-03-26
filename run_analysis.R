library(dplyr)

#specify where data is
directory <- "./UCIHAR/"

#read data
#
features <- read.table(paste(directory,"features.txt",sep=""))
subject_test <- read.table(paste(directory,"test/subject_test.txt",sep=""))
subject_train <- read.table(paste(directory,"train/subject_train.txt",sep=""))
X_test <- read.table(paste(directory,"test/X_test.txt",sep=""))
y_test <- read.table(paste(directory,"test/y_test.txt",sep="")) #descriptive activity labels
X_train <- read.table(paste(directory,"train/X_train.txt",sep=""))
y_train <- read.table(paste(directory,"train/y_train.txt",sep="")) #descriptive activity labels
activity_labels <- read.table(paste(directory,"activity_labels.txt",sep=""))

#4. Uses descriptive activity names to name the activities in the data set
colnames(X_train) <- features[,2]
colnames(X_test) <- features[,2]

#add subject df to test/train df then rename column heading
X_train <- cbind(subject_train[,1],X_train)
colnames(X_train)[1] <- "Subject_ID"
X_test <- cbind(subject_test[,1],X_test)
colnames(X_test)[1] <- "Subject_ID"

#add activity name df to test/train and rename column heading
X_train <- cbind(y_train[,1],X_train)
colnames(X_train)[1] <- "Activity_Name"
X_test <- cbind(y_test[,1],X_test)
colnames(X_test)[1] <- "Activity_Name"

#1. Merges the training and the test sets to create one data set.
mydata1 <- rbind(X_test,X_train)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
mydata2 <- mydata1[,grep("Name|ID|mean|std",names(mydata1))]

#3. Uses descriptive activity names to name the activities in the data set
# This loop assigns the activity labels to the Activity Number column 
# for (i in seq_len(nrow(activity_labels))){
#         mydata2$Activity_Name[mydata2$Activity_Name == i] <- activity_labels[i,2]
# }
        mydata2$Activity_Name[mydata2$Activity_Name == 1] <- "WALKING"
        mydata2$Activity_Name[mydata2$Activity_Name == 2] <- "WALKING_UPSTAIRS"
        mydata2$Activity_Name[mydata2$Activity_Name == 3] <- "WALKING_DOWNSTAIRS"
        mydata2$Activity_Name[mydata2$Activity_Name == 4] <- "SITTING"
        mydata2$Activity_Name[mydata2$Activity_Name == 5] <- "STANDING"
        mydata2$Activity_Name[mydata2$Activity_Name == 6] <- "LAYING"
        
#5 create tidy data set with the average of each variable for each activity and each subject.
mytidy <- mydata2 %>% group_by(Activity_Name,Subject_ID) %>% summarise_all(mean)

# create excel output file for submission
library(xlsx)
mytidydf <-as.data.frame(mytidy)
write.table(mytidydf, "mytidy.txt", row.names=FALSE)
