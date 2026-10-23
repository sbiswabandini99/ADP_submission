## NFHS files: locating and checking them.
## The 8 files can sit anywhere inside DHS_RAW_DIR (set in config.R), at any depth, so the DHS
## Program's zip files can be unzipped as they come. Only the file names matter (any case).
DHS_FILES <- c(
  "IAKR74FL.DTA",   # children, NFHS-4
  "IAKR7EFL.DTA",   # children, NFHS-5
  "IAHR74FL.DTA",   # households, NFHS-4
  "IAHR7EFL.DTA",   # households, NFHS-5
  "IAIR74FL.DTA",   # women, NFHS-4
  "IAIR7EFL.DTA",   # women, NFHS-5
  "IABR74FL.DTA",   # births, NFHS-4
  "IABR7EFL.DTA")   # births, NFHS-5

## dhs_file(): full path of one NFHS file, searched for anywhere under DHS_RAW_DIR.
## Stops if the file is missing or if more than one copy exists (which copy to use would be unclear).
dhs_file <- function(name, dir = DHS_RAW_DIR) {
  name <- basename(name)
  hits <- list.files(dir, pattern = paste0("^", gsub(".", "\\.", name, fixed = TRUE), "$"),
                     recursive = TRUE, full.names = TRUE, ignore.case = TRUE)
  if (length(hits) == 0) stop("NFHS file not found under ", dir, ": ", name, " (README, section 2)")
  if (length(hits) > 1)  stop("More than one copy of ", name, " under ", dir, ":\n  ",
                              paste(hits, collapse = "\n  "), "\nKeep one copy.")
  hits
}

## check_dhs_files(): stops at the start of a run, listing every missing or duplicated file.
check_dhs_files <- function(dir = DHS_RAW_DIR) {
  problems <- character(0)
  for (f in DHS_FILES) {
    res <- tryCatch(dhs_file(f, dir), error = function(e) conditionMessage(e))
    if (!file.exists(res[1])) problems <- c(problems, res)
  }
  if (length(problems)) stop(paste(problems, collapse = "\n"))
  message("All 8 NFHS files found under ", dir)
  invisible(TRUE)
}
