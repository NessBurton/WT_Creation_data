
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
head(dfSites)

dfCompartments <- read.csv(paste0(dirData,"WT_subcompartments.csv"))
head(dfCompartments)

dfEDSubcomps <- read.csv(paste0(dirData,"ED_compartments.csv"))
head(dfEDSubcomps)

dfCreation <- read.csv(paste0(dirData,"Creation-history.csv"))
head(dfCreation)

### do stuff -------------------------------------------------------------------

# join sites and subcompartments by ManUnit. need to keep all subcomps & duplicate site records

# join with ED data to get management regime and main species

# work out creation site age from PlantingDate in creation history data

# pull out site manager names for relevant sites

