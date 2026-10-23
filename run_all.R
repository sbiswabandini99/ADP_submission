## =============================================================================
## run_all.R: reproduce every result in the thesis with one command
## =============================================================================
## Usage: open ADP_Project.Rproj in RStudio, then in the console run
##   source("run_all.R")
##
## 1. Installs any required R package that is not yet installed (first run only).
## 2. Checks that the 8 NFHS files are in place (README, section 2).
## 3. Knits ADP_pipeline.Rmd to ADP_pipeline.html: every code chunk next to its output.
## 4. Writes all tables to outputs/tables/ and all figures to outputs/figures/.
## =============================================================================

## 1. Packages. The versions used for the thesis are listed at the end of ADP_pipeline.html.
PKGS <- c("here", "haven", "dplyr", "tidyr", "tibble", "stringr", "readr", "ggplot2", "scales",
          "MatchIt", "optmatch", "Matching", "rgenoud", "sandwich", "lmtest", "digest",
          "knitr", "rmarkdown")
missing_pkgs <- PKGS[!vapply(PKGS, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing_pkgs)) {
  message("Installing ", length(missing_pkgs), " package(s): ", paste(missing_pkgs, collapse = ", "))
  install.packages(missing_pkgs, repos = "https://cloud.r-project.org")
}

## 2. Paths and the NFHS files
source(here::here("config.R"))                 # stops with a message if the NFHS folder is not found
source(here::here("R", "check_dhs.R"))
check_dhs_files()                              # stops and lists any missing NFHS file

## 3-4. Run the analysis
t0 <- Sys.time()
rmarkdown::render(here::here("ADP_pipeline.Rmd"),
                  output_format = "html_document",
                  output_file   = "ADP_pipeline.html",
                  output_dir    = here::here(),
                  envir         = new.env())   # clean environment: nothing from the console leaks in
message("Finished in ", round(as.numeric(difftime(Sys.time(), t0, units = "mins"))), " minutes. ",
        "Results: ADP_pipeline.html, outputs/tables/, outputs/figures/.")
