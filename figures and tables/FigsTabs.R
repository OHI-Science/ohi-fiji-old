### Manuscript tables and figures
library(tidyr)

source('../ohiprep/src/R/common.R')

# new paths based on host machine
dirs = list(
  neptune_data  = dir_neptune_data, 
  neptune_local = dir_neptune_local,
  ohiprep       = '../ohiprep',
  ohicore       = '../ohicore')

scenario <- 'fiji2013'


Fiji2013 <- read.csv("fiji2013/scores.csv") %>%
  filter(region_id==18) %>%
  spread(dimension, score) %>%
  select(goal, score, status, future, trend, pressures, resilience) %>%
  mutate(goal = factor(goal, levels=c('Index', 'NP', 'AO', 'FP', 'MAR', 'FIS', 'BD', 'SPP', 'HAB',
                                      'CW', 'SP', 'LSP', 'ICO', 'LE', 'ECO', 'LIV', 'TR', 'CP', 'CS'))) %>%
  arrange(goal)
write.csv(Fiji2013, "figures and tables/Fiji2013.csv", na="", row.names=FALSE)


#-----------------------------------------------------------
# Flower plots of data
#-----------------------------------------------------------
require('RColorBrewer')
source("C:/Users/Melanie/Desktop/NCEAS/OHI R scripts/FlowerPlotFunction.R")

###Fiji data ----
Fiji2013 <- read.csv("fiji2013/scores.csv")
orderData <- c("Index", "NP", "AO", "FP", "MAR", "FIS", "BD", "SPP", "HAB",
               "CW", "SP", "LSP", "ICO", "LE", "ECO", 'LIV', "TR", "CP", "CS")

Fiji2013 <- dcast(subset(Fiji2013, region_id==18, select=c(-region_id)), goal ~ dimension)
Fiji2013 <- Fiji2013[order(order(orderData)),] 
Fiji2013 <- subset(Fiji2013, select=c("goal", "score", "status", "future", "trend", "pressures", "resilience"))

## requires loading the function below:
flowerPlots(Fiji2013, "figures and tables/FijiFlowerPlot2013OHI_Oct9_2014.png")


## EEZ data----
EEZ2013 <- read.csv("fiji2013/scores_2013EEZ.csv")
orderData <- c("Index", "NP", "AO", "FP", "MAR", "FIS", "BD", "SPP", "HAB",
               "CW", "SP", "LSP", "ICO", "LE", "ECO", 'LIV', "TR", "CP", "CS")

EEZ2013 <- dcast(subset(EEZ2013, region_id==18, select=c(-region_id)), goal ~ dimension)
EEZ2013 <- EEZ2013[order(order(orderData)),] 
EEZ2013 <- subset(EEZ2013, select=c("goal", "score", "status", "future", "trend", "pressures", "resilience"))

## requires loading the function below:
flowerPlots(EEZ2013, "figures and tables/EEZFlowerPlot2013OHI_Oct9_2014.png")

## function ----
flowerPlots <- function(plotData=data, name="FijiFlowerPlot.png"){
  row.names(plotData) <- plotData$goal
  plotData <- subset(plotData, select=c("score"))
  plotData <- data.frame(t(plotData))
  plotData <- subset(plotData, select=c("Index", "FIS", "MAR", "AO", "NP", "CS", "CP", "TR", 
                                        "LIV", "ECO", "ICO", "LSP", "CW", "HAB", "SPP"))
  plotData <- rename(plotData, c("NP"= "Natural Products",
                                 "AO"= "Artisanal Fishing \n Opportunities",
                                 "MAR"="Mariculture",
                                 "FIS"="Fisheries",
                                 "SPP"="Species",
                                 "HAB"="Habitats",
                                 "CW"="Clean Waters",
                                 "LSP"="Lasting Special \n Places",
                                 "ICO"="Iconic \n Species",
                                 "ECO"="Economies",
                                 "LIV"="Livelihoods",
                                 "TR"= "Tourism & \n Recreation",
                                 "CP"="Coastal \n Protection",
                                 "CS"="Carbon Storage"))
  ############################################################################
  ## Making the plots
  ############################################################################
  col.brks = c(seq(0,100,length.out=11)) 
  # 2013 index
  png(file=name, 
      res=300, height=8, width=8, units="in")
  par(mfrow=c(1,1))
  #par(pty="s") 
  aster(lengths=unlist(ifelse(is.na(plotData[2:15]), 100, plotData[2:15])), 
        widths=c(0.5, 0.5, 1, 1, 1, 1, 1, 0.5, 0.5, 0.5, 0.5, 1, 0.5, 0.5),
        labels= gsub("NA", "-", paste(names(plotData)[2:15], round(plotData[2:15],0), sep="\n")), 
        label.offset=0.15,
        label.cex=1,
        fill.col= ifelse(is.na(plotData[2:15]), 
                         "#d3d3d3", 
                         brewer.pal(10, 'RdYlBu')[cut(as.numeric(plotData[2:15]), col.brks, labels=1:10)]),
        center=round(plotData[1], 0), 
        #main=data[2], 
        max.length=100,
        disk=0.35, 
        cex=2,
        cex.main=1.5,
        xlim=c(-1.2, 1.2)) 
  dev.off()
}


#####################################
## FIS data explorations and figures
#####################################

c <- read.csv("fiji2013/layers/fis_meancatch.csv")
b <- read.csv("fiji2013/layers/fis_b_bmsy.csv")
a <- read.csv("fiji2013/layers/fis_proparea_saup2rgn.csv")

