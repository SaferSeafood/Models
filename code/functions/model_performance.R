#' Model Performance
#'
#' @param model_name
#' @param data_frame
#'
#' @return a dataframe with MAE, RSquared, and RMSE values along with the model name
#' @export
#'
#' @examples
#' test_fun <- model_performance(brm_fam_fit2, fish.clean.fam)

model_performance <- function(model_name, data_frame) {

  # initialize an empty dataframe
  df <- data.frame()


  # define the model - this is the one that uses family instead of species
  model <- model_name

  for (group in 1:nrow(species_name_clean)) {
    test <- data_frame %>% # data frame: either clean or fam
      filter(scientific_name %in% species_name_clean[group, 1])

    train <- data_frame %>%
      filter(!scientific_name %in% species_name_clean[group, 1]) # remove the species

    # refit the model


    # predict using other workflow
    predictions <- predict(fit_model, train) %>% #get prediction probabilities for test data
      bind_cols(train)

    # print RMSE, R2 and MAE values
    coef_df <- data.frame(estimate = postResample(predictions$.pred, train$TotalDDT.trans.non),
                          groups = group)

    df <- rbind(df, coef_df)

  }

  df <- rownames_to_column(df)

  # extract the name of the model
  name <- deparse(substitute(model_name))

  # makes the data frame of how well the model predicted the values
  df_means <- df %>%
    mutate(value = gsub('[[:digit:]]+', '', rowname)) %>%
    dplyr::select(value, estimate) %>%
    dplyr::group_by(value) %>%
    pivot_wider(names_from = value,
                values_from = estimate) %>%
    unnest(cols = 1:3) %>% # undo the list of lists
    summarize_each(mean) %>%  # get the mean values
    mutate(model = name) # add the model name as a string

  return(df_means)

}
