## Regress fish [DDT] against sediment [DDT]

# install and/or load the necessary R packages
if("pacman" %in% installed.packages() == FALSE){install.packages("pacman")}
pacman::p_load(geojsonR, factoextra,sf,dplyr, ggplot2, maps, fields,raster, 
               MuMIn, lubridate, tidyr,ggh4x, lme4,sdmTMB,inlabru,cowplot,
               INLAutils, marmap,sjPlot,rgeos, tidyverse, plyr, tidybayes, brms, bayesplot, loo,ggeffects,
               DHARMa, DHARMa.helpers) 


##################################################################################################################
################### Load in data and add censoring column   ###################
##################################################################################################################

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

##################################################################################################################
################### Plot fish against sediments   ###################
##################################################################################################################

fish.reg %>% 
  dplyr::mutate(feeding_position = factor(feeding_position, levels=c("Benthic","Benthopelagic","Midwater","Pelagic"))) %>% 
  ggplot(mapping=aes(x=TotalDDT.sed.trans, y=TotalDDT.trans, fill= trophic_category )) +
  geom_jitter(size=1.5, pch=21) +
  ylab("[DDXfish] ng/g lipid") +
  xlab("[DDXsed] ng/g dw") +
  facet_wrap(~feeding_position, nrow=1)+
  scale_fill_manual(values = c("#ffffcc","#a1dab4","#41b6c4","#225ea8"), name="Diet")+
  theme_bw() +
  theme(legend.position = "none") 

##################################################################################################################
################### Run BRMS Models   ###################
##################################################################################################################

# Look at best structure for model 
brm.none = brm(TotalDDT.trans|cens(Censored, Detection.Limit) ~ TotalDDT.sed.trans, data = fish.reg, prior = c(set_prior("cauchy(0, 0.5)", class = "b")))

brm.habitat.slope = brm(TotalDDT.trans|cens(Censored, Detection.Limit) ~ TotalDDT.sed.trans + TotalDDT.sed.trans:feeding_position, data = fish.reg, prior = c(set_prior("cauchy(0, 0.5)", class = "b")))

brm.habitat.intercept = brm(TotalDDT.trans|cens(Censored, Detection.Limit) ~ TotalDDT.sed.trans + feeding_position, data =  fish.reg, prior = c(set_prior("cauchy(0, 0.5)", class = "b")))

brm.diet.slope = brm(TotalDDT.trans|cens(Censored, Detection.Limit) ~ TotalDDT.sed.trans + TotalDDT.sed.trans:trophic_category, data =fish.reg, prior = c(set_prior("cauchy(0, 0.5)", class = "b")))

brm.diet.intercept = brm(TotalDDT.trans|cens(Censored, Detection.Limit) ~ TotalDDT.sed.trans + trophic_category, data =fish.reg, prior = c(set_prior("cauchy(0, 0.5)", class = "b")))


brm.trophic = brm(TotalDDT.trans|cens(Censored, Detection.Limit) ~ TotalDDT.sed.trans * trophic_category, 
                  data =fish.reg, prior = c(set_prior("cauchy(0, 0.5)", class = "b")))

brm.habitat = brm(TotalDDT.trans|cens(Censored, Detection.Limit) ~ TotalDDT.sed.trans * feeding_position, 
                  data =fish.reg, prior = c(set_prior("cauchy(0, 0.5)", class = "b")))

brm.diet.habitat = brm(TotalDDT.trans|cens(Censored, Detection.Limit) ~ TotalDDT.sed.trans * trophic_category + 
                         TotalDDT.sed.trans * feeding_position, data =fish.reg, prior = c(set_prior("cauchy(0, 0.5)", class = "b")))

brm.diet.habitat.year = brm(TotalDDT.trans|cens(Censored, Detection.Limit) ~ TotalDDT.sed.trans * trophic_category + 
                              TotalDDT.sed.trans * feeding_position + Year, data =fish.reg, prior = c(set_prior("cauchy(0, 0.5)", class = "b")))

brm.diet.habitat.species = brm(TotalDDT.trans|cens(Censored, Detection.Limit) ~ TotalDDT.sed.trans * trophic_category + 
                                 TotalDDT.sed.trans * feeding_position  +
                                 (1|CompositeCommonName), data =fish.reg, 
                               prior = c(
                                 set_prior("cauchy(0, 0.5)", class = "b"),   
                                 set_prior("cauchy(0, 2)", class = "sd")))

