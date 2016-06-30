library(shiny)
library(ggplot2)
library(ggthemes)
library(datasets)

# load data from csv file
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

# Define user interface
ui <- fluidPage(    
    # Give the page a title
    titlePanel("Trials by Area"),
    # Generate a row with a sidebar
    sidebarLayout(      
      # Define the sidebar with one input
      sidebarPanel(
        selectInput("sponsor", "Sponsor Type:", choices=levels(trials$sponsor)),
        hr(),
        helpText("Data from AT&T (1961) The World's Telephones.")
      ),
      # Create a spot for the barplot
      mainPanel(
        plotOutput("plot1")  
      )
    )
  )

# Define server
server <- function(input, output) {
  # Fill in the spot we created for a plot
  output$plot1 <- renderPlot({
    # Render a barplot
    (ggplot(trials[trials$sponsor == input$sponsor,], aes(area, fill=type))
     + ylab('Number of Trials')
     + xlab('Therapeutic Area')
     + ggtitle('Telemedicine Trials by Area')
     + geom_bar()
     + coord_flip()
     + scale_fill_manual(values = c("#C25B56", "#525564", "#74828F", "#96C0CE")))
  })
}

# Launch application
shinyApp(ui = ui, server = server)
