library(stargazer) 

# Filter to gain and loss only
analysis_clean <- analysis_final %>%
  filter(framing != "neutral")

cat("Rows for analysis:", nrow(analysis_clean), "\n")

# Set reference categories
analysis_clean$framing <- relevel(
  factor(analysis_clean$framing), ref = "gain")
analysis_clean$crisis_phase <- relevel(
  factor(analysis_clean$crisis_phase), ref = "early")

# Summary stats
summary_stats <- analysis_clean %>%
  group_by(framing) %>%
  summarise(
    n             = n(),
    avg_sentiment = round(mean(vader_score, na.rm=TRUE), 3),
    pct_negative  = round(mean(sentiment=="negative")*100, 1),
    pct_positive  = round(mean(sentiment=="positive")*100, 1),
    pct_panic     = round(mean(panic_flag, na.rm=TRUE)*100, 1),
    pct_fear      = round(mean(fear_flag, na.rm=TRUE)*100, 1),
    pct_reassure  = round(mean(reassurance_flag, na.rm=TRUE)*100,1),
    avg_upvotes   = round(mean(upvotes, na.rm=TRUE), 1)
  )
print(summary_stats)

# Model 1 - framing predicting sentiment
model1 <- lm(vader_score ~ framing + crisis_phase + upvotes,
             data = analysis_clean)
summary(model1)

# Model 2 - framing predicting panic
model2 <- glm(panic_flag ~ framing + crisis_phase + upvotes,
              data = analysis_clean,
              family = binomial)
summary(model2)

# Model 3 - framing predicting fear expressions
model3 <- glm(fear_flag ~ framing + crisis_phase + upvotes,
              data = analysis_clean,
              family = binomial)
summary(model3)

# Export tables
dir.create("Results/tables", recursive=TRUE, showWarnings=FALSE)
write.csv(summary_stats, "Results/tables/summary_stats.csv",
          row.names=FALSE)

stargazer(model1, model2, model3,
          type = "html",
          out  = "Results/tables/reg_table.html",
          title = "Effect of Government Message Framing on Public Fear and Panic",
          dep.var.labels = c("Sentiment Score",
                             "Panic (0/1)",
                             "Fear Expression (0/1)"),
          star.cutoffs = c(0.05, 0.01, 0.001))

cat("Done!\n")