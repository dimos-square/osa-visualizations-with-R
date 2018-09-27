# install.packages(c("dplyr", "ggplot2", "tidyr"))

source("open-source-api.R")

library(dplyr)
library(ggplot2)
library(tidyr)

# replace XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX with your actual private token
token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

# use recent day
day <- "2018-09-26"

df <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(df) <- c("hour", "issue_comments", "issues_closed", "issues_opened" , "issues_reopened")

for (h in sprintf("%02d", 23:0)){
  hour <- paste(day, h, sep = "-")

  results <- run_query(
    token,
    hour_from = hour,
    hour_to = hour,
    dimensions = list("actor_type"),
    metrics = list("issue_comments", "issues_closed", "issues_opened" , "issues_reopened"),
    filters = list(
      "actor_type" = list("User")
    )
  )

  df <- results %>%
    select(-actor_type) %>%
    mutate(hour = h) %>%
    union_all(df)

  print(paste("wait", 24 - as.numeric(h), "/ 24"))
  Sys.sleep(5)
}

daily_issues <- gather(data = df, key = Action, value = Issues, -hour) %>%
  mutate(Action = replace(Action, Action == "issue_comments", "Comment")) %>%
  mutate(Action = replace(Action, Action == "issues_closed", "Close")) %>%
  mutate(Action = replace(Action, Action == "issues_opened", "Open")) %>%
  mutate(Action = replace(Action, Action == "issues_reopened", "Reopen"))

ggplot(daily_issues, aes(x = hour, y = Issues, group = Action)) +
  geom_line(aes(color = Action), size = 1) +
  labs(x = "Hour", y = "", title = "Issues") +
  theme_minimal()
