#Functions for cleaning the ICTRP datasets

standard_date <- function(text) {
  #returns date in standardized format
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

