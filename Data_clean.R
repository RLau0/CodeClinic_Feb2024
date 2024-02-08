data <- read.delim("Fake_data.txt")

str(data)

#need to clean up the steroid column

unique(data$steroid)

library(tibble)

data <- add_column(data, 
                   "steroid.clean" = tolower(data$steroid),
                   .after = "steroid")

table(data$steroid.clean)

data$steroid.clean[which(data$steroid.clean == "batamethasone")] <- "betamethasone"

data$steroid.clean <- gsub("-", "", data$steroid.clean)

table(data$steroid.clean)

pred.mistake <- c("prdenisolone", "prednisilone", "pridnisolone")

data$steroid.clean[which(data$steroid.clean %in% pred.mistake)] <- "prednisolone"

table(data$steroid.clean)

#extracting the number for dosage

unique(data$dosage)

data$dosage <- tolower(data$dosage)

data <- add_column(data, 
                   "dosage.value" = NA,
                   .after = "dosage")

library(stringr)

data$dosage.value <- str_extract(data$dosage, "\\d+([.,]\\d+)?mg")

data$dosage[which(is.na(data$dosage.value) == TRUE)]

missing <- which(is.na(data$dosage.value) == TRUE)

data$dosage.value <- str_extract(data$dosage[missing], "\\d+([.,]\\d+)?")

data$dosage.value <- as.numeric(data$dosage.value)

#determine the total dosage for those that take steroid daily

unique(data$dosage)

daily <- grepl("d|once", data$dosage)

data$daily <- "no"
data$daily[daily] <- "yes"

data$dosage[which(data$daily == "no")] #check

#I made assumptions
#one month is 28 days (7 days and 4 weeks)
#first and end date if same month is 28 days 
#2 months would be 56 days

data$start.month <- NA

for(i in 1:nrow(data)){
  data$start.month[i] <- as.numeric(str_split(data$start.date[i], "\\/")[[1]][1])
}

data$start.year <- NA

for(i in 1:nrow(data)){
  data$start.year[i] <- as.numeric(str_split(data$start.date[i], "\\/")[[1]][2])
}

data$end.month <- NA

for(i in 1:nrow(data)){
  data$end.month[i] <- as.numeric(str_split(data$end.date[i], "\\/")[[1]][1])
}

data$end.year <- NA

for(i in 1:nrow(data)){
  data$end.year[i] <- as.numeric(str_split(data$end.date[i], "\\/")[[1]][2])
}

data$duration <- (data$end.year * 12 + data$end.month) - (data$start.year * 12 + data$start.month)

unique(data$duration)

#-1 is dates are reversed

data$duration <- abs(data$duration)

#0 is really one month - add one month 

data$duration <- data$duration + 1

data$total.dosage <- NA
data$total.dosage[which(data$daily == "no")] <- data$dosage.value[which(data$daily == "no")]

data$total.dosage[daily] <- data$dosage.value[daily] * data$duration[daily] * 28





