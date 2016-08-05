library(ggplot2)
library(shiny)
library(shinythemes)
library(shinyjs)
library(magrittr)
library(reshape)


shinyServer(fluidPage(
  # Application title
  titlePanel("Memory Utilsation with fitted Regression line (N+2 model)"),
  plotOutput("RegPlot"),
  titlePanel("Memory Utilsation in each host in HVA"),
  plotOutput("hostsPlot")
  
))