brm.diet.habitat.species.year = brm(TotalDDT.trans|cens(Censored, Detection.Limit) ~ TotalDDT.sed.trans * trophic_category + 
                                      TotalDDT.sed.trans * feeding_position + Year + 
                                      (1|CompositeCommonName), data =fish.reg, 
                                    prior = c(
                                      set_prior("cauchy(0, 0.5)", class = "b"),   
                                      set_prior("cauchy(0, 2)", class = "sd")))

##################################################################################################################
################### Run BRMS Models   ###################
##################################################################################################################

# Compare LOOIC
LOO.results = LOO(brm.none, 
                  brm.habitat.slope,brm.habitat, brm.habitat.intercept,
                  brm.diet.slope,brm.diet.intercept,brm.trophic,
                  brm.diet.habitat,brm.diet.habitat.year, 
                  brm.diet.habitat.species, brm.diet.habitat.species.year)

# Compare bayesian R2 - NOTE CENSORED MODELS HAVE ISSUES WITH INTERPRETATION OF THIS 
R2.results = lapply(X=list(brm.none, 
                           brm.habitat.slope,brm.habitat, brm.habitat.intercept,
                           brm.diet.slope,brm.diet.intercept,brm.trophic,
                           brm.diet.habitat,brm.diet.habitat.year, 
                           brm.diet.habitat.species, brm.diet.habitat.species.year), FUN=bayes_R2)

## Look at paramter estimates for best-fit model (80% highest density credible intervals)
mcmc_intervals_data(brm.diet.habitat.species.year, point_est="mean",prob = 0.8, prob_outer = 1)

##################################################################################################################
################### Plot posterior predictions for habitat/ diet models ###################
##################################################################################################################

get_dataframe_intervals <- function(model, model.type=c("trophic","habitat","all.fe")) {
  
  posterior <- as.matrix(model)
  
  if(model.type == "trophic") {levels =rev(c("Tertiary Carnivore","Secondary Carnivore","Primary Carnivore", "Baseline"))}
  else if(model.type == "habitat") {levels = rev(c("Benthic","Benthopelagic","Midwater","Baseline"))}
  else {levels = rev(c("Tertiary Carnivore","Secondary Carnivore","Primary Carnivore",
                       "Benthic","Benthopelagic","Midwater","Baseline", "Year"))}
  
  
  if(model.type %in% c("trophic","habitat","all.fe")){
    data = mcmc_intervals_data(posterior, point_est="mean",prob = 0.8, prob_outer = 1) %>% 
      dplyr::filter(grepl("b_", parameter)) %>% 
      #dplyr::filter(!parameter %in% c("sigma","lprior","lp__","sd_CompositeCommonName__Intercept")) %>% 
      dplyr::mutate(parameter_new = case_when(parameter == "b_TotalDDT.sed.trans" ~"Baseline", 
                                              parameter == "b_TotalDDT.sed.trans:feeding_positionMidwater" ~ "Midwater",
                                              parameter == "b_TotalDDT.sed.trans:feeding_positionBenthopelagic" ~ "Benthopelagic", 
                                              parameter == "b_TotalDDT.sed.trans:feeding_positionBenthic" ~ "Benthic", 
                                              parameter == "b_TotalDDT.sed.trans:trophic_categoryPrimaryCarnivore" ~ "Primary Carnivore", 
                                              parameter == "b_TotalDDT.sed.trans:trophic_categorySecondaryCarnivore" ~ "Secondary Carnivore", 
                                              parameter == "b_TotalDDT.sed.trans:trophic_categoryTertiaryCarnivore" ~ "Tertiary Carnivore", 
                                              parameter == "b_Intercept" ~ "Baseline",
                                              parameter == "b_Year" ~ "Year",
                                              parameter ==  "b_trophic_categoryPrimaryCarnivore" ~ "Primary Carnivore", 
                                              parameter == "b_trophic_categorySecondaryCarnivore" ~ "Secondary Carnivore", 
                                              parameter == "b_trophic_categoryTertiaryCarnivore" ~ "Tertiary Carnivore", 
                                              parameter == "b_feeding_positionMidwater" ~ "Midwater", 
                                              parameter == "b_feeding_positionBenthopelagic" ~ "Benthopelagic", 
                                              parameter ==  "b_feeding_positionBenthic" ~ "Benthic")) %>% 
      dplyr::mutate(type = case_when(parameter == "b_TotalDDT.sed.trans" ~"Sediment[DDT]", 
                                     parameter == "b_TotalDDT.sed.trans:feeding_positionMidwater" ~ "Sediment[DDT]",
                                     parameter == "b_TotalDDT.sed.trans:feeding_positionBenthopelagic" ~ "Sediment[DDT]", 
                                     parameter == "b_TotalDDT.sed.trans:feeding_positionBenthic" ~ "Sediment[DDT]", 
                                     parameter == "b_TotalDDT.sed.trans:trophic_categoryPrimaryCarnivore" ~ "Sediment[DDT]", 
                                     parameter == "b_TotalDDT.sed.trans:trophic_categorySecondaryCarnivore" ~ "Sediment[DDT]", 
                                     parameter == "b_TotalDDT.sed.trans:trophic_categoryTertiaryCarnivore" ~ "Sediment[DDT]", 
                                     parameter == "b_Intercept" ~ "Intercept",
                                     parameter == "b_Year" ~ "Year",
                                     parameter ==  "b_trophic_categoryPrimaryCarnivore" ~ "Intercept", 
                                     parameter == "b_trophic_categorySecondaryCarnivore" ~ "Intercept", 
                                     parameter == "b_trophic_categoryTertiaryCarnivore" ~ "Intercept", 
                                     parameter == "b_feeding_positionMidwater" ~ "Intercept", 
                                     parameter == "b_feeding_positionBenthopelagic" ~ "Intercept", 
                                     parameter ==  "b_feeding_positionBenthic" ~ "Intercept")) %>% 
      dplyr::mutate(parameter_new = factor(parameter_new, levels=levels)) 
    
  }
  else {
    data = mcmc_intervals_data(posterior, point_est="mean",prob = 0.8, prob_outer = 1) %>% 
      dplyr::mutate(type = "Intercept") %>% 
      dplyr::filter(grepl("r_", parameter)) %>% 
      dplyr::mutate(parameter_new = str_remove(parameter, c("r_CompositeCommonName"))) %>% 
      dplyr::mutate(parameter_new = str_remove(parameter_new, c(",Intercept"))) %>% 
      dplyr::mutate(parameter_new = gsub("[][()]", "", parameter_new)) %>% 
      dplyr::mutate(parameter_new = gsub("\\.", " ", parameter_new)) %>% 
      dplyr::left_join(., fish.reg[, c("CompositeCommonName","trophic_category","feeding_position")], by=c("parameter_new"="CompositeCommonName")) %>% 
      dplyr::mutate(parameter_new = factor(parameter_new, levels=(unique(fish.reg$CompositeCommonName[order(fish.reg$trophic_level)])))) %>% 
      unique()
  }
  
  return(data)
}

