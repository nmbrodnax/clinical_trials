library(ggplot2)
library(ggthemes)

#load data
load("telemed_trials.RData")

#convert data types where needed
trials$Target_size <- as.numeric(trials$Target_size)
trials$Study_type <- as.factor(trials$Study_type)
trials$Phase <- as.factor(trials$Phase)
trials$Countries <- as.factor(trials$Countries)
trials$Source_Register <- as.factor(trials$Source_Register)

#summarize trials by register
summary(trials$Source_Register)

#split data into separate files by register
ctgov <- trials[which(trials$Source_Register=="ClinicalTrials.gov"),]
anzctr <- trials[which(trials$Source_Register=="ANZCTR"),]
isrctn <- trials[which(trials$Source_Register=="ISRCTN"),]
