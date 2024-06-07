This README.txt file was generated on 2024-05-22 by Kate Becker, Hope Hahn, Luna Herschenfeld-Catalan, Ben Versteeg 

**GENERAL INFORMATION**
1. **Title of the Project:**

Improving Access to Fish Consumption Advisories and Maintaining Confidence in California's Healthy Seafood Product

2. **Author Information:**

This project was completed by a group of graduate students at the Bren School of Environmental Science & Management, UC Santa Barbara. Team members include Hope Hahn, Luna Herschenfeld-Catalán, Benjamin Versteeg, and Kate Becker with guidance from our Faculty Advisor Bruce Kendall and Capstone Advisor Carmen Galaz-García.

Principal Investigator Contact Information - 
Name: Lillian McGill
Institution: Scripps Institution of Oceanography, UCSD
Address: 9500 Gilman Drive # 0202, La Jolla, CA 92093-0202
Email:lmmcgill@ucsd.edu

Associate or Co-investigator Contact Information - 
Name: Erin Swatterwaite
Institution: UC San Diego - Scripps Institution of Oceanography; California Sea Grant & CalCOFI
Address: 9500 Gilman Dr., La Jolla, CA 92093-0232
Email: esatterthwaite@ucsd.edu

Alternate Contact Information - Name: Institution: Address: Email:
Name: Brice Semmens
Institution: Scripps Institution of Oceanography, UCSD; CalCOFI
Address: 9500 Gilman Drive La Jolla CA, 92093-0202
Email: bsemmens@ucsd.edu

3. **Date of data collection or obtaining (single date, range, approximate date):**

Sediment Data: 2003-07-01  to 2003-09-30, 2008-07-01  to 2008-09-30, 2013-07-01  to 2013-09-30, 2018-07-01  to 2018-09-30
Species Life History Characteristics Data: NA
Fish Tissue Data: At varying temporal increments from 1998-01-01 to 2021-12-31

4. **Geographic location of data collection:**

Sediment and fish data were collected at one of the 25 specified nearshore 256km^2 fishing blocks from the US - Mexico border northwards to Point Conceptions. A series of fish and sediment data collection programs characterized their spatial extent as “Point Conception CA to US-Mexico border”, “Coastal CA, filtered to SCB”, “Coastal CA  filtered to only SCB”, “ pelagic SCB”, “ SCB”,  “Palos Verdes, Santa Monica Bay, and San Pedro Bay regions”, “Adjacent to Palos Verdes”, or “Adjacent to Point Loma and South Bay outfall”. 

5. **Information about funding sources that supported the collection of the data:**

The collection of this data was supported by grant money provided by the Moore Foundation and the National Science Foundation Graduate Research Fellowship Program. 

**SHARING/ACCESS INFORMATION**
1. **Licenses/restrictions placed on the data:**

Creative Commons Attribution 4.0 International License

2. Links to publications that cite or use the data: - https://github.com/lmcgill/FishDDTApp/blob/main/documents/Historical%20DDT%20Reanalysis%20Paper_SecondDraft_Revised_3Jan2024.pdf 

3. **Links to other publicly accessible locations of the data:**

Sediment data: https://bight.sccwrp.org/ 
Tissue data: https://waterboards.ca.gov/water_issues/programs/swamp/coast_study.html 
Fishing zone polygons: https://github.com/lmcgill/FishDDTApp/blob/main/data/sediment_data/totalDDX_sediment_zone_summary.rds 

4. **Links/relationships to ancillary data sets:**

Paper with table that has the data sources for each data set used in the study: Table S1 https://github.com/lmcgill/FishDDTApp/blob/main/documents/DDT%20Fish%20-%20MEDS%202024%20Proposal.pdf 

5. **Was data derived from another source? If yes, list source(s):** 

Southern California Bight Regional Monitoring Program, SWAMP Statewide Coastal Screening Survey, SWAMP Coastal Fish Contamination Program, Jarvis et al. 2007, McLaughlin et al. 2021, Southern California Coastal Marine Fish Contaminants Survey, LA County Sanitation District Local Trends Assessment, LA County Sanitation District Seafood Safety Assessment, and City of San Diego POTW Monitoring

6. **Recommended citation for the project:** 

