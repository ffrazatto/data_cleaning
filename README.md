# README
# Data Cleaning - Final Assignment

## Description

This repository consist of:

- this README.md;
- a Code book explaning all transformations and variables: CodeBook.md;
- a R script: run_analisys.R;
- the final tidy data set: final_tidy.txt;
- a folder with all data used in the analisys.

## Introduction

Coursera's course "Getting and Cleaning Data" final assingment consists of 
reading a series of files with various variables and observations and arrannging
them as to obtain a final tidy data set.

For this, only **one** scrip was written (run_analisys.R), no separate script were
written and sourced to R beforehand besides the dplyr package. 
The mentinoned file contains all 5 steps proposed by the assignment, abeit they
are not in the "correct" order. The code follows this sequency:

- Step 0: Reading the data 
- Step 3: Discriptive activity names
- Step 1: Merging data frames
- Step 2: Mean and standard deviation columns extraction
- Step 4: Renaming Columns
- Step 5: Exporting Data


## Method

Each step is better described at the script itself, but this README will briefly
describe each step as presented in the last section. For more detailed 
information please read the run_analisys.R scrip as it was commentd by section 
and some more "complicated" snippets.

### Step 0: Reading data

Reads all raw data sets: x_train, y_train, x_test, y_test, features and 
activities_labels. Append a new column with the information of data set (traing 
or test), and assign the correct names for each column with the features.txt
file.

### Step 3: Dicriptive Activities Names

Assgin the correct name for each value under the "activities" column following 
the map provided by activities_labels.

### Step 1: Mergin Data Frames

Mergesthe two dataframes. Actualy it is a row bind since every column is in the
same postion for the two data sets.

### Step 2: Column Extraction

Identify each column name that contains **mean** or **std** in it's name and create
a sub dataframe with them and the "activity" colummn.

I decided to keet the "activity" column because it would come handy later on 
step 5.

### Step 4: Renaming Columns

Each column was renamed based on some key elements present inside the column
name and the "features.txt" and "README.txt" (*not THIS readme*, the one inside
the "UCI HAR Dataset" folder) files. So every file beginning with a "t" became
"time" and with a "f" became "fft". every file with "gyro" or "acc" became 
"gyrometer" and "accelerometer", respectively. The units became "g" 
(accelerometer) and "rad/s" (gyrometer) for all files that do not contain "jerk"
in it. Since the "jerk" is calculated by taking the variable derivative with 
respect of the time, the units are "g/s" (accelometer) and "rad/s²" (gyrometer).

For more information read the CodeBook.md file, which contains more detain on 
each variable.

### Step 5: Exporting Data

Now the "activity" column comes in handy, the data is grouped by activity and
the mean is calculated by group. Finaly the data is exported with the name 
"final_tidy.txt"





 









