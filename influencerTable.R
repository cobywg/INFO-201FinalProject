library(readr)
library(tidyverse)
library(dplyr)
instagram_global_top_1000 <- read.csv("data/instagram-global-top-1000.csv")




library(knitr)

agg_table <- instagram_global_top_1000 %>%  group_by(Audience.Country) %>% 
  summarise(mean_fol = mean(Followers, na.rm=TRUE),
            mean_eng = mean(Engagement.avg, na.rm=TRUE), 
            mean_auth = mean(Authentic.engagement,na.rm=TRUE)) %>% 
  arrange(desc(mean_fol)) %>% slice_head(n =10)

agg_table <- kable(agg_table, col.names = c("Country", "Average Followers", 
                            "Average Engagment", "Average Authentic Engagment"), caption = "Top 10 Countries with the highest average followers on Instagram") 

