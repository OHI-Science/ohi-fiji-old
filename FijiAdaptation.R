#########################################
## Substituting some of the layers with
##  Fiji-specific data
##########################################
source('../ohiprep/src/R/common.R')

library(tidyr)



### Table for OHI2013 Fiji scores:
OHI2013 <- read.csv("fiji2013/scores_2013EEZ.csv") %>%
  filter(region_id==18) %>%
  spread(dimension, score) %>%
  select(goal, score, status, future, trend, pressures, resilience) %>%
  mutate(goal = factor(goal, levels=c('Index', 'NP', 'AO', 'FP', 'MAR', 'FIS', 'BD', 'SPP', 'HAB',
                         'CW', 'SP', 'LSP', 'ICO', 'LE', 'ECO', 'LIV', 'TR', 'CP', 'CS'))) %>%
  arrange(goal)
write.csv(OHI2013, "figures and tables/OHI2013.csv", na="", row.names=FALSE)

 ##################################################
# FIS ----
##################################################

# 1. Changes to function: different penalty table and uses 25th quantile
#    rather than median for estimating b/bmsy for taxa that were not modeled.
# 2. Use constrained prior b/bmsy data
#    this is what was originally used but the 
#    latest version of the OHI2013 uses a mixture of constrained vs.
#    uniform depending on the resilience of the country.

## take a look at formatting for the old version:
old_bmsy <- read.csv("fiji2013/layers/fis_b_bmsy_ohi.csv")

## data (constrained prior with no zeros)
load("../ohiprep/Global/FIS_Bbmsy/Hex outputs/cmsy_ohi_results_table_originalPrio_no0s.RData")
b_bmsy_c_na <- cmsy.ohi.orig.no0.df %>%
  mutate(fao_id = as.numeric(sapply(strsplit(as.character(stock_id), "_"), function(x)x[2]))) %>%
  mutate(taxon_name = sapply(strsplit(as.character(stock_id), "_"), function(x)x[1])) %>%
  select(fao_id, taxon_name, year=yr, b_bmsy)

# save new data to layers:
write.csv(b_bmsy_c_na, "fiji2013/layers/fis_b_bmsy.csv", na="", row.names=FALSE)


######################################################
## AO ----
#####################################################

# calculated using same technique as FIS, but using a subset of 
# taxa that are artisanally fished.  

# copy relevant file to layers
location <- file.path(dir_neptune_data, 'model/FJ_v2013/Scripts and Data/data/AOTaxa.csv')
file.copy(location, 'fiji2013/layers/ao_taxa.csv', overwrite=TRUE)

# remove unnecessary layers 
lyrs <- read.csv('fiji2013/layers_2013EEZ.csv')
lyrs <- lyrs %>%
  filter(targets != "AO") %>%
  select(targets, layer, layer_old, name, description, fld_value, units, filename)

# add new layer
ao_taxa <- data.frame(
  targets = "AO",
  layer = "ao_taxa",
  layer_old = "ao_taxa",
  name = "list of artisanally fished species",
  description = "list created by Kristin to ID artisanally fished taxa",
  fld_value = "species",
  units = 'species name',
  filename = 'ao_taxa.csv')

lyrs <- rbind(lyrs, ao_taxa)

# write back updated layers.csv
write.csv(lyrs, 'fiji2013/layers.csv', na='', row.names=F)

######################################################
## CP and HAB ----
#####################################################

# coral data were updated for Fiji, but the functions remain the same
# New analysis only changed trend. Extent stayed the same: 3011.84 
# health stayed the same: 1
# trend changed from: 0.05464683 to: 0.007253

## take a look at formatting for the old version:
old_trend <- read.csv("fiji2013/layers/hab_trend.csv")
old_trend %>%
  filter(rgn_id==18,
         habitat=="coral")
old_trend$trend[old_trend$rgn_id==18 & old_trend$habitat=="coral"] <- 0.007253

# save new data to layers:
write.csv(old_trend, "fiji2013/layers/hab_trend.csv", na="", row.names=FALSE)


##################################################
# MAR ----
##################################################

# used Yashika data
# Global includes 'Blue shrimp' and 'Giant tiger prawn' - however, Yashika data identifies 'shrimp' and 'prawn'
# To obtain the sustainability socres for these taxa we averaged the 2013 OHI global sustainability scores
# of shrimp (2 species) and prawn (5 species) species.

## take a look at formatting for the old version:
harvest_tonnes <- read.csv("fiji2013/layers/mar_harvest_tonnes_ohi.csv") 
harvest_tonnes_fiji <- harvest_tonnes %>%
  filter(rgn_id == 18)
species <- unique(harvest_tonnes_fiji$species_code)
harvest_tonnes[harvest_tonnes$species_code %in% species, ] #species codes are specific to Fiji
# cut shrimp/prawn data for Fiji to replace with new data
harvest_tonnes  <-  harvest_tonnes %>%
  filter(!(species_code %in% c(803, 804)))
