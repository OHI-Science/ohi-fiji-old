ohi-fiji
==========

# Country Index
This was calculated in the same way as the 2013 OHI global analysis.  To calculate Fiji’s overall index, we averaged the scores for the 10 goals.

# Scores
These were calculated in the same way as the 2013 OHI global analysis. To calculate each goal/subgoal score, we averaged the current status and future status data (see below for details). 

# Future status: data and analysis
Estimates of future status are based on current status, trend, resilience and pressure.  The status and trend of some of the goals differed from the 2013 OHI global analysis due to new data or models (see below for details).  We used the same resilience and pressure data as the OHI global 2013 analysis.  We used the same model to calculate future status.  

# Status and trend: data and analysis
The following describes how the status and trend data were calculated for the goals and subgoals that differed from the global OHI analysis.  

## Artisanal opportunities
*Analysis:* We used a completely different approach than the OHI global analysis.  We identified artisanally fished taxa and then evaluated their status using the catch-MSY method used in the fisheries goal (see below). 

*Data:* We used the catch data from 2013 OHI global analysis. The list of artisanally fished taxa was generated for this analysis (see below for details). 

*Time frame:* 
Status year: 2011
Trend years: 2007-2011

## Coastal protection
*Analysis:* Same as global OHI 2013. 

*Data:* The coral health and trend data were updated (see below).  The values for the other habitats used in the calculation (coral, mangrove, salt marsh, seagrass, and shoreline seaice) remained the same as the global OHI 2013 data.  

*Time frame:* 
Status year: Depends on habitat
Trend years: Depends on habitat

## Food Provision
*Analysis:* The status of the food provision goal was recalculated using new subgoal calculations for Fisheries and Mariculture.  The food provision goal is a weighted average of the two subgoals based on their relative yields:

$x_FP=w*X_FIS+(1-w)X_MAR$

The weight is calculated by dividing the fisheries yield by the total yield (Fisheries and Mariculture).  In this case, the weight was 0.9987.
  

## Fisheries (subgoal)
*Analysis:* We applied a slightly different analytical approach than what was used for the 2013 OHI global analysis.  For both analyses, the catch MSY method was used to generate yearly B/BMSY data for each taxa identified to species level within each FAO region. However, the 2013 OHI global data used B/BMSY data calculated using constrained or uniform priors depending on resilience.  The Fiji analysis used only the contrained prior.  For taxa that did not have B/BMSY data because they were not reported to the species level, the 0.25 quantile of the B/BMSY data for taxa in the same FAO region and year was used as a starting estimate of B/BMSY, whereas, in the 2013 OHI global analysis, the median value was used.  We felt this approach still provided a conservative estimate of B/BMSY, but would not be driven by outliers.  For the taxa that were identified to species, but did not have B/BMSY data (due to variables such as a short time series or model failure), the 0.5 quantile (or, median) of the B/BMSY data was used.  The B/BMSY estimates of taxa not identified to species were penalized to reflect the fact that reporting at this taxonomic level suggests a lack of adequate management, and the penalties differed between the 2013 OHI global and Fiji analysis.  For the Fiji analysis no penalties were applied for taxa reported at the species, genus, and family levels because given the diversity of species in the tropics, it is not uncommon for fisheries to be managed at the family level.  Penalties were applied to taxa reported at higher taxanomic levels (i.e., order, class, etc.).

Table describing the penalty for B/BMSY estimates based on the level of taxonomic reporting (calculated as: B/BMSY *penalty), a value of 1 indicates no penalty.  The 2013 OHI global analysis data is presented for comparison.

*Data:* We used the same catch data as the 2013 OHI global analysis.  We also used the same b/bmsy values for each stock/year, however, we used only the data generated using the constrained prior.    

*Time frame:* 
Status year: 2011
Trend years: 2007-2011
