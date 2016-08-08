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
    if(nrow(df)>5){
      #df <- as.data.frame(read.csv(text="datetime, host1, host2, host3, host4, host5, total"))
      #data <- as.data.frame(read.csv(text="datetime, host1, host2, host3, host4, host5, total"))
      df <<- df[-c(min(as.numeric(rownames(df)))-1),]
      print(df)
    }
    df[nrow(df)+1,] <<- get_new_data()
    data <<- df[rev(rownames(df)),]
  }
  
  
  # Plot the 30 most recent values
  output$RegPlot <- renderPlot({
    invalidateLater(1000, session)
    update_data()
    ggplot(data[1:50,], aes(datetime, total, group = 1,size = "0.5")) + geom_line() + geom_smooth(method = "lm", se = FALSE, colour="blue") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) #+ stat_smooth()

  })
  output$hostsPlot <- renderPlot({
    invalidateLater(1000, session)
    hosts <<- melt(data[1:50,1:6], id=c("datetime")) 
    ggplot(hosts, aes(x=datetime, y=value, group = variable, colour = variable), size="0.5") + geom_line() + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
  
  })
})