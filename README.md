# Models

## Overview

This repository includes code for models that that will be used by Master of Environmental Data Science students from UCSB's Bren School of Environmental Science & Management to fulfill their capstone project with Scripps Institute of Oceanography and CalCOFI. The analysis and products will include developing spatiotemporal statistical models to predict DDT concentrations in sport fish across Southern California (this repository) which will be then inputted into a public facing online application (Shiny-Dashboard repository) to visualize predicted DDT concentrations for specific fish species.

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
>
>
## Metadata
Variable	                                  Definition
CompositeCompositeID	                      Unique identifier for each fish composite
TotalDDT	                                  Average DDX (summed DDT, DDD, and DDE values) for each composite in ng/g tissue wet weight 
TotalDDT.lipid	                            Average lipid normalized DDX (summed DDT, DDD, and DDE values) for each composite in ng/g lipid weight 
MDL.mean	                                  Average Method Detection Limit across the six DDX analytes 
MDL.min	                                    Minimum Method Detection Limit across the six DDX analytes 
Lipid                                       Lipid content of each composite (in g Lipid/ g tissue wet weight) 
CompositeCommonName	Common name for each fish species
CompositeTissuePrep	How composite tissue was prepared for analysis 
NumberFishPerComp	Number of fish that were pooled for a composite 
CompositeTissueName	Tissue type. Whether whole fish or fillets were used. 
WeightAvg.g	Average weight of each fish within a composite 
TLMin.mm	Length of the smallest fish within a composite 
TLMax.mm	Length of the lagest fish within a composite 
TLAvgLength.mm	Average length of each fish within a composite 
SexSummary	Summary of males and female fish within a composite 
Program	Program each composite is originally from. See the proposal and manuscript for details of each program. 
Year	Year of collection for each composite. 
Region	Broad region of capture for each fish. 
CompositeStationArea	Fishing zone for each composite. This links sediment and fish data together, given that fish capture location is often not precisely known. Zone boundaries can be found in the pelagic_nearshoe_fish_zones.rds file
	<img width="1088" alt="image" src="https://github.com/SaferSeafood/Models/assets/121061044/7cb98d0c-4e47-4cee-b75a-d41c1aebdb9d">
