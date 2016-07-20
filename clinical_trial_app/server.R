library(shiny)
library(ggplot2)
library(maps)

source("clinical_trial_data.R")

# Define server
shinyServer(function(input, output) {
    output$map1 <- renderPlot({
      ggplot(trial_data, aes(map_id = country), na.omit()) +
        ggtitle("Clinical Trials by Country") +
        geom_map(aes(fill = trial_group), map = worldmap) +
        expand_limits(x = worldmap$long, y = worldmap$lat) +
        theme(legend.title = element_blank(), legend.position = "top", 
              axis.title.x=element_blank(), axis.title.y=element_blank(),
              axis.text.x=element_blank(), axis.text.y=element_blank(), 
              axis.ticks=element_blank()) +
        guides(colour = guide_legend(nrow = 1)) +
        scale_fill_discrete(h = c(0,135), h.start = 0, direction = 1, labels = cat_subset,
                            na.value = "#A59D95")
    })
    output$plot1 <- renderPlot({
      (ggplot(trials[which(trials$sponsor == input$sponsor & trials$area != 'NA'),], aes(area, fill=type))
       + ylab('Number of Trials')
       + xlab('Therapeutic Area')
       + ggtitle('Clinical Trials by Therapeutic Area')
       + geom_bar()
       + coord_flip())
    })
    output$plot2 <- renderPlot({
      (ggplot(trials[which(trials$area == input$area & !is.na(trials$phase)),], 
              aes(phase, fill=sponsor))
       + ylab('Number of Trials')
       + xlab('Phase')
       + ggtitle('Clinical Trials by Phase')
       + geom_bar()
       )
    })
})
