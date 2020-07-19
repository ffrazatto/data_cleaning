# Code Book

## Content

This codebook is divided in 4 sections:

1. Variables;
2. Data Cleaning
3. Transformations
4. Final Data

## 1. Variables


From the provided "README.txt" and "features.txt" files ("UCI HAR Dataset" 
folder), a good descripition is avaliable for each variable measurement and
proceadure in obtaining it. Here a more succint description will be presented, 
however you will notice that the title of each variable is fairly understandable
by itself.

The "morphology", so to speak, of the variable names follows this format:

`domain-where-sensor-jerk?-function-axes/magnitude-[unit]`

- `domain`: **time** or frequency(**fft**) domain;
- `where`: measurement of the **body** or **gravity**;
- `sensor`: **accelerometer** or **gyrometer**;
- `jerk`: if the **jerk** was't calculated this term  wont't be present;
- `function`: **mean** or standard deviation(**std**) of the variable;
- `axes/magnitude`: the axis where it was measured (X, Y or Z) or it is the 
**magnitude**;
- `[unit]`: the unit of the variable, it can be **g**, **g/s**, **rad/s** or
**rad/s^2**.

Some exemples:

- `fft-body-gyrometer-mean-Z-[rad/s]`
- `time-body-accelerometer-std-Z-[g]`
- `time-body-accelerometer-jerk-mean-X-[g/s]`
- `time-body-gyrometer-jerk-std-magnitude-[rad/s^2]`

The last column is the "activity" which describes how the measurement was made.
It can assume the values "walking", "walking-upstairs", "walking-downstairs",
"laying", "sitting" and "standing".


## Data Cleaning

The initial data had various different variables, such as max, min, correlation 
values etc. However the assignment stated that only the mean and standard 
deviation values were to be used in the final dataframe, so only the columns
containing "mean" and "std" in their names should be selected. 

First of all, the correct labels for the activities and features were assigned
to all columns for both data sets (test and training), making identification
easier. Afterwars, the data sets were merged together.

Then the required mean and standard deviation columns were extracted, and new 
descriptive labels were assinied to each column, rendering a cleaner data.


## Transformations

There were only one significant transforamtion that altered the data. As 
requested, the data set was grouped by activiy and the average for each column
was taken.


## Final Data













