#### Eastern Snake Plain - Farmer Adaptation Model (ESP-FAM)
#### Version 1.0, 2019-03-03
## To do before running: 
#   1. Download NetLogo - This agent-based modeling platform 
#   2. ...
#   3. Install all packages below ... Use code on next lines
##     install.packages("RNetlogo")
#   4. Change the setwd code below, which sets the working directory to the proper location to find the data file ... probably the github directory on your computer. 
#   5. 



# ======= Section 0: Declarations and Preparing Files =========
# Leave uncommented if you want to clear the environment at the start of the run - WARNING - will erase all current variables and data!  
#rm(list=ls())

#Set the working directory so it can find the correct file. This will need to be changed on different computers. 
#setwd("C:/Users/hawes0/GitHub/ESPA-CAMP-ABM/Programming Working Folder")

library(RNetLogo)

# the initialization function
prepro <- function(dummy, gui, nl.path, nl.jarname, model.path) {
  library(RNetLogo)
  NLStart(nl.path=nl.path,gui=TRUE, nl.obj=NULL, is3d=FALSE, nl.jarname=nl.jarname)
  NLLoadModel(model.path)
}
# the simulation function
## Need to set Generating Worlds, FixRandomSeed?, RandomSeed, Animate?, and PopulateMethod prior to importing a world. 
## To import the world, we need the WorldFileName
simfun <- function(ExperimentDF) 
  ##Use the following variables in a data frame to supply the variables for the function. 
  # FixRandomSeed,RandomSeed,PopulateMethod,WorldFileName,Animate, #End of Stage 1 Variables
  # ExperimentName,DecisionMaking,NumberOfSeasons,Tracers,WriteCropBudgets,WriteDetailedCropBudgets,WriteOutputs,StartingTicks,
  # ExperimentalToleranceForLoss,PerceptionThreshold,BeliefInSocialSanctionsAverage,SimulateESPA_CAMP,ExperimentVariablesFile,
  # PrintReporters,IACPhysArousThreshold,F_Ratio_V,RandomStartingMoney,F_Ratio_W,UseRandomRotations,WaterRightDistribution,RunNumber,
  # TypicalAmountFarmerIsWillingToLosePerField,ROISeasonTolerance,SocialConnectionsperFarmer,InputIntensityDistribution,
  # LognormalSigma,InternalScalar,IndividualFieldCalcs,BeliefInESPASD,GeneratingWorlds,BeliefInSocialSanctionsSD,ExternalScalar,
  # EfficacyScalar,AcreageDistributionType,RhythmScalar,InterfaceVariableFileName,BeliefInESPAAverage,CustomFarmerAccess,
  # BeliefsInEconomicSanctionsSD,waterpreference,OffsetIrrigationWithSkill,ChargeForOverdraw,ConsultantsperFarmer,BeliefInEconomicSanctionsAverage,
  # UseAquaCrop,PercVarWillingnessToLose,GWD,WaterRightSeniorityDistribution
  #End of Stage 2 Variables
{
  # view(ExperimentDF)
  # IntroPrint <- cat("Starting a simulation in ", ExperimentDF$WorldFileName, " with ", ExperimentDF$DecisionMaking, " for ", ExperimentDF$NumberOfSeasons, " years.\n", sep="")
  # Beginning setup with initialization - first need to use stage 0 to clear NetLogo
  NLCommand("setupStage0R")
  NLCommand("set FixRandomSeed?", ExperimentDF$FixRandomSeed)
  NLCommand("set RandomSeed", ExperimentDF$RandomSeed)
  NLCommand("set PopulateMethod", ExperimentDF$PopulateMethod)
  NLCommand("set WorldFileName", ExperimentDF$WorldFileName)
  NLCommand("set Animate?", ExperimentDF$Animate)
  NLCommand("setupStage1R")
  # Initialize new variables before Setup Stage 2
  NLCommand("set FixRandomSeed?", ExperimentDF$FixRandomSeed)
  NLCommand("set RandomSeed", ExperimentDF$RandomSeed)
  NLCommand("set ExperimentName", ExperimentDF$ExperimentName)
  NLCommand("set Decision-Making", ExperimentDF$DecisionMaking)
  NLCommand("set NumberOfSeasons", ExperimentDF$NumberOfSeasons)
  NLCommand("set Tracers?", ExperimentDF$Tracers)
  NLCommand("set WriteCropBudgets?", ExperimentDF$WriteCropBudgets)
  NLCommand("set WriteDetailedCropBudgets?", ExperimentDF$WriteDetailedCropBudgets)
  NLCommand("set WriteOutputs?", ExperimentDF$WriteOutputs)
  NLCommand("set StartingTicks", ExperimentDF$StartingTicks)
  NLCommand("set ExperimentalToleranceforLoss", ExperimentDF$ExperimentalToleranceForLoss)
  NLCommand("set PerceptionThreshold", ExperimentDF$PerceptionThreshold)
  NLCommand("set BeliefInSocialSanctionsAverage", ExperimentDF$BeliefInSocialSanctionsAverage)
  NLCommand("set Simulate-ESPA_CAMP", ExperimentDF$SimulateESPA_CAMP)
  NLCommand("set ExperimentVariablesFile", ExperimentDF$ExperimentVariablesFile)
  NLCommand("set PrintReporters?", ExperimentDF$PrintReporters)
  NLCommand("set IAC-PhysArous-Threshold", ExperimentDF$IACPhysArousThreshold)
  NLCommand("set F-Ratio-V", ExperimentDF$F_Ratio_V)
  NLCommand("set RandomStartingMoney", ExperimentDF$RandomStartingMoney)
  NLCommand("set F-Ratio-W", ExperimentDF$F_Ratio_W)
  NLCommand("set UseRandomRotations?", ExperimentDF$UseRandomRotations)
  NLCommand("set WaterRightDistribution", ExperimentDF$WaterRightDistribution)
  NLCommand("set Run-Number", ExperimentDF$RunNumber)
  NLCommand("set TypicalAmountFarmerIsWillingToLosePerField", ExperimentDF$TypicalAmountFarmerIsWillingToLosePerField)
  NLCommand("set Animate?", ExperimentDF$Animate)
  NLCommand("set ROISeasonTolerance", ExperimentDF$ROISeasonTolerance)
  NLCommand("set Social-Connections-per-Farmer", ExperimentDF$SocialConnectionsperFarmer)
  NLCommand("set InputIntensityDistribution", ExperimentDF$InputIntensityDistribution)
  NLCommand("set Lognormal-Sigma", ExperimentDF$LognormalSigma)
  NLCommand("set InternalScalar", ExperimentDF$InternalScalar)
  NLCommand("set IndividualFieldCalcs?", ExperimentDF$IndividualFieldCalcs)
  NLCommand("set BeliefInESPASD", ExperimentDF$BeliefInESPASD)
  NLCommand("set GeneratingWorlds?", ExperimentDF$GeneratingWorlds)
  NLCommand("set BeliefInSocialSanctionsSD", ExperimentDF$BeliefInSocialSanctionsSD)
  NLCommand("set ExternalScalar", ExperimentDF$ExternalScalar)
  NLCommand("set EfficacyScalar", ExperimentDF$EfficacyScalar)
  NLCommand("set AcreageDistributionType", ExperimentDF$AcreageDistributionType)
  NLCommand("set RhythmScalar", ExperimentDF$RhythmScalar)
  NLCommand("set InterfaceVariableFileName", ExperimentDF$InterfaceVariableFileName)
  NLCommand("set BeliefInESPAAverage", ExperimentDF$BeliefInESPAAverage)
  NLCommand("set CustomFarmerAccess", ExperimentDF$CustomFarmerAccess)
  NLCommand("set PopulateMethod", ExperimentDF$PopulateMethod)
  NLCommand("set BeliefsInEconomicSanctionsSD", ExperimentDF$BeliefsInEconomicSanctionsSD)
  NLCommand("set water-preference", ExperimentDF$waterpreference)
  NLCommand("set OffsetIrrigationWithSkill?", ExperimentDF$OffsetIrrigationWithSkill)
  NLCommand("set ChargeForOverdraw", ExperimentDF$ChargeForOverdraw)
  NLCommand("set Consultants-per-Farmer", ExperimentDF$ConsultantsperFarmer)
  NLCommand("set BeliefInEconomicSanctionsAverage", ExperimentDF$BeliefInEconomicSanctionsAverage)
  NLCommand("set Use-Aqua-Crop", ExperimentDF$UseAquaCrop)
  NLCommand("set PercVarWillingnessToLose", ExperimentDF$PercVarWillingnessToLose)
  NLCommand("set GWD", ExperimentDF$GWD)
  NLCommand("set WaterRightSeniorityDistribution", ExperimentDF$WaterRightSeniorityDistribution)
  NLCommand("setupStage2R")
  # Setup complete
  i <- 1
  while (i <= ExperimentDF$NumberOfSeasons) {
    NLCommand("SimulateASeasonR")
    i <- i + 1
  }
  NLCommand("EvaluateRunR")
  ret <- data.frame(ExperimentDF$WorldFileName,ExperimentDF$DecisionMaking,ExperimentDF$NumberOfSeasons,
                    ExperimentDF$RandomSeed,ExperimentDF$ExperimentalToleranceForLoss,ExperimentDF$BeliefInSocialSanctionsAverage,
                    ExperimentDF$SimulateESPA_CAMP,ExperimentDF$ROISeasonTolerance,ExperimentDF$SocialConnectionsperFarmer,
                    ExperimentDF$BeliefInEconomicSanctionsAverage, NLReport("timer"),
                    NLReport("item 0 NumberOfFarmersWithChangedWM"),NLReport("item 1 NumberOfFarmersWithChangedWM"),NLReport("item 2 NumberOfFarmersWithChangedWM"),
                    NLReport("item 3 NumberOfFarmersWithChangedWM"),NLReport("item 4 NumberOfFarmersWithChangedWM"),NLReport("item 5 NumberOfFarmersWithChangedWM"),
                    NLReport("item 6 NumberOfFarmersWithChangedWM"),NLReport("item 7 NumberOfFarmersWithChangedWM"),NLReport("item 8 NumberOfFarmersWithChangedWM"),
                    NLReport("item 9 NumberOfFarmersWithChangedWM"),NLReport("item 10 NumberOfFarmersWithChangedWM"),NLReport("item 11 NumberOfFarmersWithChangedWM"),
                    NLReport("item 12 NumberOfFarmersWithChangedWM"),NLReport("item 13 NumberOfFarmersWithChangedWM"),NLReport("item 14 NumberOfFarmersWithChangedWM"),
                    NLReport("item 15 NumberOfFarmersWithChangedWM"),NLReport("item 16 NumberOfFarmersWithChangedWM"),NLReport("item 17 NumberOfFarmersWithChangedWM"),
                    NLReport("item 18 NumberOfFarmersWithChangedWM"),NLReport("item 19 NumberOfFarmersWithChangedWM"),
                    NLReport("count turtles"), NLReport("potato-count"), NLReport("beet-count"), 
                    NLReport("alfalfa-count"), NLReport("a-p-count"), NLReport("alfalfa-total-count"), 
                    NLReport("sw-count"), NLReport("ww-count"), NLReport("corn-count"), 
                    NLReport("grain-count"), NLReport("barley-count"), NLReport("total-crops"))
  names(ret) <- c("WorldFile","Decision making","Number of Seasons","RandomSeed","Tolerance for Loss","Belief in Social Sanctions",
                  "Simulate CAMP?","ROI Tolerance","Social Connections","Belief in Economic Sanctions","Length of sim (sec)",
                  "Infra Changes, Yr 1","Infra Changes, Yr 2","Infra Changes, Yr 3","Infra Changes, Yr 4","Infra Changes, Yr 5",
                  "Infra Changes, Yr 6","Infra Changes, Yr 7","Infra Changes, Yr 8","Infra Changes, Yr 9","Infra Changes, Yr 10",
                  "Infra Changes, Yr 11","Infra Changes, Yr 12","Infra Changes, Yr 13","Infra Changes, Yr 14","Infra Changes, Yr 15",
                  "Infra Changes, Yr 16","Infra Changes, Yr 17","Infra Changes, Yr 18","Infra Changes, Yr 19","Infra Changes, Yr 20",
                  "Turtles","Potatoes","Beets","Alfalfa","Alf-Per","Alf-Tot","Spr-Wht","Wint-Wht","Corn","Grain","Barley","Total")
  print(ret)
  writeLines("End of Simulation.\n")
  return(ret)
}
# Run evaluation
evaluateSim <- function()
{
  NLCommand("EvaluateRunR")
  res <- data.frame(ExperimentDF$WorldFileName,ExperimentDF$DecisionMaking,ExperimentDF$NumberOfSeasons,
                    ExperimentDF$RandomSeed,ExperimentDF$ExperimentalToleranceForLoss,ExperimentDF$BeliefInSocialSanctionsAverage,
                    ExperimentDF$SimulateESPA_CAMP,ExperimentDF$ROISeasonTolerance,ExperimentDF$SocialConnectionsperFarmer,
                    ExperimentDF$BeliefInEconomicSanctionsAverage,
                    NLReport("count turtles"), NLReport("potato-count"), NLReport("beet-count"), 
                    NLReport("alfalfa-count"), NLReport("a-p-count"), NLReport("alfalfa-total-count"), 
                    NLReport("sw-count"), NLReport("ww-count"), NLReport("corn-count"), 
                    NLReport("grain-count"), NLReport("barley-count"), NLReport("total-crops"))
  names(res) <- c("WorldFile","Decision making","Number of Seasons","RandomSeed","Tolerance for Loss","Belief in Social Sanctions",
                  "Simulate CAMP?","ROI Tolerance","Social Connections","Belief in Economic Sanctions","Turtles","Potatoes","Beets",
                  "Alfalfa","Alf-Per","Alf-Tot","Spr-Wht","Wint-Wht","Corn","Grain","Barley","Total")
  print(res)
  return(res)
}
# the quit function
postpro <- function(x) {
  NLQuit()
}

