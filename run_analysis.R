###############################################################################
# Assignment Week 4 
# 
# Author: Andreas Kunert
# Titel: run_analysis.R
###############################################################################
# 

library(dplyr)
library(tidyr)

##### STEP 1: Merging Data
#####

# Setting the working directory 
setwd("~/Documents/GET_CLEAN_TIDY/GET_CLEAN_TIDY/DATA/UCI HAR Dataset/test")


# Setting up the different files

## Test data set: measurements 
fileTestData <- "~/Documents/GET_CLEAN_TIDY/GET_CLEAN_TIDY/DATA/UCI HAR Dataset/test/x_test.txt"

## Test data set: activity labels
fileTestActivity <- "~/Documents/GET_CLEAN_TIDY/GET_CLEAN_TIDY/DATA/UCI HAR Dataset/test/y_test.txt"

fileSubjectTest <-  "~/Documents/GET_CLEAN_TIDY/GET_CLEAN_TIDY/DATA/UCI HAR Dataset/test/subject_test.txt"


# DATA SET -- TRAINIG DATA SET --- 70% of the 30 volunteers - (21)
#

fileTrainData <- "~/Documents/GET_CLEAN_TIDY/GET_CLEAN_TIDY/DATA/UCI HAR Dataset/train/x_train.txt"

# Subject key for the trainig data set

fileSubjectTrain <- "~/Documents/GET_CLEAN_TIDY/GET_CLEAN_TIDY/DATA/UCI HAR Dataset/train/subject_train.txt"

# TRAIN SET Activity labels
fileTrainActivity <- "~/Documents/GET_CLEAN_TIDY/GET_CLEAN_TIDY/DATA/UCI HAR Dataset/train/y_train.txt"


fileFeaturesLabel <- "~/Documents/GET_CLEAN_TIDY/GET_CLEAN_TIDY/DATA/UCI HAR Dataset/features.txt"

fileActivityLabel <- "~/Documents/GET_CLEAN_TIDY/GET_CLEAN_TIDY/DATA/UCI HAR Dataset/activity_labels.txt"


data_test <- read.table(fileTestData)
activity_test <- read.table(fileTestActivity)
subject_test <- read.table(fileSubjectTest)

data_train <- read.table(fileTrainData)
activity_train <- read.table(fileTrainActivity) 
subject_train <- read.table(fileSubjectTrain)

# Load features description 

LabelFeatures <- read.table(fileFeaturesLabel)

# Load activity description
LabelActivities <- read.table(fileActivityLabel)

# Des
names(data_test) <- LabelFeatures[,2]
names(data_train) <- LabelFeatures[,2]


# Selection of all variables from  that contain Mean or Std in their name
Test_ES_DF <- data_test[, grep("[Mm]ean|[Ss]td", names(data_test), value = TRUE)]
Train_ES_DF <- data_train[, grep("[Mm]ean|[Ss]td", names(data_train), value = TRUE)]

rm(data_train)
rm(data_test)


# Merging the 
Test_DF <- cbind(subject_test, activity_test, Test_ES_DF)
Training_DF <- cbind(subject_train, activity_train, Train_ES_DF)


names(Test_DF)[1] <- "NSubject"
names(Training_DF)[1] <- "NSubject"
names(Test_DF)[2] <- "NActivity"
names(Training_DF)[2] <- "NActivity"


# Merging the test and train data to one complete dataset
Tidy_Data <- tbl_df(rbind(Test_DF,  Training_DF))
# Removing some data (housekeeping operation)
rm(Test_DF)
rm(Training_DF)


# Extraction of the mean() and  std() 
# FINAL STEP - 


# Naming activities in the data set

Tidy_Data$NActivity <- factor(Tidy_Data$NActivity, levels = LabelActivities[, 1], labels = LabelActivities[, 2])

names(Tidy_Data) <- gsub(pattern = "-+|,+|\\(|\\)", replacement = "", tolower(names(Tidy_Data)))

setwd("~/Documents/GET_CLEAN_TIDY/GET_CLEAN_TIDY/")

write.csv(Tidy_Data, file = "TIDY_DATA.csv")
write.csv(names(Tidy_Data), file = "VARIABLE_NAMES.csv")


# Computation of each subject and eac
Mean_DF <- Tidy_Data %>%
group_by(nsubject, nactivity) %>%
summarise_each(funs(mean))

write.csv(Mean_DF, file = "MEAN_DATA.csv")


        












# End of File -- Have a nice day!
###############################################################################
