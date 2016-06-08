#Functions for cleaning the ICTRP datasets

standard_date <- function(char) {
  #parameter for,at DD/MM/YYYY
  #returns date in standardized format MM/DD/YYYY
  date <- paste(substr(char,4,5),"/",substr(char,1,2),"/",substr(char,7,10),sep="")
}

sponsor_type <- function(text) {
  #returns str for category of sponsor
}

gender_type <- function(text) {
  #returns the category for genders allowed in the study
}

strip_age <- function(text) {
  #returns an int age or NA
}

strip_phase <- function(text) {
  #returns an int phase (1-4) or NA
}

list_countries <- function(text) {
  #returns a country or list of countries
}

recruiting <- function(text) {
  #returns 1 recruiting or 0 not recruiting
}