testfun <- function(ExperimentDF){
  ExperimentDF
  
  ExperimentDF$FixRandomSeed 
  ExperimentDF$RandomSeed
  ExperimentDF$PopulateMethod
  ExperimentDF$WorldFileName
  ExperimentDF$Animate 
  ExperimentDF$ExperimentName
  ExperimentDF$DecisionMaking
  ExperimentDF$NumberOfSeasons
  ExperimentDF$Tracers
  ExperimentDF$WriteCropBudgets
  ExperimentDF$WriteDetailedCropBudgets 
  return(ExperimentDF)
}


# ======= End Section 0: Declarations and Preparing Files =====


# ======= Section 1: Simulation =========

#Set universal variables
nl.path <- "C:/Program Files/NetLogo 6.0.2/app"
gui <- FALSE
nl.jarname <- "netlogo-6.0.2.jar"
model.path <- "~/GitHub/ESPA-CAMP-ABM/Programming Working Folder/ESPA Farmer Adaptation Model.nlogo"

##Set simulation variable lists - get imported into a dataframe for passing.
#Actual variables that vary
WorldFileName_list <- c("\"Aberdeen-American Falls GWD_EmptyWorld_Run 1_InformedRotations\"","\"Aberdeen-American Falls GWD_EmptyWorld_Run 2_InformedRotations\"","\"Aberdeen-American Falls GWD_EmptyWorld_Run 3_InformedRotations\"",
                        "\"Bingham GWD_EmptyWorld_Run 1_InformedRotations\"","\"Bingham GWD_EmptyWorld_Run 2_InformedRotations\"","\"Bingham GWD_EmptyWorld_Run 3_InformedRotations\"",
                        "\"Bonneville-Jefferson GWD_EmptyWorld_Run 1_InformedRotations\"","\"Bonneville-Jefferson GWD_EmptyWorld_Run 2_InformedRotations\"","\"Bonneville-Jefferson GWD_EmptyWorld_Run 3_InformedRotations\"",
                        "\"Carey Valley GWD_EmptyWorld_Run 1_InformedRotations\"","\"Carey Valley GWD_EmptyWorld_Run 2_InformedRotations\"","\"Carey Valley GWD_EmptyWorld_Run 3_InformedRotations\"",
                        "\"Jefferson-Clark GWD_EmptyWorld_Run 1_InformedRotations\"","\"Jefferson-Clark GWD_EmptyWorld_Run 2_InformedRotations\"","\"Jefferson-Clark GWD_EmptyWorld_Run 3_InformedRotations\"",
                        "\"Magic Valley GWD_EmptyWorld_Run 1_InformedRotations\"","\"Magic Valley GWD_EmptyWorld_Run 2_InformedRotations\"","\"Magic Valley GWD_EmptyWorld_Run 3_InformedRotations\"",
                        "\"North Snake GWD_EmptyWorld_Run 1_InformedRotations\"","\"North Snake GWD_EmptyWorld_Run 2_InformedRotations\"","\"North Snake GWD_EmptyWorld_Run 3_InformedRotations\"")
