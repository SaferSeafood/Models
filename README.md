# SaferSeafood

## Overview

This is the main repository that will be used by Master of Environmental Data Science students from UCSB's Bren School of Environmental Science & Management to fulfill their capstone project with Scripps Institute of Oceanography and CalCOFI. The analysis and products will include developing spatiotemporal statistical models to predict DDT concentrations in sport fish across Southern California and creating a public facing online application to visualize predicted DDT concentrations for specific fish species. 

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
The files in this repository include code for EDS 411A that fulfill academic requirements and modeling for client deliverables. All code files exist in the folder called 'code_files', which has two folders nested within it. The '411A_files' folder contains files that have been created for analysis within academic requirements, and the 'models' folder contains the models the client provided as well as model updates the team is undertaking. Each member of the team will have a separate .rmd file in this folder that will serve as individual practice/ideas for model updates and proceeding with this project.

## Structure 
The structure of the repo is as follows:
> ```
> SaferSeafood
> │   README.md
> │   SaferSeafood.Rproj
> │  .gitignore
> └───data
>       │ fish_data
>       │ sediment_data
>       │ data_outputs
> └───code_files
>       │ 411A_files
>       │ models
