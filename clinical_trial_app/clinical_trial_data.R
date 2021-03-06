library(shiny)
library(ggplot2)
library(maps)

##TRIAL DATA FOR PLOTS
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

##COUNTRY DATA FOR MAP
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

# create plot with map of trial data in discrete buckets
categories <- c("0" ,"1-25", "26-50", "51-75", "76-100", "101-125", "126-150", "151-175",
                "176-200", "201-225", "226-250", "251-275", "276-300", "301-325", "326-350", 
                "351-375", "376-400", "401-425", "426-450", "451-475", "476-500", "501-525", 
                "526-550", "551-575", "576-600")
cat_subset <- c("1-25", "26-50", "51-75", "76-100", "101-125", "201-225", "326-350",
                "451-475", "501-525")
trial_group <- cut(trial_data$trials, seq(0,600, by = 25))