DecisionMaking_list <- c("\"Theory of Planned Behavior\"","\"IAC Framework\"","\"Rational Actor Theory\"")
ExperimentalToleranceForLoss_list <- 5000
ChargeForOverdraw_list <- 100
BeliefInSocialSanctionsAverage_list <- 0.5
SimulateESPA_CAMP_list <- TRUE
ROISeasonTolerance_list <- 20
SocialConnectionsperFarmer_list <- 3
BeliefInEconomicSanctionsAverage_list <- 0.5
RandomSeed_list <- 15

# # For testing
# WorldFileName_list <- c("\"Aberdeen-American Falls GWD_EmptyWorld_Run 1_InformedRotations\"",
#                         # "\"Bingham GWD_EmptyWorld_Run 1_InformedRotations\"",
#                         # "\"Bonneville-Jefferson GWD_EmptyWorld_Run 1_InformedRotations\"",
#                         # "\"Carey Valley GWD_EmptyWorld_Run 1_InformedRotations\"",
#                         # "\"Jefferson-Clark GWD_EmptyWorld_Run 1_InformedRotations\"",
#                         "\"Magic Valley GWD_EmptyWorld_Run 1_InformedRotations\"",
#                         "\"North Snake GWD_EmptyWorld_Run 1_InformedRotations\"")
# DecisionMaking_list <- "\"Theory of Planned Behavior\""
# ExperimentalToleranceForLoss_list <- 5000
# ChargeForOverdraw_list <- 100
# BeliefInSocialSanctionsAverage_list <- 0.5
# SimulateESPA_CAMP_list <- TRUE
# ROISeasonTolerance_list <- 20
# SocialConnectionsperFarmer_list <- 3
# BeliefInEconomicSanctionsAverage_list <- 0.5
# RandomSeed_list <- 15

