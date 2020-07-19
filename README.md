# README
# Data Cleaning - Final Assignment

## Description

This repository consist of:

- this README.md;
- a Code book explaning all transformations and variables: CodeBook.md;
- a R script with all the data cleaning: run_analisys.R;
- the final tidy data set: final_tidy.txt;
- Two html files with the mardown files renderings: README.html and 
CodeBook.html;
- a folder with all data used in the analisys.

## 1 Introduction

Coursera's "Getting and Cleaning Data" course final assingment consists of 
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


## 2 Method

Each step is better described at the script itself, but this README will briefly
describe each step as presented in the last section. For more detailed 
information please read the run_analisys.R scrip as it was commentd by section 
and some more "complicated" snippets.

### 2.1 Step 0: Reading data

Reads all raw data sets: x_train, y_train, x_test, y_test, features and 
activities_labels files. Append a new column with the information of data set
type (training or test) and assign the correct names for each column based on
the features.txt file.

### 2.2 Step 3: Dicriptive Activities Names

Assgin the correct name for each value under the "activities" column following 
the map provided by activities_labels.

### 2.3 Step 1: Merging Data Frames

Merges the two dataframes. Actualy, it is a row bind since every column is in
the same postion in both data sets.

### 2.4 Step 2: Column Extraction

Identify all columns which contains **mean** or **std** in it's name and create
a sub dataframe with them and the "activity" colummn.

I decided to keet the "activity" column because it would come in handy later on 
step 5.

### 2.5 Step 4: Renaming Columns

Each column was renamed based on some key elements present inside the column
name and the "features.txt" and "README.txt" files (*not THIS readme*, the one
inside "UCI HAR Dataset" folder). So every column beginning with a "t" became
"time" and with a "f" became "fft". every feature with "gyro" or "acc" became 
"gyrometer" and "accelerometer", respectively. The units became "g" 
(accelerometer) and "rad/s" (gyrometer) for all files that do not contain "jerk"
in it. Since the "jerk" is calculated by taking the variable derivative with 
respect of the time, the units are "g/s" (accelometer) and "rad/s²" (gyrometer).

For more information read the CodeBook.md file, which contains more detain on 
each variable.

### 2.6 Step 5: Exporting Data

The data is grouped by activity and the mean is calculated by group. Finally the
data is exported with the name "final_tidy.txt".




