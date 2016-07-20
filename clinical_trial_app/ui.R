library(shiny)
library(ggplot2)
library(maps)

source("clinical_trial_data.R")

# Define user interface
shinyUI(
  fluidPage(    
  # Give the page a title
  titlePanel("Clinical Trials Featuring Telemedicine"),
  p("Application Created By: ",
  a(href = "https://www.linkedin.com/in/nalettebrodnax/", 
    "NaLette Brodnax")),
  p("Data Source: ", a(href = "http://apps.who.int/trialsearch/default.aspx", 
    "World Health Organization, International Clinical Trial Registry Platform")),
  p("Data Last Updated: May 30, 2016"),
  plotOutput("map1", height = "600px", width = "900px"),
  hr(),
  h2("Number of Clinical Trials"),
  mainPanel(
    tabsetPanel(
      tabPanel(
        "By Therapeutic Area",
        selectInput("sponsor", "Choose Sponsor:", choices=levels(trials$sponsor),
                    selected = "Commercial"),
        plotOutput("plot1", width = "900px", height = "700px")
      ),
      tabPanel(
        "By Phase",
        selectInput("area", "Choose Therapeutic Area:", choices=levels(trials$area),
                    selected = "Diabetes"),
        plotOutput("plot2", width = "900px", height = "600px")
      )
    )
    )
  #p(),
  #hr(),
  #h1("Clinical Trials by Sponsor"),
  #mainPanel(plotOutput("plot2"))
)
)
