library(dplyr)
library(plotly)
library(stringr)
library(tidyr)
library(tidyverse)
library(ggplot2)

# Load Data Frame
instagram_data <- read.csv("data/instagram-global-top-1000.csv", stringsAsFactors = FALSE)

# Overall Server Function
server <- function(input, output) {
  
  # Chart 1 Data 
  output$chart1 <- renderPlotly({
    
    # Data Frame for Chart
    influencers_per_country1 <- instagram_data %>% 
      group_by(Audience.Country) %>% 
      summarize(num_of_influencers1 = length(Audience.Country))
    
    influencers_per_country1 = influencers_per_country1[-1,]
    
    chart1_data <- influencers_per_country1 %>% 
      filter(Audience.Country %in% input$chart1_widget)
    
    # Chart 1
    chart1 <- plot_ly(chart1_data,
                      y = ~Audience.Country,
                      x = ~num_of_influencers1,
                      type = "bar",
                      orientation = 'h',
                      color = ~Audience.Country,
                      text = ~paste(Audience.Country, "- Total Follwers:", num_of_influencers1),
                      hoverinfo = "text") %>%
      layout(title = "Number of Influencers Per Country",
             xaxis = list(title = "Number of Influencers"),
             yaxis = list(title = "Audience Country"))
  })
  
  # Chart 1 Message
  output$message1 <- renderText({
    message_str <- paste("I chose a horizontal bar chart to show the number of
                         influencers for each country because it’s easily
                         readable due to the clear x axis that shows number of
                         influencers and long y axis for all the different
                         countries. This variable is not the actual ‘country’
                         the influencers are from, but the country where their
                         engagement is the highest. This information helps us
                         take a critical look at what countries have a
                         significant number of 'influencers' and what reasons
                         some countries may have more influencers than others.
                         Is this due to the internet/social media access of the
                         area? Or does it depend on the cultural relevance of
                         Instagram or other types of social media? How does this
                         differ over different locations? These are all bigger
                         questions we can start to explore while we look at this
                         data.")
    message_str
  })
  
  
  # Chart 2 Data 
  output$scatter_plot <- renderPlotly({
    avg_engagement_per_country <- instagram_data %>% 
      group_by(Audience.Country) %>% 
      summarise(avg_engagement = mean(Engagement.avg, na.rm = TRUE))
    
    avg_engagement_per_country = avg_engagement_per_country[-1,]
    
    chart2_data <- avg_engagement_per_country %>%
      filter(Audience.Country %in% input$country_dropdown)
    
    # Chart 2    
    plot2 <- plot_ly(chart2_data,
                     x = ~avg_engagement,
                     y = ~Audience.Country,
                     type = "scatter",
                     color = ~Audience.Country,
                     mode = "markers",
                     marker = list(size = 20),
                     text = ~paste(Audience.Country, " - Average Engagment: ", avg_engagement),
                     hoverinfo = "text") 
    
    plot2 <- plot2 %>%
      layout(title = "Engagement of Audience Globally",
             xaxis = list(title = "Average Engagement"),
             yaxis = list(title = "Country"))   
    
    return(plot2)
  })
  
  # Chart 2 Message
  output$explanation <- renderText ({
    explanation_str <- paste("I chose this scatter plot to display the average
                             engagement based on the audience's country due to
                             the points effectively showing the differences in
                             average. It also makes the country names readable
                             by having the country names on the y-axis and
                             average engagement on the x-axis. It clearly shows
                             the average engagement in South Korea and Indonesia
                             are the most engaged. The average are evenly spread
                             and there isn't a clear trend in engagement.")
    return(explanation_str)
  })
  
  
  
  # Chart 3 Data Frame
  
output$influencer_plot <- renderPlotly({
    
  newdata <- pivot_longer(data = instagram_data,
                          cols = c(Engagement.avg, Authentic.engagement ),
                          names_to = "Eng",
                          values_to = "value")
  
    if (input$user_selection_line == 1) {
      filterd_df <- newdata %>%
        filter(Eng == "Engagement.avg")
    } else {
      filterd_df <- newdata %>%
        filter(Eng == "Authentic.engagement")
    }
  
    chart3 <- plot_ly(filterd_df,
                      x = ~value,
                      y= ~Followers,
                      name = "Trace",
                      type = 'scatter',
                      mode = 'lines') 
    
    
     chart3 <- chart3 %>% layout(title = "Engagement Average & Authentic Engagement",
             xaxis = list(title = "Engagement"),
             yaxis = list(title = "Followers"))
     
    return(chart3)
  })

}