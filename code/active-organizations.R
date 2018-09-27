# install.packages(c("dplyr", "ggplot2"))

source("open-source-api.R")

library(dplyr)
library(ggplot2)

# replace XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX with your actual private token
token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

# use recent hours
hour_from <- "2018-09-13-12"
hour_to <- "2018-09-20-11"

df <- run_query(
  token,
  hour_from,
  hour_to,
  dimensions = list("organization"),
  metrics = list("pull_requests_merged"),
  limit = 11
)

popular_orgs <- df %>%
  filter(organization != "None")

ggplot(data = popular_orgs, mapping = aes(x = organization, y = pull_requests_merged)) +
  geom_col() +
  labs(x = "Organization", y = "Pull Request Merges", title = "Active Organizations")
