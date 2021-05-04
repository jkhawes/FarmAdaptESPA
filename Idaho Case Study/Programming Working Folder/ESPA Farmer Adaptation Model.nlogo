; READ-ME in brief: Preparing to run this program
;; 1. Create a folder heirarchy with a primary working folder for your program and data subfolders for your inputs and components.
;; 2. Prepare inputs as described in the READ-ME. Update the component addresses in the includes section below and the Working Directory on the GUI.
;; 3. Make sure GIS add-in is installed.


__includes
[ ;; need to add comments on each of these identifying which commands reside in each.
  "./Components/Setup/Animate.nls"
  "./Components/Setup/Demographics.nls"
  "./Components/Setup/DrawDistrict.nls"
  "./Components/Setup/DrawDoI.nls"
  "./Components/Setup/DrawWorld.nls"
  "./Components/Setup/Equipment.nls"
  "./Components/Setup/IDAPD.nls"
  "./Components/Setup/ImportVariables.nls"
  "./Components/Setup/ImportGWDGISFiles.nls"
  "./Components/Setup/MiscInitialization.nls"
  "./Components/Setup/ParameterizeDistrict.nls"
  "./Components/Setup/PopulateExperimental.nls"
  "./Components/Setup/PopulateRandom.nls"
  "./Components/Setup/PrepareFields.nls"
  "./Components/Setup/RandomDistributions.nls"
  "./Components/Setup/Rotation.nls"
  "./Components/Setup/SocialNetwork.nls"

  "./Components/PlanningSeason/CalculateReturns.nls"
  "./Components/PlanningSeason/CropBudget.nls"
  "./Components/PlanningSeason/DetermineLandUse.nls"
  "./Components/PlanningSeason/Irrigation.nls"
  "./Components/PlanningSeason/PlanningSeason.nls"
  "./Components/PlanningSeason/ROI.nls"
  "./Components/PlanningSeason/Settlement.nls"
  "./Components/PlanningSeason/SocialReturnFunctions.nls"
  "./Components/PlanningSeason/Weather.nls"

  "./Components/CropSeason/CropSeason.nls"
  "./Components/CropSeason/CropSimulation.nls"
  "./Components/CropSeason/AquaCropFunctions.nls"

  "./Components/Reconciliation/CatalogConditions.nls"
  "./Components/Reconciliation/KnowledgeSharing.nls"
  "./Components/Reconciliation/Reconcile.nls"
  "./Components/Reconciliation/tracers.nls"

  "./Components/UsingBehaviorSpace.nls"
  "./Components/UsingR.nls"
]

extensions
[
  gis ; for importing shapefiles
  csv ; for outputs
]

breed [ farmers farmer ] ; Main agent in the simulation. Simulates a farmer in the arid or semi-arid west who uses irrigation for all cash crops.
breed [ CropConsultants CropConsultant ] ; Networking agent - identified as one of three primary consultants of interest. Helps farmer agents choose new or novel crops.
breed [ Agronomists Agronomist ] ; Networking agent - identified as one of three primary consultants of interest. Helps farmer agents minimize cost of inputs.
breed [ IrrigationConsultants IrrigationConsultant ] ; Networking agent - identified as one of three primary consultants of interest. Helps farmer agents install new infrastructure or minimize input cost.
undirected-link-breed [ friendships friendship ] ; Link between farmers - designates "target" for knowledge sharing and social networking.
undirected-link-breed [ consultancies consultancy ] ; Link between farmer and consultant - designates that farmer has a certain type of consultant.

globals
[
  ; BehaviorSpace variables
  Is-Setup? ; currently unused, was originally used to kill system while generating worlds.
  Active-Farmer ; for monitoring which farmer is acting from the interface.
  StartingTicks ; for identifying a start time for simulation
  ExperimentName ; for tracking which experiment is running
  ExperimentList ; for importing the list of experiments to behavior space
  ExperimentalToleranceforLoss ; Variable used to vary tolerance for loss in pre-generated worlds

  ;Inputs - Crops
  LandUseList
  CropList ; an identical list to above without anything that isn't a crop - used for identifying how many AquaCrop simulations to run.
  WaterManagementList
  TypicalYield
  YieldVariability
  CommodityPrice
  PriceVariability
  CommodityPrice-CB
  TypicalYield-CB
  SeedPrice
  Fertilizer
  Pesticides
  CustomConsultants
  WaterAssessment
  IrrigationRepairs
  IrrigationPower
  MachineryAnnual
  FarmOwnership
  LaborCosts
  Crop-SpecificCosts
  MiscCosts
  JanWater
  FebWater
  MarWater
  AprWater
  MayWater
  JunWater
  JulWater
  AugWater
  SepWater
  OctWater
  NovWater
  DecWater
  CropStartDate
  in-ground-length
  PercentOfCropland2016
  PercentOfCropland2015
  PercentOfCropland2014
  PercentOfCropland2013
  PercentOfCropland2012
  PercentOfCropland2011
  PercentOfCropland2010
  PercentOfCropland2009
  PercentOfCropland2008
  PercentOfCropland2007
  CropscapePercentAlfalfa
  CropscapePercentBarley
  CropscapePercentCorn
  CropscapePercentPotatoes
  CropscapePercentSpringWheat
  CropscapePercentSugarbeets
  CropscapePercentWinterWheat

  ;Inputs - Water Management
  CostOfWaterStrategy
  AnnualCost
  RelativeWaterUse
  LifetimeOfStrategy

  ;Inputs - Equipment
  TractorCosts
  TractorCostsSD
  TractorFreq
  ForageHarvesterCosts
  ForageHarvesterCostsSD
  ForageHarvesterFreq
  GrainAndBeanCombineCosts
  GrainAndBeanCombineCostsSD
  GrainAndBeanCombineFreq
  HayBalerCosts
  HayBalerCostsSD
  HayBalerFreq

  ;Inputs - District Variables
  District-name ; Reads out the district name as input on the first line of the file.
  Number-of-Farms ; Reads number of farms as appears in second line ...
  Total-Acres ; Same as above, throughout remainder of section.
  Total-Irrigated-Acres
  Average-Farm-Size
  Median-Farm-Size
  Number-Farmers-Primarily-Farm
  Number-Farmers-Primarily-Other
  Farms-With-A-Tractor
  Farms-with-Grain-and-Bean-Combine
  Farms-with-Forage-Harvester
  Farms-with-Hay-Baler
  Farms-with-Beef-Cattle
  Farms-with-Dairy-Cattle
  One-to-9-Acre-farms
  Ten-to-49-acre-farms
  Fifty-to-179-acre-farms
  OneHundredEighty-to-499-acre-farms
  FiveHundred-to-999-acre-farms
  OneThousand-to-10000-acre-farms
  Assessment-Value ; Assessment value hard-coded because variance is currently unknown between districts. Hope to update later.
  PriorityTiers
  Min%Decrease
  Max%Decrease
  AFCapMatrix
  JanETRef
  FebETRef
  MarETRef
  AprETRef
  MayETRef
  JunETRef
  JulETRef
  AugETRef
  SepETRef
  OctETRef
  NovETRef
  DecETRef
  Rent08
  Rent09
  Rent10
  Rent11
  Rent12
  Rent13
  Rent14
  Rent16
  Rent17
  RentList
  ;; District-specific weather variables
  January-.01-inch-days
  January-.10-inch-days
  January-.50-inch-days
  January-1.0-inch-days
  February-.01-inch-days
  February-.10-inch-days
  February-.50-inch-days
  February-1.0-inch-days
  March-.01-inch-days
  March-.10-inch-days
  March-.50-inch-days
  March-1.0-inch-days
  April-.01-inch-days
  April-.10-inch-days
  April-.50-inch-days
  April-1.0-inch-days
  May-.01-inch-days
  May-.10-inch-days
  May-.50-inch-days
  May-1.0-inch-days
  June-.01-inch-days
  June-.10-inch-days
  June-.50-inch-days
  June-1.0-inch-days
  July-.01-inch-days
  July-.10-inch-days
  July-.50-inch-days
  July-1.0-inch-days
  August-.01-inch-days
  August-.10-inch-days
  August-.50-inch-days
  August-1.0-inch-days
  September-.01-inch-days
  September-.10-inch-days
  September-.50-inch-days
  September-1.0-inch-days
  October-.01-inch-days
  October-.10-inch-days
  October-.50-inch-days
  October-1.0-inch-days
  November-.01-inch-days
  November-.10-inch-days
  November-.50-inch-days
  November-1.0-inch-days
  December-.01-inch-days
  December-.10-inch-days
  December-.50-inch-days
  December-1.0-inch-days
  Jan-Avg-Max-Temp
  Jan-Avg-Min-Temp
  Feb-Avg-Max-Temp
  Feb-Avg-Min-Temp
  Mar-Avg-Max-Temp
  Mar-Avg-Min-Temp
  Apr-Avg-Max-Temp
  Apr-Avg-Min-Temp
  May-Avg-Max-Temp
  May-Avg-Min-Temp
  Jun-Avg-Max-Temp
  Jun-Avg-Min-Temp
  Jul-Avg-Max-Temp
  Jul-Avg-Min-Temp
  Aug-Avg-Max-Temp
  Aug-Avg-Min-Temp
  Sep-Avg-Max-Temp
  Sep-Avg-Min-Temp
  Oct-Avg-Max-Temp
  Oct-Avg-Min-Temp
  Nov-Avg-Max-Temp
  Nov-Avg-Min-Temp
  Dec-Avg-Max-Temp
  Dec-Avg-Min-Temp
  Jan-Avg-Max-Temp-SD
  Feb-Avg-Max-Temp-SD
  Mar-Avg-Max-Temp-SD
  Apr-Avg-Max-Temp-SD
  May-Avg-Max-Temp-SD
  Jun-Avg-Max-Temp-SD
  Jul-Avg-Max-Temp-SD
  Aug-Avg-Max-Temp-SD
  Sep-Avg-Max-Temp-SD
  Oct-Avg-Max-Temp-SD
  Nov-Avg-Max-Temp-SD
  Dec-Avg-Max-Temp-SD
  Jan-Avg-Min-Temp-SD
  Feb-Avg-Min-Temp-SD
  Mar-Avg-Min-Temp-SD
  Apr-Avg-Min-Temp-SD
  May-Avg-Min-Temp-SD
  Jun-Avg-Min-Temp-SD
  Jul-Avg-Min-Temp-SD
  Aug-Avg-Min-Temp-SD
  Sep-Avg-Min-Temp-SD
  Oct-Avg-Min-Temp-SD
  Nov-Avg-Min-Temp-SD
  Dec-Avg-Min-Temp-SD

  ;; For Use in Calculating Annual Weather patterns in the district
  AnnualPrecip
  MaxTemperature
  MinTemperature

  ; Rotation percentages - each of these is pulled from an input file, and it indicates the percentage of farmers who use that particular rotation.
  PotatoGrainBeetGrain
  PotatoBeetGrainGrain
  HayGrain
  HayGrainPotatoGrain
  PotatoGrainGrain
  HayBarleyPotato
  HayGrainGrainPotato
  GrainPotatoBeetsHay

  ; Determine Crop variables
  cropZ ; Variable that records which crop we're analyzing at that moment.
  waterstratZ ; Variable that records which water management strat we're analyzing.
  Current-Land-Use ; global record of which crop is under analysis. Prevents having to pass a bunch of stuff and use different variables names or local everything
  Water-Management-Strategy ; Same as above. Global record of which water mgmt strat is being analyzed.
  field-global ; Same as above, but this time for the field of interest.
  TimeListValue ; Wariable that records the location in the input lists - 2007, 2009, 2011, 2013, or 2017
  RotationPosition-local ; Variable cataloging the rotation position of the patch of interest
  ;; Cost records
  InfrastructureCostsCatalog ; List of infrastructure costs for each crop for the active farmer
  OwnershipCostsCatalog ; List of ownership costs for each crop for the active farmer
  SettlementCostsCatalog ; List of costs associated with the settlement for each crop for the active farmer - not sure this will remain active with new organization
  SocialCostsCatalog ; List of social negatives for each crop for the active farmer (norm dis/adherence)
  SocialGainsCatalog ; List of social positives for each crop for the active farmer (attitude consistency)
  OperatingCostsCatalog ; List of operating costs for each crop for the active farmer
  ExpectedGrossFinancialReturns ; Old variable cataloging financial returns from current crop ... in flux as of 3/19/2019
  ExpectedGrossReturns ; Old variable cataloging overall utility returns from current crop ... in flux as of 3/19/2019
  NetExpectedReturns ; Old variable cataloging net utility from current crop ... in flux as of 3/19/2019
  ROIPeriod ; ROI period for the chosen crop? In flux as of 3/19/2019
  TotalCostsCatalog ; Old variable cataloging all costs from current crop ... in flux as of 3/19/2019 - probably still going to be used to generate a list of total utility returns for each crop
  WasAlfalfa? ; Variable documenting whether or not the last year's crop was alfalfa in a particular field
  WasAlfalfaYear ; simialr to above, but capturing the year that the alfalfa was on the year before.
  WasGrain? ; same as above, for grain
  WasGrainYear ; same as above, for grain
  NumberOfFarmersWithChangedWM ; tracking for the number of farmers who change Water Mgmt each year
  ;; Irrigation
  TotalIrrigationUseCatalog ; Catalog of the water requirements of the active crop
  TotalIrrigationUseForThisCrop
  IrrigationPlan ; Daily irrigation schedule for the active crop
  WaterOverdraw
  WaterOverdrawCatalog ; Water use prescribed by the irrigation plan that is in excess of settlement limits or original water right - catalog for each crop
  IACHabitScalar ; Variable that is unused but is in existing worlds, so want to avoid clicking accept on the ignore
  IACSocialScalar ; Variable that is unused but is in existing worlds, so want to avoid clicking accept on the ignore
  TPBFinancialScalar ; Variable that is unused but is in existing worlds, so want to avoid clicking accept on the ignore


  ;World variables - descriptors and records
  FinalCSVPrintList ; record for csv at the end - contains a list of outcomes for each patch.

  ;Internal
  Working-Directory ; Variable to hold the working directory for the current simulation.
  Finished ; Finished is a status variable for use in BehaviorSpace - gives the simulation an indicator of when it can quit. - set as False in setup, changed after X ticks.
  location ; Variable to hold the current location in the model

  ;Iteration and other tracking calculation variables - used in random distribution generation
  i
  j
  X

  ;Evaluation Variables - Mostly reporting to R
  potato-count
  beet-count
  alfalfa-count
  a-p-count
  alfalfa-total-count
  sw-count
  ww-count
  corn-count
  grain-count
  barley-count
  total-crops
  WaterStratChangePercentR
]

