# ---------------------------------------------------------

# Melbourne Bioinformatics Training Program

# This exercise to assess your familiarity with R and git. Please follow
# the instructions on the README page and link to your repo in your application.
# If you do not link to your repo, your application will be automatically denied.

# Leave all code you used in this R script with comments as appropriate.
# Let us know if you have any questions!


# You can use the resources available on our training website for help:
# Intro to R: https://mbite.org/intro-to-r
# Version Control with Git: https://mbite.org/intro-to-git/

# ----------------------------------------------------------

# Load libraries -------------------
# You may use base R or tidyverse for this exercise

library(tidyverse)

# Load data here ----------------------
# Load each file with a meaningful variable name.

expression_data <- read.csv("data/GSE60450_GeneLevel_Normalized(CPM.and.TMM)_data.csv", row.names = 1)
metadata <- read.csv("data/GSE60450_filtered_metadata.csv")

# Inspect the data -------------------------

# What are the dimensions of each data set? (How many rows/columns in each?)
# Keep the code here for each file.

## Expression data

dim(expression_data)
head(expression_data)
str(expression_data)

## Metadata

dim(metadata)
head(metadata)
str(metadata)


# Prepare/combine the data for plotting ------------------------
# How can you combine this data into one data.frame?

# Convert expression matrix to long format
expression_long <- expression_data %>% select(-gene_symbol) %>%
  rownames_to_column(var = "gene") %>%
  pivot_longer(
    cols = -gene,
    names_to = "sample",
    values_to = "expression"
  )

# Merge with metadata by sample name
combined_data <- expression_long %>%
  left_join(metadata, by = c("sample" = "X"))

# Inspect combined data
dim(combined_data)
head(combined_data)

# Plot the data --------------------------
## Plot the expression by cell type
## Can use boxplot() or geom_boxplot() in ggplot2

ggplot(combined_data, aes(x = sample, y = expression)) +
  geom_boxplot() +
  labs(title = "Gene Expression by Cell Type",
       x = "Cell Type",
       y = "Expression") +
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  

## Save the plot
### Show code for saving the plot with ggsave() or a similar function

# Save plot
ggsave(
  filename = "results/expression_by_cell_type.png",
  width = 8,
  height = 6,
  dpi = 300
)

