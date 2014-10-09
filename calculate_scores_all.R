
# Melanie access on PC 
#setwd("C:/Users/Melanie/Github/ohi-fiji")
#setwd(file.path('~/github/ohi-fiji'))
#  setwd('~/ohi-fiji')

## check to see if following also works on Mac:
source('../ohiprep/src/R/common.R')

# new paths based on host machine
dirs = list(
  neptune_data  = dir_neptune_data, 
  neptune_local = dir_neptune_local,
  ohiprep       = '../ohiprep',
  ohicore       = '../ohicore')

scenario <- 'fiji2013'

# load ohicore (must first download using directions from here: )
library(ohicore) # or 
#devtools::load_all(dirs$ohicore)
library(stringr)

  

conf   = Conf(sprintf('%s/conf', scenario))
    
    # run checks on layers
    CheckLayers(layers.csv = sprintf('%s/layers.csv', scenario), 
                layers.dir = sprintf('%s/layers', scenario), 
                flds_id    = conf$config$layers_id_fields)
  
  
    conf   = Conf(sprintf('%s/conf', scenario))
    layers = Layers(sprintf('%s/layers.csv', scenario), sprintf('%s/layers', scenario))
    
    # calculate scores
    scores = CalculateAll(conf, layers, debug=T)
     write.csv(scores, sprintf('%s/scores.csv', scenario), na='', row.names=F)
    
#     # archive scores on disk (out of github, for easy retrieval later)
#     csv = sprintf('%s/scores_%s.csv', 
#                   scenario, format(Sys.Date(), '%Y-%m-%d'))
# #         write.csv(scores, csv, na='', row.names=F)
#     