## Fiji is saup id 242
# catch data
c$fao_id <- as.numeric(sapply(strsplit(as.character(c$fao_saup_id), "_"), function(x)x[1]))
c$saup_id <- as.numeric(sapply(strsplit(as.character(c$fao_saup_id), "_"), function(x)x[2]))
c$TaxonName <- sapply(strsplit(as.character(c$taxon_name_key), "_"), function(x)x[1])
c$TaxonKey <- as.numeric(sapply(strsplit(as.character(c$taxon_name_key), "_"), function(x)x[2]))
#Create Identifier for linking assessed stocks with country-level catches
c$stock_id <- paste(as.character(c$TaxonName),
                    as.character(c$fao_id), sep="_")

c <- c %>%
  filter(saup_id==242) %>%
  select(year, mean_catch, fao_id, TaxonName, stock_id, TaxonKey)

c[grep("Decapterus russelli_71", c$TaxonName), ]         
         
# b_bmsy data
# Identifier taxa/fao region:
b$stock_id <- paste(b$taxon_name, b$fao_id, sep="_")
b <- b %>%
  select(stock_id, year, b_bmsy)
b[grep("Decapterus", b$stock_id), ]
# ------------------------------------------------------------------------
# STEP 1. Merge the species status data with catch data
#     AssessedCAtches: only taxa with catch status data
# -----------------------------------------------------------------------
AssessedCatches <- join(b, c, 
                        by=c("stock_id", "year"), type="inner")

Fiji_2011_assessed <- AssessedCatches %>%
  filter(year %in% 2011) %>%
  select(fao_id, TaxonName, year, b_bmsy) %>%
  arrange(b_bmsy)

Fiji_2007_2011_assessed <- AssessedCatches %>%
  filter(year %in% 2007:2011) %>%
  select(fao_id, TaxonName, year, b_bmsy) %>%
  arrange(fao_id, TaxonName, year)


lm = dlply(
  Fiji_2007_2011_assessed, .(TaxonName, fao_id),
  function(x) lm(b_bmsy ~ year, x))
trend_lm <- ldply(lm, coef)
trend_lm <- trend_lm %>%
  select(TaxonName, fao_id, trend=year)

p = dlply(
  Fiji_2007_2011_assessed, .(TaxonName, fao_id),
  function(x) summary(lm(b_bmsy ~ year, x)))
p_lm  <- ldply(p, function(x) x$coeff[2,4])
p_lm <- p_lm %>%
  select(TaxonName, fao_id, Pvalue=V1)

common <- read.csv("figures and tables/FishCommonNames.csv") %>%
  select(TaxonName=Genus.species, Common.name)
common <- unique(common)

Fiji_data_bbmsy <- Fiji_2011_assessed%>%
  mutate(year=as.numeric(year)) %>%
  left_join(trend_lm) %>%
  left_join(p_lm) %>%
  mutate(Trend2 = ifelse(trend < 0 & Pvalue < 0.05, "negative",
                       ifelse(trend > 0 & Pvalue < 0.05, "positive",
                              "none"))) %>%
  mutate(fao_id = ifelse(fao_id == 81, "Southwest Pacific", "Western Central Pacific")) %>%
  left_join(common, by='TaxonName')

#write.csv(Fiji_data_bbmsy, "figures and tables/b_bmsy_data.csv", row.names=FALSE)

## do a quick test of data
test_Sj <- c(0.3347268, 0.3206750, 0.2858359, 0.2317777, 0.1819549)
year <- c(2007:2011)
mod <- lm(test_Sj ~ year)
summary(mod)


## some summaries:
library(RColorBrewer)
library(colorspace)
library(ggplot2)
library(grid)
source('https://www.nceas.ucsb.edu/~frazier/myTheme.txt')

ggplot(Fiji_data_bbmsy, aes(x=b_bmsy, fill=as.factor(Trend2))) +
  geom_dotplot(stackgroups=TRUE,method="histodot", binwidth=1/30, shape=19) +
  ylim(0,10) +
  coord_fixed(ratio=1/30)+
  scale_fill_manual(name="Trend", 
                    breaks=c("negative", "none", "positive"),
                    values=c("negative"=diverge_hcl(4)[4],
                             "none"= "cornsilk2",
                             "positive"=diverge_hcl(4)[1])) +
  labs(x=expression(B/B[msy])) +
  #myTheme +
  theme_bw() +
  theme(legend.key = element_blank()) 

ggsave("figures and tables/bbmsy.png")

# ------------------------------------------------------------------------
# STEP 2. Estimate status data for catch taxa without species status
#     UnAssessedCatches: taxa with catch status data
# -----------------------------------------------------------------------

c_2011 <- c %>%
  filter(year==2011)  #63 stocks
sum(c_2011$TaxonKey < 400000)

UnAssessedCatches <- c[!(c$year %in% AssessedCatches$year &
                           c$stock_id %in% AssessedCatches$stock_id), ]
Fiji_2011_UnAssessed <- UnAssessedCatches %.%
  filter(saup_id %in% 242 & year %in% 2011) %.%
  select(fao_id, TaxonName, year, TaxonKey)

Fiji_2011_UnAssessed[Fiji_2011_UnAssessed$TaxonKey>=600000,]
dim(Fiji_2011_UnAssessed[Fiji_2011_UnAssessed$TaxonKey<600000,])

## checking on numbers:
tmp <- UnAssessedCatches[(UnAssessedCatches$saup_id %in% 242 & UnAssessedCatches$year %in% 2011), ]
unique(tmp$TaxonName) #N=60 species
sum(tmp$MeanCatch) # total mean catch = 14096
tmp$TaxonPenaltyCode <- substring(tmp$TaxonKey,1,1)
tmp2 <- unique(subset(tmp, select=c(TaxonName, fao_id, TaxonPenaltyCode)))
table(tmp2$TaxonPenaltyCode)
sum(table(tmp2$TaxonPenaltyCode))
tmp2[tmp2$TaxonPenaltyCode<4,]

