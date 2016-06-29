library(ggplot2)
library(ggthemes)

data <- read.csv("ictrp_trials.csv", header = TRUE)
# trials <- data.frame(data[,1], data[,3], data[,17], data[,c(35:39)])
trials <- data.frame(
  id = data$TrialID,
  title = data$Public_title,
  size = data$Target_size,
  sponsor = data$Sponsor_Type,
  area = data$Therapeutic_Area,
  type = data$Type,
  phase = data$Study_Phase
)

trials$size <- as.numeric(trials$size)
trials$id <- as.character(trials$id)
trials$title <- as.character(trials$title)
