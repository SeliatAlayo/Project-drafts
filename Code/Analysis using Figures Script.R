# Install & load necessary packages
install.packages(c("ggplot2", "tidyverse", "wordcloud2", 
                   "tidytext", "RColorBrewer", "patchwork"))
library(ggplot2)
library(tidyverse)
library(wordcloud2)
library(tidytext)
library(RColorBrewer)
library(patchwork)

# Load data
analysis_clean <- read.csv("tweets_coded_final_v3.csv") %>%
  filter(framing != "neutral")

# Create output folder
dir.create("Results/figures", recursive = TRUE, 
           showWarnings = FALSE)

# FIGURE 1: Average sentiment by framing type (bar chart)

sentiment_summary <- analysis_clean %>%
  group_by(framing) %>%
  summarise(
    avg_sentiment = mean(vader_score, na.rm = TRUE),
    se = sd(vader_score, na.rm = TRUE) / sqrt(n()),
    n = n()
  ) %>%
  mutate(framing = str_to_title(framing))

fig1 <- ggplot(sentiment_summary, 
               aes(x = framing, y = avg_sentiment, fill = framing)) +
  geom_col(width = 0.5, alpha = 0.85) +
  geom_errorbar(aes(ymin = avg_sentiment - se,
                    ymax = avg_sentiment + se),
                width = 0.15, linewidth = 0.8) +
  geom_hline(yintercept = 0, linetype = "dashed", 
             color = "gray40") +
  scale_fill_manual(values = c("Gain" = "#2E86AB", 
                               "Loss" = "#E84855")) +
  labs(
    title = "Average Public Sentiment by Government Message Framing",
    subtitle = "Reddit comments on COVID-19 posts (Year 2020)",
    x = "Message Framing Type",
    y = "Average Sentiment Score ranging from -1 to +1",
    caption = "Error bars show standard error. 
    Dashed line = neutral sentiment."
  ) +
  theme_minimal(base_size = 13) +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(color = "gray40"))

ggsave("Results/figures/fig1_sentiment_by_framing.png",
       fig1, width = 7, height = 5, dpi = 300)
cat("Figure 1 saved!\n")

# FIGURE 2: % Negative vs Positive comments by framing

sentiment_pct <- analysis_clean %>%
  group_by(framing) %>%
  summarise(
    Negative = mean(sentiment == "negative") * 100,
    Positive = mean(sentiment == "positive") * 100,
    Neutral  = mean(sentiment == "neutral") * 100
  ) %>%
  pivot_longer(cols = c(Negative, Positive, Neutral),
               names_to = "sentiment_type",
               values_to = "percentage") %>%
  mutate(
    framing = str_to_title(framing),
    sentiment_type = factor(sentiment_type, 
                            levels = c("Positive", 
                                       "Neutral", 
                                       "Negative"))
  )

fig2 <- ggplot(sentiment_pct, 
               aes(x = framing, y = percentage, 
                   fill = sentiment_type)) +
  geom_col(position = "dodge", width = 0.6, alpha = 0.85) +
  scale_fill_manual(values = c("Positive" = "#2E86AB",
                               "Neutral"  = "#A8DADC",
                               "Negative" = "#E84855")) +
  labs(
    title = " Public Sentiment Distribution by Framing Type",
    subtitle = "Reddit comments on COVID-19 posts (Year 2020)",
    x = "Message Framing Type",
    y = "Percentage of Comments (%)",
    fill = "Sentiment",
    
  ) +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(color = "gray40"))

ggsave("Results/figures/fig2_sentiment_distribution.png",
       fig2, width = 8, height = 5, dpi = 300)
cat("Figure 2 saved!\n")

# FIGURE 3: Sentiment over time by framing (time series)

time_series <- analysis_clean %>%
  mutate(date = as.Date(date),
         month = floor_date(date, "month")) %>%
  group_by(month, framing) %>%
  summarise(avg_sentiment = mean(vader_score, na.rm = TRUE),
            n = n(), .groups = "drop") %>%
  filter(n >= 5) %>%  # only months with enough data
  mutate(framing = str_to_title(framing))

fig3 <- ggplot(time_series,
               aes(x = month, y = avg_sentiment,
                   color = framing, group = framing)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2.5) +
  geom_hline(yintercept = 0, linetype = "dashed",
             color = "gray40") +
  scale_color_manual(values = c("Gain" = "#2E86AB",
                                "Loss" = "#E84855")) +
  scale_x_date(date_labels = "%b %Y", date_breaks = "2 months") +
  labs(
    title = "Public Sentiment Over Time by Government Message Framing",
    subtitle = "Monthly average sentiment scores, 2020",
    x = "Month",
    y = "Average Sentiment Score",
    color = "Framing Type",
    caption = "Dashed line = neutral sentiment"
  ) +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(color = "gray40"),
        axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("Results/figures/fig3_sentiment_timeseries.png",
       fig3, width = 9, height = 5, dpi = 300)
cat("Figure 3 saved!\n")

cat("\nAll figures saved to Results/figures/\n")
cat("Files created:\n")
cat("- fig1_sentiment_by_framing.png\n")
cat("- fig2_sentiment_distribution.png\n")
cat("- fig3_sentiment_timeseries.png\n")