##Stage 1 inputs that do not vary
FixRandomSeed <- TRUE
PopulateMethod <- "\"Experimental\""
Animate <- FALSE

##Stage 2 inputs that do not vary
ExperimentName <- "\"All Districts_DM\""
ExperimentalToleranceForLoss <- 5000
BeliefInSocialSanctionsAverage <- 0.5
# SimulateESPA_CAMP <- TRUE
ROISeasonTolerance <- 5
SocialConnectionsperFarmer <- 3
BeliefInEconomicSanctionsAverage <- 0.5
NumberOfSeasons <- 20
Tracers <- FALSE
WriteCropBudgets <- FALSE
WriteDetailedCropBudgets <- FALSE
WriteOutputs <- FALSE
StartingTicks <- 0
PerceptionThreshold <- 0.5
ExperimentVariablesFile <- "\"ExperimentVariables.txt\""
PrintReporters <- FALSE
IACPhysArousThreshold <- 2.5
F_Ratio_V <- 0
RandomStartingMoney <- FALSE
F_Ratio_W <- 0
UseRandomRotations <- TRUE
WaterRightDistribution <- "\"Normal\""
RunNumber <- 0
TypicalAmountFarmerIsWillingToLosePerField <- 2500
Animate <- FALSE
InputIntensityDistribution <- "\"Random\""
LognormalSigma <- 0
InternalScalar <- 1
IndividualFieldCalcs <- TRUE
BeliefInESPASD <- 0.1
GeneratingWorlds <- FALSE
BeliefInSocialSanctionsSD <- 0.1
ExternalScalar <- 1
EfficacyScalar <- 1
AcreageDistributionType <- "\"Categorical\""
RhythmScalar <- 1
InterfaceVariableFileName <- "\"InterfaceVariables.txt\""
BeliefInESPAAverage <- 0.5
CustomFarmerAccess <- 100
PopulateMethod <- "\"Random\""
BeliefsInEconomicSanctionsSD <- 0.1
waterpreference <- 100
OffsetIrrigationWithSkill <- FALSE
# ChargeForOverdraw <- 100
ConsultantsperFarmer <- 2
UseAquaCrop <- FALSE
PercVarWillingnessToLose <- 5
GWD <- "\"Magic Valley GWD\""
WaterRightSeniorityDistribution <- "\"Uniform\""


