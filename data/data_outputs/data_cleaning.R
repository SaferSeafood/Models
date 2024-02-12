##################################################################################################################
################### Load and Install Packages   ###################
##################################################################################################################
if("pacman" %in% installed.packages() == FALSE){install.packages("pacman")}
pacman::p_load(geojsonR, factoextra,sf,dplyr, ggplot2, maps, fields,raster,
               MuMIn, lubridate, tidyr,ggh4x, lme4,sdmTMB,inlabru,cowplot,marmap,sjPlot, tidyverse, plyr, tidybayes, brms, bayesplot, loo,ggeffects,
               DHARMa)


##################################################################################################################
################### Load in data and add censoring column   ###################
##################################################################################################################

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

##################################################################################################################
################### Load in ORIGINAL data and add censoring column   ###################
##################################################################################################################

# Read in sediment data
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

# Add transformed columns (TotalDDT.lipid is already normalized by Lipid for fish)
fish.reg$TotalDDT.trans = log(fish.reg$TotalDDT.lipid + 1)
fish.reg$TotalDDT.sed.trans = log(fish.reg$TotalDDT.sed + 1)

# Add censoring for values equal to zero (so value is constrained to fall between zero and MDL)
fish.reg = fish.reg %>%
  dplyr::mutate(Censored = ifelse(TotalDDT.trans == 0, "interval","none"),
                Detection.Limit = ifelse(is.na(MDL.min), 0.5,log1p(MDL.min/Lipid))) %>%
  dplyr::mutate(Year = Year - 1998) # We want to use years since 1998


##################################################################################################################
################### Export to .csv file  ###################
##################################################################################################################

write.csv(fish_reg, "/Users/lunacatalan/Documents/dev/capstone/SaferSeafood/data/fish_clean.csv", row.names=FALSE)

write.csv(fish.reg, "/Users/lunacatalan/Documents/dev/capstone/SaferSeafood/data/fish_clean_ORIGINAL.csv", row.names=FALSE)