dummy <- data.frame(term = rep("dummy",6), 
                    type = c("Intercept","Intercept","Sediment[DDT]","Sediment[DDT]","Year","Year"), 
                    m = c(-1.25, 3.1, -0.56, 0.85, -0.15, 0.15))

null.effects = ggplot(get_dataframe_intervals(brm.none, model.type="trophic"), 
                      aes(x = m)) + 
  geom_linerange(aes(y = parameter_new, color=parameter_new,xmin = ll, xmax = hh), size=1.1, color="black")+
  geom_crossbar(aes(y = parameter_new, color=parameter_new, fill=parameter_new,xmin = l, xmax = h), width=0.2, color="black")+
  theme_bw() + 
  facet_wrap(~type, scales="free_x") + 
  geom_vline(xintercept=0, linetype="dashed") + 
  scale_color_manual(values=c("#ffffcc","#a1dab4","#41b6c4","#225ea8")) + 
  scale_fill_manual(values=c("#ffffcc","#a1dab4","#41b6c4","#225ea8")) + 
  xlab("Coefficient Estimate") + 
  ylab("") + 
  theme(legend.position = "none") + 
  ggtitle("Null Model") + 
  geom_blank(data=dummy[dummy$type != "Year",]) 


diet.effects = ggplot(get_dataframe_intervals(brm.trophic, model.type="trophic"), 
                      aes(x = m)) + 
  geom_linerange(aes(y = parameter_new, color=parameter_new,xmin = ll, xmax = hh), size=1.1, color="black")+
  geom_crossbar(aes(y = parameter_new, color=parameter_new, fill=parameter_new,xmin = l, xmax = h), width=0.2, color="black")+
  theme_bw() + 
  facet_wrap(~type, scales="free_x") + 
  geom_vline(xintercept=0, linetype="dashed") + 
  scale_color_manual(values=c("#ffffcc","#a1dab4","#41b6c4","#225ea8")) + 
  scale_fill_manual(values=c("#ffffcc","#a1dab4","#41b6c4","#225ea8")) + 
  xlab("Coefficient Estimate") + 
  ylab("") + 
  theme(legend.position = "none") + 
  ggtitle("Diet Model") + 
  geom_blank(data=dummy[dummy$type != "Year",]) 


