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

load.measures <- function(files, features, activity_labels) {
    # Load measuers with proper headers
    measures <- read.table(
        file.path(config$folder, files$measures),
        header = FALSE,
        col.names = features
    )
    
    # Load activity names (merged with labels), returns labels
    activities <- merge(read.table(
        file.path(config$folder, files$activities),
        header = FALSE,
        col.names = c('activity_id')
    ), activity_labels, by.x = "activity_id", by.y = "id")[,c('activity')]
    
    # Load subjects
    subjects <- read.table(
        file.path(config$folder, files$subjects),
        header = FALSE,
        col.names = c('subject')
    )
    cbind(subjects, activities, measures)
}

load.features <- function() {
    features <- read.table(
        file.path(config$folder, config$labels$features),
        header = FALSE,
        col.names = c('id', 'feature')
    )
    features[order(features$id), 'feature']
}

load.activities <- function() {
    activities <- read.table(
        file.path(config$folder, config$labels$activity),
        header = FALSE,
        col.names = c('id', 'activity')
    )
    activities$activity <- sub("_", " ", tolower(activities$activity))
    activities
}

load.dataset <- function() {
    features <- load.features()
    activities <- load.activities()
    rbind(
        load.measures(
            config$train,
            features = features,
            activity_labels = activities
        ),
        load.measures(
            config$test,
            features = features,
            activity_labels = activities
        )
    )
}

main <- function() {
    load.dataset()
}
res <- main()