# Putting all of these variables into a list of dataframes for processing in NetLogo
N <- length(WorldFileName_list) * length(DecisionMaking_list) * length(RandomSeed_list)
ExperimentList <- vector("list",N)

i <- 1
for (RandomSeed in RandomSeed_list) {
  for (WorldFileName in WorldFileName_list) {
    for (DecisionMaking in DecisionMaking_list) {
      for (SimulateESPA_CAMP in SimulateESPA_CAMP_list) {
        for (ChargeForOverdraw in ChargeForOverdraw_list) {
      ExperimentDF <- data.frame(RandomSeed,
                                 WorldFileName,
                                 DecisionMaking,SimulateESPA_CAMP,ChargeForOverdraw)
      
      ExperimentDF$FixRandomSeed <- FixRandomSeed
      #ExperimentDF$RandomSeed<- RandomSeed 
      ExperimentDF$PopulateMethod <- PopulateMethod
      #ExperimentDF$WorldFileName <- WorldFileName
      ExperimentDF$Animate <- Animate
      ExperimentDF$ExperimentName <- ExperimentName
      # ExperimentDF$DecisionMaking <- DecisionMaking
      ExperimentDF$NumberOfSeasons <- NumberOfSeasons
      ExperimentDF$Tracers <- Tracers
      ExperimentDF$WriteCropBudgets <- WriteCropBudgets
      ExperimentDF$WriteDetailedCropBudgets <- WriteDetailedCropBudgets 
      ExperimentDF$WriteOutputs <- WriteOutputs
      ExperimentDF$StartingTicks <- StartingTicks
      ExperimentDF$ExperimentalToleranceForLoss <- ExperimentalToleranceForLoss
      ExperimentDF$PerceptionThreshold <- PerceptionThreshold
      ExperimentDF$BeliefInSocialSanctionsAverage <- BeliefInSocialSanctionsAverage
      # ExperimentDF$SimulateESPA_CAMP <- SimulateESPA_CAMP
      ExperimentDF$ExperimentVariablesFile <- ExperimentVariablesFile
      ExperimentDF$PrintReporters <- PrintReporters
      ExperimentDF$IACPhysArousThreshold <- IACPhysArousThreshold
      ExperimentDF$F_Ratio_V <- F_Ratio_V
      ExperimentDF$RandomStartingMoney <- RandomStartingMoney
      ExperimentDF$F_Ratio_W <- F_Ratio_W
      ExperimentDF$UseRandomRotations <- UseRandomRotations
      ExperimentDF$WaterRightDistribution <- WaterRightDistribution
      ExperimentDF$RunNumber <- RunNumber
      ExperimentDF$TypicalAmountFarmerIsWillingToLosePerField <- TypicalAmountFarmerIsWillingToLosePerField
      ExperimentDF$ROISeasonTolerance <- ROISeasonTolerance
      ExperimentDF$SocialConnectionsperFarmer <- SocialConnectionsperFarmer
      ExperimentDF$InputIntensityDistribution <- InputIntensityDistribution
      ExperimentDF$LognormalSigma <- LognormalSigma
      ExperimentDF$InternalScalar <- InternalScalar
      ExperimentDF$IndividualFieldCalcs <- IndividualFieldCalcs
      ExperimentDF$BeliefInESPASD <- BeliefInESPASD
      ExperimentDF$GeneratingWorlds <- GeneratingWorlds
      ExperimentDF$BeliefInSocialSanctionsSD <- BeliefInSocialSanctionsSD
      ExperimentDF$ExternalScalar <- ExternalScalar
      ExperimentDF$EfficacyScalar <- EfficacyScalar
      ExperimentDF$AcreageDistributionType <- AcreageDistributionType
      ExperimentDF$RhythmScalar <- RhythmScalar
      ExperimentDF$InterfaceVariableFileName <- InterfaceVariableFileName
      ExperimentDF$BeliefInESPAAverage <- BeliefInESPAAverage
      ExperimentDF$CustomFarmerAccess <- CustomFarmerAccess
      ExperimentDF$BeliefsInEconomicSanctionsSD <- BeliefsInEconomicSanctionsSD
      ExperimentDF$waterpreference <- waterpreference
      ExperimentDF$OffsetIrrigationWithSkill <- OffsetIrrigationWithSkill
      # ExperimentDF$ChargeForOverdraw <- ChargeForOverdraw
      ExperimentDF$ConsultantsperFarmer <- ConsultantsperFarmer
      ExperimentDF$BeliefInEconomicSanctionsAverage <- BeliefInEconomicSanctionsAverage
      ExperimentDF$UseAquaCrop <- UseAquaCrop
      ExperimentDF$PercVarWillingnessToLose <- PercVarWillingnessToLose 
      ExperimentDF$GWD <- GWD
      ExperimentDF$WaterRightSeniorityDistribution <- WaterRightSeniorityDistribution 
        
      ExperimentList[[i]] <- ExperimentDF
      i <- i + 1
        }
      }
    }
  }
}



