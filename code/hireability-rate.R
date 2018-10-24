# install.packages(c("dplyr", "ggplot2", "rworldmap"))

source("open-source-api.R")

library(dplyr)
library(ggplot2)
library(rworldmap)

# replace XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX with your actual private token
token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

# use recent hours
hour_from <- "2018-09-13-12"
hour_to <- "2018-09-20-11"

df <- run_query(
  token,
  hour_from,
  hour_to,
  dimensions = list("actor_country", "actor_is_hireable"),
  metrics = list("push_actors"),
  filters = list(
      "actor_type" = list("User")
    )
)

df_without_na <- df %>%
  filter(actor_country != "n/a" & "actor_is_hireable" != "n/a")
  
total_hireability <- df_without_na %>%
  group_by(actor_country) %>%
  summarise(total_actors = sum(push_actors))

hireability <- df_without_na %>%
  filter(actor_is_hireable == "true") %>%
  select(-actor_is_hireable) %>%
  left_join(total_hireability, by = "actor_country") %>%
  filter(total_actors > 10) %>%
  mutate(rate = push_actors / total_actors)

mapped_data <- joinCountryData2Map(hireability, joinCode = "ISO2", nameJoinColumn = "actor_country")

mapCountryData(mapped_data, nameColumnToPlot = "rate",  mapTitle = "Hireability Rate")
