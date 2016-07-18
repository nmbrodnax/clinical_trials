library(ggplot2)

# get list of countries in ggplot world map
worldmap <- map_data("world")
worldmap$region <- as.factor(worldmap$region)
countries <- levels(worldmap$region)


# check country names in trial data set that do not match ggplot world map
country_data <- read.csv("trial_map_data.csv", header = TRUE)
country_data <- as.data.frame(country_data)
# do I need to recode the country variable as chr rather than factor?
ictrp_countries <- levels(country_data$Country)
for (c in ictrp_countries){if (is.na(match(c,countries))){print(c)}}

# for each country in the list displayed, fix recoding in clean_ictrp.py