##Dataframe to append results to
ExperimentResults <- data.frame("Name:","Theory:",0,0,0,0,TRUE, #New lines to make it easier to tell what is assigned where (see column names below)
                                0,0,0,0,0,0,0,0,
                                0,0,0,0,0,0)
names(ExperimentResults) <- c("WorldFile","Decision making","Number of Seasons","Turtles","Tolerance for Loss","Social Sanctions","Settlement Active",
                              "ROI Limits","Number of Network Connections","Economic Santions","Potatoes","Beets","Alfalfa","Alf-Per","Alf-Tot",
                              "Spr-Wht","Wint-Wht","Corn","Grain","Barley","Total")
#Output File for the results
OutputFile <- "~/GitHub/ESPA-CAMP-ABM/Programming Working Folder/R/Thesis Experiment Output/Experiment Test - 20190712.csv"

# #Writing new unparallelized functions, because parallel doesn't play nice with ISU computer. 
# #Call functions (running not in parallel)
# #Setup NetLogo (not model setup)
# prepro(gui = gui, nl.path = nl.path, nl.jarname = nl.jarname, model.path = model.path)
# ##Run simulation
# for (WorldFileName_i in WorldFileName) {
#   ExperimentResults <- rbind(ExperimentResults,simfun(ExperimentList))
# }
# ##Kill simulation
# postpro()


