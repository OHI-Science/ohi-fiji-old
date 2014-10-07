#########################################
## Substituting some of the layers with
##  Fiji-specific data
##########################################
library(dplyr)
library(tidyr)

### Table for OHI2013 Fiji scores:
OHI2013 <- read.csv("fiji2013/scores_2013EEZ.csv") %>%
  filter(region_id==18) %>%
  spread(dimension, score) %>%
  select(goal, score, future, status, trend, pressures, resilience)



# FIS ----
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