habitat.effects = ggplot(get_dataframe_intervals(brm.habitat, model.type="habitat"), 
                         aes(x = m)) + 
  geom_linerange(aes(y = parameter_new, color=parameter_new,xmin = ll, xmax = hh), size=1.1, color="black")+
  geom_crossbar(aes(y = parameter_new, color=parameter_new, fill=parameter_new,xmin = l, xmax = h), width=0.2, color="black")+
  theme_bw() + 
  facet_wrap(~type, scales="free_x") + 
  geom_vline(xintercept=0, linetype="dashed") + 
  scale_color_manual(values=c("#ffffcc","#fecc5c","#fd8d3c","#e31a1c")) + 
  scale_fill_manual(values=c("#ffffcc","#fecc5c","#fd8d3c","#e31a1c")) + 
  xlab("Coefficient Estimate") + 
  ylab("") + 
  theme(legend.position = "none")+ 
  geom_blank(data=dummy[dummy$type != "Year",]) +
  ggtitle("Habitat Model")

cowplot::plot_grid(null.effects, diet.effects,habitat.effects, 
                   align = "hv",ncol = 1,  rel_heights = c(0.5, 1,1), 
                   labels=c("A","B", "C"))

##################################################################################################################
################### Plot posterior predictions for best fit model ###################
##################################################################################################################

fixed.effects.plot = ggplot(get_dataframe_intervals(brm.diet.habitat.species.year, model.type="all.fe"), 
                            aes(x = m)) + 
  geom_linerange(aes(y = parameter_new, color=parameter_new,xmin = ll, xmax = hh), size=1.1, color="black")+
  geom_crossbar(aes(y = parameter_new, color=parameter_new, fill=parameter_new,xmin = l, xmax = h), width=0.2, color="black")+
  #geom_point(color="black", size=2, alpha=0.5, pch=21) + 
  theme_bw() + 
  #facet_wrap(~type, scales="free") + 
  ggforce::facet_col(vars(type), scales = 'free', space = 'free') +
  #facet_grid(rows=vars(type), scales="free", space="free_y") + 
  geom_vline(xintercept=0, linetype="dashed") + 
  scale_color_manual(values=c("#ffffcc","#ffffcc","#fecc5c","#fd8d3c","#e31a1c","#a1dab4","#41b6c4","#225ea8")) + 
  scale_fill_manual(values=c("#ffffcc","#ffffcc","#fecc5c","#fd8d3c","#e31a1c","#a1dab4","#41b6c4","#225ea8")) + 
  xlab("Coefficient Estimate") + 
  ylab("") + 
  theme(legend.position = "none")+
  geom_blank(data=dummy) 

random.effects.plot = ggplot(get_dataframe_intervals(brm.diet.habitat.species.year, model.type="all.re") %>% 
                               dplyr::mutate(trophic_category = as.factor(trophic_category)) %>% 
                               unique(), 
                             aes(x = m)) + 
  geom_linerange(aes(y = parameter_new, color=trophic_category,xmin = ll, xmax = hh), size=0.9, color="black")+
  geom_crossbar(aes(y = parameter_new, color=trophic_category, fill=trophic_category,xmin = l, xmax = h), width=0.4, color="black")+
  theme_bw() + 
  facet_grid(rows=vars(feeding_position), scales="free_y", space="free_y") + 
  geom_vline(xintercept=0, linetype="dashed") + 
  scale_color_manual(values=c("#ffffcc","#a1dab4","#41b6c4","#225ea8")) + 
  scale_fill_manual(values=c("#ffffcc","#a1dab4","#41b6c4","#225ea8")) + 
  xlab("Coefficient Estimate") + 
  ylab("") + 
  theme(legend.position = "none")+
  geom_blank(data=dummy) 

cowplot::plot_grid(fixed.effects.plot,random.effects.plot, ncol = 2,  rel_heights = c(1,1), 
                   labels=c("A","B"))
