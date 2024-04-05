library(tidymodels)
library(tidyposterior)
library(tidyverse)


run_and_compare_models <- function(model_names) {
  # Run loo using the specified models
  compare_mods <- brms::loo(
    !!!syms(model_names),
    compare = FALSE
  )

  # Subset just the model outputs
  loos <- compare_mods$loos

  # Set up empty data frames for for loop
  df_compare <- data.frame()
  df <- data.frame()

  # Create for loop to fill in the df with the estimates from the loo cv
  for (model in seq_along(loos)) {
    df <- loos[[model]]$estimates
    df_compare <- rbind(df_compare, df)
  }

  # Make the model names into a dataframe
  x <- rep(model_names, each = 3) %>%
    as.data.frame()

  # Rename the column as mod
  names(x) <- "mod"

  # Bind the row names to the dataframe
  df_comp <- df_compare %>%
    rownames_to_column() %>%
    cbind(x)

  # Remove the numbers from the columns
  row_names <- tm::removeNumbers(df_comp$rowname)

  # Compiled estimates for all of the models
  df_comp <- df_comp %>%
    mutate(rowname = row_names) %>%
    group_by(mod) %>%
    pivot_wider(
      names_from = rowname,
      values_from = c(Estimate, SE)
    )

  return(df_comp)
}

# Example usage:
# Specify the models you want to compare
models_to_compare <- c(
  'brm.none',
  'brm.habitat.slope',
  'brm.habitat',
  'brm.habitat.intercept',
  'brm.diet.slope',
  'brm.diet.intercept',
  'brm.trophic',
  'brm.diet.habitat',
  'brm.diet.habitat.year',
  'brm.diet.habitat.species',
  'brm.diet.habitat.species.year'
)
