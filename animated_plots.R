#  animation plots
# install.packages("ggplot2")
# install.packages("gganimate")
# install.packages("dplyr")
# install.packages("tibble")
# install.packages("gifski")     # For rendering .gif animations
# install.packages("transformr") # Dependency for gganimate transitions


library(tibble)
library(dplyr)

# Simulate time series gene expression data for 3 genes over 10 time points
set.seed(42)
toy_data <- expand.grid(
  Gene = c("GeneA", "GeneB", "GeneC"),
  Time = 1:10
) %>%
  rowwise() %>%
  mutate(Expression = round(runif(1, 5, 15) + sin(Time/2 + as.numeric(as.factor(Gene))), 2))

head(toy_data)


library(ggplot2)
library(gganimate)

# Base plot
p <- ggplot(toy_data, aes(x = Time, y = Expression, color = Gene)) +
  geom_line(aes(group = Gene), size = 1) +
  geom_point(size = 2) +
  labs(title = "Gene Expression Over Time",
       subtitle = "Time: {frame_time}",
       x = "Time Point", y = "Expression Level") +
  theme_minimal(base_size = 15) +
  transition_time(Time) +
  ease_aes('linear')

# Animate and save as GIF
animate(p, duration = 5, fps = 10, width = 600, height = 400, renderer = gifski_renderer("gene_expression.gif"))