# get Yashika data and bind
Yashika_harvest <- read.csv(file.path(dir_neptune_data, 'model/FJ_v2013/Scripts and Data/data/MAR_harvest_tonnes.csv'))
harvest_tonnes <- rbind(harvest_tonnes, Yashika_harvest)
write.csv(harvest_tonnes, "fiji2013/layers/mar_harvest_tonnes.csv", row.names=FALSE)

# change harvest species names to more general names:
harvest_species <- read.csv("fiji2013/layers/mar_harvest_species_ohi.csv", stringsAsFactors=FALSE) 
harvest_species[harvest_species$species_code %in% species, ]
harvest_species$species[harvest_species$species_code == 803]  <- "Shrimp"
harvest_species$species[harvest_species$species_code == 804]  <- "Prawn"
write.csv(harvest_species, "fiji2013/layers/mar_harvest_species.csv", row.names=FALSE)

# revise sustainability scores:
sust_species <- read.csv("fiji2013/layers/mar_sustainability_score_ohi.csv", stringsAsFactors=FALSE) 
sust_species %>%
  filter(rgn_id==18)
sust_species$species[sust_species$rgn_id==18 & sust_species$species=="Blue shrimp"] <- "Shrimp"
sust_species$species[sust_species$rgn_id==18 & sust_species$species=="Giant tiger prawn"] <- "Prawn"
sust_species$sust_coeff[sust_species$rgn_id==18 & sust_species$species=="Shrimp"] <- 0.320588
sust_species$sust_coeff[sust_species$rgn_id==18 & sust_species$species=="Prawn"] <- 0.354365
write.csv(sust_species, "fiji2013/layers/mar_sustainability_score.csv", row.names=FALSE)


##################################################
# ICO ----
##################################################

#updated iconics list for Fiji

##### Status data ###############

status <- read.csv("fiji2013/layers/ico_spp_extinction_status_ohi.csv") 

#cut Fiji in OHI data
status <- status %>%
  filter(rgn_id != 18)

# format new Fiji data and add
new_data <- read.csv(file.path(dir_neptune_data, 'model/FJ_v2013/Scripts and Data/data/Fiji_Iconics.csv'), na.strings="")
status_new <- new_data %>%
  mutate(rgn_id = 18) %>%
  select(rgn_id, sciname=Scientific, category=IUCN.Category) %>%
  filter(!is.na(category))

status <- rbind(status, status_new)

write.csv(status, "fiji2013/layers/ico_spp_extinction_status.csv", row.names=FALSE)

##### Trend data ###############

trend <- read.csv("fiji2013/layers/ico_spp_popn_trend_ohi.csv") 

#cut Fiji in OHI data
trend <- trend %>%
  filter(rgn_id != 18)

# format new Fiji data and add
trend_new <- new_data %>%
  mutate(rgn_id = 18) %>%
  select(rgn_id, sciname=Scientific, popn_trend=Trend) %>%
  filter(!is.na(popn_trend))

trend <- rbind(trend, trend_new)

write.csv(trend, "fiji2013/layers/ico_spp_popn_trend.csv", row.names=FALSE)


##################################################
# LSP ----
##################################################

# Different approach than OHI2013.  Use the qoliqoli regions as the cmpa region (rather than 3nm).
# Weight different 'cmpa's on the basis of their management effectiveness.
# CP data is the same as OHI 2013
# Check on weighting of CP and CMPA

### generate effective management areas for Fiji
LSP_data <- read.csv(file.path(dir_neptune_data, 'model/FJ_v2013/Scripts and Data/data/LSPFiji.csv'), na.strings="")

## The following was the original method for estimating weights, but it was 
## resulting in inflated scores.  See email from Stacy Jupiter...
## New weights are provided below...
# weights <- read.csv("Scripts and Data\\data\\LSPScores.csv")

cmpa <- LSP_data[LSP_data$type %in% c("cmpa_Qoliqoli", "cmpa_Tabu"), ]

#------------------------------------------------------------------
## Assign weights to cmpa data
#------------------------------------------------------------------
weightSummary <- data.frame(management=c("NoTabu",  "WithTabu", "Tabu_permanent", "Tabu_controlled_harvest", "Tabu_uncontrolled_haverst", "Tabu_other_management"),
                            weight = c(0, 0.15, 1, 0.5, 0.1, 0.1))

cmpa <- merge(cmpa, weightSummary, by="management", all.x=TRUE)
cmpa$WeightedArea <- cmpa$Area_km2 * cmpa$weight

sum(cmpa$Area_km2)  # This is the total area that replaces the 3 nm in the OHI analysis, 30050.5 km2

cmpa_effective_area <- cmpa %>%
  group_by(year) %>%
  summarize(area_km2=sum(WeightedArea)) %>%
  mutate(rgn_id=18) %>%
  select(rgn_id, year, area_km2)

# replace Fiji data in OHI 2013 data:
cmpa_ohi <- read.csv("fiji2013/layers/lsp_prot_area_offshore3nm_ohi.csv") 
cmpa_ohi  <- cmpa_ohi %>%
  filter(rgn_id!=18)

cmpa <- rbind(cmpa_ohi, cmpa_effective_area)
write.csv(cmpa, "fiji2013/layers/lsp_prot_area_offshore3nm.csv", row.names=FALSE)
