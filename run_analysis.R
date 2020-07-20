###--- Libraries ---###

library(dplyr)


### Step 0 - Read Raw Data ###

labs_raw <- read.csv("UCI\ HAR\ Dataset/activity_labels.txt", header = FALSE)
feats <- read.table("UCI\ HAR\ Dataset/features.txt", header = FALSE)

x_test_raw <- read.table("UCI\ HAR\ Dataset/test/X_test.txt", header = FALSE)
y_test_raw <- read.table("UCI\ HAR\ Dataset/test/y_test.txt", header = FALSE)
sub_test <- read.table("UCI\ HAR\ Dataset/test/subject_test.txt", header = FALSE)

x_train_raw <- read.table("UCI\ HAR\ Dataset/train/X_train.txt", header = FALSE)
y_train_raw <- read.table("UCI\ HAR\ Dataset/train/y_train.txt", header = FALSE)
sub_train <- read.table("UCI\ HAR\ Dataset/train/subject_train.txt", header = FALSE)

## Add set type: 0 for test and 1 for train, and subject column for both##
## A hot one encoding could be done here, but choosing only one column keeps
## the date a little more tidy


y_test <- cbind(rep(0, dim(y_test_raw)[1]), sub_test, y_test_raw)
y_train <- cbind(rep(1, dim(y_train_raw)[1]), sub_train, y_train_raw)

## Prepare dataframes. First assign names to the rows

x_test <- x_test_raw    # Backup the raw data
x_train <- x_train_raw  # Backup the raw data


colnames(y_test) <- c("test_type", "subject_id", "activity")
colnames(y_train) <- c("test_type", "subject_id", "activity")

colnames(x_test) <- feats$V2
colnames(x_train) <- feats$V2



### Step 3 - Descriptive activity names
## I have chosen to make step 3 before everything else because I think it would
## reduce time since the dataframes sizes are smaller. I have kept every
## "walking*" as a different value because they are 3 distinct types of
## activities and I don't see the point of merging them.

labs <- apply(labs_raw, 1, function(x) sub("[0-9] ", "", x))

## I couldn't think of a better way of doing this, so I ended up doing this 
## instead of something more "elegant".

j1 <- c()
j2 <- c()


for(i in 1:dim(y_test)[1]){
 
   j1[i] <- labs[y_test[i,3]]

   }


for(i in 1:dim(y_train)[1]){
  
  j2[i] <- labs[y_train[i,3]]

  }

y_test$activity <- j1
y_train$activity <- j2


# Step 1 - Merging the dataframes

test <- cbind(y_test, x_test)
train <- cbind(y_train, x_train)


df_tt <- rbind(test, train)


# Step 2 - extract all columns with the mean and std
## I decided to keep the activity columns because of step 5.

df_mstd <- df_tt %>% 
  names %>% 
  grep(pattern = "*mean*|*std*") %>% 
  as.array %>% 
  select(2, 3,-1, .data = df_tt)


#Step 4 - Rename columns

colnames(df_mstd) <- df_mstd %>% 
  names %>% 
  sub(pattern = "^t", replacement = "time-") %>% 
  sub(pattern = "^f", replacement = "fft-") %>% 
  sub(pattern = "*Acc*", replacement = "-accelerometer-") %>% 
  sub(pattern = "Gyro", replacement = "-gyrometer-") %>% 
  sub(pattern = "*Body*", replacement = "body") %>% 
  sub(pattern = "Body", replacement = "") %>% 
  sub(pattern = "Jerk", replacement = "jerk-") %>% 
  sub(pattern = "*Mag*", replacement = "magnitude-") %>% 
  sub(pattern = "*Gravity*", replacement = "gravity-") %>% 
  gsub(pattern = "*--*", replacement = "-") %>% 
  sub(pattern = "*\\(\\)*", replacement = "")


### Append units. 
## I am sure that the time domain variables are ok, however
## the frequency domain units I have my doubts, maybe they are g.Hz, [m/s].Hz or
## they end up remaining the same after the FFT. In any case I have chosen to 
## keep all units in the "time domain": g, g/s, rad/s, rad/s^2

b <- colnames(df_mstd) %>% grep(pattern = "*gyrometer*")
colnames(df_mstd)[b] <- paste(colnames(df_mstd)[b],
                              "[rad/s]",
                              sep = "-")

b <- colnames(df_mstd) %>% grep(pattern = "*jerk*")
colnames(df_mstd)[b] <- sub(colnames(df_mstd)[b],
                            pattern = "*\\[rad/s\\]*",
                            replacement = "[rad/s^2]")

b <- colnames(df_mstd) %>% grep(pattern = "*accelerometer*|*gravity*")
colnames(df_mstd)[b] <- paste(colnames(df_mstd)[b],
                              "[g]",
                              sep = "-")

b <- colnames(df_mstd) %>% grep(pattern = "*jerk*")
colnames(df_mstd)[b] <- sub(colnames(df_mstd)[b],
                            pattern = "*\\[g\\]*",
                            replacement = "[g/s]")

b <- colnames(df_mstd) %>% grep(pattern = "*magnitude-mean*")
colnames(df_mstd)[b] <- sub(colnames(df_mstd)[b], 
                            pattern = "*magnitude-mean*",
                            replacement = "mean-magnitude")

b <- colnames(df_mstd) %>% grep(pattern = "*magnitude-std*")
colnames(df_mstd)[b] <- sub(colnames(df_mstd)[b], 
                            pattern = "*magnitude-std*",
                            replacement = "std-magnitude")



# Step 5 - Export txt table

df_final <- df_mstd %>%
  group_by(activity, subject_id) %>% 
  summarise_all("mean")

write.table(df_final, "final_tidy.txt", row.name  = FALSE)