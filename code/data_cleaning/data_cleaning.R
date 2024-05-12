# Data cleaning script
# This script contains the code to compile necessary data for modeling into two different dataframes/.csv files
# fish.reg and fish_clean_ORIGINAL.csv contain data for our client's original model with lipid-normalized DDT data
# fish_reg and fish_clean.csv contain data with non lipid-normalized DDT data
# fish_clean_ORIGINAL_fam.csv and fish_clean_fam.csv have family and genus added to the df

library(tidyverse)
library(rfishbase)

#####################################
# ---- Client data cleaning code ----
#####################################

# Read in sediment data
sediment.summary = readRDS(here::here("data","sediment_data","totalDDX_sediment_zone_summary.rds")) %>%
  dplyr::select(Name, Est.2003, Est.2008, Est.2013, Est.2018) %>%
  gather(key="Year",value="TotalDDT",Est.2003:Est.2018) %>%
  dplyr::mutate(Year = case_when(Year == "Est.2003" ~ "2003",
                                 Year == "Est.2008" ~ "2008",
                                 Year == "Est.2013" ~ "2013",
                                 Year == "Est.2018" ~ "2018")) %>%
  dplyr::group_by(Name, Year) %>%
  dplyr::summarize(TotalDDT.sed = (mean((TotalDDT)))) %>%
  dplyr::ungroup()

# Read in fish life history
fish.lh = read.csv(here::here("data","fish_data","fish_life_history.csv")) %>%
  dplyr::mutate(species = tolower(species))

# Read in fish data, and join with sediments
fish.reg = read.csv(here::here("data","fish_data","totalDDX_fish_southernCA.csv")) %>% # Read in fish DDT values
  # We have sediment data blocked off by 2003, 2008, 2013, and 2018. Figure out what (continous) fish years go with which sediment years.
  dplyr::mutate(NewYear = case_when(Year %in% c(1995:2005) ~ "2003",
                                    Year %in% c(2006:2010) ~ "2008",
                                    Year %in% c(2011:2015) ~ "2013",
                                    Year %in% c(2016:2022) ~ "2018")) %>%
  left_join(., sediment.summary, by=c("CompositeStationArea"="Name", "NewYear"="Year")) %>%
  dplyr::left_join(., fish.lh, by=c("CompositeCommonName"="species")) %>%
  dplyr::mutate(feeding_position = case_when(feeding_position == "pelagic" ~ "Pelagic",
                                             feeding_position == "midwater" ~ "Midwater",
                                             feeding_position == "benthopelagic " ~ "Benthopelagic",
                                             feeding_position == "benthic" ~ "Benthic",
                                             TRUE ~ feeding_position)) %>%
  dplyr::mutate(feeding_position = factor(feeding_position, levels=c("Pelagic","Midwater","Benthopelagic","Benthic"))) %>%
  dplyr::mutate(trophic_category = case_when(trophic_category == "herbivore" ~ "Herbivore",
                                             trophic_category == "primary_carnivore" ~ "Primary Carnivore",
                                             trophic_category == "secondary_carnivore" ~ "Secondary Carnivore",
                                             trophic_category == "tertiary_carnivore" ~ "Tertiary Carnivore"))

# Add transformed columns (TotalDDT.lipid is already normalized by Lipid for fish)
fish.reg$TotalDDT.trans = log(fish.reg$TotalDDT.lipid + 1)
fish.reg$TotalDDT.sed.trans = log(fish.reg$TotalDDT.sed + 1)

# Add censoring for values equal to zero (so value is constrained to fall between zero and MDL)
fish.reg = fish.reg %>%
  dplyr::mutate(Censored = ifelse(TotalDDT.trans == 0, "interval","none"),
                Detection.Limit = ifelse(is.na(MDL.min), 0.5,log1p(MDL.min/Lipid))) %>%
  dplyr::mutate(Year = Year - 1998) # We want to use years since 1998

# save this dataframe as a .csv file
# write.csv(fish.reg, here::here("data", "data_outputs", "fish_clean_ORIGINAL.csv")

##################################################################
# ---- Updated Data Cleaning (with non-lipid normalized data) ----
##################################################################

# Read in sediment data
sediment_summary = readRDS(here::here("data","sediment_data","totalDDX_sediment_zone_summary.rds")) %>%
  dplyr::select(Name, Est.2003, Est.2008, Est.2013, Est.2018) %>%
  gather(key="Year",value="TotalDDT",Est.2003:Est.2018) %>%
  dplyr::mutate(Year = case_when(Year == "Est.2003" ~ "2003",
                                 Year == "Est.2008" ~ "2008",
                                 Year == "Est.2013" ~ "2013",
                                 Year == "Est.2018" ~ "2018")) %>%
  dplyr::group_by(Name, Year) %>%
  dplyr::summarize(TotalDDT.sed = (mean((TotalDDT)))) %>%
  dplyr::ungroup()

# Read in fish life history
fish_lh = read.csv(here::here("data","fish_data","fish_life_history.csv")) %>%
  dplyr::mutate(species = tolower(species))

# select the long and latitude
fish_location = read.csv(here::here("data","fish_data","totalDDT_fish_southernCA.csv")) %>%
  dplyr::select(CompositeCompositeID, CompositeTargetLatitude, CompositeTargetLongitude)

