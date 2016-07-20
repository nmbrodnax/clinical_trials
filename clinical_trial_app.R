library(shiny)
library(ggplot2)
# library(ggthemes)
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
    titlePanel("Clinical Trials Featuring Telemedicine"),
    mainPanel(p("Created By: NaLette M. Brodnax"), p("Last Updated: May 30, 2016"),
              img(src = "global_trial_map_discrete.png")),
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
     + scale_fill_manual(values = c("#F36A50", "#FF9352", "#FFDC45", "#BDB4AE")))
  })
}

# Launch application
shinyApp(ui = ui, server = server)
