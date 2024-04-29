library(tidymodels)
library(tidyposterior)
library(tidyverse)

#dt <- read_csv(here::here('data', "data_outputs", "loo_compare.csv"))

# run loo using the original models
compare_original_mods <- brms::loo(brm.none,
                                   brm.none.fam,
                                   brm.habitat.slope,
                                   brm.habitat.slope.fam,
                                   brm.habitat,
                                   brm.habitat.fam,
                                   brm.habitat.intercept,
                                   brm.habitat.intercept.fam,
                                   brm.diet.slope,
                                   brm.diet.slope.fam,
                                   brm.diet.intercept,
                                   brm.diet.intercept.fam,
                                   brm.trophic,
                                   brm.trophic.fam,
                                   brm.diet.habitat.fam,
                                   brm.diet.habitat.fam.clean, # non lipid normalized
                                   brm.diet.habitat.year,
                                   brm.diet.habitat.year.fam,
                                   brm.diet.habitat.year.fam.clean, # no species, with family, non lipid normalized
                                   brm.diet.habitat.species.year, # the original model from client with species
                                   brm.diet.habitat.species.year.clean, # the original model with species but non lipid
                                   compare = FALSE)
# subset just the model outputs
loos <- compare_original_mods$loos

# create list of the model names
mod_names = c('brm.none',
              'brm.none.fam',
              'brm.habitat.slope',
              'brm.habitat.slope.fam',
              'brm.habitat',
              'brm.habitat.fam',
              'brm.habitat.intercept',
              'brm.habitat.intercept.fam',
              'brm.diet.slope',
              'brm.diet.slope.fam',
              'brm.diet.intercept',
              'brm.diet.intercept.fam',
              'brm.trophic',
              'brm.trophic.fam',
              'brm.diet.habitat.fam',
              'brm.diet.habitat.fam.clean', # non lipid normalized
              'brm.diet.habitat.year',
              'brm.diet.habitat.year.fam',
              'brm.diet.habitat.year.fam.clean', # no species, with family, non lipid normalized
              'brm.diet.habitat.species.year', # the original model from client with species
              'brm.diet.habitat.species.year.clean')

# set up empty data frames for for loop
df_compare <- data.frame()
df <- data.frame()

# create for loop to fill in the df with the estimates from the loo cv
for (model in 1:21) {

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


R2.results = lapply(X=list(brm.none,
                           brm.none.fam,
                           brm.habitat.slope,
                           brm.habitat.slope.fam,
                           brm.habitat,
                           brm.habitat.fam,
                           brm.habitat.intercept,
                           brm.habitat.intercept.fam,
                           brm.diet.slope,
                           brm.diet.slope.fam,
                           brm.diet.intercept,
                           brm.diet.intercept.fam,
                           brm.trophic,
                           brm.trophic.fam,
                           brm.diet.habitat.fam,
                           brm.diet.habitat.fam.clean, # non lipid normalized
                           brm.diet.habitat.year,
                           brm.diet.habitat.year.fam,
                           brm.diet.habitat.year.fam.clean, # no species, with family, non lipid normalized
                           brm.diet.habitat.species.year, # the original model from client with species
                           brm.diet.habitat.species.year.clean),
                    FUN=bayes_R2)

# convert list of lists into
# dataframe by column
df_r2 <- as.data.frame(do.call(rbind, R2.results))

# rename the column as mod
df_r2$mod <- mod_names

df_comp_est <- df_comp %>%
  left_join(df_r2, by = "mod") %>%
  dplyr::select(mod, Estimate_elpd_loo, Estimate_looic, R2_Estimate = Estimate)
# Export dataframe to a CSV file
##write.csv(df_comp_est, file = "df_comp_est.csv", row.names = FALSE)


# To uderstand the outputs for loo: https://search.r-project.org/CRAN/refmans/loo/html/loo-glossary.html
