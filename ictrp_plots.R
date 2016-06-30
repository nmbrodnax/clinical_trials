library(ggplot2)
library(ggthemes)

# load data from csv file
data <- read.csv("ictrp_trials.csv", header = TRUE)

# create data frame with subset of columns
trials <- data.frame(
  id = data$TrialID,
  title = data$Public_title,
  sponsor = data$Sponsor_Type,
  area = data$Therapeutic_Area,
  type = data$Type,
  phase = data$Study_Phase
)

# recode variables to proper type and remove NA
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

# save data file to hard disk
write.table(trials, "ictrp_trials.dat")

# plots

# trials by sponsor type (fill by study type)
plot1 <- (ggplot(trials[which(!is.na(trials$sponsor)),], aes(sponsor, fill=type))
          + ylab('Number of Trials')
          + xlab('Sponsor Type')
          + ggtitle('Telemedicine Trials by Sponsor Type')
          + geom_bar()
          + scale_fill_manual(values = c("#C25B56", "#525564", "#74828F", "#96C0CE")))
ggsave(file="trials_by_sponsor.pdf")

plot2 <- (ggplot(trials[which(!is.na(trials$sponsor) & trials$area == 'Diabetes'),],
                 aes(sponsor, fill=type))
          + ylab('Number of Trials')
          + xlab('Sponsor Type')
          + ggtitle('Telemedicine Trials by Sponsor Type: Diabetes')
          + geom_bar()
          + scale_fill_manual(values = c("#C25B56", "#525564", "#74828F", "#96C0CE")))
ggsave(file="diabetes_by_sponsor.pdf")

temp_data <- trials[trials$sponsor == 'Commercial',]
sorted_levels <- names(sort(table(temp_data$area)))
temp_data$area <- factor(temp_data$area, levels = sorted_levels)
plot3 <- (ggplot(temp_data[which(!is.na(temp_data$area)),],
                 aes(area, fill=type))
          + ylab('Number of Trials')
          + xlab('Sponsor Type')
          + ggtitle('Telemedicine Trials by Area: Commercial')
          + geom_bar()
          + coord_flip()
          + scale_fill_manual(values = c("#C25B56", "#525564", "#74828F")))
ggsave(file="commercial_by_area.pdf")

color_swatches <- c("#525564", "#74828F", "#96C0CE", "#BEB9B5", "#C25B56", "#FEF6EB")
