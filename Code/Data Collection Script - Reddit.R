library(RedditExtractoR)
library(tidyverse)

# LOSS FRAMING: Danger communication from the government 

posts_loss1 <- find_thread_urls(
  keywords = "CDC coronavirus deaths covid19 kills Americans will die crisis",
  subreddit = "Coronavirus",
  sort_by = "top",
  period = "all"
)
cat("Loss 1:", nrow(posts_loss1), "\n")

posts_loss2 <- find_thread_urls(
  keywords = "government failed COVID Americans dying death deadly",
  subreddit = "Coronavirus",
  sort_by = "top",
  period = "all"
)
cat("Loss 2:", nrow(posts_loss2), "\n")

posts_loss3 <- find_thread_urls(
  keywords = "CDC warning coronavirus danger high risk severe emergency",
  subreddit = "Coronavirus",
  sort_by = "top",
  period = "all"
)
cat("Loss 3:", nrow(posts_loss3), "\n")

# GAIN FRAMING: Government hopeful communication

posts_gain1 <- find_thread_urls(
  keywords = "CDC coronavirus vaccine safe effective approved protected",
  subreddit = "Coronavirus",
  sort_by = "top",
  period = "all"
)
cat("Gain 1:", nrow(posts_gain1), "\n")

posts_gain2 <- find_thread_urls(
  keywords = "coronavirus recovery treatment working hope",
  subreddit = "Coronavirus",
  sort_by = "top",
  period = "all"
)
cat("Gain 2:", nrow(posts_gain2), "\n")

posts_gain3 <- find_thread_urls(
  keywords = "COVID good news improving better saved",
  subreddit = "Coronavirus",
  sort_by = "top",
  period = "all"
)
cat("Gain 3:", nrow(posts_gain3), "\n")

# Panic keywords in the comments
panic_words <- c(
  "scared", "terrified", "panic", "panicking",
  "afraid", "fear", "fearful", "doomed",
  "hopeless", "anxious", "anxiety", "worried",
  "nightmare", "horrified", "dread", "dreading",
  "cant concentrate", "losing sleep", "overwhelmed",
  "we are all going to die", "this is the end",
  "never going to end", "so scared", "sad", "stuck"
)

# Fear keywords in the comments
fear_expressions <- c(
  "i am scared", "i'm scared", "im scared",
  "i am terrified", "i'm terrified",
  "this scares me", "frightening",
  "how worried", "very worried",
  "extremely concerned", "deeply concerned",
  "i cant stop thinking", "keeps me up",
  "my heart", "heartbreaking",
  "i feel sick", "makes me sick"
)

# Combine all posts and remove duplicates
all_posts_v3 <- bind_rows(
  posts_loss1, posts_loss2, posts_loss3,
  posts_gain1, posts_gain2, posts_gain3
) %>%
  distinct(url, .keep_all = TRUE)

cat("Total unique posts:", nrow(all_posts_v3), "\n")

# Save posts
write.csv(all_posts_v3, "covid_posts_v3.csv", row.names = FALSE)

# Pull comments
cat("Pulling comments.\n")
all_comments_v3 <- get_thread_content(all_posts_v3$url)

# Save comments
write.csv(all_comments_v3$comments,
          "covid_comments_v3.csv",
          row.names = FALSE)

cat("Done! Comments:", nrow(all_comments_v3$comments), "\n")

