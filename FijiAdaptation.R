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
  select(goal, score, future, status, trend, pressures, resilience)


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
