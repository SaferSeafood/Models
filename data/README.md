# Data

## Overview

This folder organizes the data that is both inputted for the creation of the model as well as the outputted as products of data cleaning. The files in the fish_data and sediment_data folders came from the client and the tidied, combined version of this data in tabular form is found in the data_outputs folder. More information about data output files can be found here: https://doi.org/10.5061/dryad.7pvmcvf2g. 

The fish_data folder contains the inputs of fish species information and DDX concentrations, sediment_data has modeled sediment DDT concentrations, and data_outputs has the results of data cleaning which can be found in data_cleaning.R within the code folder. The data_outputs files are what were used to create and test models. 

## About the Input Data
**Sediment Data**
*Sediment Table*
* A table of sediment data will include year and total concentration of DDT in sediment.

*Sediment Rasters*
* Rasters of sediment DDT concentrations across the Southern California Bight from 2003-2018. Data was collected by the Southern California Bight Regional Monitoring Program and rasters were processed by Lillian McGill.

**DDT Monitoring Data**
* A database of fish DDT monitoring data collected within the Southern California Bight. Fish tissue contaminant data was aggregated from eight different surveys across Southern California collected between 1998 and 2021 (Table S1).

**Species Life History**
* A database of species life history characteristics.

**Methods of data collection**

The data was compiled from researchers at the Scripps Institution of Oceanography from previously collected fish and sediment contaminant monitoring data from 1998 through 2021. The data came from the following sources: Southern California Bight Regional Monitoring Program, SWAMP Statewide Coastal Screening Survey, SWAMP Coastal Fish Contamination Program, Jarvis et al. 2007, McLaughlin et al. 2021, Southern California Coastal Marine Fish Contaminants Survey, LA County Sanitation District Local Trends Assessment, LA County Sanitation District Seafood Safety Assessment, and City of San Diego POTW Monitoring. This data focuses on the Southern California Bight. The sediment samples were collected via grab samples of top 5 cm at embayment sites and top 2 cm at offshore sites in 2003, 2008, 2013, and 2018. Fish tissue samples were collected off piers and boats, and composites consisted of 5-10 specimens and included only single species per composite. The data was subset to include only sediment and fish samples that explicitly measured DDX (2,4′-DDE, 4,4′-DDE, 2,4′-DDD, 4,4′-DDD, 2,4′-DDT, and 4,4′-DDT). Each species was assigned diet and habitat, and composites were assigned to fishing zones. The DDT concentrations, both lipid-normalized and non lipid-normalized was normalized, and the sediment DDT concentrations were also normalized.

## Structure 
The structure of this folder is as follows:
> ```
> └───data
>       │  README.md
>       └───fish_data
>             │  fish_life_history.csv
>             │  pelagic_nearshore_fish_zones.rds
>             │  totalDDT_fish_SouthernCA.csv
>             │  totalDDX_fish_metadata.csv
>             │  totalDDX_fish_southernCA.csv
>       └───sediment_data
>             │  sediment_rasters
>             │  totalDDX_sediment_zone_summary.rds
>       └───data_outputs
>             │  brm_species_model.rda
>             │  ddx_southernCA_lipidnorm.csv
>             │  ddx_southernCA_norm.csv
>             │  metadata.md
>       
