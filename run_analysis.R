library(reshape2)

# Global configuraion
config <- list(
    folder = "Dataset",
    train = list(
        measures = file.path("train","X_train.txt"),
        activities = file.path("train","y_train.txt"),
        subjects = file.path("train","subject_train.txt")
    ),
    test = list(
        measures = file.path("test", "X_test.txt"),
        activities = file.path("test", "y_test.txt"),
        subjects = file.path("test", "subject_test.txt")
    ),
    labels = list(
        activity = "activity_labels.txt",
        features = "features.txt"
    )
)

load.measures <- function(files, features, activityLabels, selectedFeatures) {
    # Loads measures with appropriate labels, var names

    # Load subjects
    subjects <- read.table(
        file.path(config$folder, files$subjects),
        header = FALSE,
        col.names = c('subject')
    )

    # Load activity names (merged with labels), returns labels
    activities <- merge(read.table(
        file.path(config$folder, files$activities),
        header = FALSE,
        col.names = c('activity_id')
    ), activityLabels, by.x = "activity_id", by.y = "id")['activity']

    # Load measuers with proper headers
    measures <- read.table(
        file.path(config$folder, files$measures),
        header = FALSE,
        col.names = features
    )

    # Merge all together, fiter out columns
    cbind(subjects, activities, measures[,make.names(selectedFeatures)])
}

load.features <- function() {
    # Gives back the feature list

    features <- read.table(
        file.path(config$folder, config$labels$features),
        header = FALSE,
        col.names = c('id', 'feature')
    )
    features[order(features$id), 'feature']
}

load.activities <- function() {
    # Gives back the reformated names of activities

    activities <- read.table(
        file.path(config$folder, config$labels$activity),
        header = FALSE,
        col.names = c('id', 'activity')
    )
    activities$activity <- sub("_", " ", tolower(activities$activity))
    activities
}

load.dataset <- function(...) {
    # Loads and merge together the train and test measures

    rbind(
        load.measures(
            config$train,
            ...
        ),
        load.measures(
            config$test,
            ...
        )
    )
}

write.result <- function(dataset, filename, ...) {
    # Writer wrapper, stores the given dataset

    write.table(
        dataset,
        filename,
        row.names = FALSE,
        ...
    )
}

main <- function() {
    # Extract and prepare the dataset and store the tidy data

    # Load meta data
    activityLabels <- load.activities()
    features <- load.features()
    selectedFeatures <- grep("^t(.*?)(std\\(\\)|mean\\(\\))", features, value = TRUE)
    col.names = c('subject', 'activity', selectedFeatures)

    # Load the tidy dataset
    dataset <- load.dataset(
        features = features,
        activityLabels = activityLabels,
        selectedFeatures = selectedFeatures
    )

    # Store the tidy dataset for exercise 1
    write.result(
        dataset,
        "result_1.txt",
        col.names = col.names
    )

    # Melts the dataset, prepare for cast
    datasetMelt <- melt(
        dataset,
        id.vars=c('subject', 'activity'),
        measure.vars=make.names(selectedFeatures)
    )
    # Cast the given prepared dataset, calculate the average
    datasetCast <- dcast(datasetMelt, subject + activity ~ variable, mean)

    # Store the result for exercise 2
    write.result(
        datasetCast,
        "result_2.txt",
        col.names = col.names
    )
}

main()
