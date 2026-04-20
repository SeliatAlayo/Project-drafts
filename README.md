# How to reproduce the project: Studying Public Responses to Crisis Communication: The Effect of Government Message Framing on Public Fear and Panic

**Brief Introduction**
The project aims to understand how the public reacted to communications from the government during the peak period of the coronavirus pandemic in the US. Essentially, it focuses on how positive and negative framing by the government drives public reactions, specifically measuirng sentiments level on social media posts. 

**Research Questions:**
- How do specific words or texts used in public communications (framing) by the government alleviate or increase public sentiments during major crises?
- To what extent do 


**Data collection**
This study uses data gotten from Reddit. Specifically, it analyzes data from posts made by government agencies (Centers for Disease Control and Prevention (CDC), White House) and the comments made on the posts by the public reflecting their opinions, concerns and emotional responses. 

**Software used** 
R/RStudio
Github

**Repository on GitHub**
-Create a repository on GitHub titled "Project Drafts". 
  -Under the Project drafts folder:   
    *Code
  Data collection script.R: # Collect raw data from government posts about coronavirus on Reddit and comments from the public
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
      

      



