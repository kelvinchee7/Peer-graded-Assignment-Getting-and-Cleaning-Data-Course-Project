
# Please install dplyr package before running the script

# Code Blocks to Read feature list and activity names from the features.txt file and activity_labels.txt file
List_Of_Feature <- read.table("features.txt", col.names = c("no","features"))
activity <- read.table("activity_labels.txt", col.names = c("label", "activity"))


#Code Blocks to Read test data set and combine into one data frame
Test_Subject_Data <- read.table("test/subject_test.txt", col.names = "subject")
X_Test_Data <- read.table("test/X_test.txt", col.names = List_Of_Feature$features)
Y_Test_Data <- read.table("test/Y_test.txt", col.names = "label")
Label_Test_Y <- left_join(Y_Test_Data, activity, by = "label")

Binding_tidy_test_Data <- cbind(Test_Subject_Data, Label_Test_Y, X_Test_Data)
Binding_tidy_test_Data <- select(Binding_tidy_test_Data, -label)


#Code Blocks to  Read train dataset
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
x_Data_train <- read.table("train/X_train.txt", col.names = List_Of_Feature$features)
y_Data_train <- read.table("train/Y_train.txt", col.names = "label")
Label_Y_TrainData <- left_join(y_Data_train, activity, by = "label")

Tidy_Train_Data <- cbind(subject_train, Label_Y_TrainData , x_Data_train)
Tidy_Train_Data <- select(Tidy_Train_Data, -label)

# Code Blocks to combine test and train data set
Merge_tidy_Dataset <- rbind(Binding_tidy_test_Data, Tidy_Train_Data)

# Code Blocks to Extract mean and standard deviation
Mean_and_Tidy_Standard_DeviationData <- select(Merge_tidy_Dataset, contains("mean"), contains("std"))

# Code Blocks to Average all variable by each subject at each activity
Mean_and_Tidy_Standard_DeviationData$subject <- as.factor(Merge_tidy_Dataset$subject)
Mean_and_Tidy_Standard_DeviationData$activity <- as.factor(Merge_tidy_Dataset$activity)

Average_Tidy_Dataset <- Mean_and_Tidy_Standard_DeviationData %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))