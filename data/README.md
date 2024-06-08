# Data

## Overview

This folder organizes the data that is both inputted for the creation of the model as well as the outputted as products of data cleaning. The files in the fish_data and sediment_data folders came from the client and the tidied, combined version of this data in tabular form is found in the data_outputs folder. More information about data output files can be found here: https://doi.org/10.5061/dryad.7pvmcvf2g. 

## The data:
The fish_data folder contains the inputs of fish species information and DDX concentrations, sediment_data has modeled sediment DDT concentrations, and data_outputs has the results of data cleaning which can be found in data_cleaning.R within the code folder. The data_outputs files are what were used to create and test models. 

## Structure 
The structure of this folder is as follows:
> ```
> └───data
>       └───fish_data
>             │fish_life_history.csv
>             │pelagic_nearshore_fish_zones.rds
>             │totalDDT_fish_SouthernCA.csv
>             │totalDDX_fish_metadata.csv
>             │totalDDX_fish_southernCA.csv
>       └───sediment_data
>             │sediment_rasters
>             │totalDDX_sediment_zone_summary.rds
>       └───data_outputs
>             │brm_species_model.rda
>             │ddx_southernCA_lipidnorm.csv
>             │ddx_southernCA_norm.csv
>             │metadata.md
>       