patches-own
[

  in-district ; variable indicating that the patch is inside the district (prevents patches out in the black space from being included)
  InRiver ; This is an incredibly simulation intensive part of the process, but it seems to work - indicates what patches are in the river (thy turn blue, as well)
  owner ; identifies the farmer who "owns this plot of land"
  candidate ; variable used in water preference simulation - first we create an agentset of 100 candidates, then we select the favored candidate as the one closest to water.
  favored-candidate ; as is described above, this is the patches-own variable that indicates the candidate closest to water.
  FieldNumber ; variable that identifies which of a farmer's fields a patch belongs to
  FieldSeed ; Binary indicating whether or not that patch is the "seed" for that field - "seeds" are used as the core of all field-level calculations.
  InputIntensity ; Effectively a scalar - scales the costs of inputs related to agricultural production - summative scalar for fertilizer, pesticides, etc. Same for all crops (assumption)
  FieldSize-PatchVar ; Replicate of the FieldSize variable from farmers - need in pathc context so easier to have saved as a patch variable
  CropHistory-fields ; List that indicates the crop grown on a particular patch for all of its recent history - used to be an actual history, now a tracer.
  AlfalfaYear ; Set in various locations ... used to track how many years the current stand of alfalfa has been in a field. For the purposes of this simulation, 7 is considered the max.
  GrainYear ; Same as above, used for rotations that run through multiple years of grain
  TypeOfIrrigation ; Variable indetifying the type of irrigation in use on this plot of ground.
  RotationPosition ; Variable recording the position of the patch in the rotation sequence.

  ; for calculating land use returns
  ExpectedNetReturnsForThisLandUse
  ExpectedNetReturnsForAllLandUses
  HighestReturns
  PreferredLandUse
  PreferredLandUse-category ;variable for comparing to rotation - categories instead of specific crop
  PreferredWaterManagementStrat
  IrrigationPlanForThisCrop
  cropZForUse
  waterstratZForUse

  ;for cataloging actual outcomes
  AnnualReturns
]

turtles-own
[
  breed?
]

CropConsultants-own
[
  LandUsePerceptions-consultant
]

IrrigationConsultants-own
[
  WaterManagementPerceptions-consultant
]

farmers-own
[
  FarmSize ; Number of acres in farm
  Fields ; list of lists - each list contains a group of patches that form a field.
  FieldSeeds ; list of patches that form the field seeds ... field seeds are used for the calculations for the entire field.
  NumberFields ;
  RotationMaxPosition ; set in demographics - Variable recording the length of the rotation on this farm (length minus 1 for iteration starting at 0).
  beef-cattle? ; set in demographics - based on the location file - 0/1 for whether or not farmer has
  dairy-cattle? ; set in demographics - based on the location file - 0/1 for whether or not farmer has
  EquipmentMatrix ; set in demographics - based on the location file - format [0/1 0/1 0/1 0/1] - seets whether or not farmer has four types of equipment detailed in demographics section
  MoneyAvailable ; set in demographics - can be random or uniform - just the starting savings for each farmer
  WaterRightSeniority ; set in demographics - random - either uniform or normal distribution ... varies from 1880 to 1980.
  WaterRightSize ; set in demographics - random - either normal or gamma distribution ... see demographics for more info
  BeliefInESPA ; set in demographics - random-normal - based on globals set on GUI (BeliefInSocialSanctionAverage & BeliefInSocialSanctionSD)
  BeliefInSocialSanctions ; set in demographics - random-normal based on globals set on GUI (BeliefInSocialSanctionsAverage & BeliefInSocialSanctionsSD)
  BeliefInEconomicSanctions ; set in demographics - random-normal based on globals set on GUI (BeliefInEconomicSanctionsAverage & BeliefInEconomicSanctionsSD)
  NegativeFarmSize ; set in demographics - a computational variable used to sort by inverse farm size
  LandUsePerceptions ; set in demographics - semi-random perception of each LandUse in simulation
  WaterManagementPerceptions ; set in demographics - semi-random perception of each water management strategy in simulation
  OtherJob? ; set in demographics - variable indicating whether a farmer has another job from which they draw income. Can also be intrepreted as a question of the farmer's major source of living expenses.
  IrrigationPlanningMethod ; set in demogrpahics - matrix of binaries indicating if farmers use a variety of methods - more detail in initialization
  IrrigataionPlanningStandardDeviation ; set in demographics - actual variable to be used in calculation of irrigation strategy
  IrrigationPlanningDelay ; set in demogrpahics - same as above (think mean, instead of SD)
  Rotation ; set in Rotation file - Just a string that has the "name" of the rotation for that farmer - the "name" is just all the crops concatenated.
  RotationList ; set in Rotation file - a list of all the crops in the rotation - used for iterating thru crops
  Barley_Contract ; set in demographics file - if barley is in rotation, usually grown on contract. This helps specify how many
  Potato_Contract ; set in demographics file - if potato is in rotation, usually grown on contract. This helps specify how many
  Sugarbeet_Contract ; set in demographics file - if sugarbeet is in rotation, usually grown on contract. This helps specify how many
  FieldSize ; set in PrepareFields field - identifies the number of patches in each field that farmer owns (acres = 10*patches)
  PlanningSeasonComplete? ; set at beginning and end of planning season - allows us to easily track which farmers have planned so far.
  ExpectedNetReturnsForThisLandUse-farmer ; semi-local variable used for translating returns back to field
  AmountFarmerIsWillingToLose ; set in demographics - variable defining the amount a farmer is willing to lose in any given year.
  ROISeasonTolerance-farmer ; set in demographics - sets the number of years a farmer is willing to wait for something to pay itself off.
  ID_Number ; For use in identifying farmers in file titles without parentheses.
  AnnualReturns-farmer ; used to catalog money earned or lost
  AnnualReturns-farmer-extracted ; used to pull each value out of its own list.
  LandUseThisYear ; used to catalog crops
  LandUsesKnown ; list of all land uses with which the farmer is familiar thru exerience.
  CropHistory ; extended form list of what all a farmer has planted in any field ever.
  ChangedWaterManagementThisYear? ; reporter to allow tracking of the number of folks that change irrigation methods in any given year.
]

; In general, there are three ways to run this program. The first is simply to use the basic go and setup function and manually enter all the relevant information.
; The second is using the BehaviorSpace features of the program. This is a limited, flawed approach, since most inputs are erased if you are using Experimental Setup.
;; Functions for running BehaviorSpace simulations can be found in UsingBehaviorSpace.nls.
; The third is through R. Using the R code included in this repository, it is possible to run simulations, both stand-alone and in parallel. See the RNetLogo package for more info.
;; Functions for running R simulations can be found in UsingR.nls.

to Go
  ;; Go is the primary function in this program. It is called by the Go button on the GUI or as the primary function in a BehaviorSpace sim.
  ;; Go calls setup, then catalogs initial conditions, then loops through planning and planting for a given number of seasons, then Catalogs Final Conditions, then closes the program.
  reset-timer
  print timer
  setup ; Setup contains all the one-time setup procedures. It is one of three functions that can be called independently from the GUI.
  ; TODO - Need to determine what things are useful to catalog and write the component to do that.
  while [ticks < NumberOfSeasons]
  [ ; this is the code to run the simulation for a given NumberOfSeasons. I think this could easily be modified to include multiple simulations within one run.
    ; Throughout this code, tracers are inserted for use during troubleshooting and general timing of the program.
    trace "start of new tick (year)"
    PlanningSeason  ; Farmers select their actions for the year. Actions include any kind of water conservation practice, as well as what/how much to plant.
    trace "end of planning for all farmers"
    CropSeason ; Calculate actual returns from choice of land use.
    trace "end of simulation season. Crop outcomes recorded and preparing to reconcile."
    Reconcile ; Balances budgets, finds farmers who are out of money, and checks on the status of the settlement agreement.
    trace "end of season reconciliation. Farmers are now prepared to share outcomes (if not Bounded Rationality) and start new year"
    if Decision-Making != "Bounded Rationality" [ KnowledgeSharing ]
    trace "end of knowledge sharing. Farmers have shared their ideas and are ready for the new planning season"
    tick
  ]
  set location "THE-END_post-simulation"
  if NumberOfSeasons > 0 [export-world (word GWD "_" Decision-Making "_CompletedSim_Run " RandomSeed "_" ExperimentName)] ; Changed to random seed to I can vary the outcomes across the worlds in a regulated way.
  CatalogConditions location
  set Finished TRUE
  print timer
  stop
