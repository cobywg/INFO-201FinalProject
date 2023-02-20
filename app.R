# Load Packages
library(shiny)
library(rsconnect)

# Source Files
source("server.R")
source("ui.R")

# Shiny App
shinyApp(ui = ui, server = server)
