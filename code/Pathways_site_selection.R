
# date: 07/01/2026
# author: VB
# desc: script to explore WT site & subcompartment data, linked to historical creation data

### packages -------------------------------------------------------------------

library(tidyverse)

### directories ----------------------------------------------------------------

wd <- "~/R/Data-Analysis/WT_creation_data"
dirData <- paste0(wd,"/data-raw/")
dirScratch <- paste0(wd,"/data-scratch/")
dirOut <- paste0(wd,"/data-out/")
dirFigs <- paste0(wd,"/figures/")

### read in data ---------------------------------------------------------------

dfSites <- read.csv(paste0(dirData,"WT_sites.csv"))
tibble(dfSites)

dfCompartments <- read.csv(paste0(dirData,"WT_subcompartments.csv"))
tibble(dfCompartments)
dfCompartments$ManUnit <- as.integer(dfCompartments$ManUnit)

dfEDSubcomps <- read.csv(paste0(dirData,"ED_compartments.csv"))

dfCreation <- read.csv(paste0(dirData,"Creation-history.csv"))
tibble(dfCreation)

### do stuff -------------------------------------------------------------------

# join sites and subcompartments by ManUnit. need to keep all subcomps & duplicate site records

dfSites |> 
  count(ManUnit) |> 
  filter(n > 1)

dfCompartments |> 
  count(ManUnit)

dfSites2 <- dfSites |> 
  select(WoodName,ManUnit,Region,SiteManager,Hectares) |> 
  left_join(dfCompartments |> mutate(Cpt = Cpt..) |>  select(ManUnit,Cpt,SubCpt,Area_ha), relationship = "many-to-many")

tibble(dfSites2)

# join with ED data to get management regime and main species

tibble(dfEDSubcomps)

dfSites3 <- dfSites2 |> 
  left_join(dfEDSubcomps |> mutate(WoodName = Site.Name) |> select(WoodName, Cpt, SubCpt, Management.Regime, Main.Species, Secondary.Species, Year))

# filter to just woodland establishment



# work out creation site age from PlantingDate in creation history data

# pull out site manager names for relevant sites

