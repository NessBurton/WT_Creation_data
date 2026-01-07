
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

dfSites <- tibble(read.csv(paste0(dirData,"WT_sites.csv")))

dfCompartments <- tibble(read.csv(paste0(dirData,"WT_subcompartments.csv")))
dfCompartments$ManUnit <- as.integer(dfCompartments$ManUnit)

dfEDSubcomps <- tibble(read.csv(paste0(dirData,"ED_compartments.csv")))

dfCreation <- tibble(read.csv(paste0(dirData,"Creation-history.csv")))

### do stuff -------------------------------------------------------------------

# join sites and subcompartments by ManUnit. need to keep all subcomps & duplicate site records

dfSites |> 
  count(ManUnit) |> 
  filter(n > 1)

dfCompartments |> 
  count(ManUnit)

dfSites2 <- dfSites |> 
  select(WoodName,ManUnit,Region,SiteManager,Hectares) |> 
  left_join(dfCompartments |> 
              mutate(Cpt = Cpt..) |>  
              select(ManUnit,Cpt,SubCpt,Area_ha), relationship = "many-to-many")

# join with ED data to get management regime and main species

dfEDSubcomps

dfSites3 <- tibble(dfSites2) |> 
  left_join(dfEDSubcomps |> 
              mutate(WoodName = Site.Name) |> 
              select(WoodName, Cpt, SubCpt, Management.Regime, Main.Species, Secondary.Species, Year))

# filter to just woodland establishment

dfSites4 <- tibble(dfSites3) |> 
  filter(Management.Regime == "Wood establishment") |> 
  mutate(Year = as.numeric(Year)) |> 
  filter(Year <= 2005) |> 
  mutate(WoodAge = 2025 - Year) |> 
  filter(WoodAge <=30)

dfSites4

ggplot(dfSites4, aes(x=Main.Species, fill = Main.Species))+
  geom_bar()+
  facet_wrap(~Region, nrow = 2) + 
  theme(axis.text.x = element_text(angle = 90))

ggplot(dfSites4, aes(x=Year, fill = Region))+
  geom_bar()+
  #facet_wrap(~Region, nrow = 2) + 
  theme(axis.text.x = element_text(angle = 45))

unique(dfSites4$WoodName) # 50 sites
unique(dfSites4$SiteManager)
mean(dfSites4$Hectares) # average site size
mean(as.numeric(dfSites4$Area_ha)) # average subcompartment size

# work out creation site age from PlantingDate in creation history data

# pull out site manager names for relevant sites

