library(ggplot2)
library(ggthemes)

data <- read.csv("ictrp_trials.csv", header = TRUE)
trials <- data.frame(
  id = data$TrialID,
  title = data$Public_title,
  sponsor = data$Sponsor_Type,
  area = data$Therapeutic_Area,
  type = data$Type,
  phase = data$Study_Phase
)

trials$id <- as.character(trials$id)
trials$title <- as.character(trials$title)
trials$sponsor[trials$sponsor == 'N/A'] <- NA
trials$sponsor <- factor(trials$sponsor, levels = c("University", "Hospital", "NGO",
                                                    "Government", "Investigator", "Commercial",
                                                    "Other"))
trials$area[trials$area == 'N/A'] <- NA
trials$area <- factor(trials$area, levels = c("Bariatric", "Bone Muscle Joint", "Cardiovascular",
                                              "Diabetes", "Elderly Population", "Immunology",
                                              "Neuroscience", "Obstetrics and Gynecology",
                                              "Oncology", "Pediatrics", "Respiratory", "Sleep",
                                              "Substance Abuse", "Urology and Gastrics", "Vision",
                                              "Other"))
trials$type <- factor(trials$type, levels = c("Interventional", "Observational", "Other", "N/A"))
trials$phase[trials$phase == 'No Match'] <- NA
trials$phase[trials$phase == 'No Phase'] <- NA
trials$phase <- factor(trials$phase, levels = c("0", "1", "2", "3", "4"))