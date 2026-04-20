# How to reproduce the project: Studying Public Responses to Crisis Communication: The Effect of Government Message Framing on Public Fear and Panic

**Brief Introduction:**
The project aims to understand how the public reacted to communications from the government during the peak period of the coronavirus pandemic in the US. Essentially, it focuses on how positive and negative framing in the government communications drive public reactions, specifically measuirng sentiments level on social media posts. 

**Research Questions:**
- How do specific words or texts used in public communications (framing) by the government alleviate or increase public sentiments during major crises?
- To what extent do 


**Data collection:**
This study uses data collected from r/Coronavirus on Reddit during the time period of 2020. It analyzes posts, specifically those discussing communications from government agencies such as the Centers for Disease Control and Prevention (CDC) and White House, and the comments made on the posts by the public reflecting their opinions, concerns, and emotional responses. Using specific keywords, 1,059 posts were gotten along with 62,010 comments. 

**Software used:** 
R/RStudio:
  Packages installed on R:
  "RedditExtractoR": To 
  "tidyverse": 
  "sentimentr" 
  "lubridate" 
  "stargazer" 
  "ggplot2" 
  "tidytext" 
  "patchwork" 
  "RColorBrewer"
  

**Repository on GitHub:**
-Create a repository on GitHub titled "Project Drafts". 
  -Under the Project drafts folder:   
  
    *Code
    Data collection script.R: # Collect raw data from posts about coronavirus on Reddit and comments from the public
    Data cleaning script.R: # Clean the raw data, categorize framing, and sentiment scoring
    Regression script. R: # Get the summary statistics and run the regression models
    Analysis using figures script. R: # Generate three figures describing the data 

    *Data
      -Raw: 
      covid_posts_v3.csv: # Raw Reddit data containing government posts
      covid_comments_v3.csv: #Public Comments on government posts on coronavirus
      
      -Analysis:
      tweets_coded_finalvv3.csv: #Clean and coded data from the raw data


      *Results
        -Tables
        Summary Statistics.xlsx
        Regression Result.xlsx 

        -Figures
        Figure 1 - Sentiment Score by Framing.png
        Figure 2 - Sentiment Distribution in Percentages.png
        Figure 3 - Sentiment Monthly Timeseries.png
      

      