end

to Test
  ;; Test is a typically empty function that can be used to test new functionality or to run short add-ons. It is not called anywhere but the GUI.
  print "R called the Test function successfully"
  let RTestVariable "R called the Test function successfully"
end

to setup
  ;; Setup is usually called by Go. It has two primary forks, one which randomly populates the district and one which populates the district based on a loaded file.
  ;; It can also be called independently. For example, this may be used to generate a new world for a number of simulations without actually running a simulation immediately.

  set Is-Setup? false
  if FixRandomSeed? = TRUE [random-seed RandomSeed]

  clear-all ; reset everything, including display, variables, memory. This is key to avoid memory leaks over the course of many runs.
  set Finished FALSE ; Finished is a status variable for use in BehaviorSpace - gives the simulation an indicator of when it can quit.
  reset-timer ; Reset the timer so it can be used to track system performance - primarily relevant during testing, don't care as much during actual simulations.
  reset-ticks
  if Animate? = TRUE [ animate ]  ; If the setting on the interface says to animate, then go through the process of showing the context and specific simulation location.
  ifelse PopulateMethod = "Random" [ ; If the populate method on the interface is "Random," we generate a new world. If it is experimental (or somehow somethinge else), it will load whatever world is designated on the GUI.
    trace "beginning of Populate Random ifelse section" ; trace function is in the Tracers component - it prints the location and timer to a file and to the user interface. The location is defined in the input here.
    ImportDrawAndParameterizeDistrict
    trace "district imported and prepared"
        ;This LandUseList serves as the master list for crops included in the simulation. Crops are parameterized after this list is available.
    set LandUseList ["Barley" "Spring Wheat" "Alfalfa" "Sugarbeets" "Potatoes" "Corn" "Winter Wheat" "Alfalfa_Perennial"]
    set CropList ["Barley" "Spring Wheat" "Alfalfa" "Sugarbeets" "Potatoes" "Corn" "Winter Wheat" "Alfalfa_Perennial"]
    ;; After DetermineCropReturns, "Winter Wheat" is treated as Spring Wheat for all calculation purposes.
        ; This was more or less confirmed through interviews. Farmers don't distinguish between the two except for marketing purposes and for rotational scheduling.
        ; Shouldn't matter how it is simulated.
    set WaterManagementList ["Center Pivot LEPA" "Center Pivot LESA" "Center Pivot MESA" "Drip Tape" "Furrow"] ; others will include modified tillage, end guns, hand lines, and wheel lines.
    trace "crops and other basic initialization"
    InitializeCropsAndMisc
    trace "actual PopulateRandom function"
    PopulateRandom
    trace "end of Populate Random" ; trace function is in the Tracers component - it prints the location and timer to a file and to the user interface. The location is defined in the input here.
    ifelse UseRandomRotations? = true
    [export-world (word GWD "_EmptyWorld_Run " RandomSeed "_RandomRotations")] ; Changed to random seed to I can vary the outcomes across the worlds in a regulated way.
    [export-world (word GWD "_EmptyWorld_Run " RandomSeed "_InformedRotations")] ; Changed to random seed to I can vary the outcomes across the worlds in a regulated way.
  ]
  [
    PopulateExperimental
    ;;After Populate Experimental, it's necessary to manually set any variables that you are interested in varying.
    ;set Tracers? TRUE
;    set WriteOutputs? FALSE
;    set WriteCropBudgets? FALSE
;    set WriteDetailedCropBudgets? FALSE
;    set NumberOfSeasons 15
;    set InternalScalar 1
;    set ExternalScalar 1
;    set EfficacyScalar 1
;    set ChargeForOverdraw 100
;    set ROISeasonTolerance 5
;    set PerceptionThreshold 0.5



    ;;Although it is useful to be able to set things manually like above, it's simpler to import a file that resets things. Can use R to automatically iterate through this.
    set ExperimentVariablesFile "/data/ExperimentVariables.txt"
    ImportExperimentVariables
    ask farmers [
      set ChangedWaterManagementThisYear? 0
      set AmountFarmerIsWillingToLose random-normal ExperimentalToleranceforLoss ((PercVarWillingnessToLose / 100) * ExperimentalToleranceforLoss)
    ]

  ]
  ; This would be the moment to change the working directory in MATLAB if using AquaCrop.
  ;   matlab:eval "cd '//itsofs06.itap.purdue.edu/ag_fnr/Users/hawes0/GitHub/ESPA-CAMP-ABM/Programming Working Folder/MATLAB'"
  ask farmers [
    CreateCleanDetailedCropBudget
    CreateCleanCropBudget
    CreateCleanSocialCropBudget
  ]
  set NumberOfFarmersWithChangedWM []
  set FinalCSVPrintList []
  set Is-Setup? true

  set location "Initial_post-setup"
  FixRotations
  CatalogConditions location ; Catalog variables that will serve as evaluation criteria - CatalogConditions is a generic cataloging function that names variables based on the time in the model (Initial is the "time" input)
end

to EvaluateRun
;  ; set of commands used to produce easily analyzable information. For instance, produce crop counts or percent who change irrigation strategies.
;
;  ; Evaluating rotations
;  let potato-rot-count 0
;  let beet-rot-count 0
;  let alfalfa-rot-count 0
;  let grain-rot-count 0
;  let barley-rot-count 0
;
;  ask farmers [
;    foreach RotationList [
;      [entry] ->
;      if entry = "Potato"  [set potato-rot-count potato-rot-count + 1]
;      if entry = "Beet" [set beet-rot-count beet-rot-count + 1]
;      if entry = "Hay" [set alfalfa-rot-count alfalfa-rot-count + 1]
;      if entry = "Grain" [set grain-rot-count grain-rot-count + 1]
;      if entry = "Barley" [set barley-rot-count barley-rot-count + 1]
;    ]
;  ]
;  print (word "potato-rotation-count is " potato-rot-count)
;  print (word "beet-rotation-count is " beet-rot-count)
;  print (word "alfalfa-rotation-count is " alfalfa-rot-count)
;  print (word "grain-rotation-count is " grain-rot-count)
;  print (word "barley-rotation-count is " barley-rot-count)
;  let rot-sum barley-rot-count + grain-rot-count + alfalfa-rot-count + beet-rot-count + potato-rot-count
;  print (word "Percent potato in rotations is " (potato-rot-count / rot-sum * 100) " as compared to " CropscapePercentPotatoes " prescribed by cropscape.")
;  print (word "Percent beet in rotations is " (beet-rot-count / rot-sum * 100) " as compared to " CropscapePercentSugarbeets " prescribed by cropscape.")
;  print (word "Percent alfafa in rotations is " (alfalfa-rot-count / rot-sum * 100) " as compared to " CropscapePercentAlfalfa " prescribed by cropscape.")
;  print (word "Percent grain in rotations is " (grain-rot-count / rot-sum * 100) " as compared to " (CropscapePercentSpringWheat + CropscapePercentCorn + CropscapePercentWinterWheat) " prescribed by cropscape.")
;  print (word "Percent barley in rotations is " (barley-rot-count / rot-sum * 100) " as compared to " CropscapePercentBarley " prescribed by cropscape.")
;
;  ; Evaluating crop histories
;  set potato-count 0
;  set beet-count 0
;  set alfalfa-count 0
;  set a-p-count 0
;  set alfalfa-total-count 0
;  set sw-count 0
;  set ww-count 0
;  set corn-count 0
;  set grain-count 0
;  set barley-count 0
;  set total-crops 0
;
;  ask farmers [
;    foreach crophistory [
;      [entry] ->
;      if entry = ["Potatoes"]  [set potato-count potato-count + 1]
;      if entry = ["Sugarbeets"] [set beet-count beet-count + 1]
;      if entry = ["Alfalfa"] [set alfalfa-count alfalfa-count + 1]
;      if entry = ["Alfalfa"] [set alfalfa-total-count alfalfa-total-count + 1]
;      if entry = ["Spring Wheat"] [set sw-count sw-count + 1]
;      if entry = ["Spring Wheat"] [set grain-count grain-count + 1]
;      if entry = ["Winter Wheat"] [set ww-count ww-count + 1]
;      if entry = ["Winter Wheat"] [set grain-count grain-count + 1]
;      if entry = ["Corn"] [set corn-count corn-count + 1]
;      if entry = ["Corn"] [set grain-count grain-count + 1]
;      if entry = ["Barley"] [set barley-count barley-count + 1]
;      if entry = ["Alfalfa_Perennial"] [set a-p-count a-p-count + 1]
;      if entry = ["Alfalfa_Perennial"] [set alfalfa-total-count alfalfa-total-count + 1]
;    ]
;  ]
;  set total-crops potato-count + beet-count + barley-count + alfalfa-total-count + grain-count
;  print (word "potato-count is " potato-count)
;  print (word "beet-count is " beet-count)
;  print (word "alfalfa-count is " alfalfa-count)
;  print (word "sw-count is " sw-count)
;  print (word "ww-count is " ww-count)
;  print (word "corn-count is " corn-count)
;  print (word "barley-count is " barley-count)
;  print (word "alfalfa perennial count is " a-p-count)
;  print (word "Alfalfa total count is " alfalfa-total-count)
;  print (word "grain-count is " grain-count)
;  print (word "total-crops is " total-crops)
;
;  ; Evaluating number of folks who changed rotation at any point. Works best when only running year 10.
;  let WaterStratChange 0
;  ask farmers [
;    if ChangedWaterManagementThisYear? = 1
;    [ set WaterStratChange WaterStratChange + 1 ]
;  ]
;  let WaterStratChangePercent-local (WaterStratChange / count farmers * 100)
;  print (word "The percent of farmers changing their water use strategy is " WaterStratChangePercent-local)

end

