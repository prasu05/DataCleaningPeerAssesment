#merge subjects
subject_test <- read.table('test/subject_test.txt')
subject_train <- read.table('train/subject_train.txt')
subject_merged <- rbind(subject_test, subject_train)

#merge data
X_test <- read.table('test/X_test.txt')
X_train <- read.table('train/X_train.txt')
X_merged <- rbind(X_test, X_train)

#read feature names
feature_names <- read.table('features.txt')
#merge labels
y_test <- read.table('test/y_test.txt')
y_train <- read.table('train/y_train.txt')
y_merge <- rbind(y_test, y_train)

#get index for mean of std variables
features <- read.table('features.txt')
mean_and_std_index <- grep('mean()*|std()*', feature$V2)
mean_and_std_data <- X_merged[,mean_or_std_index]
write.csv(mean_and_std_data, 'mean_and_std.csv')
#label descriptive names to data
colnames(mean_and_std_data) <- feature_names$V2[mean_and_std_index]

#read activity labels
activity_labels <- read.table('activity_labels.txt')
#labels the data set with  descriptive activity labels
for(i in activity_labels$V1){
    y_merge[y_merge==i] <- toString(activity_labels$V2[i])
}


#add descriptive labels to subject_merged
for ( i in 1:30){
    subject_merged[subject_merged==i] <-  paste('subject', i, sep='')
}
#add descriptive labels and subject to X_merged
X_merged$subject <- subject_merged
X_merged$label <- y_merge

#tidy data for each activity
td_activity <- as.data.frame(tapply(X_merged[,1], X_merged$label, mean))
for(i in 2:561){
    td_activity <- cbind(result, tapply(X_merged[,i], X_merged$label, mean))    
}
td_activity <- as.data.frame(result)
colnames(td_activity) <- features$V2
write.csv(td_activity, 'td_activity.csv')
#tidy data for each subject
td_subject <- as.data.frame(tapply(X_merged[,1], X_merged$subject, mean))
row_names <- rownames(td_subject)
for(i in 2:561){
    td_subject <- cbind(result, tapply(X_merged[,i], X_merged$subject, mean))
}
rownames(td_subject) <- row_names
colnames(td_subject) <- features$V2
write.csv(td_subject, 'td_subject.csv')