# Read in fish data, and join with sediments
fish_reg = read.csv(here::here("data","fish_data","totalDDX_fish_southernCA.csv")) %>% # Read in fish DDT values
  # We have sediment data blocked off by 2003, 2008, 2013, and 2018. Figure out what (continous) fish years go with which sediment years.
  dplyr::mutate(NewYear = case_when(Year %in% c(1995:2005) ~ "2003",
                                    Year %in% c(2006:2010) ~ "2008",
                                    Year %in% c(2011:2015) ~ "2013",
                                    Year %in% c(2016:2022) ~ "2018")) %>%
  left_join(., fish_location) %>%
  left_join(., sediment_summary, by=c("CompositeStationArea"="Name",
                                      "NewYear"="Year")) %>%
  dplyr::left_join(., fish_lh, by=c("CompositeCommonName"="species")) %>%
  dplyr::mutate(feeding_position = case_when(feeding_position == "pelagic" ~ "Pelagic",
                                             feeding_position == "midwater" ~ "Midwater",
                                             feeding_position == "benthopelagic " ~ "Benthopelagic",
                                             feeding_position == "benthic" ~ "Benthic",
                                             TRUE ~ feeding_position)) %>%
  dplyr::mutate(feeding_position = factor(feeding_position, levels=c("Pelagic","Midwater","Benthopelagic","Benthic"))) %>%
  dplyr::mutate(trophic_category = case_when(trophic_category == "herbivore" ~ "Herbivore",
                                             trophic_category == "primary_carnivore" ~ "Primary Carnivore",
                                             trophic_category == "secondary_carnivore" ~ "Secondary Carnivore",
                                             trophic_category == "tertiary_carnivore" ~ "Tertiary Carnivore"))

# Add transformed columns (TotalDDT which is non-lipid normalized for fish)
fish_reg$TotalDDT.trans.non = log(fish_reg$TotalDDT + 1) # add + 1 to account for 0 values
fish_reg$TotalDDT.sed.trans = log(fish_reg$TotalDDT.sed + 1)

# Add censoring for values equal to zero (so value is constrained to fall between zero and MDL)
fish_reg = fish_reg %>%
  dplyr::mutate(Censored = ifelse(TotalDDT.trans.non == 0, "interval","none"),

                # ask about this limit since its divided by Lipid
                Detection.Limit = ifelse(is.na(MDL.min),
                                         0.5, # if MDL.min is an NA value fill with this value
                                         log1p(MDL.min))) %>%

  dplyr::mutate(Year = Year - 1998) # We want to use years since 1998

# save this dataframe as a .csv file
# write.csv(fish_reg, here::here("data", "data_outputs", "fish_clean.csv")

########################################
# ---- Adding Family to the dataset ----
########################################

# get the unique species names - should be 61
species_name <- unique(fish_clean$scientific_name)

# look at the list of species using the names - these are different sizes
species_info <- species(species_list = species_name)

# Comparing the number of fish in the fish_clean and the fish_lh
fish_clean_names <- as.data.frame(unique(fish_clean$scientific_name)) %>%
  mutate(species = `unique(fish_clean$scientific_name)`) %>%
  dplyr::select('species')

# update the names of the fish to match fishbase
species_name_clean <- as.data.frame(species_name) %>%
  dplyr::mutate(species_name = case_when(species_name == "Embiotica jacksoni" ~ "Embiotoca jacksoni",
                                         species_name ==  "Rhinobatos productus" ~ "Pseudobatos productus",
                                         TRUE ~ species_name))

# look at the taxa of the fish
taxa <- rfishbase::load_taxa()

# filter the taxa based on name
taxa_filter <- taxa %>%
  filter(Species %in% species_name_clean$species_name) %>%
  dplyr::select(scientific_name = Species, Family, Genus)

fish_clean_test <- fish_clean %>%
  left_join(taxa_filter, by = "scientific_name")

species_common_science <- fish_clean_test %>%
  dplyr::select(CompositeCommonName, scientific_name, Family, trophic_category, feeding_position) %>%
  distinct()

# save the file as a data output
#write.csv(species_common_science, here::here("data/data_outputs/species_common_science.csv"))

# add the family and genus to the dataframe
fish.reg.fam <- fish_clean_original %>%
  dplyr::mutate(scientific_name = case_when(scientific_name == "Embiotica jacksoni" ~ "Embiotoca jacksoni",
                                            scientific_name ==  "Rhinobatos productus" ~ "Pseudobatos productus",
                                            TRUE ~ scientific_name)) %>%
  left_join(taxa_filter, by = "scientific_name") %>%
  dplyr::mutate(Family = ifelse(scientific_name == "Doryteuthis opalescens",
                                "Loliginidae",
                                Family))

# save the file as a data output
#write.csv(fish.reg.fam, here::here("data/data_outputs/fish_clean_ORIGINAL_fam.csv"))

# add the family and genus to the dataframe
fish.clean.fam <- fish_clean %>%
  dplyr::mutate(scientific_name = case_when(scientific_name == "Embiotica jacksoni" ~ "Embiotoca jacksoni",
                                            scientific_name ==  "Rhinobatos productus" ~ "Pseudobatos productus",
                                            TRUE ~ scientific_name)) %>%
  left_join(taxa_filter, by = "scientific_name") %>%
  dplyr::mutate(Family = ifelse(scientific_name == "Doryteuthis opalescens",
                                "Loliginidae",
                                Family))

# save the file as a data output
#write.csv(fish.clean.fam, here::here("data/data_outputs/fish_clean_fam.csv"))