Hahn, Hope; Becker, Kate; Herschenfeld-Catalan, Luna; Versteeg, Benjamin (2024). DDX Concentrations in Fish Tissue and Sediment from the Southern California Bight [Dataset]. Dryad. https://doi.org/10.5061/dryad.7pvmcvf2g

**DATA & FILE OVERVIEW**

1. **File List:**

ddx_southernCA_norm.csv - contains ddt data for 61 species, as well as life history characteristics, of fish in Southern California. The fish composite transformations are normalized.
ddx_southernCA_lipidnorm.csv - contains ddt data for 61 species, as well as life history characteristics, of fish in Southern California. The fish composite transformations are lipid-normalized.

2. **Relationship between files, if important:**

Files have the same variables, but main variables of interest but TotalDDT values went through different transformations. ddx_southernCA_norm.csv includes DDT transformations that are normalized (without basing off lipids), and ddx_southernCA_lipidnorm.csv include DDT transformations that are lipid-normalized.

3. **Additional related data collected that was not included in the current data package:**

None

4. **Are there multiple versions of the dataset?**

No

**METHODOLOGICAL INFORMATION**
1. **Description of methods used for collection/generation of data:** 

The data was compiled from researchers at the Scripps Institution of Oceanography from previously collected fish and sediment contaminant monitoring data from 1998 through 2021. The data came from the following sources: Southern California Bight Regional Monitoring Program, SWAMP Statewide Coastal Screening Survey, SWAMP Coastal Fish Contamination Program, Jarvis et al. 2007, McLaughlin et al. 2021, Southern California Coastal Marine Fish Contaminants Survey, LA County Sanitation District Local Trends Assessment, LA County Sanitation District Seafood Safety Assessment, and City of San Diego POTW Monitoring. This data focuses on the Southern California Bight. The sediment samples were collected via grab samples of top 5 cm at embayment sites and top 2 cm at offshore sites in 2003, 2008, 2013, and 2018. Fish tissue samples were collected off piers and boats, and composites consisted of 5-10 specimens and included only single species per composite. The data was subset to include only sediment and fish samples that explicitly measured DDX (2,4′-DDE, 4,4′-DDE, 2,4′-DDD, 4,4′-DDD, 2,4′-DDT, and 4,4′-DDT). Each species was assigned diet and habitat, and composites were assigned to fishing zones. The DDT concentrations, both lipid-normalized and non lipid-normalized was normalized, and the sediment DDT concentrations were also normalized.

2. **Methods for processing the data:**

The raw data underwent several processing steps, including data cleaning, joining datasets, and normalization transformations.

3. **Instrument- or software-specific information needed to interpret the data:**

The data analysis and modeling were performed using R software in version 4.4.0. 

4. **Standards and calibration information, if appropriate:**

The sediment data included test site specifics and fishing zone averaged DDT concentrations. Fishing zone averages were generated to be used as covariates in a model of fish bioaccumulation. - Normalizing the lipid data was performed due to the positive relationship between lipid content and organic contaminant concentration in fish tissue .

5. **Environmental/experimental conditions:**

Sediment Sampling: Conducted at various sites along the California coast between 2003 and 2018.
Fish Sampling: Conducted across different years from 1998 to 2021, covering multiple species and fishing zones.
Field Conditions: Samples were taken from nearshore southern California waters, specifically targeting areas impacted by DDT dumping

6. **Describe any quality-assurance procedures performed on the data:**

The data was compiled by researchers at the Scripps Institution of Oceanography and CalCOFI, and all laboratories that analyzed the sediment and fish data were subject to a common set of rigorous quality assurance and quality control (QA/QC) guidelines to ensure comparability (Du et al. 2020, McLaughlin et al. 2020).

7. **People involved with sample collection, processing, analysis and/or submission:**

Lillian McGill from the Scripps Institution of Oceanography was involved in the original organization of data. Ben Versteeg, Hope Hahn, Kate Becker, and Luna Herschenfeld-Catalán were involved in further data processing and analysis. 

**DATA-SPECIFIC INFORMATION FOR:**

[ddx_southernCA_norm.csv]
1. **Number of variables:** 33

2. **Number of cases/rows:** 1103

