###--- Libraries ---###

library(dplyr)


### Step 0 - Read Data ###

labs_raw <- read.csv("UCI\ HAR\ Dataset/activity_labels.txt", header = FALSE)
feats <- read.table("UCI\ HAR\ Dataset/features.txt", header = FALSE)

x_test_raw <- read.table("UCI\ HAR\ Dataset/test/X_test.txt", header = FALSE)
y_test_raw <- read.table("UCI\ HAR\ Dataset/test/y_test.txt", header = FALSE)

x_train_raw <- read.table("UCI\ HAR\ Dataset/train/X_train.txt", header = FALSE)
y_train_raw <- read.table("UCI\ HAR\ Dataset/train/y_train.txt", header = FALSE)

## Add set type: 0 for test and 1 for train ##
## A hot one encoding could be done here, but choosing only one column keeps
## the date a little more tidy


y_test <- cbind(rep(0, dim(y_test_raw)[1]), y_test_raw)
y_train <- cbind(rep(1, dim(y_train_raw)[1]), y_train_raw)

## Prepare dataframes. First assign names to the rows

x_test <- x_test_raw    # Backup the raw data
x_train <- x_train_raw  # Backup the raw data


colnames(y_test) <- c("test_type", "activity")
colnames(y_train) <- c("test_type", "activity")

colnames(x_test) <- feats$V2
colnames(x_train) <- feats$V2



### Step 3
## I have chosen to make step 3 before everything else because I think it would
## reduce time, since the dataframes sizes are smaller. I have kept every
## "walking*" as separate values because they are 3 distinct types of
## activities and I don't see the point of merging them together.


labs <- apply(labs_raw, 1, function(x) sub("[0-9] ", "", x))


## I coulnd't think of a better way of doing this, so I ended up doing this 
## instead of something more "elegant".

j1 <- c()
j2 <- c()


for(i in 1:dim(y_test)[1]){
 
   j1[i] <- labs[y_test[i,2]]

   }


for(i in 1:dim(y_train)[1]){
  
  j2[i] <- labs[y_train[i,2]]

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
  select(2, -1, .data = df_tt)


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

# Step 5

df_final <- df_mstd %>%
  group_by(activity) %>% 
  summarise_all("mean")

write.csv(df_final, "final.csv")