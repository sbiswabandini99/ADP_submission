## =============================================================================
## config.R: paths and run settings, in one place
## =============================================================================
## Every path in the pipeline is built from the objects below. here::here() finds the
## project root through ADP_Project.Rproj / .here, so the code runs the same wherever
## RStudio's working directory is.

library(here)

PROJECT_DIR <- here::here()

## Folder with the NFHS files: put the 8 .DTA files in data/raw/nfhs/ (README, section 2).
## (Advanced users can point elsewhere by setting ADP_DHS_DIR in a .Renviron file.)
DHS_RAW_DIR <- Sys.getenv("ADP_DHS_DIR", unset = here::here("data", "raw", "nfhs"))
EXT_RAW_DIR <- here::here("data", "raw", "external")   # SECC 2011, U-DISE 2015-16, Saubhagya
LOOKUP_DIR  <- here::here("data", "lookups")           # official AD list, district links and matches
INTER_DIR   <- here::here("data", "intermediate")      # files written by the pipeline (not shared)
TABLE_DIR   <- here::here("outputs", "tables")
FIG_DIR     <- here::here("outputs", "figures")

for (d in c(INTER_DIR, TABLE_DIR, FIG_DIR)) dir.create(d, showWarnings = FALSE, recursive = TRUE)

## Unzipping NFHS_data.zip on some systems (e.g. Windows "Extract All") creates
## NFHS_data/NFHS_data/. If the files are one level down, use that folder.
if (!file.exists(file.path(DHS_RAW_DIR, "IAKR74FL.DTA")) &&
    file.exists(file.path(DHS_RAW_DIR, "NFHS_data", "IAKR74FL.DTA"))) {
  DHS_RAW_DIR <- file.path(DHS_RAW_DIR, "NFHS_data")
}

if (!dir.exists(DHS_RAW_DIR)) {
  stop("NFHS data folder not found: ", DHS_RAW_DIR,
       "\nPut the 8 NFHS .DTA files in the folder data/raw/nfhs/ (README, section 2).")
}

## The knitted document runs every chunk from data/intermediate (set in the Rmd's setup chunk).
## Interactive runs use the same working directory, so both behave identically.
if (!isTRUE(getOption("knitr.in.progress"))) setwd(INTER_DIR)

SEED <- 42   # every random step (genetic matching, permutation inference)
