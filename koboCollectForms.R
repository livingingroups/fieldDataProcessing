# Alex Mandel and Ani Ghosh
# University of California
# 2017
# Edited by K Tiedeman
# 2023 (Thank you Alex and Ani)

# Parse xml ODK data into a table for review
# Long term and Shiny app for viewing data/photos/locations might be nice
# The script should be in the same location (local or server) as the xml files to prevent this error: #https://www.appsloveworld.com/r/100/155/r-xml-content-does-not-seem-to-be-xml

library(XML)
library(plyr)

# Make a list of the xml files in the correct folders 
# For each xml file parse and clean the structure, then rbind them all together to get nice table

parseODK <- function(input){
  # Read XML document of ODK data collect
  doc <- xmlTreeParse(input, useInternal=T, encoding="UTF-8" ) #check xml files for encoding
  root <- xmlRoot(doc)
  # Get the names of the fields
  var.names <- names(root)
  # Extract the values of the fields
  dvalues <- sapply(var.names, function(x) {xpathSApply(root, x, xmlValue)})
  #Convert to a data frame
  outrow <- as.data.frame(t(dvalues))
  return(outrow)
}

# Load the forms

getwd()

setwd("")

# the pattern will be our survey Name! 
b <- list.files("Pixels/Tracy_black/org.koboc.collect.android/files/projects/d7338cea-8349-43d9-8e51-3c98fd20be85/instances",recursive = TRUE, pattern = "Baobab.*\\.xml$", full.names = TRUE)


# Convert XML to Data Frames
parsed <- lapply(b, parseODK)
# Merge the data frames
output <- rbind.fill(parsed)

write.csv(output, ".csv")
