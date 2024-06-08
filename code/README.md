# Code
## Overview
The files in this folder contain work to update and validate our client's model. Each document contains the workflow for model analysis, and the final model can be found in brms_workflow.Rmd

## About the files
*brms_workflow.Rmd*

The model was created by taking the client’s exact model structure but switching out the DDT concentration variable to the one that was appropriately transformed for this project (non lipid-normalized as opposed to lipid-normalized). As the clients had used the brms package to create their models and used the loo package to perform LOO cross-validation, the initial approach was to use the brms format to create the models and use LOO cross-validation to determine the best performing model (choose model with highest elpd). Each model was created using the brm() function, and the formulas for the models that were tested were the same as the client’s original model testing (found in client_models.R), however, the DDT concentrations were non lipid-normalized as opposed to their lipid-normalized DDT concentrations. The LOO() function was used to test model performance. The best model was chosen using LOOIC (leave one out information criterion) which showed that the best updated model formula used the same predictors as the client’s best-performing model. After testing the updated model with the best performance, this model was compared against the client’s original model using LOO cross-validation scores. The updated model had a slightly higher LOOIC value than the original model but was still the highest performing compared to all of the other updated models. 
Because this model was used to predict DDT concentration in fish for data points, and potentially species, that were not included in the original dataset, the model was tested again with species removed as a predictor. This model performance was also tested using LOO cross-validation, and the results were compared against the best original and updated models. Removing species as a predictor caused a decrease in model performance, so it was added back into the model. However, to further test the generalizability of out-of-sample data, the model was also tested by: updating the formula to include family instead of species, running LOO cross-validation, and comparing the results to the original and updated models. This model also did not perform as well as the original model, but it performed better than the model that completely removed species. The final model used in this project included all original parameters used by the client: trophic level, feeding position, species, year, and sediment DDT concentration. This model was saved in the object called ‘brm.diet.habitat.species.year.non’ and can be found in the ‘brms_workflow.Rmd file’ and was also saved to ‘brm_species_model.rda’ in the ‘data_outputs’ folder within the ‘data’ folder. 

*tidymodels_workflow.Rmd*

To evaluate the robustness and predictive power from the models using brms and LOO, the model was run through a machine learning approach in the tidymodels package, in which the data was split into a training set and a testing set. The training set is 70% of the data while the testing set is 30% of the data and is left out of all of the model fitting processes. To apply Bayesian statistics to the model, the extension package multilevelmod was used in the tidymodels workflow. The same formula and priors as the brms models were used in the machine learning testing. With tidymodels, a model specification and workflow were set, and this workflow was used to fit the training data to the model. The model fit with the training data was then used to make predictions on the testing data. The performance of the model was determined using the R-squared and RMSE values because LOO CV was not used in this process. The R-squared value was used to compare predictive power to the models that were fit using brms. The R-squared value was similar for both methods using brms and tidymodels, confirming the model performance.

*feature_selection.Rmd*

To add to the machine learning process, the projpred package was used to understand whether all predictors in the final model were useful and the model was not overfitted. The results of this process suggested that the interacting variables may be slightly less important for the model and lead to potential overfitting. To double check these results, the interacting variables were removed from the tidymodels workflow to determine whether the model performs better without these variables. However, the model with all predictors present had a higher predictive power than the new model without interacting predictors, based on the R2 value, further confirming the decision of using the client’s original model formula.


## Structure
The structure of this folder is as follows 

> ```
> └───code
>       └───data_cleaning
>             │data_cleaning.R
>       └───models
>             │BRMS_testing.Rmd
>             │client_models.R
>             │feature_selection.Rmd
>             │tidymodels_testing.Rmd
