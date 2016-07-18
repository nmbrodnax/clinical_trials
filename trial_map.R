library(ggplot2)

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
data <- data.frame(T)
colnames(data) <- c("country", "trials")
data$country <- as.character(data$country) # convert factor to character
data$trials <- as.numeric(levels(data$trials)[data$trials]) # convert factor to numeric

# create plot with map of trial data by country
mp <- NULL
mp <- ggplot() + geom_map(data = data, aes(map_id = country, fill= trials), map = worldmap)

