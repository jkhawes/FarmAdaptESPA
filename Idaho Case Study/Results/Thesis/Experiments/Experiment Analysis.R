# Starting from a dataset with only the relevant observations but all variables. This is what would get disectly imported if 
## an experiment ever ran without a hitch (lol)

# So there are a few things that I want to accomplish here. I'd like to ... 
# 1. Summarize each run into a single observation. Do all values with a single experiment name? Or everything from a single run? 
# 1a. As part of this, I'll have to separately pull out the number of people who switched each year. 
# 2. Take the sumamrized data and compare the percent compositions of each observation to the actual percent compositions (only the first ten years) (paired t tests?)
# 3. Run regressions on a variety of things ... percent composition of each crop, number of folks who transfered. Use all varying values as predictors. 
# 3a. Can you run regressions on t test scores? 
# Things I'd like to do eventually ... 
# 1. Incorporate some temporality into the analysis. 

#===== Section 0: Pulling in packages =====
library(dplyr)
library(ggplot2)
library(ggthemes)


#===== Section 1: Creating summary datasets =====
d_tbl <- as_tibble(d_actual)
# d_GroupedBy_Run <- group_by(d_GroupedBy_Run,`[run number]`) # doesn't work when run in separate chunks - have to do a two-part group instead
d_GroupedBy_Exp <- group_by(d_tbl,ExperimentName)
summaryByExp <- summarise(d_GroupedBy_Exp,
                          count = n(),
                          acreage_total = sum(`"count patches with [PreferredLandUse = ""Alfalfa""]"` + `"count patches with [PreferredLandUse = ""Barley""]"` + 
                            `"count patches with [PreferredLandUse = ""Corn""]"` + `"count patches with [PreferredLandUse = ""Potatoes""]"` + 
                            `"count patches with [PreferredLandUse = ""Spring Wheat""]"` + `"count patches with [PreferredLandUse = ""Sugarbeets""]"` + 
                            `"count patches with [PreferredLandUse = ""Winter Wheat""]"` + `"count patches with [PreferredLandUse = ""Alfalfa_Perennial""]"`),
                          acreage_average = acreage_total / 3,
                          alfalfa_total = sum(`"count patches with [PreferredLandUse = ""Alfalfa""]"`),
                          alfalfa_average = alfalfa_total / 3,
                          alfalfa_percentage = alfalfa_average / acreage_average * 100,
                          barley_total = sum(`"count patches with [PreferredLandUse = ""Barley""]"`),
                          barley_average = barley_total / 3,
                          barley_percentage = barley_average / acreage_average * 100,
                          corn_total = sum(`"count patches with [PreferredLandUse = ""Corn""]"`),
                          corn_average = corn_total / 3,
                          corn_percentage = corn_average / acreage_average * 100,
                          potato_total = sum(`"count patches with [PreferredLandUse = ""Potatoes""]"`),
                          potato_average = potato_total / 3,
                          potato_percentage = potato_average / acreage_average * 100,
                          spring_wheat_total = sum(`"count patches with [PreferredLandUse = ""Spring Wheat""]"`),
                          spring_wheat_average = spring_wheat_total / 3,
                          spring_wheat_percentage = spring_wheat_average / acreage_average * 100,
                          sugarbeet_total = sum(`"count patches with [PreferredLandUse = ""Sugarbeets""]"`),
                          sugarbeet_average = sugarbeet_total / 3,
                          sugarbeet_percentage = sugarbeet_average / acreage_average * 100,
                          winter_wheat_total = sum(`"count patches with [PreferredLandUse = ""Winter Wheat""]"`),
                          winter_wheat_average = winter_wheat_total / 3,
                          winter_wheat_percentage = winter_wheat_average / acreage_average * 100,
                          alfalfa_perennial_total = sum(`"count patches with [PreferredLandUse = ""Alfalfa_Perennial""]"`),
                          alfalfa_perennial_average = alfalfa_perennial_total / 3,
                          alfalfa_perennial_percentage = alfalfa_perennial_average / acreage_average * 100,
                          alfalfa_total_percentage = alfalfa_percentage + alfalfa_perennial_percentage,
                          grain_percentage = corn_percentage + spring_wheat_percentage + winter_wheat_percentage,
                          total_percentage = alfalfa_percentage + alfalfa_perennial_percentage + corn_percentage + spring_wheat_percentage + 
                            winter_wheat_percentage + potato_percentage + sugarbeet_percentage + barley_percentage,
                          total_grouped_percentage = alfalfa_total_percentage + grain_percentage + potato_percentage + sugarbeet_percentage + barley_percentage
                          )
