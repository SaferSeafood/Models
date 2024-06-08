# Models

## Overview

This repository includes code for models that that will be used by Master of Environmental Data Science students from UCSB's Bren School of Environmental Science & Management to fulfill their capstone project with Scripps Institute of Oceanography and CalCOFI. The analysis and products will include developing spatiotemporal statistical models to predict DDT concentrations in sport fish across Southern California (this repository) which will be then inputted into a public facing online application (Shiny-Dashboard repository) to visualize predicted DDT concentrations for specific fish species.

Each folder has its own README.md to describe the files in more detail.

## About the Files

The files in this repository include code to complete the deliverables for the SaferSeafood capstone project for students from the Bren School of Environmental Science & Management to complete the Master of Environmental Data Science degree. All code files exist in the folder called 'code', which has two folders nested within it: data_cleaning and models. The 'data_cleaning' folder contains a script that includes all necessary data cleaning, and all cleaned data was saved as a data output in the 'data_outputs' folder within the main 'data' folder. The 'models' folder contains files of model testing processes as well as final model workflows. Each main folder will contain a corresponding README.md to explain the contents in more detail.

## Structure 

The structure of the repo is as follows:

> ```
> Models
> │   README.md
> │   Models.Rproj
> │  .gitignore
> │   session_info.txt
> └───data
>       │ fish_data
>       │ sediment_data
>       │ data_outputs
> └───code
>       │ data_cleaning
>       │ models