#Running simulations in parallel

##Setup
# load the parallel package, if not already done
library(parallel)
# detect the number of cores available
processors <- detectCores() - 1

# create cluster
# # When you want to run a sim that outputs as it goes (testing new timings, etc.), use this outfile input
# cl <- makeCluster(processors,outfile=OutputFile)
# Otherwise, this should do. 
cl <- makeCluster(processors,outfile="")

# load NetLogo in each processor/core
invisible(parLapply(cl, 1:processors, prepro, gui=gui, nl.path=nl.path, nl.jarname = nl.jarname, model.path=model.path))



#After the initialization is done in all processors, we can run the simulation. 
# run a simulation for each combination of values by calling parallel sapply
##Run simulation 
results_parallel <- parSapply(
  #Parallelized clusters first
  cl,
  # Input the varying variable
  ExperimentList,
  #Function name
  FUN=simfun,
  #Other variable inputs would go here
  # Trying to change the output with simplify
  simplify=FALSE,
  # Use name of world for output
  USE.NAMES=TRUE
)

#To reformat the results - this needs rewritten for more than 3 sims. 
finalResults <- rbind(results_parallel[[1]],results_parallel[[2]],results_parallel[[3]],results_parallel[[4]],results_parallel[[5]],results_parallel[[6]],results_parallel[[7]],results_parallel[[8]],results_parallel[[9]],results_parallel[[10]],
                      results_parallel[[11]],results_parallel[[12]],results_parallel[[13]],results_parallel[[14]],results_parallel[[15]],results_parallel[[16]],results_parallel[[17]],results_parallel[[18]],results_parallel[[19]],results_parallel[[20]],
                      results_parallel[[21]],results_parallel[[22]],results_parallel[[23]],results_parallel[[24]],results_parallel[[25]],results_parallel[[26]],results_parallel[[27]],results_parallel[[28]],results_parallel[[29]],results_parallel[[30]],
                      results_parallel[[31]],results_parallel[[32]],results_parallel[[33]],results_parallel[[34]],results_parallel[[35]],results_parallel[[36]],results_parallel[[37]],results_parallel[[38]],results_parallel[[39]],results_parallel[[40]],
                      results_parallel[[41]],results_parallel[[42]],results_parallel[[43]],results_parallel[[44]],results_parallel[[45]],results_parallel[[46]],results_parallel[[47]],results_parallel[[48]],results_parallel[[49]],results_parallel[[50]],
                      results_parallel[[51]],results_parallel[[52]],results_parallel[[53]],results_parallel[[54]],results_parallel[[55]],results_parallel[[56]],results_parallel[[57]],results_parallel[[58]],results_parallel[[59]],results_parallel[[60]],
                      results_parallel[[61]],results_parallel[[62]],results_parallel[[63]])

