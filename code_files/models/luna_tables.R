library(tidymodels)
library(tidyposterior)
library(tidyverse)

#dt <- read_csv(here::here('data', "data_outputs", "loo_compare.csv"))

# run loo using the original models
compare_original_mods <- brms::loo(brm.none,
                                   brm.habitat.slope,brm.habitat,
                                   brm.habitat.intercept,
                                   brm.diet.slope,
                                   brm.diet.intercept,
                                   brm.trophic,
                                   brm.diet.habitat,
                                   brm.diet.habitat.year,
                                   brm.diet.habitat.species,
                                   brm.diet.habitat.species.year,
                                   compare = FALSE)
# subset just the model outputs
loos <- compare_original_mods$loos

# create list of the model names
mod_names = c('brm.none',
              'brm.habitat.slope',
              'brm.habitat',
              'brm.habitat.intercept',
              'brm.diet.slope',
              'brm.diet.intercept',
              'brm.trophic',
              'brm.diet.habitat',
              'brm.diet.habitat.year',
              'brm.diet.habitat.species',
              'brm.diet.habitat.species.year')

# set up empty data frames for for loop
df_compare <- data.frame()
df <- data.frame()

# create for loop to fill in the df with the estimates from the loo cv
for (model in 1:11) {

  df <- loos[[model]]$estimates
  df_compare <- rbind(df_compare, df)
}

# make the model names into a dataframe
x <- rep(mod_names, each=3) %>%
  as.data.frame()

# rename the column as mod
names(x) <- "mod"

# bind the row names to the dataframe
df_comp <- df_compare %>%
  rownames_to_column() %>%
  cbind(x)

# remove the numbers from the columns
row_names <- tm::removeNumbers(df_comp$rowname)

# compiled estimates for all of the models
df_comp <- df_comp %>%
  mutate(rowname = row_names) %>%
  group_by(mod) %>%
  pivot_wider(names_from = rowname,
              values_from = c(Estimate, SE))


# Export dataframe to a CSV file
##write.csv(df_comp, file = "original_loo.csv", row.names = FALSE)

##################################################################################################################
################### Run Original Models with Family instead of Species  ###################
##################################################################################################################

# run loo using the original models
compare_fam_mods <- brms::loo(brm.none.fam,
                                   brm.habitat.slope,brm.habitat.fam,
                                   brm.habitat.intercept.fam,
                                   brm.diet.slope.fam,
                                   brm.diet.intercept.fam,
                                   brm.trophic.fam,
                                   brm.diet.habitat.fam,
                                   brm.diet.habitat.year.fam,
                                   brm.diet.habitat.species.fam,
                                   brm.diet.habitat.species.year.fam,
                                   compare = FALSE)
# subset just the model outputs
loos <- compare_fam_mods$loos

# create list of the model names
mod_names = c('brm.none.fam',
              'brm.habitat.slope.fam',
              'brm.habitat.fam',
              'brm.habitat.intercept.fam',
              'brm.diet.slope.fam',
              'brm.diet.intercept.fam',
              'brm.trophic.fam',
              'brm.diet.habitat.fam',
              'brm.diet.habitat.year.fam',
              'brm.diet.habitat.species.fam',
              'brm.diet.habitat.species.year.fam')

# set up empty data frames for for loop
df_compare <- data.frame()
df <- data.frame()

# create for loop to fill in the df with the estimates from the loo cv
for (model in 1:11) {

  df <- loos[[model]]$estimates
  df_compare <- rbind(df_compare, df)
}

# make the model names into a dataframe
x <- rep(mod_names, each=3) %>%
  as.data.frame()

# rename the column as mod
names(x) <- "mod"

# bind the row names to the dataframe
df_comp_fam <- df_compare %>%
  rownames_to_column() %>%
  cbind(x)

# remove the numbers from the columns
row_names <- tm::removeNumbers(df_comp_fam$rowname)

# compiled estimates for all of the models
df_comp_fam <- df_comp_fam %>%
  mutate(rowname = row_names) %>%
  group_by(mod) %>%
  pivot_wider(names_from = rowname,
              values_from = c(Estimate, SE))

# write.csv(df_comp_fam, file = "original_loo_family.csv", row.names = FALSE)


# compare both

# run loo using the original models
compare_mods <- brms::loo(brm.none,
                          brm.habitat.slope,brm.habitat,
                          brm.habitat.intercept,
                          brm.diet.slope,
                          brm.diet.intercept,
                          brm.trophic,
                          brm.diet.habitat,
                          brm.diet.habitat.year,
                          brm.diet.habitat.species,
                          brm.diet.habitat.species.year,
                          brm.diet.habitat.species.fam, # adding family instead of species
                          brm.diet.habitat.species.year.fam,
                          compare = FALSE)

# subset just the model outputs
loos <- compare_mods$loos

# create list of the model names
mod_names = c('brm.none',
              'brm.habitat.slope',
              'brm.habitat',
              'brm.habitat.intercept',
              'brm.diet.slope',
              'brm.diet.intercept',
              'brm.trophic',
              'brm.diet.habitat',
              'brm.diet.habitat.year',
              'brm.diet.habitat.species',
              'brm.diet.habitat.species.year',
              'brm.diet.habitat.species.fam',
              'brm.diet.habitat.species.year.fam')

# set up empty data frames for for loop
df_compare <- data.frame()
df <- data.frame()

# create for loop to fill in the df with the estimates from the loo cv
for (model in 1:13) {

  df <- loos[[model]]$estimates
  df_compare <- rbind(df_compare, df)
}

# make the model names into a dataframe
x <- rep(mod_names, each=3) %>%
  as.data.frame()

# rename the column as mod
names(x) <- "mod"

# bind the row names to the dataframe
df_comp_all <- df_compare %>%
  rownames_to_column() %>%
  cbind(x)

# remove the numbers from the columns
row_names <- tm::removeNumbers(df_comp_all$rowname)

# compiled estimates for all of the models
df_comp_all <- df_comp_all %>%
  mutate(rowname = row_names) %>%
  group_by(mod) %>%
  pivot_wider(names_from = rowname,
              values_from = c(Estimate, SE))

## write.csv(df_comp_all, file = "loo_compare.csv", row.names = FALSE)

# possible approaches
# grop the data by species name
# then do initial split
