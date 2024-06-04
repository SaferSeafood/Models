# Models

## Overview

This repository includes code for models that that will be used by Master of Environmental Data Science students from UCSB's Bren School of Environmental Science & Management to fulfill their capstone project with Scripps Institute of Oceanography and CalCOFI. The analysis and products will include developing spatiotemporal statistical models to predict DDT concentrations in sport fish across Southern California (this repository) which will be then inputted into a public facing online application (Shiny-Dashboard repository) to visualize predicted DDT concentrations for specific fish species.

## About the Data
**Sediment Data**
*Sediment Table*
* A table of sediment data will include year and total concentration of DDT in sediment.

*Sediment Rasters*
* Rasters of sediment DDT concentrations across the Southern California Bight from 2003-2018. Data was collected by the Southern California Bight Regional Monitoring Program and rasters were processed by Lillian McGill.

**DDT Monitoring Data**
* A database of fish DDT monitoring data collected within the Southern California Bight. Fish tissue contaminant data was aggregated from eight different surveys across Southern California collected between 1998 and 2021 (Table S1).

**Species Life History**
* A database of species life history characteristics.

## About the Files
The files in this repository include code to complete the deliverables for the SaferSeafood capstone project for students from the Bren School of Environmental Science & Management to complete the Master of Environmental Data Science degree. All code files exist in the folder called 'code', which has four folders nested within it: data_cleaning, functions, models, and tables. The 'data_cleaning' folder contains a script that includes all necessary data cleaning, and all cleaned data was saved as a data output in the 'data_outputs' folder within the main 'data' folder. The 'models' folder contains files of model testing processes as well as final model workflows. The 'functions' folder stores all scripts of functions created to run the model within our web application, and the 'tables' folder contains the code to output any tables used to compare model performance. Each main folder will contain a corresponding README.md to explain the contents in more detail.

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
>       │ model_performance
> └───code
>       │ data_cleaning
>       │ functions
>       │ models
>       │ tables
