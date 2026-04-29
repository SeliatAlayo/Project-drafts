# ============================================================
# 02_clean_code.R
# Purpose: Clean comments, classify post framing, score sentiment
# Input:  Data/raw/covid_reddit_posts.csv
#         Data/raw/covid_reddit_comments.csv
# Output: Data/analysis/tweets_coded.csv
# ============================================================

# ── Install & load packages ──────────────────────────────────
install.packages(c("tidyverse", "vader", "lubridate"))
library(tidyverse)
library(vader)
library(lubridate)

# vader is not on CRAN, install from GitHub
install.packages("devtools")
devtools::install_github("chris31415926535/vaderSentiment")

# Then load it
library(vaderSentiment)

install.packages("sentimentr")
library(sentimentr)

# ── Load data ────────────────────────────────────────────────
posts    <- read.csv("covid_reddit_posts.csv")
comments <- read.csv("covid_reddit_comments.csv")

# ── Step 1: Clean comments ───────────────────────────────────
comments_clean <- comments %>%
  # Remove deleted/empty comments
  filter(!is.na(comment),
         comment != "[deleted]",
         comment != "[removed]",
         comment != "") %>%
  # Remove bot-like very short comments
  filter(nchar(comment) > 10)

# ── Step 2: Classify post framing ───────────────────────────
gain_keywords <- c("saved", "recovered", "protected", "survived",
                   "prevented", "safe", "effective", "working",
                   "recovery", "hope", "success", "contained")

loss_keywords <- c("died", "death", "deaths", "will die", "risk",
                   "danger", "fatal", "infected", "spreading",
                   "overwhelmed", "surge", "crisis", "botched",
                   "failed", "too slow", "snail")

posts_coded <- posts %>%
  mutate(
    title_lower = str_to_lower(title),
    gain_score  = str_count(title_lower,
                            paste(gain_keywords, collapse = "|")),
    loss_score  = str_count(title_lower,
                            paste(loss_keywords, collapse = "|")),
    framing     = case_when(
      gain_score > loss_score ~ "gain",
      loss_score > gain_score ~ "loss",
      TRUE ~ "neutral"
    )
  ) %>%
  select(url, title, date_utc, framing, gain_score, loss_score)

# ── Step 3: Score comment sentiment with sentimentr ───────────────
# This may take a few minutes
cat("Scoring sentiment... please wait\n")

comments_clean <- comments_clean %>%
  mutate(
    vader_score = sapply(comment, function(x) {
      tryCatch(
        mean(sentiment(x)$sentiment),
        error = function(e) NA
      )
    }),
    sentiment = case_when(
      vader_score >= 0.05  ~ "positive",
      vader_score <= -0.05 ~ "negative",
      TRUE                 ~ "neutral"
    )
  )

# ── Step 4: Flag panic & reassurance keywords ────────────────
panic_words <- c("scared", "panic", "terrified", "worried",
                 "afraid", "fear", "doomed", "hopeless",
                 "overwhelmed", "disaster")

reassurance_words <- c("thank", "safe", "grateful", "relieved",
                       "calm", "okay", "fine", "good job",
                       "appreciate", "hope")

comments_clean <- comments_clean %>%
  mutate(
    comment_lower    = str_to_lower(comment),
    panic_flag       = str_detect(comment_lower,
                                  paste(panic_words, collapse = "|")),
    reassurance_flag = str_detect(comment_lower,
                                  paste(reassurance_words, collapse = "|"))
  )

# ── Step 5: Merge posts and comments ─────────────────────────
analysis_data <- comments_clean %>%
  left_join(posts_coded, by = "url") %>%
  mutate(
    date     = as.Date(date),
    month    = month(date),
    crisis_phase = case_when(
      month <= 2 ~ "early",
      month <= 5 ~ "peak",
      TRUE       ~ "declining"
    )
  )

# ── Step 6: Save analysis dataset ───────────────────────────
write.csv(analysis_data,
          "Data/analysis/tweets_coded.csv",
          row.names = FALSE)

cat("Done! Rows in analysis dataset:", nrow(analysis_data), "\n")

# Create the folder if it doesn't exist
dir.create("Data/analysis", recursive = TRUE, showWarnings = FALSE)

# Now save the file
write.csv(analysis_data, "Data/analysis/tweets_coded.csv", row.names = FALSE)

# Check it saved
cat("Done! Rows:", nrow(analysis_data), "\n")



# See framing breakdown
table(analysis_data$framing)

# See sentiment breakdown  
table(analysis_data$sentiment)

# See crisis phase breakdown
table(analysis_data$crisis_phase)