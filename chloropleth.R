# Minimal chloropleth example
library(ggplot2)
library(maps)

crimes <-data.frame(state = tolower(rownames(USArrests)), USArrests)

states_map <-map_data("state")

ggplot(crimes, aes(map_id = state)) +
  geom_map(aes(fill = Murder), map = states_map) +
  expand_limits(x = states_map$long, y = states_map$lat) 

##############

# load trial data by country (csv file created by clean_ictrp.py)
country_data <- read.csv("trials_per_country.csv", col.names = c("country", "trials"))
country_data <- as.data.frame(country_data)
country_data$country <- as.character(country_data$country)

# get list of all countries in ggplot world map
worldmap <- map_data("world")
worldmap$region <- as.factor(worldmap$region)
country_list <- levels(worldmap$region)

# create matrix with number of trials for all countries
T <- NULL
for (country in country_list){
  match_row <- match(country, country_data$country)
  if (!is.na(match_row)) T <- rbind(T,c(country,country_data$trials[match_row]))
  else T <- rbind(T,c(country,0))
}

# create data frame from factor matrix
trial_data <- data.frame(T)
colnames(trial_data) <- c("country", "trials")
trial_data$trials <- as.numeric(levels(trial_data$trials)[trial_data$trials])

# create map
countries_map <-map_data("world")

ggplot(trial_data, aes(map_id = country)) +
  geom_map(aes(fill = trials), map = countries_map) +
  expand_limits(x = countries_map$long, y = countries_map$lat) +
  scale_fill_gradient2(name=trial_data$trials, low = "red", mid = "white", 
                      high = "blue")
