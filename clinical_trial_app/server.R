library(shiny)
library(ggplot2)
library(maps)

source("clinical_trial_data.R")

# Define server
shinyServer(function(input, output) {
    output$plot1 <- renderPlot({
    (ggplot(trials[trials$sponsor == input$sponsor,], aes(area, fill=type))
     + ylab('Number of Trials')
     + xlab('Therapeutic Area')
     + ggtitle('Telemedicine Trials by Area')
     + geom_bar()
     + coord_flip()
     + scale_fill_manual(values = c("#F36A50", "#FF9352", "#FFDC45", "#BDB4AE")))
  })
    output$map1 <- renderPlot({
      ggplot(trial_data, aes(map_id = country), na.omit()) +
        geom_map(aes(fill = trial_group), map = worldmap) +
        expand_limits(x = worldmap$long, y = worldmap$lat) +
        theme(legend.title = element_blank(), legend.position = "bottom", 
              axis.title.x=element_blank(), axis.title.y=element_blank(),
              axis.text.x=element_blank(), axis.text.y=element_blank(), 
              axis.ticks=element_blank()) +
        scale_fill_discrete(h = c(0,135), h.start = 0, direction = 1, labels = cat_subset,
                            na.value = "#A59D95")
    })
})
