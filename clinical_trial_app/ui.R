library(shiny)
library(ggplot2)
library(maps)

# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).
library(datasets)

# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(    
    
    # Give the page a title
    titlePanel("Telephones by region"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar with one input
      sidebarPanel(
        selectInput("region", "Region:", 
                    choices=colnames(WorldPhones)),
        hr(),
        helpText("Data from AT&T (1961) The World's Telephones.")
      ),
      
      # Create a spot for the barplot
      mainPanel(
        plotOutput("phonePlot")  
      )
      
    )
  )
)

# Define user interface
shinyUI(
  fluidPage(    
  # Give the page a title
  titlePanel("Clinical Trials Featuring Telemedicine"),
  # Generate a row with a sidebar
  sidebarLayout(      
    # Define the sidebar with one input
    sidebarPanel(
      selectInput("sponsor", "Sponsor Type:", choices=levels(trials$sponsor)),
      hr(),
      helpText("Data from the World Health Organization (2016) International\
               Clinical Trial Registry Platform.")
      ),
    # Create a spot for the barplot
    mainPanel(
      plotOutput("plot1"),
      plotOutput("map1")
    )
    )
)
)