3. **Variable List:**
CompositeCompositeID: Unique identifier for each fish composite
TotalDDT: Average DDX (summed DDT, DDD, and DDE values) for each composite in ng/g tissue wet weight
TotalDDT.lipid: Average lipid normalized DDX (summed DDT, DDD, and DDE values) for each composite in ng/g lipid weight
Lipid: Lipid content of each composite (in g Lipid/ g tissue wet weight)
CompositeCommonName: Common name for each fish species
Year: Year of collection for each composite. (Represented by single number)
MDL.mean: Average Method Detection Limit across the six DDX analytes
MDL.min: Minimum Method Detection Limit across the six DDX analytes
CompositeTissuePrep: How composite tissue was prepared for analysis
NumberFishPerComp: Number of fish that were pooled for a composite
CompositeTissueName: Tissue type. Whether whole fish or fillets were used.
WeightAvg.g: Average weight of each fish within a composite
TLMin.mm: Length of the smallest fish within a composite
TLMax.mm: Length of the largest fish within a composite
TLAvgLength.mm: Average length of each fish within a composite
SexSummary: Summary of males and female fish within a composite
Program: Program each composite is originally from. See the proposal and manuscript for details of each program.
CompositeStationArea: Fishing zone for each composite. This links sediment and fish data together, given that fish capture location is often not precisely known. Zone boundaries can be found in the pelagic_nearshoe_fish_zones.rds file
Region: Broad region of capture for each fish.
CompositeTargetLatitude: Latitude of composite
CompositeTargetLongitude: Longitude of composite
scientific_name: genus and species of composite
trophic_level: Numeric level of fish trophic level.
tropic_category: Trophic level of fish.
feeding_position: Water column position in which the fish feeds.
TotalDDT.trans.non: Average normalized DDX (summed DDT, DDD, and DDE values) for each composite in ng/g tissue wet weight
TotalDDT.sed.trans: Average normalized DDX values in sediment.
Censored: is “interval” if TotalDDT.trans is 0, “none” if not.
Detection.Limit: 0.5 if MDL.min is NA, otherwise the natural log of MDL.min/Lipid plus 1
Family: Scientific family of composite species
Genus: Genus of composite species

4. **Missing data codes:**

NA - no recorded data

5. **Specialized formats or other abbreviations used:**

None

[ddx_southernCA_lipidnorm.csv]

1. **Number of variables:** 33 

2. **Number of cases/rows:** 1103

3. **Variable List:**
CompositeCompositeID: Unique identifier for each fish composite
TotalDDT: Average DDX (summed DDT, DDD, and DDE values) for each composite in ng/g tissue wet weight
TotalDDT.lipid: Average lipid normalized DDX (summed DDT, DDD, and DDE values) for each composite in ng/g lipid weight
Lipid: Lipid content of each composite (in g Lipid/ g tissue wet weight)
CompositeCommonName: Common name for each fish species
Year: Year of collection for each composite. (Represented by single number)
MDL.mean: Average Method Detection Limit across the six DDX analytes
MDL.min: Minimum Method Detection Limit across the six DDX analytes
CompositeTissuePrep: How composite tissue was prepared for analysis
NumberFishPerComp: Number of fish that were pooled for a composite
CompositeTissueName: Tissue type. Whether whole fish or fillets were used.
WeightAvg.g: Average weight of each fish within a composite
TLMin.mm: Length of the smallest fish within a composite
TLMax.mm: Length of the largest fish within a composite
TLAvgLength.mm: Average length of each fish within a composite
SexSummary: Summary of males and female fish within a composite
Program: Program each composite is originally from. See the proposal and manuscript for details of each program.
CompositeStationArea: Fishing zone for each composite. This links sediment and fish data together, given that fish capture location is often not precisely known. Zone boundaries can be found in the pelagic_nearshoe_fish_zones.rds file
Region: Broad region of capture for each fish.
CompositeTargetLatitude: Latitude of composite
CompositeTargetLongitude: Longitude of composite
scientific_name: genus and species of composite
trophic_level: Numeric level of fish trophic level.
tropic_category: Trophic level of fish.
feeding_position: Water column position in which the fish feeds.
TotalDDT.trans: TotalDDT.lipid column normalized
TotalDDT.sed.trans: Average normalized DDX values in sediment.
Censored: is “interval” if TotalDDT.trans is 0, “none” if not.
Detection.Limit: 0.5 if MDL.min is NA, otherwise the natural log of MDL.min/Lipid plus 1
Family: Scientific family of composite species
Genus: Genus of composite species

4. **Missing data codes:** 

NA - no recorded data

5. **Specialized formats or other abbreviations used:**

None