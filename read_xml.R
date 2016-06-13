# Load XML file into memory and parse into r object
library(XML)
xml.url <- "telemed_trials_may30.xml" #loads in the xml file
trials <- xmlToDataFrame(xml.url)
save(trials, file = "telemed_trials.RData")
write.table(trials, file = "telemed_trials.csv", sep = ",", row.names = FALSE)
