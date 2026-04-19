install.packages("RedditExtractoR")
library(RedditExtractoR)

posts <- find_thread_urls(
  keywords = "CDC coronavirus briefing",
  subreddit = "Coronavirus",
  sort_by = "top",
  period = "year"
)

View(posts)

# Check what came back
nrow(posts)
View(posts)


posts <- find_thread_urls(
  keywords = "coronavirus CDC",
  subreddit = "Coronavirus",
  sort_by = "top",
  period = "all"   # changed from "year" to "all" to get more results
)


# How many posts did we get?
nrow(posts)

# Save it immediately so you don't lose it
write.csv(posts, "covid_reddit_posts.csv", row.names = FALSE)

comments <- get_thread_content(posts$url)


nrow(comments$comments)
write.csv(comments$comments, "covid_reddit_comments.csv", row.names = FALSE)

colnames(comments$comments)
head(comments$comments)