to GenerateExperiments

  ; Experiments run on the matrix of decision-making, tolerance for loss, charge for overdraw, DM scalars, and perception threshold
  let District-list (list "Aberdeen-American Falls GWD" "Bingham GWD" "Carey Valley GWD" "Jefferson-Clark GWD" "Magic Valley GWD" "North Snake GWD" )
  let Worlds-list (list "_EmptyWorld_Run 1_InformedRotations" "_EmptyWorld_Run 2_InformedRotations" "_EmptyWorld_Run 3_InformedRotations")
  let DM-list (list "Rational Actor" "Theory of Planned Behavior" "IAC Framework")
  let TFL-list (list 2500 5000 10000)
  let CFO-list (list 0 100 1000)
  let InternalScalar-list (list 1.0)
  let ExternalScalar-list (list 1.0)
  let EfficacyScalar-list (list 1.0)
  let RhythmScalar-list (list 1.0)
  let PT-list (list 0.5)

  foreach District-list [
    [District-local] ->
    foreach Worlds-list [
      [World-name-local] ->
      let file-name (word "/data/InterfaceInputs_" District-local World-name-local ".txt")
      file-open file-name
      file-write true ;Fix Random Seed?
      file-write 15 ;RandomSeed
      file-write "Experimental" ;PopulateMethod
      file-write (word District-local World-name-local) ;WorldFileName
      file-close
    ]
  ]

  set ExperimentList []
  foreach District-list [
    [District-local] ->
    foreach DM-list [
      [DM-local] ->
      foreach TFL-list [
        [TFL-local] ->
        foreach CFO-list [
          [CFO-local] ->
          foreach InternalScalar-list [
            [IS-local] ->
            foreach ExternalScalar-list [
              [ES-local] ->
              foreach EfficacyScalar-list [
                [EffS-local] ->
                foreach RhythmScalar-list [
                  [RS-local] ->
                  foreach PT-list [
                    [PT-local] ->
                    let file-name (word "/data/Experiment_" District-local "_DM-" DM-local "_TFL-" TFL-local "_CFO-" CFO-local "_IS-" IS-local "_ES-" ES-local "_EffS-" EffS-local "_RS-" RS-local "_PT-" PT-local ".txt")
                    set ExperimentList lput file-name ExperimentList
                    file-open file-name
                    file-write (word "Experiment_" District-local "_DM-" DM-local "_TFL-" TFL-local "_CFO-" CFO-local "_IS-" IS-local "_ES-" ES-local "_EffS-" EffS-local "_RS-" RS-local "_PT-" PT-local)
                    file-print ""
                    file-print 1
                    file-write (word DM-local)
                    file-print ""
                    file-print 15
                    file-print false
                    file-print false
                    file-print false
                    file-print false
                    file-print 0
                    file-print TFL-local
                    file-print CFO-local
                    file-print IS-local
                    file-print ES-local
                    file-print EffS-local
                    file-print RS-local
                    file-print PT-local
                    file-close
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
  file-open "/Results/ExperimentNames.txt"
  foreach ExperimentList [[EL-local] -> file-write (word "\"" EL-local "\"")]
;  foreach ExperimentList [[EL-local] -> file-write (word EL-local )]
  file-close

end



to-report potato-rot-count
  let potato-rot-count-temp 0
  ask farmers [
    foreach RotationList [
      [entry] ->
      if entry = "Potato"  [set potato-rot-count-temp potato-rot-count + 1]
    ]
  ]
  report potato-rot-count-temp
end

to-report beet-rot-count
  let beet-rot-count-temp 0
  ask farmers [
    foreach RotationList [
      [entry] ->
      if entry = "Beet" [set beet-rot-count-temp beet-rot-count-temp + 1]
    ]
  ]
  report beet-rot-count-temp
end
to-report alfalfa-rot-count
  let alfalfa-rot-count-temp 0
  ask farmers [
    foreach RotationList [
      [entry] ->
      if entry = "Hay" [set alfalfa-rot-count-temp alfalfa-rot-count-temp + 1]
    ]
  ]
  report alfalfa-rot-count-temp
end
to-report grain-rot-count
  let grain-rot-count-temp 0
  ask farmers [
    foreach RotationList [
      [entry] ->
      if entry = "Grain" [set grain-rot-count-temp grain-rot-count-temp + 1]
      ]
  ]
  report grain-rot-count-temp
end
to-report barley-rot-count
  let barley-rot-count-temp 0
  ask farmers [
    foreach RotationList [
      [entry] ->
      if entry = "Barley" [set barley-rot-count-temp barley-rot-count-temp + 1]
    ]
  ]
  report barley-rot-count-temp
end

to-report total-crops
  ask farmers [
    foreach crophistory [
      [entry] ->
      if entry = ["Potatoes"]  [set potato-count-temp potato-count-temp + 1]
      if entry = ["Sugarbeets"] [set beet-count-temp beet-count-temp + 1]
      if entry = ["Alfalfa"] [set alfalfa-total-count-temp alfalfa-total-count-temp + 1]
      if entry = ["Spring Wheat"] [set grain-count-temp grain-count-temp + 1]
      if entry = ["Winter Wheat"] [set grain-count-temp grain-count-temp + 1]
      if entry = ["Corn"] [set grain-count-temp grain-count-temp + 1]
      if entry = ["Barley"] [set barley-count-temp barley-count-temp + 1]
      if entry = ["Alfalfa_Perennial"] [set alfalfa-total-count-temp alfalfa-total-count-temp + 1]
    ]
  ]
  report potato-count-temp + beet-count-temp + barley-count-temp + alfalfa-total-count-temp + grain-count-temp
end

to-report potato-count
  ask farmers [
    foreach crophistory [
      [entry] ->
      if entry = ["Potatoes"]  [set potato-count-temp potato-count-temp + 1]
    ]
  ]
  report potato-count-temp
end

to-report beet-count
  ask farmers [
    foreach crophistory [
      [entry] ->
      if entry = ["Sugarbeets"]  [set beet-count-temp beet-count-temp + 1]
    ]
  ]
  report beet-count-temp
end


to-report grain-count
  ask farmers [
    foreach crophistory [
      [entry] ->
      if entry = ["Spring Wheat"] [set grain-count-temp grain-count-temp + 1]
      if entry = ["Winter Wheat"] [set grain-count-temp grain-count-temp + 1]
      if entry = ["Corn"] [set grain-count-temp grain-count-temp + 1]
          ]
  ]
  report grain-count-temp
end
@#$#@#$#@
GRAPHICS-WINDOW
646
80
1890
957
-1
-1
4.0
1
10
1
1
1
0
0
0
1
0
308
0
216
0
0
1
ticks
30.0

CHOOSER
229
234
416
279
GWD
GWD
"Aberdeen-American Falls GWD" "Bingham GWD" "Bonneville-Jefferson GWD" "Carey Valley GWD" "Jefferson-Clark GWD" "Magic Valley GWD" "North Snake GWD" "Test"
5

CHOOSER
22
235
195
280
Decision-Making
Decision-Making
"Rational Actor Theory" "Theory of Planned Behavior" "IAC Framework"
0

BUTTON
234
85
413
145
Go
Go
NIL
1
T
OBSERVER
NIL
G
NIL
NIL
1

CHOOSER
226
868
387
913
AcreageDistributionType
AcreageDistributionType
"Gamma" "Chi-square" "F-Ratio" "Lognormal" "Categorical"
4

INPUTBOX
41
1370
196
1430
F-Ratio-W
0.0
1
0
Number

INPUTBOX
207
1370
364
1430
F-Ratio-V
0.0
1
0
Number

INPUTBOX
374
1370
529
1430
Lognormal-Sigma
0.0
1
0
Number

BUTTON
28
85
115
145
Only Setup
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

SLIDER
229
190
416
223
NumberOfSeasons
NumberOfSeasons
0
50
5.0
1
1
years
HORIZONTAL

SWITCH
22
758
203
791
RandomStartingMoney
RandomStartingMoney
1
1
-1000

CHOOSER
35
869
185
914
WaterRightDistribution
WaterRightDistribution
"Gamma" "Normal"
1

INPUTBOX
266
800
352
860
Run-Number
0.0
1
0
Number

CHOOSER
453
234
633
279
PopulateMethod
PopulateMethod
"Random" "Experimental"
0

INPUTBOX
22
305
637
365
WorldFileName
0
1
0
String

CHOOSER
427
867
593
912
InputIntensityDistribution
InputIntensityDistribution
"Constant" "Random"
1

CHOOSER
41
960
239
1005
WaterRightSeniorityDistribution
WaterRightSeniorityDistribution
"Uniform" "Normal"
0

SLIDER
32
1074
283
1107
ChargeForOverdraw
ChargeForOverdraw
0
200
0.0
1
1
$ per acre-foot
HORIZONTAL

SLIDER
167
1489
414
1522
BeliefInEconomicSanctionsAverage
BeliefInEconomicSanctionsAverage
0
1
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
350
1074
565
1107
ROISeasonTolerance
ROISeasonTolerance
0
20
5.0
1
1
seasons
HORIZONTAL

SWITCH
948
35
1051
68
Tracers?
Tracers?
1
1
-1000

SLIDER
181
1527
401
1560
BeliefsInEconomicSanctionsSD
BeliefsInEconomicSanctionsSD
0
1.0
0.1
.01
1
NIL
HORIZONTAL

SWITCH
1204
35
1310
68
Animate?
Animate?
1
1
-1000

SWITCH
222
758
391
791
IndividualFieldCalcs?
IndividualFieldCalcs?
0
1
-1000

SWITCH
1057
35
1199
68
PrintReporters?
PrintReporters?
1
1
-1000

TEXTBOX
28
288
335
316
World File Name for experimental populate only
11
0.0
1

TEXTBOX
284
165
434
184
Basic Setup
15
0.0
1

TEXTBOX
272
705
422
743
  Simulation Customization
15
0.0
1

TEXTBOX
1055
10
1205
29
Interface Preferences
15
0.0
1

TEXTBOX
132
1330
504
1387
Mathematical Customization/Distribution Parameters
15
0.0
1

TEXTBOX
227
492
431
530
Decision-Making Parameters
15
0.0
1

SLIDER
197
1674
369
1707
BeliefInESPAAverage
BeliefInESPAAverage
0
1
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
197
1710
369
1743
BeliefInESPASD
BeliefInESPASD
0
1
0.1
.01
1
NIL
HORIZONTAL

SLIDER
176
1575
403
1608
BeliefInSocialSanctionsAverage
BeliefInSocialSanctionsAverage
0
1
0.5
.01
1
NIL
HORIZONTAL

SLIDER
186
1619
381
1652
BeliefInSocialSanctionsSD
BeliefInSocialSanctionsSD
0
1
0.1
.01
1
NIL
HORIZONTAL

SLIDER
60
530
280
563
Social-Connections-per-Farmer
Social-Connections-per-Farmer
0
10
3.0
1
1
NIL
HORIZONTAL

BUTTON
32
175
95
208
Test
test
NIL
1
T
OBSERVER
NIL
T
NIL
NIL
1

SWITCH
420
758
600
791
UseRandomRotations?
UseRandomRotations?
1
1
-1000

SLIDER
249
1025
592
1058
CustomFarmerAccess
CustomFarmerAccess
0
100
100.0
1
1
% farmers with custom farmers
HORIZONTAL

SLIDER
346
529
595
562
Consultants-per-Farmer
Consultants-per-Farmer
0
3
2.0
.1
1
consultants
HORIZONTAL

SLIDER
305
965
577
998
water-preference
water-preference
0
100
100.0
1
1
% care
HORIZONTAL

SWITCH
49
1025
223
1058
Simulate-ESPA_CAMP
Simulate-ESPA_CAMP
0
1
-1000

SWITCH
24
1132
165
1165
Use-Aqua-Crop
Use-Aqua-Crop
1
1
-1000

SWITCH
16
1183
209
1216
OffsetIrrigationWithSkill?
OffsetIrrigationWithSkill?
1
1
-1000

SLIDER
388
1270
603
1303
PerceptionThreshold
PerceptionThreshold
0
1
0.5
.01
1
NIL
HORIZONTAL

SLIDER
157
1229
475
1262
TypicalAmountFarmerIsWillingToLosePerField
TypicalAmountFarmerIsWillingToLosePerField
0
10000
5000.0
50
1
NIL
HORIZONTAL

SLIDER
16
1270
305
1303
PercVarWillingnessToLose
PercVarWillingnessToLose
0
100
5.0
1
1
percent variance
HORIZONTAL

SWITCH
457
1130
605
1163
FixRandomSeed?
FixRandomSeed?
0
1
-1000

INPUTBOX
530
84
627
144
RandomSeed
1.0
1
0
Number

SWITCH
408
1178
603
1211
WriteDetailedCropBudgets?
WriteDetailedCropBudgets?
1
1
-1000

SWITCH
236
1179
372
1212
WriteOutputs?
WriteOutputs?
1
1
-1000

TEXTBOX
219
1440
369
1482
Misc. Values that could be used to enhance decision making
11
0.0
1

SLIDER
332
653
529
686
IAC-PhysArous-Threshold
IAC-PhysArous-Threshold
0
5
2.5
.01
1
NIL
HORIZONTAL

SWITCH
232
1133
395
1166
WriteCropBudgets?
WriteCropBudgets?
1
1
-1000

MONITOR
785
23
878
68
NIL
Active-Farmer
17
1
11

BUTTON
523
177
628
210
Evaluate Run
EvaluateRun
NIL
1
T
OBSERVER
NIL
E
NIL
NIL
1

INPUTBOX
416
397
635
457
InterfaceVariableFileName
NIL
1
0
String

SWITCH
247
418
408
451
GeneratingWorlds?
GeneratingWorlds?
1
1
-1000

INPUTBOX
19
402
238
462
ExperimentVariablesFile
/data/ExperimentVariables.txt
1
0
String

SLIDER
29
597
201
630
InternalScalar
InternalScalar
0
2
1.0
0.01
1
NIL
HORIZONTAL

SLIDER
235
597
407
630
ExternalScalar
ExternalScalar
0
2
1.0
.01
1
NIL
HORIZONTAL

SLIDER
436
597
608
630
EfficacyScalar
EfficacyScalar
0
2
1.0
.01
1
NIL
HORIZONTAL

SLIDER
120
654
292
687
RhythmScalar
RhythmScalar
0
2
1.0
.01
1
NIL
HORIZONTAL

@#$#@#$#@
This write-up is a work-in-progress, along with some of the other documentation and will be updated as the author is able. If you wish to use the model in the meantime, please contact jasonkhawes@gmail.com for information and assistance. 


## WHAT IS IT?

The model was designed as part of a study with two primary goals. First, the study was intended to examine patterns of adaptation among groundwater farmers in the Eastern Snake Plain. Due to the introduction of a new groundwater management agreement, farmers throughout the plain have been required to cut an average of 13% of their groundwater use. This has led to the adoption of a variety of new practices and strategies for reducing water use. This model is intended to simulate this adoption. Adaptation and decision-making practices are simulated through the operationalization of three social decision-making theories; the model can be run using any of these three theories, thus allowing for parallel investigation of the first research question with three different theoretical drivers. This, then, lays the groundwork for the second objective. The team seeks to better understand the implications of the adopted decision-making model for the results and conclusions of a modeling effort. To do this, the team sought to investigate the first research question using all three decision-making models and compare these results and outcomes to each other as well as to empirical data. The implementation of three separate, theory-based decision-making mechanisms to govern farmer agent behavior within a fully functional model of an agricultural system allowed the study team to investigate the original, applied research question, while also improving the collective understanding of the type of variability introduced when decision-making rules are varied. 

## HOW IT WORKS

Farmers are the only actors with true agency. They proceed through a four-season year, which approximates their real-world schedule.
1.	Planning season – traditional: Farmers determine preferred crop, plan for planting that best meets their requirements – may still be revised in adaptation planning. With each crop, farmers calculate their expected water use and analyze various water-saving measures, including more efficient irrigation, less water-intensive crops, and fallowing acres or corners. This is all considered in an overall utility function that uses the selected decision-making theory to approximate a farmer’s decision-making process in light of available information. 
2.	Planting season: Farmers execute plan developed in planning season. Simulation determines total water use by farmers, yields (AquaCrop), and net revenue.
3.	Harvest Season (Reconciliation): Farmers calculate their yield and income and adapt their attitudes based on this year’s outcomes.  
4.	Offseason: Farmers communicate results with other farmers and with consultants in their social network. Afterwards, consultants speak with their farmer clients about the new attitudes they’ve developed after seeing that year’s performance for a variety of farmers. 
Other agents only participate in the offseason section of the model, communicating with farmers and sharing their opinions about each possible crop and irrigation method. 

Farmer behavior is governed by one of three decision-making theories, selected by the user. A general description is included here and more details can be found in the model READ-ME and ODD+D. The first decision-making theory, profit-seeking bounded rationality, is the control setting for this model, mocking itself after many of the early models developed in ABM. Farmers are motivated only to maximize economic profits based on their limited perceptions. The second theory is the Theory of Planned Behvaior developed by Azjen. This theory incoporates social psychology into the decision-making algorithms, engaging social norms, individual attitudes, and perceived behavioral control as constructs informing ultimate action. Finally, the Integrated Agent-Centered Framework is a recent proposal from Feola and Binder, which integrates two previous theories of decision making to propose a new, more model-friendly theory. Major differences between TPB and IAC include the presence of habit in IAC and the more explicit integration of the surrounding social-ecological system. 

## HOW TO USE IT

The model as it stands can be directly downloaded and used on any computer capable of running NetLogo. It has not been tested on Mac or Linux OS, but the authors have no reason to suspect that it would not work. 

If there are problems running the model, it is recommended that the first area of investigation be the directories of the input files - it is possible that differences in directory formatting could cause problems. 

Broadly, the user is expected to input four main things from the interface before beginning - all other inptus can be left on the default. First, the user must determine the number of years they want the model to run for. Second, the user must determine the social theory they want to employ. Third, the user must identify in which groundwater district the simulation should be run - this is not actually necessary if the simulation will be an experiment one. Therefore finally, the user must indicate if the model should generate a new world to run in (Random Populate) or use an existing one (Experimental Populate). If the user wishes to run an experimental populate, they should ensure that the text boxes for the world file location and the two input files are filled in. More information on the contents of the input files can be found in the Inputs folder in the GitHub. 


## THINGS TO NOTICE

Not much happens while the mdoel is running. Future releases may include color-coding for crops in each field to allow a but more interaction. THe user is invited to add graphs to the Interface tab to track key variables. Variables of interest may be the number of fields with each crop and the number of fields with each irrigation strategy. 

## THINGS TO TRY

There are many inputs on the interface tab, and not all of them have been thoroughly tested to determine their impacts in a wide variety of scenarios. Knowing this, it is recommended that the user use caution when experimenting with inputs. Inputs that have been tested and found to have significant impact on the model include the Charge for Overdraw, the Number of Consultants, the ROI Threshold, and Perception Threshold. Again, reach out to the primary author for more information- further tests may have been run between the updating of this document and today. If the user is interested in seeing a variety of runs, these inputs would allow for significant variation. 

## EXTENDING THE MODEL

The model is many thousands of lines of code long, and it is not recommended that the user roll out significant changes to the code unless they intend to invest significant time in troubleshooting. Many changes cna be implemented through the inputs, and a huge amount of testing remains to be done to know the degree to which these different inputs change outcomes of the model. 
From an inputs perspective, an important extension which the original authors hope to include would be the expansion of adaptation beyond infrastructural improvements. A variety of other categories of adaptation were analyzed in empirical evidence, and the model could be analyzed along several new dimesnions from the extension of this input. Ultimately, this will have a significant impact on the decision making algorithms and would be a non-trivial undertaking, which is why it remains incomplete to-date. 

## NETLOGO FEATURES

The model employs the NetLogo GIS extension as a mechanism for integrating spatially accurate worlds. It does not employ the actual locations of each farm, but the use of a vector file means that if a dedicated user wanted to, they could integrate real-world soill data, hydrologic data, and farmer information without too much overhaul of the program. 

## RELATED MODELS

None to-date. A generalized form of Farm-Adapt is in the works, although only this version initialized in Idaho is available as of late 2019. 

## CREDITS AND REFERENCES

The program was developed and implemented by Jason Hawes, who can be reached at jasonkhawes@gmail.com. He would like to thank Dr. Zhao Ma, Dr. Morey Burnham, and Dr. David Yu for their input and support on this project. 
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="F-Ratio tests" repetitions="3" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>Go</go>
    <exitCondition>Finished = TRUE</exitCondition>
    <metric>length X</metric>
    <metric>mean X</metric>
    <metric>median X</metric>
    <metric>i</metric>
    <metric>j</metric>
    <metric>OneTo9</metric>
    <metric>TenTo49</metric>
    <metric>FiftyTo179</metric>
    <metric>OneEightyTo499</metric>
    <metric>FiveHundredTo999</metric>
    <metric>Greater1000</metric>
    <enumeratedValueSet variable="F-Ratio-V">
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="AcreageDistributionType">
      <value value="&quot;F-Ratio&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Lognormal-Sigma">
      <value value="1"/>
    </enumeratedValueSet>
    <steppedValueSet variable="F-Ratio-W" first="2" step="0.5" last="4"/>
    <enumeratedValueSet variable="Decision-Making">
      <value value="&quot;Rational Actor theory&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GWD">
      <value value="&quot;Bingham GWD&quot;"/>
      <value value="&quot;Aberdeen-American Falls GWD&quot;"/>
      <value value="&quot;Bonneville-Jefferson GWD&quot;"/>
      <value value="&quot;Carey Valley GWD&quot;"/>
      <value value="&quot;Jefferson-Clark GWD&quot;"/>
      <value value="&quot;Magic Valley GWD&quot;"/>
      <value value="&quot;North Snake GWD&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Gamma and Chi-Square tests" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>Go</go>
    <exitCondition>Finished = TRUE</exitCondition>
    <metric>length X</metric>
    <metric>mean X</metric>
    <metric>median X</metric>
    <metric>i</metric>
    <metric>j</metric>
    <metric>OneTo9</metric>
    <metric>TenTo49</metric>
    <metric>FiftyTo179</metric>
    <metric>OneEightyTo499</metric>
    <metric>FiveHundredTo999</metric>
    <metric>Greater1000</metric>
    <enumeratedValueSet variable="F-Ratio-V">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="AcreageDistributionType">
      <value value="&quot;Gamma&quot;"/>
      <value value="&quot;Chi-square&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Lognormal-Sigma">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-W">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Decision-Making">
      <value value="&quot;Rational Actor theory&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GWD">
      <value value="&quot;Bingham GWD&quot;"/>
      <value value="&quot;Aberdeen-American Falls GWD&quot;"/>
      <value value="&quot;Bonneville-Jefferson GWD&quot;"/>
      <value value="&quot;Carey Valley GWD&quot;"/>
      <value value="&quot;Jefferson-Clark GWD&quot;"/>
      <value value="&quot;Magic Valley GWD&quot;"/>
      <value value="&quot;North Snake GWD&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Lognormal tests" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>Go</go>
    <exitCondition>Finished = TRUE</exitCondition>
    <metric>length X</metric>
    <metric>mean X</metric>
    <metric>median X</metric>
    <metric>i</metric>
    <metric>j</metric>
    <metric>OneTo9</metric>
    <metric>TenTo49</metric>
    <metric>FiftyTo179</metric>
    <metric>OneEightyTo499</metric>
    <metric>FiveHundredTo999</metric>
    <metric>Greater1000</metric>
    <enumeratedValueSet variable="F-Ratio-V">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="AcreageDistributionType">
      <value value="&quot;Lognormal&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="Lognormal-Sigma" first="0.5" step="0.5" last="2.5"/>
    <enumeratedValueSet variable="F-Ratio-W">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Decision-Making">
      <value value="&quot;Rational Actor theory&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GWD">
      <value value="&quot;Bingham GWD&quot;"/>
      <value value="&quot;Aberdeen-American Falls GWD&quot;"/>
      <value value="&quot;Bonneville-Jefferson GWD&quot;"/>
      <value value="&quot;Carey Valley GWD&quot;"/>
      <value value="&quot;Jefferson-Clark GWD&quot;"/>
      <value value="&quot;Magic Valley GWD&quot;"/>
      <value value="&quot;North Snake GWD&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Categorical Test" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>Finished = TRUE</exitCondition>
    <metric>X</metric>
    <enumeratedValueSet variable="NumberOfSeasons">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-V">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="AcreageDistributionType">
      <value value="&quot;Categorical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomStartingMoney">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Lognormal-Sigma">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-W">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Decision-Making">
      <value value="&quot;Theory of Planned Behavior&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightDistribution">
      <value value="&quot;Gamma&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Run-Number">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GWD">
      <value value="&quot;Aberdeen-American Falls GWD&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="TPB-RA Tests" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="BeliefInSocialSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FixRandomSeed?">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Simulate-ESPA_CAMP">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PrintReporters?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-V">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomStartingMoney">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-W">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="UseRandomRotations?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightDistribution">
      <value value="&quot;Normal&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="Run-Number" first="1" step="1" last="10"/>
    <enumeratedValueSet variable="RandomSeed">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Animate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ROISeasonTolerance">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Social-Connections-per-Farmer">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InputIntensityDistribution">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Lognormal-Sigma">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IndividualFieldCalcs?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Tracers?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPASD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInSocialSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NumberOfSeasons">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="AcreageDistributionType">
      <value value="&quot;Categorical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TypicalAmountFarmerIsWillingToLose">
      <value value="20000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPAAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CustomFarmerAccess">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PopulateMethod">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPBSocialScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefsInEconomicSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="water-preference">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OffsetIrrigationWithSkill?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WorldFileName">
      <value value="&quot;0&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="LandUsePerceptionThreshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ChargeForOverdraw">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Consultants-per-Farmer">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInEconomicSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPBFinancialScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Use-Aqua-Crop">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PercVarWillingnessToLose">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GWD">
      <value value="&quot;Test&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Decision-Making">
      <value value="&quot;Theory of Planned Behavior&quot;"/>
      <value value="&quot;Rational Actor Theory&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightSeniorityDistribution">
      <value value="&quot;Uniform&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="GeneratingWorlds-Thesis" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>goexperimental</go>
    <exitCondition>Finished = TRUE</exitCondition>
    <metric>count farmers</metric>
    <metric>count patches with [owner != 0]</metric>
    <metric>count farmers with [farmsize &lt; 50]</metric>
    <metric>count farmers with [farmsize &gt; 50 AND farmsize &lt; 100]</metric>
    <metric>count farmers with [farmsize &gt; 100 AND farmsize &lt; 500]</metric>
    <metric>count farmers with [farmsize &gt; 500 AND farmsize &lt; 1000]</metric>
    <metric>count farmers with [farmsize &gt; 1000 AND farmsize &lt; 10000]</metric>
    <metric>count farmers with [rotation = "PotatoBeetGrainGrain"]</metric>
    <metric>count farmers with [rotation = "PotatoGrainBeetGrain"]</metric>
    <metric>count farmers with [rotation = "HayGrain"]</metric>
    <metric>count farmers with [rotation = "HayGrainPotatoGrain"]</metric>
    <metric>count farmers with [rotation = "PotatoGrainGrain"]</metric>
    <metric>count farmers with [rotation = "HayBarleyPotato"]</metric>
    <metric>count farmers with [rotation = "HayGrainGrainPotato"]</metric>
    <metric>count farmers with [rotation = "GrainPotatoBeetsHay"]</metric>
    <metric>count farmers with [rotation = "Landlord"]</metric>
    <enumeratedValueSet variable="PerceptionThreshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInSocialSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FixRandomSeed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PrintReporters?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Simulate-ESPA_CAMP">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteDetailedCropBudgets?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IAC-PhysArous-Threshold">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-V">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomStartingMoney">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-W">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteOutputs?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="UseRandomRotations?">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightDistribution">
      <value value="&quot;Normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Run-Number">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomSeed">
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Animate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TypicalAmountFarmerIsWillingToLosePerField">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ROISeasonTolerance">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Social-Connections-per-Farmer">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InputIntensityDistribution">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Lognormal-Sigma">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IACSocialScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IndividualFieldCalcs?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Tracers?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPASD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInSocialSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NumberOfSeasons">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IACHabitScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="AcreageDistributionType">
      <value value="&quot;Categorical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPAAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CustomFarmerAccess">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PopulateMethod">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefsInEconomicSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="water-preference">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OffsetIrrigationWithSkill?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WorldFileName">
      <value value="&quot;0&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ChargeForOverdraw">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Consultants-per-Farmer">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInEconomicSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPBFinancialScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Use-Aqua-Crop">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Decision-Making">
      <value value="&quot;IAC Framework&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GWD">
      <value value="&quot;Magic Valley GWD&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PercVarWillingnessToLose">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightSeniorityDistribution">
      <value value="&quot;Uniform&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GeneratingWorlds?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="MagicValleySims-Thesis" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>GoExperimental</go>
    <metric>count farmers</metric>
    <metric>count patches with [owner != 0]</metric>
    <metric>count farmers with [farmsize &lt; 50]</metric>
    <metric>count farmers with [farmsize &gt; 50 AND farmsize &lt; 100]</metric>
    <metric>count farmers with [farmsize &gt; 100 AND farmsize &lt; 500]</metric>
    <metric>count farmers with [farmsize &gt; 500 AND farmsize &lt; 1000]</metric>
    <metric>count farmers with [farmsize &gt; 1000 AND farmsize &lt; 10000]</metric>
    <metric>count farmers with [rotation = "PotatoBeetGrainGrain"]</metric>
    <metric>count farmers with [rotation = "PotatoGrainBeetGrain"]</metric>
    <metric>count farmers with [rotation = "HayGrain"]</metric>
    <metric>count farmers with [rotation = "HayGrainPotatoGrain"]</metric>
    <metric>count farmers with [rotation = "PotatoGrainGrain"]</metric>
    <metric>count farmers with [rotation = "HayBarleyPotato"]</metric>
    <metric>count farmers with [rotation = "HayGrainGrainPotato"]</metric>
    <metric>count farmers with [rotation = "GrainPotatoBeetsHay"]</metric>
    <metric>count farmers with [rotation = "Landlord"]</metric>
    <metric>count patches with [PreferredLandUse = "Alfalfa"]</metric>
    <metric>count patches with [PreferredLandUse = "Barley"]</metric>
    <metric>count patches with [PreferredLandUse = "Corn"]</metric>
    <metric>count patches with [PreferredLandUse = "Potatoes"]</metric>
    <metric>count patches with [PreferredLandUse = "Spring Wheat"]</metric>
    <metric>count patches with [PreferredLandUse = "Sugarbeets"]</metric>
    <metric>count patches with [PreferredLandUse = "Winter Wheat"]</metric>
    <metric>count patches with [PreferredLandUse = "Alfalfa_Perennial"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Center Pivot LEPA"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Center Pivot LESA"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Center Pivot MESA"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Drip Tape"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Furrow"]</metric>
    <metric>NumberOfFarmersWithChangedWM</metric>
    <enumeratedValueSet variable="PerceptionThreshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInSocialSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FixRandomSeed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PrintReporters?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Simulate-ESPA_CAMP">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteDetailedCropBudgets?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IAC-PhysArous-Threshold">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-V">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomStartingMoney">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-W">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteOutputs?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="UseRandomRotations?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightDistribution">
      <value value="&quot;Normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Run-Number">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomSeed">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Animate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TypicalAmountFarmerIsWillingToLosePerField">
      <value value="2500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ROISeasonTolerance">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Social-Connections-per-Farmer">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InputIntensityDistribution">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Lognormal-Sigma">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IACSocialScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IndividualFieldCalcs?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Tracers?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPASD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInSocialSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NumberOfSeasons">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IACHabitScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="AcreageDistributionType">
      <value value="&quot;Categorical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPAAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CustomFarmerAccess">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PopulateMethod">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefsInEconomicSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="water-preference">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OffsetIrrigationWithSkill?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WorldFileName">
      <value value="&quot;0&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ChargeForOverdraw">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Consultants-per-Farmer">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInEconomicSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPBFinancialScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Use-Aqua-Crop">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Decision-Making">
      <value value="&quot;IAC Framework&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GWD">
      <value value="&quot;Magic Valley GWD&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PercVarWillingnessToLose">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightSeniorityDistribution">
      <value value="&quot;Uniform&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterfaceVariableFileName">
      <value value="&quot;/data/InterfaceInputs1.txt&quot;"/>
      <value value="&quot;/data/InterfaceInputs2.txt&quot;"/>
      <value value="&quot;/data/InterfaceInputs3.txt&quot;"/>
      <value value="&quot;/data/InterfaceInputs4.txt&quot;"/>
      <value value="&quot;/data/InterfaceInputs5.txt&quot;"/>
      <value value="&quot;/data/InterfaceInputs6.txt&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GeneratingWorlds?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Thesis Experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>goexperimental</go>
    <metric>count farmers</metric>
    <metric>ExperimentName</metric>
    <metric>RandomSeed</metric>
    <metric>Decision-Making</metric>
    <metric>ExperimentalToleranceforLoss</metric>
    <metric>InternalScalar</metric>
    <metric>ExternalScalar</metric>
    <metric>EfficacyScalar</metric>
    <metric>RhythmScalar</metric>
    <metric>PerceptionThreshold</metric>
    <metric>count patches with [owner != 0]</metric>
    <metric>count farmers with [farmsize &lt; 50]</metric>
    <metric>count farmers with [farmsize &gt; 50 AND farmsize &lt; 100]</metric>
    <metric>count farmers with [farmsize &gt; 100 AND farmsize &lt; 500]</metric>
    <metric>count farmers with [farmsize &gt; 500 AND farmsize &lt; 1000]</metric>
    <metric>count farmers with [farmsize &gt; 1000 AND farmsize &lt; 10000]</metric>
    <metric>count farmers with [rotation = "PotatoBeetGrainGrain"]</metric>
    <metric>count farmers with [rotation = "PotatoGrainBeetGrain"]</metric>
    <metric>count farmers with [rotation = "HayGrain"]</metric>
    <metric>count farmers with [rotation = "HayGrainPotatoGrain"]</metric>
    <metric>count farmers with [rotation = "PotatoGrainGrain"]</metric>
    <metric>count farmers with [rotation = "HayBarleyPotato"]</metric>
    <metric>count farmers with [rotation = "HayGrainGrainPotato"]</metric>
    <metric>count farmers with [rotation = "GrainPotatoBeetsHay"]</metric>
    <metric>count farmers with [rotation = "Landlord"]</metric>
    <metric>count patches with [PreferredLandUse = "Alfalfa"]</metric>
    <metric>count patches with [PreferredLandUse = "Barley"]</metric>
    <metric>count patches with [PreferredLandUse = "Corn"]</metric>
    <metric>count patches with [PreferredLandUse = "Potatoes"]</metric>
    <metric>count patches with [PreferredLandUse = "Spring Wheat"]</metric>
    <metric>count patches with [PreferredLandUse = "Sugarbeets"]</metric>
    <metric>count patches with [PreferredLandUse = "Winter Wheat"]</metric>
    <metric>count patches with [PreferredLandUse = "Alfalfa_Perennial"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Center Pivot LEPA"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Center Pivot LESA"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Center Pivot MESA"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Drip Tape"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Furrow"]</metric>
    <metric>NumberOfFarmersWithChangedWM</metric>
    <enumeratedValueSet variable="PerceptionThreshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInSocialSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FixRandomSeed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Simulate-ESPA_CAMP">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExperimentVariablesFile">
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PrintReporters?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteCropBudgets?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IAC-PhysArous-Threshold">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteDetailedCropBudgets?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-V">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomStartingMoney">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteOutputs?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-W">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="UseRandomRotations?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightDistribution">
      <value value="&quot;Normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Run-Number">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomSeed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TypicalAmountFarmerIsWillingToLosePerField">
      <value value="2500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Animate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ROISeasonTolerance">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Social-Connections-per-Farmer">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InputIntensityDistribution">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Lognormal-Sigma">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InternalScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IndividualFieldCalcs?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Tracers?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPASD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GeneratingWorlds?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInSocialSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExternalScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NumberOfSeasons">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EfficacyScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="AcreageDistributionType">
      <value value="&quot;Categorical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RhythmScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterfaceVariableFileName">
      <value value="&quot;/data/InterfaceInputs4.txt&quot;"/>
      <value value="&quot;/data/InterfaceInputs5.txt&quot;"/>
      <value value="&quot;/data/InterfaceInputs6.txt&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPAAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CustomFarmerAccess">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PopulateMethod">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefsInEconomicSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="water-preference">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OffsetIrrigationWithSkill?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WorldFileName">
      <value value="&quot;0&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ChargeForOverdraw">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Consultants-per-Farmer">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInEconomicSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Use-Aqua-Crop">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Decision-Making">
      <value value="&quot;IAC Framework&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PercVarWillingnessToLose">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GWD">
      <value value="&quot;Magic Valley GWD&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightSeniorityDistribution">
      <value value="&quot;Uniform&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Thesis Experiment-Refined after interrupt" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>goexperimental</go>
    <metric>count farmers</metric>
    <metric>ExperimentName</metric>
    <metric>RandomSeed</metric>
    <metric>Decision-Making</metric>
    <metric>ExperimentalToleranceforLoss</metric>
    <metric>InternalScalar</metric>
    <metric>ExternalScalar</metric>
    <metric>EfficacyScalar</metric>
    <metric>RhythmScalar</metric>
    <metric>PerceptionThreshold</metric>
    <metric>count patches with [owner != 0]</metric>
    <metric>count farmers with [farmsize &lt; 50]</metric>
    <metric>count farmers with [farmsize &gt; 50 AND farmsize &lt; 100]</metric>
    <metric>count farmers with [farmsize &gt; 100 AND farmsize &lt; 500]</metric>
    <metric>count farmers with [farmsize &gt; 500 AND farmsize &lt; 1000]</metric>
    <metric>count farmers with [farmsize &gt; 1000 AND farmsize &lt; 10000]</metric>
    <metric>count farmers with [rotation = "PotatoBeetGrainGrain"]</metric>
    <metric>count farmers with [rotation = "PotatoGrainBeetGrain"]</metric>
    <metric>count farmers with [rotation = "HayGrain"]</metric>
    <metric>count farmers with [rotation = "HayGrainPotatoGrain"]</metric>
    <metric>count farmers with [rotation = "PotatoGrainGrain"]</metric>
    <metric>count farmers with [rotation = "HayBarleyPotato"]</metric>
    <metric>count farmers with [rotation = "HayGrainGrainPotato"]</metric>
    <metric>count farmers with [rotation = "GrainPotatoBeetsHay"]</metric>
    <metric>count farmers with [rotation = "Landlord"]</metric>
    <metric>count patches with [PreferredLandUse = "Alfalfa"]</metric>
    <metric>count patches with [PreferredLandUse = "Barley"]</metric>
    <metric>count patches with [PreferredLandUse = "Corn"]</metric>
    <metric>count patches with [PreferredLandUse = "Potatoes"]</metric>
    <metric>count patches with [PreferredLandUse = "Spring Wheat"]</metric>
    <metric>count patches with [PreferredLandUse = "Sugarbeets"]</metric>
    <metric>count patches with [PreferredLandUse = "Winter Wheat"]</metric>
    <metric>count patches with [PreferredLandUse = "Alfalfa_Perennial"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Center Pivot LEPA"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Center Pivot LESA"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Center Pivot MESA"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Drip Tape"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Furrow"]</metric>
    <metric>NumberOfFarmersWithChangedWM</metric>
    <enumeratedValueSet variable="PerceptionThreshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInSocialSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FixRandomSeed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Simulate-ESPA_CAMP">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExperimentVariablesFile">
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-100_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PrintReporters?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteCropBudgets?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IAC-PhysArous-Threshold">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteDetailedCropBudgets?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-V">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomStartingMoney">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteOutputs?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-W">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="UseRandomRotations?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightDistribution">
      <value value="&quot;Normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Run-Number">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomSeed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TypicalAmountFarmerIsWillingToLosePerField">
      <value value="2500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Animate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ROISeasonTolerance">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Social-Connections-per-Farmer">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InputIntensityDistribution">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Lognormal-Sigma">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InternalScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IndividualFieldCalcs?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Tracers?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPASD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GeneratingWorlds?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInSocialSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExternalScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NumberOfSeasons">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EfficacyScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="AcreageDistributionType">
      <value value="&quot;Categorical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RhythmScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterfaceVariableFileName">
      <value value="&quot;/data/InterfaceInputs4.txt&quot;"/>
      <value value="&quot;/data/InterfaceInputs5.txt&quot;"/>
      <value value="&quot;/data/InterfaceInputs6.txt&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPAAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CustomFarmerAccess">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PopulateMethod">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefsInEconomicSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="water-preference">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OffsetIrrigationWithSkill?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WorldFileName">
      <value value="&quot;0&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ChargeForOverdraw">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Consultants-per-Farmer">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInEconomicSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Use-Aqua-Crop">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Decision-Making">
      <value value="&quot;IAC Framework&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PercVarWillingnessToLose">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GWD">
      <value value="&quot;Magic Valley GWD&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightSeniorityDistribution">
      <value value="&quot;Uniform&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Thesis Experiment - CFO 0 and 1000" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>goexperimental</go>
    <metric>count farmers</metric>
    <metric>ExperimentName</metric>
    <metric>RandomSeed</metric>
    <metric>Decision-Making</metric>
    <metric>ExperimentalToleranceforLoss</metric>
    <metric>ChargeForOverdraw</metric>
    <metric>InternalScalar</metric>
    <metric>ExternalScalar</metric>
    <metric>EfficacyScalar</metric>
    <metric>RhythmScalar</metric>
    <metric>PerceptionThreshold</metric>
    <metric>count patches with [owner != 0]</metric>
    <metric>count farmers with [farmsize &lt; 50]</metric>
    <metric>count farmers with [farmsize &gt; 50 AND farmsize &lt; 100]</metric>
    <metric>count farmers with [farmsize &gt; 100 AND farmsize &lt; 500]</metric>
    <metric>count farmers with [farmsize &gt; 500 AND farmsize &lt; 1000]</metric>
    <metric>count farmers with [farmsize &gt; 1000 AND farmsize &lt; 10000]</metric>
    <metric>count farmers with [rotation = "PotatoBeetGrainGrain"]</metric>
    <metric>count farmers with [rotation = "PotatoGrainBeetGrain"]</metric>
    <metric>count farmers with [rotation = "HayGrain"]</metric>
    <metric>count farmers with [rotation = "HayGrainPotatoGrain"]</metric>
    <metric>count farmers with [rotation = "PotatoGrainGrain"]</metric>
    <metric>count farmers with [rotation = "HayBarleyPotato"]</metric>
    <metric>count farmers with [rotation = "HayGrainGrainPotato"]</metric>
    <metric>count farmers with [rotation = "GrainPotatoBeetsHay"]</metric>
    <metric>count farmers with [rotation = "Landlord"]</metric>
    <metric>count patches with [PreferredLandUse = "Alfalfa"]</metric>
    <metric>count patches with [PreferredLandUse = "Barley"]</metric>
    <metric>count patches with [PreferredLandUse = "Corn"]</metric>
    <metric>count patches with [PreferredLandUse = "Potatoes"]</metric>
    <metric>count patches with [PreferredLandUse = "Spring Wheat"]</metric>
    <metric>count patches with [PreferredLandUse = "Sugarbeets"]</metric>
    <metric>count patches with [PreferredLandUse = "Winter Wheat"]</metric>
    <metric>count patches with [PreferredLandUse = "Alfalfa_Perennial"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Center Pivot LEPA"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Center Pivot LESA"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Center Pivot MESA"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Drip Tape"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Furrow"]</metric>
    <metric>NumberOfFarmersWithChangedWM</metric>
    <enumeratedValueSet variable="PerceptionThreshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInSocialSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FixRandomSeed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Simulate-ESPA_CAMP">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExperimentVariablesFile">
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-Theory of Planned Behavior_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-0_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-0.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-0.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-0.5_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1_RS-1_PT-0.75.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.25.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.5.txt&quot;"/>
      <value value="&quot;/data/Experiment_DM-IAC Framework_TFL-2500_CFO-1000_IS-1.5_ES-1.5_EffS-1.5_RS-1_PT-0.75.txt&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PrintReporters?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteCropBudgets?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IAC-PhysArous-Threshold">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteDetailedCropBudgets?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-V">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomStartingMoney">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteOutputs?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-W">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="UseRandomRotations?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightDistribution">
      <value value="&quot;Normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Run-Number">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomSeed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TypicalAmountFarmerIsWillingToLosePerField">
      <value value="2500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Animate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ROISeasonTolerance">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Social-Connections-per-Farmer">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InputIntensityDistribution">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Lognormal-Sigma">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InternalScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IndividualFieldCalcs?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Tracers?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPASD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GeneratingWorlds?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInSocialSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExternalScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NumberOfSeasons">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EfficacyScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="AcreageDistributionType">
      <value value="&quot;Categorical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RhythmScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterfaceVariableFileName">
      <value value="&quot;/data/InterfaceInputs4.txt&quot;"/>
      <value value="&quot;/data/InterfaceInputs5.txt&quot;"/>
      <value value="&quot;/data/InterfaceInputs6.txt&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPAAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CustomFarmerAccess">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PopulateMethod">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefsInEconomicSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="water-preference">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OffsetIrrigationWithSkill?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WorldFileName">
      <value value="&quot;0&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ChargeForOverdraw">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Consultants-per-Farmer">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInEconomicSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Use-Aqua-Crop">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Decision-Making">
      <value value="&quot;IAC Framework&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PercVarWillingnessToLose">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GWD">
      <value value="&quot;Magic Valley GWD&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightSeniorityDistribution">
      <value value="&quot;Uniform&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="GeneratingWorlds-Thesis Revisions" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>goexperimental</go>
    <exitCondition>Finished = TRUE</exitCondition>
    <metric>count farmers</metric>
    <metric>count patches with [owner != 0]</metric>
    <metric>count farmers with [farmsize &lt; 50]</metric>
    <metric>count farmers with [farmsize &gt; 50 AND farmsize &lt; 100]</metric>
    <metric>count farmers with [farmsize &gt; 100 AND farmsize &lt; 500]</metric>
    <metric>count farmers with [farmsize &gt; 500 AND farmsize &lt; 1000]</metric>
    <metric>count farmers with [farmsize &gt; 1000 AND farmsize &lt; 10000]</metric>
    <metric>count farmers with [rotation = "PotatoBeetGrainGrain"]</metric>
    <metric>count farmers with [rotation = "PotatoGrainBeetGrain"]</metric>
    <metric>count farmers with [rotation = "HayGrain"]</metric>
    <metric>count farmers with [rotation = "HayGrainPotatoGrain"]</metric>
    <metric>count farmers with [rotation = "PotatoGrainGrain"]</metric>
    <metric>count farmers with [rotation = "HayBarleyPotato"]</metric>
    <metric>count farmers with [rotation = "HayGrainGrainPotato"]</metric>
    <metric>count farmers with [rotation = "GrainPotatoBeetsHay"]</metric>
    <metric>count farmers with [rotation = "Landlord"]</metric>
    <enumeratedValueSet variable="PerceptionThreshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInSocialSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FixRandomSeed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PrintReporters?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Simulate-ESPA_CAMP">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteDetailedCropBudgets?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IAC-PhysArous-Threshold">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-V">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomStartingMoney">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-W">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteOutputs?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="UseRandomRotations?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightDistribution">
      <value value="&quot;Normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Run-Number">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomSeed">
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Animate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TypicalAmountFarmerIsWillingToLosePerField">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ROISeasonTolerance">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Social-Connections-per-Farmer">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InputIntensityDistribution">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Lognormal-Sigma">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IACSocialScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IndividualFieldCalcs?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Tracers?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPASD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInSocialSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NumberOfSeasons">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IACHabitScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="AcreageDistributionType">
      <value value="&quot;Categorical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPAAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CustomFarmerAccess">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PopulateMethod">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefsInEconomicSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="water-preference">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OffsetIrrigationWithSkill?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WorldFileName">
      <value value="&quot;0&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ChargeForOverdraw">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Consultants-per-Farmer">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInEconomicSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPBFinancialScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Use-Aqua-Crop">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Decision-Making">
      <value value="&quot;IAC Framework&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GWD">
      <value value="&quot;Aberdeen-American Falls GWD&quot;"/>
      <value value="&quot;Bingham GWD&quot;"/>
      <value value="&quot;Bonneville-Jefferson GWD&quot;"/>
      <value value="&quot;Carey Valley GWD&quot;"/>
      <value value="&quot;Jefferson-Clark GWD&quot;"/>
      <value value="&quot;Magic Valley GWD&quot;"/>
      <value value="&quot;North Snake GWD&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PercVarWillingnessToLose">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightSeniorityDistribution">
      <value value="&quot;Uniform&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GeneratingWorlds?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Thesis Experiment - Revisions" repetitions="1" runMetricsEveryStep="true">
    <setup>setupexperimental</setup>
    <go>goexperimental</go>
    <exitCondition>Finished = TRUE</exitCondition>
    <metric>count farmers</metric>
    <metric>ExperimentName</metric>
    <metric>RandomSeed</metric>
    <metric>Decision-Making</metric>
    <metric>ExperimentalToleranceforLoss</metric>
    <metric>InternalScalar</metric>
    <metric>ExternalScalar</metric>
    <metric>EfficacyScalar</metric>
    <metric>RhythmScalar</metric>
    <metric>PerceptionThreshold</metric>
    <metric>count patches with [owner != 0]</metric>
    <metric>count farmers with [farmsize &lt; 50]</metric>
    <metric>count farmers with [farmsize &gt; 50 AND farmsize &lt; 100]</metric>
    <metric>count farmers with [farmsize &gt; 100 AND farmsize &lt; 500]</metric>
    <metric>count farmers with [farmsize &gt; 500 AND farmsize &lt; 1000]</metric>
    <metric>count farmers with [farmsize &gt; 1000 AND farmsize &lt; 10000]</metric>
    <metric>count farmers with [rotation = "PotatoBeetGrainGrain"]</metric>
    <metric>count farmers with [rotation = "PotatoGrainBeetGrain"]</metric>
    <metric>count farmers with [rotation = "HayGrain"]</metric>
    <metric>count farmers with [rotation = "HayGrainPotatoGrain"]</metric>
    <metric>count farmers with [rotation = "PotatoGrainGrain"]</metric>
    <metric>count farmers with [rotation = "HayBarleyPotato"]</metric>
    <metric>count farmers with [rotation = "HayGrainGrainPotato"]</metric>
    <metric>count farmers with [rotation = "GrainPotatoBeetsHay"]</metric>
    <metric>count farmers with [rotation = "Landlord"]</metric>
    <metric>count patches with [PreferredLandUse = "Alfalfa"]</metric>
    <metric>count patches with [PreferredLandUse = "Barley"]</metric>
    <metric>count patches with [PreferredLandUse = "Corn"]</metric>
    <metric>count patches with [PreferredLandUse = "Potatoes"]</metric>
    <metric>count patches with [PreferredLandUse = "Spring Wheat"]</metric>
    <metric>count patches with [PreferredLandUse = "Sugarbeets"]</metric>
    <metric>count patches with [PreferredLandUse = "Winter Wheat"]</metric>
    <metric>count patches with [PreferredLandUse = "Alfalfa_Perennial"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Center Pivot LEPA"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Center Pivot LESA"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Center Pivot MESA"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Drip Tape"]</metric>
    <metric>count patches with [TypeOfIrrigation = "Furrow"]</metric>
    <metric>NumberOfFarmersWithChangedWM</metric>
    <enumeratedValueSet variable="PerceptionThreshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInSocialSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FixRandomSeed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Simulate-ESPA_CAMP">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExperimentVariablesFile">
      <value value="&quot;/data/ExperimentVariables.txt&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PrintReporters?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteCropBudgets?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IAC-PhysArous-Threshold">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteDetailedCropBudgets?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-V">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomStartingMoney">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteOutputs?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-W">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="UseRandomRotations?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightDistribution">
      <value value="&quot;Normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Run-Number">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomSeed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TypicalAmountFarmerIsWillingToLosePerField">
      <value value="2500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Animate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ROISeasonTolerance">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Social-Connections-per-Farmer">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InputIntensityDistribution">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Lognormal-Sigma">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InternalScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IndividualFieldCalcs?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Tracers?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPASD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GeneratingWorlds?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInSocialSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExternalScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NumberOfSeasons">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EfficacyScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="AcreageDistributionType">
      <value value="&quot;Categorical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RhythmScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterfaceVariableFileName">
      <value value="&quot;/data/InterfaceInputs4.txt&quot;"/>
      <value value="&quot;/data/InterfaceInputs5.txt&quot;"/>
      <value value="&quot;/data/InterfaceInputs6.txt&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPAAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CustomFarmerAccess">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PopulateMethod">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefsInEconomicSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="water-preference">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OffsetIrrigationWithSkill?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WorldFileName">
      <value value="&quot;0&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ChargeForOverdraw">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Consultants-per-Farmer">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInEconomicSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Use-Aqua-Crop">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Decision-Making">
      <value value="&quot;IAC Framework&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PercVarWillingnessToLose">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GWD">
      <value value="&quot;Magic Valley GWD&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightSeniorityDistribution">
      <value value="&quot;Uniform&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="RevisionsTest" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <final>EvaluateRunR</final>
    <metric>count turtles</metric>
    <metric>potato-rot-count</metric>
    <metric>beet-rot-count</metric>
    <metric>alfalfa-rot-count</metric>
    <metric>grain-rot-count</metric>
    <metric>barley-rot-count</metric>
    <metric>rot-sum</metric>
    <metric>potato-count</metric>
    <metric>beet-count</metric>
    <metric>alfalfa-count</metric>
    <metric>sw-count</metric>
    <metric>ww-count</metric>
    <metric>corn-count</metric>
    <metric>barley-count</metric>
    <metric>a-p-count</metric>
    <metric>alfalfa-total-count</metric>
    <metric>grain-count</metric>
    <metric>total-crops</metric>
    <enumeratedValueSet variable="PerceptionThreshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInSocialSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FixRandomSeed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Simulate-ESPA_CAMP">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExperimentVariablesFile">
      <value value="&quot;/data/ExperimentVariables.txt&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteCropBudgets?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PrintReporters?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IAC-PhysArous-Threshold">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteDetailedCropBudgets?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-V">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomStartingMoney">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-Ratio-W">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WriteOutputs?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="UseRandomRotations?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightDistribution">
      <value value="&quot;Normal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Run-Number">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RandomSeed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TypicalAmountFarmerIsWillingToLosePerField">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Animate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ROISeasonTolerance">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Social-Connections-per-Farmer">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InputIntensityDistribution">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Lognormal-Sigma">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InternalScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IndividualFieldCalcs?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Tracers?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExternalScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInSocialSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPASD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GeneratingWorlds?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NumberOfSeasons">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EfficacyScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="AcreageDistributionType">
      <value value="&quot;Categorical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RhythmScalar">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterfaceVariableFileName">
      <value value="&quot;/data/InterfaceInputs6.txt&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInESPAAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CustomFarmerAccess">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PopulateMethod">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefsInEconomicSanctionsSD">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="water-preference">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="OffsetIrrigationWithSkill?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WorldFileName">
      <value value="&quot;Aberdeen-American Falls GWD_EmptyWorld_Run 1_InformedRotations&quot;"/>
      <value value="&quot;Aberdeen-American Falls GWD_EmptyWorld_Run 2_InformedRotations&quot;"/>
      <value value="&quot;Aberdeen-American Falls GWD_EmptyWorld_Run 3_InformedRotations&quot;"/>
      <value value="&quot;Bingham GWD_EmptyWorld_Run 1_InformedRotations&quot;"/>
      <value value="&quot;Bingham GWD_EmptyWorld_Run 2_InformedRotations&quot;"/>
      <value value="&quot;Bingham GWD_EmptyWorld_Run 3_InformedRotations&quot;"/>
      <value value="&quot;Bonneville-Jefferson GWD_EmptyWorld_Run 1_InformedRotations&quot;"/>
      <value value="&quot;Bonneville-Jefferson GWD_EmptyWorld_Run 2_InformedRotations&quot;"/>
      <value value="&quot;Bonneville-Jefferson GWD_EmptyWorld_Run 3_InformedRotations&quot;"/>
      <value value="&quot;Carey Valley GWD_EmptyWorld_Run 1_InformedRotations&quot;"/>
      <value value="&quot;Carey Valley GWD_EmptyWorld_Run 2_InformedRotations&quot;"/>
      <value value="&quot;Carey Valley GWD_EmptyWorld_Run 3_InformedRotations&quot;"/>
      <value value="&quot;Jefferson-Clark GWD_EmptyWorld_Run 1_InformedRotations&quot;"/>
      <value value="&quot;Jefferson-Clark GWD_EmptyWorld_Run 2_InformedRotations&quot;"/>
      <value value="&quot;Jefferson-Clark GWD_EmptyWorld_Run 3_InformedRotations&quot;"/>
      <value value="&quot;Magic Valley GWD_EmptyWorld_Run 1_InformedRotations&quot;"/>
      <value value="&quot;Magic Valley GWD_EmptyWorld_Run 2_InformedRotations&quot;"/>
      <value value="&quot;Magic Valley GWD_EmptyWorld_Run 3_InformedRotations&quot;"/>
      <value value="&quot;North Snake GWD_EmptyWorld_Run 1_InformedRotations&quot;"/>
      <value value="&quot;North Snake GWD_EmptyWorld_Run 2_InformedRotations&quot;"/>
      <value value="&quot;North Snake GWD_EmptyWorld_Run 3_InformedRotations&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ChargeForOverdraw">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Consultants-per-Farmer">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Use-Aqua-Crop">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PercVarWillingnessToLose">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BeliefInEconomicSanctionsAverage">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Decision-Making">
      <value value="&quot;Rational Actor Theory&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GWD">
      <value value="&quot;Magic Valley GWD&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WaterRightSeniorityDistribution">
      <value value="&quot;Uniform&quot;"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
