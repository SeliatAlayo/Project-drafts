library(tidyverse)
library(sentimentr)
library(lubridate)

# Load the dataset 
all_posts_v3    <- read.csv("covid_posts_v3.csv")
all_comments_v3 <- read.csv("covid_comments_v3.csv")

cat("Posts loaded:", nrow(all_posts_v3), "\n")
cat("Comments loaded:", nrow(all_comments_v3), "\n")

# Step 1: Clean the comments
comments_clean <- all_comments_v3 %>%
  filter(!is.na(comment),
         comment != "[deleted]",
         comment != "[removed]",
         comment != "") %>%
  filter(nchar(comment) > 10)

cat("Clean comments:", nrow(comments_clean), "\n")

# Step 2: Classify post framing
gain_keywords <- c("saved", "recovered", "protected", "survived",
                   "prevented", "safe", "effective", "working",
                   "recovery", "hope", "success", "contained",
                   "vaccine", "treatment", "approved",
                   "flatten", "slowing", "improvement", "better",
                   "declining", "good news")

loss_keywords <- c("died", "death", "deaths", "will die", "risk",
                   "danger", "fatal", "infected", "spreading",
                   "overwhelmed", "surge", "crisis", "botched",
                   "failed", "worse", "catastrophe", "disaster",
                   "shortage", "dying", "kill")

posts_coded <- all_posts_v3 %>%
  mutate(
    title_lower = str_to_lower(title),
    gain_score  = str_count(title_lower,
                            paste(gain_keywords, collapse = "|")),
    loss_score  = str_count(title_lower,
                            paste(loss_keywords, collapse = "|")),
    framing = case_when(
      gain_score > loss_score ~ "gain",
      loss_score > gain_score ~ "loss",
      TRUE ~ "neutral"
    )
  ) %>%
  select(url, title, date_utc, framing, gain_score, loss_score)

cat("Framing breakdown:\n")
print(table(posts_coded$framing))

# Step 3: Take Subsample comments
# Maximum 5 comments per post to keep scoring manageable
set.seed(123)
comments_sample <- comments_clean %>%
  group_by(url) %>%
  slice_sample(n = 5) %>%
  ungroup()

cat("Sampled comments:", nrow(comments_sample), "\n")

# Step 4: Score sentiment
cat("Scoring sentiment.\n")

comments_sample <- comments_sample %>%
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

# Step 5: Flag panic keywords in comments 
panic_words <- c(
  "scared", "terrified", "panic", "panicking",
  "afraid", "fear", "fearful", "doomed",
  "hopeless", "anxious", "anxiety", "worried",
  "nightmare", "horrified", "dread", "dreading",
  "cant concentrate", "losing sleep", "overwhelmed",
  "we are all going to die", "this is the end",
  "never going to end", "so scared", "sad", "stuck"
)

# Step 6: Flag fear expressions in comments
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

reassurance_words <- c(
  "thank", "safe", "grateful", "relieved",
  "calm", "okay", "fine", "good job",
  "appreciate", "hope", "better now",
  "feeling better", "not worried"
)

comments_sample <- comments_sample %>%
  mutate(
    comment_lower    = str_to_lower(comment),
    panic_flag       = str_detect(comment_lower,
                                  paste(panic_words, collapse = "|")),
    fear_flag        = str_detect(comment_lower,
                                  paste(fear_expressions, collapse = "|")),
    reassurance_flag = str_detect(comment_lower,
                                  paste(reassurance_words, collapse = "|"))
  )

# Step 7: Merge posts and comments together
analysis_final <- comments_sample %>%
  left_join(posts_coded, by = "url") %>%
  mutate(
    date = as.Date(date),
    year = format(date, "%Y"),
    month = month(date),
    crisis_phase = case_when(
      month <= 2 ~ "early",
      month <= 5 ~ "peak",
      TRUE       ~ "declining"
    )
  ) %>%
  filter(year == "2020")

cat("Final dataset rows:", nrow(analysis_final), "\n")
cat("\nFraming:\n")
print(table(analysis_final$framing))
cat("\nSentiment:\n")
print(table(analysis_final$sentiment))
cat("\nCrisis phase:\n")
print(table(analysis_final$crisis_phase))

# Step 8: Save analysis dataset
dir.create("Data/analysis", recursive = TRUE,
           showWarnings = FALSE)

write.csv(analysis_final,
          "tweets_coded_final.csv",
          row.names = FALSE)

cat("Saved!\n")
