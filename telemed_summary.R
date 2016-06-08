library(ggplot2)
library(ggthemes)

load("telemed_trials.RData")
trials$Target_size <- as.numeric(trials$Target_size)
trials$Study_type <- as.factor(trials$Study_type)
trials$Phase <- as.factor(trials$Phase)
trials$Countries <- as.factor(trials$Countries)
trials$Source_Register <- as.factor(trials$Source_Register)