SummaryForExport <- select(summaryByExp,ExperimentName,alfalfa_total_percentage,barley_percentage,grain_percentage,potato_percentage,sugarbeet_percentage)
## Let's try summarizing by decision-making theory
d_GroupedBy_DM <- group_by(d_tbl,`Decision-Making3`)
summaryByDM <- summarise(d_GroupedBy_DM,
                          count = n(),
                          acreage_total = sum(`count patches with [PreferredLandUse = "Alfalfa"]` + `count patches with [PreferredLandUse = "Barley"]` + 
                                                `count patches with [PreferredLandUse = "Corn"]` + `count patches with [PreferredLandUse = "Potatoes"]` + 
                                                `count patches with [PreferredLandUse = "Spring Wheat"]` + `count patches with [PreferredLandUse = "Sugarbeets"]` + 
                                                `count patches with [PreferredLandUse = "Winter Wheat"]` + `count patches with [PreferredLandUse = "Alfalfa_Perennial"]`),
                          acreage_average = acreage_total / 3,
                          alfalfa_total = sum(`count patches with [PreferredLandUse = "Alfalfa"]`),
                          alfalfa_average = alfalfa_total / 3,
                          alfalfa_percentage = alfalfa_average / acreage_average * 100,
                          barley_total = sum(`count patches with [PreferredLandUse = "Barley"]`),
                          barley_average = barley_total / 3,
                          barley_percentage = barley_average / acreage_average * 100,
                          corn_total = sum(`count patches with [PreferredLandUse = "Corn"]`),
                          corn_average = corn_total / 3,
                          corn_percentage = corn_average / acreage_average * 100,
                          potato_total = sum(`count patches with [PreferredLandUse = "Potatoes"]`),
                          potato_average = potato_total / 3,
                          potato_percentage = potato_average / acreage_average * 100,
                          spring_wheat_total = sum(`count patches with [PreferredLandUse = "Spring Wheat"]`),
                          spring_wheat_average = spring_wheat_total / 3,
                          spring_wheat_percentage = spring_wheat_average / acreage_average * 100,
                          sugarbeet_total = sum(`count patches with [PreferredLandUse = "Sugarbeets"]`),
                          sugarbeet_average = sugarbeet_total / 3,
                          sugarbeet_percentage = sugarbeet_average / acreage_average * 100,
                          winter_wheat_total = sum(`count patches with [PreferredLandUse = "Winter Wheat"]`),
                          winter_wheat_average = winter_wheat_total / 3,
                          winter_wheat_percentage = winter_wheat_average / acreage_average * 100,
                          alfalfa_perennial_total = sum(`count patches with [PreferredLandUse = "Alfalfa_Perennial"]`),
                          alfalfa_perennial_average = alfalfa_perennial_total / 3,
                          alfalfa_perennial_percentage = alfalfa_perennial_average / acreage_average * 100,
                          alfalfa_total_percentage = alfalfa_percentage + alfalfa_perennial_percentage,
                          grain_percentage = corn_percentage + spring_wheat_percentage + winter_wheat_percentage,
                          total_percentage = alfalfa_percentage + alfalfa_perennial_percentage + corn_percentage + spring_wheat_percentage + 
                            winter_wheat_percentage + potato_percentage + sugarbeet_percentage + barley_percentage,
                          total_grouped_percentage = alfalfa_total_percentage + grain_percentage + potato_percentage + sugarbeet_percentage + barley_percentage,
                         `count farmers` = mean(`count farmers`)
                         
)
SummaryForExport <- select(summaryByDM,`Decision-Making3`,alfalfa_total_percentage,barley_percentage,grain_percentage,potato_percentage,sugarbeet_percentage)
AdaptationSummary <- select(SummaryByDM,`Decision-Making3`,NumberOfFarmersWhoAdaptIn2Years,`count farmers`)


