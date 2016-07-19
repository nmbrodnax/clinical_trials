library(ggplot2)
library(maps)

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
trial_data$country <- as.character(trial_data$country)
trial_data$trials <- as.numeric(levels(trial_data$trials)[trial_data$trials])

# create plot with map of trial data by country
ggplot(trial_data, aes(map_id = country)) +
  geom_map(aes(fill = trials), map = worldmap) +
  expand_limits(x = worldmap$long, y = worldmap$lat)
ggsave("global_trial_map_continuous.pdf")

# create plot with map of trial data in discrete buckets
lilly <- c("#EAE5E3", "#D3CCC8", "#A59D95", "#FFE789", "#FFDC45", "#FF9352",
           "#F36A50", "#D52B1E")
categories <- c("0" ,"1-25", "26-50", "51-75", "76-100", "101-125", "126-150", "151-175",
                "176-200", "201-225", "226-250", "251-275", "276-300", "301-325", "326-350", 
                "351-375", "376-400", "401-425", "426-450", "451-475", "476-500", "501-525", 
                "526-550", "551-575", "576-600")
cat_subset <- c("1-25", "26-50", "51-75", "76-100", "101-125", "201-225", "326-350",
                "451-475", "501-525")
trial_group <- cut(trial_data$trials, seq(0,600, by = 25))
ggplot(trial_data, aes(map_id = country), na.omit()) +
  geom_map(aes(fill = trial_group), map = worldmap) +
  expand_limits(x = worldmap$long, y = worldmap$lat) +
  theme(legend.title = element_blank(), legend.position = "bottom", 
        axis.title.x=element_blank(), axis.title.y=element_blank(),
        axis.text.x=element_blank(), axis.text.y=element_blank(), 
        axis.ticks=element_blank()) +
  scale_fill_discrete(h = c(0,135), h.start = 0, direction = 1, labels = cat_subset,
                      na.value = "#A59D95")
ggsave("global_trial_map_discrete.pdf")
