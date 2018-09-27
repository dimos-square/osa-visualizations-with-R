# install.packages(c("dplyr", "ggplot2", "tidyr"))

source("open-source-api.R")

library(dplyr)
library(ggplot2)
library(tidyr)

# replace XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX with your actual private token
token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

# use recent hours
hour_from <- "2018-09-13-12"
hour_to <- "2018-09-20-11"

df <- run_query(
  token,
  hour_from,
  hour_to,
  dimensions = list("repo_language"),
  metrics = list("star_actors",
                 "fork_actors"),
  filters = list(
    "repo_language" = list("Clojure",
                           "Elixir",
                           "F#",
                           "Haskell",
                           "Scala",
                           "OCaml")
  )
)

functional_langs <- gather(data = df, key = Action, value = n, -repo_language) %>%
  mutate(Action = replace(Action, Action == "star_actors", "Star")) %>%
  mutate(Action = replace(Action, Action == "fork_actors", "Fork"))

ggplot(data = functional_langs, mapping = aes(x = repo_language, y = n, fill = Action)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  labs(x = "Language", y = "Users", title = "Functional Languages")
