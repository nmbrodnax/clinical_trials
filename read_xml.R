# Load XML file into memory and parse into r object
library(XML)
xml.url <- "telemed_trials_may30.xml" #loads in the xml file
xmlfile <- xmlTreeParse(xml.url) #converts the xml file to an r object
xmltop <- xmlRoot(xmlfile) #root is the highest level in the hierarchy

# Convert xml object into data frame
trials <- xmlSApply(xmltop, function(x) xmlSApply(x,xmlValue))
trials_df <- data.frame(t(trials), row.names=NULL)
#this didn't quite work, need to fix
