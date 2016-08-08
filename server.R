library(ggplot2)
library(shiny)
library(shinythemes)
library(shinyjs)
library(magrittr)
library(reshape)


shinyServer(function(input, output, session){
  
  df <- as.data.frame(read.csv(text="datetime, host1, host2, host3, host4, host5, total"))
  data <- as.data.frame(read.csv(text="datetime, host1, host2, host3, host4, host5, total"))
  
  # Function to get new observations
  get_new_data <- function(){
    host1 <- sample(20:75, 1)
    host2 <- sample(20:75, 1)
    host3 <- sample(20:75, 1)
    host4 <- sample(20:75, 1)
    host5 <- sample(20:75, 1)
    total <- host1 + host2 + host3 + host4 + host5 
    datetime <- format(Sys.time())
    return(c(datetime,host1, host2, host3, host4, host5, total))
  }
  
  # Initialize my_data
  df[nrow(df)+1,] <- get_new_data()
  
  # Function to update my_data
  update_data <- function(){
    if(nrow(df)>100){
      df <<- df[-1, ]
    }
    df[nrow(df)+1,] <<- get_new_data()
    rownames(df) <<- c(1:nrow(df))
  }
  
  # Plot the 30 most recent values
  output$RegPlot <- renderPlot({
    invalidateLater(1000, session)
    update_data()
    ggplot(df, aes(datetime, as.numeric(total), group = 1)) + geom_line() + geom_smooth(method = "lm", se = FALSE, colour="blue")  +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) + expand_limits(y=c(0,500))# + scale_y_continuous(breaks=seq(0, 500, 50))
  })
  output$hostsPlot <- renderPlot({
    invalidateLater(1000, session)
    hosts <<- melt(df[,1:6], id=c("datetime")) 
    ggplot(hosts, aes(datetime, as.numeric(value), group = variable, colour = variable), size="0.5") + geom_line() + 
            theme(axis.text.x = element_text(angle = 45, hjust = 1)) + expand_limits(y=c(0,100))
  })
  
  
})