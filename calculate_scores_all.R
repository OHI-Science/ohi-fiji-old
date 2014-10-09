
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

# scenarios
  
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
    
  
    # restore working directory
    setwd('..') 
    
    # archive scores on disk (out of github, for easy retrieval later)
    csv = sprintf('%s/git-annex/Global/NCEAS-OHI-Scores-Archive/scores/scores_%s_%s.csv', 
                  dirs$neptune_data, scenario, format(Sys.Date(), '%Y-%m-%d'))
#         write.csv(scores, csv, na='', row.names=F)
    
    if (scenarios$eez2014$do) { source('global2014/merge_scores.R')  }
#    print_scenarios = T;       source('../ohidev/report/compare_scores.R')  
    
  }
  
  if (do.other){
    # spatial  
    for (f in scenarios[[scenario]][['f_spatial']]){ # f = f_spatial[1]
      stopifnot(file.exists(f))
      file.copy(f, sprintf('%s/spatial/%s', scenario, basename(f)))
    }
    
    # delete old shortcut files
    for (f in c('launchApp.bat','launchApp.command','launchApp_code.R','scenario.R')){
      path = sprintf('%s/%s',scenario,f)
      if (file.exists(path)) unlink(path)
    }
    
    # save shortcut files not specific to operating system
    write_shortcuts(scenario, os_files=0)
    
    # launch on Mac # setwd('~/github/ohi-global/eez2013'); launch_app()
    #system(sprintf('open %s/launch_app.command', scenario))
  }
}


# # DEBUG comparison for 2013a
source('../ohidev/report/compare_scores.R')
suppressWarnings(source('../ohidev/report/visualizeScores/visualizeScores.R'))

# prepare data for Radical 2012 and 2013 eez (need to add Antarctica and High Seas)
#source('../ohidev/report/radical.R')

# comparison 2014a
# source('../ohidev/report/compare_scenarios.R')

