# How to reproduce the project: Studying Public Responses to Crisis Communication: The Effect of Government Message Framing on Public Fear and Panic

**1. Brief Introduction:**
The project aims to understand how the public reacted to communications from the government during the peak period of the coronavirus pandemic in the US. Essentially, it focuses on how positive and negative framing in the government communications drive public reactions, specifically measuring sentiments level on social media posts. 

**2. Research Questions:**
- How do specific words or texts used in public communications (framing) by the government alleviate or increase public sentiments during major crises?
- To what extent do people express fear and panic in loss-framed messages from the government as compared with gain-framed messages


**3. Data collection:**
This study uses data collected from r/Coronavirus on Reddit during the time period of 2020. It analyzes posts, specifically those discussing communications from government agencies such as the Centers for Disease Control and Prevention (CDC) and White House, and the comments made on the posts by the public reflecting their opinions, concerns, and emotional responses. Using specific keywords, 1,059 posts were gotten along with 62,010 comments. 


**4. Software used:** 
R/RStudio:
-Packages installed on R:
  - "RedditExtractoR": To collect data from Reddit
  - "tidyverse": To clean data
  - "sentimentr": To score public sentiments 
  - "lubridate": To classify the crisis phase
  - "stargazer": To export the regression result from R into a formatted table (which was then manually moved to Excel)
  - "ggplot2": To generate the figures
  - "tidytext": break words into tokens to make frequency analysis
  - "patchwork": To combine the frequency charts into one image
  - "RColorBrewer": To add colors to the figures
  

**5. Repository on GitHub:**
-Create a repository on GitHub titled "Project Drafts". 
  -Under the Project drafts folder, upload:   
  
    *Code
    Data collection script.R: # Collect raw data from posts about coronavirus on Reddit and comments from the public
    Data cleaning script.R: # Clean the raw data, categorize framing, and sentiment scoring
    Regression script. R: # Get the summary statistics and run the regression models
    Analysis using figures script. R: # Generate three figures describing the data 

    *Data
      -Raw: 
      covid_posts_v3.csv: # Raw Reddit data containing r/coronavirus posts
      covid_comments_v3.csv: #Public Comments on government posts on coronavirus
      
      -Analysis:
      tweets_coded_finalvv3.csv: #Clean and coded data from the raw data


      *Results
        -Tables
        Summary Statistics.xlsx
        Regression Results.xlsx 

        -Figures
        Figure 1 - Sentiment Score by Framing.png
        Figure 2 - Sentiment Distribution in Percentages.png
        Figure 3 - Sentiment Monthly Timeseries.png
      

      
**Step by step**
- Install the packages in section 4 above in R 
- Set the working directory: setwd("/Users/admin/Documents/POL 688")
- Run the following scripts accordingly (as found in section 5):
  - "Data collection script"
  - "Data cleaning script"
  - "Regression script"
  - "Analysis using figures script"
  
- Upload the following files to GitHub:
  - Data folder: Raw data and Cleaned data
  - Code folder: Scripts
  - Results: Tables and Figures 






