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
              axis.ticks=element_blank(), plot.title = element_text(size = 20)) +
        guides(colour = guide_legend(nrow = 1)) +
        scale_fill_discrete(h = c(0,135), h.start = 0, direction = 1, labels = cat_subset,
                            na.value = "#A59D95")
    })
    output$plot1 <- renderPlot({
      (ggplot(trials[which(trials$sponsor == input$sponsor & trials$area != 'NA'),], 
              aes(area, fill=type))
       + ylab('Number of Trials')
       + xlab('Therapeutic Area')
       + theme(axis.text.x = element_text(angle = 90, size = 14, hjust = 1),
               axis.text.y = element_text(size = 14),
               axis.title.x = element_text(size = 16),
               axis.title.y = element_text(size = 16),
               plot.title = element_text(size = 18),
               legend.position = "top")
       + ggtitle('Clinical Trials by Therapeutic Area')
       + guides(fill=guide_legend(title = "Type"), colour = guide_legend(nrow = 1))
       + geom_bar()
       )
    })
    output$plot2 <- renderPlot({
      (ggplot(trials[which(trials$area == input$area & !is.na(trials$phase)),], 
              aes(phase, fill=sponsor))
       + ylab('Number of Trials')
       + xlab('Phase')
       + theme(axis.text.x = element_text(size = 14, hjust = 1),
               axis.text.y = element_text(size = 14),
               axis.title.x = element_text(size = 16),
               axis.title.y = element_text(size = 16),
               plot.title = element_text(size = 18),
               legend.position = "top")
       + ggtitle('Clinical Trials by Phase')
       + geom_bar()
       + guides(fill=guide_legend(title = "Sponsor"))
       )
    })
})
