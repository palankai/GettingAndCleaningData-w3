# Analysis of Human Activity Recognition Using Smartphones Data Set

The run_analysis.R script loads the given, uncompressed txt files and
prepare it for further analysis as requested.

I've broken down the parts of code to small, easy to understand functions.

In this document I describe the main flow of process however I tried to use
readable function and variable names.

## Background

The measures, meaning of measures (column headers), label of activities,
and id of subjects for each row stored in different files.

# Process `main()`

The `main` function loads the features (names of measurements) and the labels
of activities. Creates a list of selected columns which have to be used for
filtering out measurements. The `load.dataset` function loads the train
and test dataset and merge it together.

## Make it tidy (`load.measures`)

The `load.measures` function loads the subjects of given dataset.
In the second phase it loads the activities and store the activity labels
as a subset. The third phase loads the measures then finally combine it
together and gives back the prepared nice and tidy `data.frame`.

# Requirements

The dataset is not part of the project.
You should download and uncompress it to the `Dataset` folder.
Note that the folder name can be reconfigured.
Source of data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