# Quit NetLogo in each processor/core
invisible(parLapply(cl, 1:processors, postpro))
# stop cluster
stopCluster(cl)




#Old, out-of-date functions to call not run in parallel. Need to update with Dataframe method before use.
#Call functions (running not in parallel)
#Setup NetLogo (not model setup)
prepro(gui = gui, nl.path = nl.path, nl.jarname = nl.jarname, model.path = model.path)
##Run simulation
for (WorldFileName_i in WorldFileName) {
  ExperimentResults <- rbind(ExperimentResults,
                             simfun(FixRandomSeed=FixRandomSeed,RandomSeed=RandomSeed,PopulateMethod=PopulateMethod,WorldFileName=WorldFileName_i,Animate=Animate, #End of Stage 1 Variables
                                    ExperimentName=ExperimentName,DecisionMaking=DecisionMaking,NumberOfSeasons=NumberOfSeasons,Tracers=Tracers,WriteCropBudgets=WriteCropBudgets,
                                    WriteDetailedCropBudgets=WriteDetailedCropBudgets,WriteOutputs=WriteOutputs,StartingTicks=StartingTicks,
                                    ExperimentalToleranceForLoss=ExperimentalToleranceForLoss,PerceptionThreshold=PerceptionThreshold,
                                    BeliefInSocialSanctionsAverage=BeliefInSocialSanctionsAverage,SimulateESPA_CAMP=SimulateESPA_CAMP,ExperimentVariablesFile=ExperimentVariablesFile,
                                    PrintReporters=PrintReporters,IACPhysArousThreshold=IACPhysArousThreshold,F_Ratio_V=F_Ratio_V,RandomStartingMoney=RandomStartingMoney,F_Ratio_W=F_Ratio_W,
                                    UseRandomRotations=UseRandomRotations,WaterRightDistribution=WaterRightDistribution,RunNumber=RunNumber,TypicalAmountFarmerIsWillingToLosePerField=TypicalAmountFarmerIsWillingToLosePerField,
                                    ROISeasonTolerance=ROISeasonTolerance,SocialConnectionsperFarmer=SocialConnectionsperFarmer,InputIntensityDistribution=InputIntensityDistribution,LognormalSigma=LognormalSigma,
                                    InternalScalar=InternalScalar,IndividualFieldCalcs=IndividualFieldCalcs,BeliefInESPASD=BeliefInESPASD,GeneratingWorlds=GeneratingWorlds,BeliefInSocialSanctionsSD=BeliefInSocialSanctionsSD,
                                    ExternalScalar=ExternalScalar,EfficacyScalar=EfficacyScalar,AcreageDistributionType=AcreageDistributionType,RhythmScalar=RhythmScalar,InterfaceVariableFileName=InterfaceVariableFileName,
                                    BeliefInESPAAverage=BeliefInESPAAverage,CustomFarmerAccess=CustomFarmerAccess,BeliefsInEconomicSanctionsSD=BeliefsInEconomicSanctionsSD,waterpreference=waterpreference,
                                    OffsetIrrigationWithSkill=OffsetIrrigationWithSkill,ChargeForOverdraw=ChargeForOverdraw,ConsultantsperFarmer=ConsultantsperFarmer,BeliefInEconomicSanctionsAverage=BeliefInEconomicSanctionsAverage,
                                    UseAquaCrop=UseAquaCrop,PercVarWillingnessToLose=PercVarWillingnessToLose,GWD=GWD,WaterRightSeniorityDistribution=WaterRightSeniorityDistribution) #End of Stage 2 Variables
  )
}
##Kill simulation
postpro()

# ======= End Section 1: Simulation =====

# ======= Section 2: Analysis =========



# ======= End Section 2: Analysis =====

#Before closing session, close NetLogo, then restart R. 
NLQuit()
.rs.restartR()
