library(ggplot2)
library(shiny)
library(shinythemes)
library(shinyjs)
library(magrittr)
library(reshape)


shinyServer(fluidPage(
  # Application title
  titlePanel("Memory Utilisation with Fitted Regression Line (N+2 Model)"),
  plotOutput("RegPlot"),
  titlePanel("Memory Utilisation on Each Host in HVX"),
  plotOutput("hostsPlot")
  
))
