
library("lubridate")
library("stringdist")
library("stringr")

standard_steroids <- c("betamethasone", "prednisolone", "methyl-prednisolone")

# See "minimum edit distance" and "Levenshtein distance"...
fuzzy_match <- function(standard, candidates, max_dist = 4) {
  standard[amatch(candidates, standard, maxDist = max_dist)]
}

data <- read.delim("Fake_data.txt")

data$clean_steroid <- fuzzy_match(gold_standard, data$steroid)

# Lubridate's the way to go here: https://lubridate.tidyverse.org/
# Some start dates are later than the end dates! -Presumed swapped?!
# Need to swap the raw dates before we can truncate to the start
# or end of month.
broken_date <- parse_date_time(data$start.date, "my") >
  parse_date_time(data$end.date, "my")
tmp_date <- data$start.date[broken_date]
data$start.date[broken_date] <- data$end.date[broken_date]
data$end.date[broken_date] <- tmp_date

data$clean_start_date <- parse_date_time(data$start.date, "my")
# https://stackoverflow.com/questions/9503896/create-end-of-the-month-date-from-a-date-variable
data$clean_end_date <- rollforward(parse_date_time(data$end.date, "my"))

data$duration <- data$clean_end_date - data$clean_start_date

# The "dosage" column is *far* too irregular to do much with.
# How dangerous to assume that dosage >> mean is a one-off!?
# L-o-n-g, brittle gazetteer of dosage formats?
# Sanity-check with ranges on a per-steroid basis?
# IM == Intramuscular Injection? More *likely* to be one-off?
# Need explicit dose/frequency/method.
# Does the duration inform this?
# Anything more to stay other than "Collect Better Data"?
# Just throw the irregular rows away?!

data$raw_dosage <- as.double(str_extract(data$dosage, "[0-9.]+"))

data$assumed_total_dose <- as.integer(data$raw_dosage * data$duration)
single_dose <- data$raw_dosage > mean(data$raw_dosage)
data$assumed_total_dose[single_dose] <- data$raw_dosage[single_dose]