# Generating my own tibble based on summary in Excel
d_summary <- tribble(
  ~ExperimentName, ~AlfalfaPercent, ~CornPercent, ~GrainPercent, ~PotatoesPercent, ~SugarbeetsPercent,
  "Cropscape",   "Cropscape",    17.11569,    23.77406,    12.90138,    19.07965,
  "TPB",   2,    20.249676,    25.46902,    21.59812,    26.58069,
  "IAC",   3,    5.972326,    22.95619,    27.88247,    21.35133,
  "RA",    0,    0,    29.9,    61.5,    8
)
d_summary_analysis <- tribble(
  ~AlfalfaPercent, ~CornPercent, ~GrainPercent, ~PotatoesPercent, ~SugarbeetsPercent,
  1,    17.11569,    23.77406,    12.90138,    19.07965,
  2,    20.249676,    25.46902,    21.59812,    26.58069,
  3,    5.972326,    22.95619,    27.88247,    21.35133,
  0,    0,    29.9,    61.5,    8
)
summary_dist <- dist(d_summary_analysis)
heatmap(as.matrix(summary_dist))
heat_data <- tribble(
  ~X, ~Y, ~Z,
  1, 1, 0,
  1, 2, 12.06622,
  1, 3, 18.93243,
  1, 4, 53.06655,
  2, 1, 0,
  2, 2, 0,
  2, 3, 16.67322,
  2, 4, 48.69379,
  3, 1, 0,
  3, 2, 0,
  3, 3, 0,
  3, 4, 37.43369, 
  4, 1, 0,
  4, 2, 0,
  4, 3, 0,
  4, 4, 0
  
)
ggplot(heat_data, aes(X, Y, z= Z)) + geom_tile(aes(fill = Z)) + theme_bw()
heat_data_named <- tribble(
  ~Theory, ~Theory., ~Distance,
  "USDA NASS", "USDA NASS", 0,
  "USDA NASS", "TPB", 0,
  "USDA NASS", "IAC", 0,
  "USDA NASS", "RA", 0,
  "TPB", "USDA NASS", 12.06622,
  "TPB", "TPB", 0,
  "TPB", "IAC", 0,
  "TPB", "RA", 0,
  "IAC", "USDA NASS", 18.93243,
  "IAC", "TPB", 16.67322,
  "IAC", "IAC", 0,
  "IAC", "RA", 37.43369, 
  "RA", "USDA NASS", 53.06655,
  "RA", "TPB", 48.69379,
  "RA", "IAC", 0,
  "RA", "RA", 0
  
)
ggplot(heat_data_named, aes(Theory, Theory., z= Distance)) + geom_tile(aes(fill = Distance),color="black") + geom_text(aes(label = round(Distance, 1)))
plot(hclust(summary_dist))

dendro_data <- tribble(
  ~Name, ~Cropscape, ~TPB, ~IAC, ~RA,
  "Cropscape",    0,    12.06622,    18.93243,    53.06655,
  "TPB",    12.06622,    0,    16.67322,    48.69379,
  "IAC",    18.93243,    16.67322,    0,    37.43369,
  "RA",    53.06655,    48.69379,    37.43369,    0
)
plot(hclust(dendro_data))
plot(hclust(summary_dist))
dendro_data <- summary_dist
names(dendro_data) <- c("Cropscape","TPB","IAC","RA")
plot(hclust(dendro_data))
dendro_dist <- as.matrix(dist(d_summary_analysis),labels=TRUE)
colnames(dendro_dist) <- rownames(dendro_dist) <- c("Cropscape","TPB","IAC","RA")
plot(hclust(dendro_dist))
