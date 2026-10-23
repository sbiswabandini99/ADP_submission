# Aspirational Districts Programme and women's empowerment: replication code

Replication package for the thesis *Aspirational Districts and Women's Empowerment in India: Evidence
from India's National Family Health Survey* (ECOM90027 Econometrics Research Report Part 2,
Master of Applied Econometrics (Enhanced), University of Melbourne, 2026), by Sukanya Biswabandini.

The thesis replicates the propensity-score-matched difference-in-differences evaluation of India's
Aspirational Districts Programme (ADP) by Agarwal and Mishra (2024), using NFHS-4 (2015-16) and
NFHS-5 (2019-21), and extends it to women's empowerment.

The whole analysis is one R Markdown file, `ADP_pipeline.Rmd`, which runs from the raw NFHS files to
every table and figure in the thesis. `ADP_pipeline.html` is the knitted version: every code chunk
with its output, so all results can be checked without running the code.

## Quick start

1. Download the 8 NFHS files from The DHS Program (section 2) into one folder.
2. Tell the code where that folder is (section 3): either name it `NFHS_data` and put it next to
   this repository's folder, or set its path in a `.Renviron` file.
3. Open `ADP_Project.Rproj` in RStudio and run `source("run_all.R")` in the console.
4. Compare the results with the thesis using section 5.

## 1. Requirements

- R (4.5 or later; the thesis used R 4.5.1) and RStudio. `run_all.R` installs any missing package on the first run; the
  versions used for the thesis are listed at the end of `ADP_pipeline.html`.
- At least 16 GB of RAM: Stage 01 reads the full NFHS household and women's files.
- About 20 minutes for the first run from the raw files, and about 7 minutes for later runs, which
  reuse the extracts saved in `data/intermediate/checkpoints/`.
- Python is not needed: `R/build_district_links.py` was run once and its output is included.
- The NFHS-4 and NFHS-5 data files (section 2).

## 2. NFHS data

The NFHS data are distributed by The DHS Program and cannot be shared, so they are not included.
To obtain them:

1. Register at dhsprogram.com and request access to the India surveys **2015-16 (NFHS-4)** and
   **2019-21 (NFHS-5)**.
2. Download these four datasets for each survey, in **Stata** format: Children's Recode (KR),
   Household Recode (HR), Individual (women's) Recode (IR) and Births' Recode (BR).
3. Unzip them into one folder, for example `NFHS_data/`. The folder can contain other files and
   subfolders: the code searches it for the 8 files below by name (upper or lower case), wherever
   they are inside it. Each file must appear only once.

| File | Survey | Recode |
|---|---|---|
| `IAKR74FL.DTA` | NFHS-4 | Children (KR) |
| `IAKR7EFL.DTA` | NFHS-5 | Children (KR) |
| `IAHR74FL.DTA` | NFHS-4 | Households (HR) |
| `IAHR7EFL.DTA` | NFHS-5 | Households (HR) |
| `IAIR74FL.DTA` | NFHS-4 | Women (IR) |
| `IAIR7EFL.DTA` | NFHS-5 | Women (IR) |
| `IABR74FL.DTA` | NFHS-4 | Births (BR) |
| `IABR7EFL.DTA` | NFHS-5 | Births (BR) |

All other inputs (SECC 2011, U-DISE 2015-16, Saubhagya, the official list of Aspirational Districts
and the district links) are public and included in `data/` (sections 6 and 7).

## 3. How to run

The only setup is telling the code where the NFHS folder is. Either:

- **put the folder next to this repository** and name it `NFHS_data`:

  ```
  any_folder/
    <this repository>/
    NFHS_data/          (the 8 NFHS files, section 2)
  ```

- **or set its path**: copy `.Renviron.example` to a new file named `.Renviron` in the repository
  folder, set `ADP_DHS_DIR` to the full path of the NFHS folder, and restart R (Session > Restart R).
  On Windows, use forward slashes, for example `ADP_DHS_DIR="C:/Users/name/Data/NFHS_data"`.
  Files whose names start with a dot are hidden by default: on a Mac, press Cmd + Shift + . in
  Finder to show them; on Windows, tick *View > Hidden items* in File Explorer. The file can also be
  created in RStudio (*File > New File > Text File*, then save it as `.Renviron` in the repository
  folder).

Then:

1. Open `ADP_Project.Rproj` in RStudio.
2. In the R console, run `source("run_all.R")`.

`run_all.R` installs any missing package, checks that all 8 NFHS files are found (it stops and lists
any that are missing), knits `ADP_pipeline.Rmd` to `ADP_pipeline.html`, and writes every table to
`outputs/tables/` and every figure to `outputs/figures/`. Section 5 lists which file gives each table
and figure in the thesis. Every random step uses a fixed seed (42, in `config.R`). With the package
versions listed at the end of `ADP_pipeline.html`, a rerun reproduces the outputs exactly; newer
versions of the matching packages can change later decimal places of the genetic-matching
robustness checks. Intermediate files, including individual-level extracts of the NFHS data, are
written to `data/intermediate/`, which is created on the first run and must not be shared.

**Checking the results.** The repository already contains the outputs used in the thesis, and a run
overwrites them. To compare a run with the thesis outputs, copy `outputs/tables/` to another folder
before running, then compare the two folders; every file should be identical. Section 5 gives the
file behind each thesis table and figure.

**If the run stops:**

| Message | What to do |
|---|---|
| `NFHS data folder not found` | The path in `.Renviron` is wrong or R was not restarted after saving it, or `NFHS_data` is not next to the repository folder |
| `NFHS file not found under ...` | One of the 8 files in section 2 is missing from the folder, or was not unzipped |
| `More than one copy of ...` | The same file is in the folder twice (for example in two subfolders); keep one copy |
| A package fails to install | Install it by hand with `install.packages("name")`, then run `source("run_all.R")` again |
| R runs out of memory | Close other programs; the first run needs about 16 GB of RAM |

## 4. Pipeline

| Stage in `ADP_pipeline.Rmd` | What it does | Outputs in `outputs/` |
|---|---|---|
| 01 Child-level data | NFHS covariates and health outcomes, validated against the NFHS-4 and NFHS-5 national reports | |
| 02 Treatment | The 112 Aspirational Districts from NITI Aayog's official list, matched to NFHS districts | |
| 03 External covariates | Landless households (SECC 2011), adverse pupil-teacher ratio (U-DISE 2015-16), unelectrified households (Saubhagya, October 2017) | |
| 05 Linking the rounds (there is no Stage 04) | Links NFHS-4 and NFHS-5 districts; keeps districts with the same boundaries in both rounds | |
| 06 Empowerment outcomes | Decision-making and healthcare barrier indices (PCA weights from NFHS-4), education, water collection time; sample sizes | `empowerment_*`, `pca_n4_*`, `appendix_water_*` |
| 07 Descriptive statistics | Sample flow; covariates and outcomes by AD status, with t-tests | `desc_*` |
| 08 Matching | Full matching (main), full matching on common support, nearest neighbour 3:1, genetic 3:1; balance before and after matching, with t-tests | `match_*` |
| 09 ATT-DiD | Main and covariate-adjusted estimates; standard errors clustered by district; alternative matching; weight trimming; leave one state out; water caps; permutation inference; multiple-testing correction | `att_*` |
| 10 Index weights | Index results with NFHS-4 PCA weights (main), and with equal-weighted and Anderson (2008) indices | `att_empowerment_main_n4`, `att_index_*`, `att_appendix_index_weighting` |
| 11 Treatment validation | Checks that the treatment indicator equals 1 exactly for the official Aspirational Districts and accounts for all 112 | `treatment_*`, `software_versions` |

## 5. Thesis tables and figures

Every table and figure in the thesis (final version), with the file it comes from. The thesis rounds
values to two or three decimals. Where a file has several samples or specifications, the filter is
given in brackets.

**Main text**

| Thesis | Content | Output file (`outputs/`) |
|---|---|---|
| Table 1 | NITI Aayog selection indicators and weights | Not computed: from Agarwal and Mishra (2024), Table 1 |
| Figure 1 | Map of the Aspirational Districts | Not computed: reproduced from Agarwal and Mishra (2024), Figure 1 |
| Table 2 | Construction of the estimation sample | `tables/desc_sample_flow.csv` |
| Table 3 | Covariate definitions and sources | Not computed: definitions (built in Stages 01 and 03) |
| Table 4 | Outcomes, samples and numbers of women | `tables/empowerment_sample_sizes.csv` |
| Table 5 | Index items and NFHS-4 PCA weights | `tables/pca_n4_loadings.csv` (PC1), `tables/pca_n4_variance.csv`, `tables/pca_n4_by_round.csv` |
| Table 6 | Covariates by Aspirational District status, with t-tests | `tables/desc_table5_covariates_by_ad.csv`, `tables/desc_table5_covariates_ttest.csv` (`sample = full`) |
| Table 7 | Outcomes for women, by survey round | `tables/desc_table6_empowerment_women.csv` (`group = All`) |
| Table 8 | Balance before matching | `tables/desc_table3_balance_before_full.csv`, `tables/desc_table3_balance_before_precovid.csv` |
| Table 9 | Balance after full matching | `tables/match_balance_after.csv` (`spec = full`); p-values from `tables/match_balance_after_ttest.csv` (`spec = full`) |
| Table 10 | Balance and effective sample size by matching method | `tables/match_method_comparison.csv` (also `tables/match_summary.csv`) |
| Table 11 | Main ATT-DiD estimates | `tables/att_empowerment_main_table.csv` |
| Figure 2 | Pre-COVID estimates by specification | `figures/att_coefficients_empowerment_precovid.png` |

**Appendix**

| Thesis | Content | Output file (`outputs/`, unless stated) |
|---|---|---|
| A.1 (text) | Construction of the estimation sample | `tables/treatment_flow.csv`, `tables/desc_sample_flow.csv`; district links in `data/lookups/nfhs4_nfhs5_district_links.csv`; official list in `data/lookups/adp_official_list.csv` |
| Table 12 (A.2) | Women behind each district average | `tables/empowerment_cell_sizes.csv` |
| Table 13 (A.3) | Item weights under each index construction | `tables/empowerment_index_weights_by_version.csv` (each column rescaled to sum to one) |
| Table 14 (A.3) | Correlation of the main index with other versions | `tables/pca_n4_validation.csv` |
| Table 15 (A.3) | Index estimates under each construction | `tables/att_appendix_index_weighting.csv` (`version = unadjusted`; `index_version = n4, ew, and`) |
| Table 16 (A.4) | Covariates by Aspirational District status, pre-COVID | `tables/desc_table5_covariates_ttest.csv` (`sample = precovid`) |
| Table 17 (A.4) | Unmatched comparison of outcomes by Aspirational District status | `tables/desc_table6_empowerment_women.csv` (`group = AD` and `Non-AD`; change = NFHS-5 minus NFHS-4) |
| Figure 3 (A.5) | Standardised mean differences before and after matching | `figures/match_balance_love_plot.png` |
| Table 18 (A.5) | Standardised mean differences after matching, by method | `tables/match_balance_after.csv` |
| Figures 4 and 5 (A.5) | Covariate distributions before and after full matching | `figures/match_densities_full.png`, `figures/match_densities_precovid.png` |
| Figures 6 and 7 (A.6) | Permutation distributions | `figures/att_permutation_empowerment_full.png`, `figures/att_permutation_empowerment_precovid.png` (values: `tables/att_permutation.csv`) |
| Table 19 (A.7) | Estimates under each matching method | `tables/att_all_specifications.csv` (`version = unadjusted`, `family = empowerment`) |
| Figure 8 (A.7) | Full-sample estimates by specification | `figures/att_coefficients_empowerment_full.png` |
| Table 20 (A.8) | Effect of trimming on the control weights | `tables/att_trim_info.csv` |
| Table 21 (A.8) | Estimates with trimmed weights | `tables/att_trim.csv` (`family = empowerment`) |
| Figures 9 and 10 (A.9) | Leave one state out | `figures/att_loso_empowerment_full.png`, `figures/att_loso_empowerment_precovid.png` (values: `tables/att_loso.csv`, `tables/att_loso_summary.csv`) |
| Table 22 (A.10) | Alternative water measures | `tables/att_water_caps.csv`, `tables/att_appendix_water_jmp.csv` (`adjusted = FALSE`) |
| Table 23 (A.11) | Standard errors clustered by district | `tables/att_cluster_district.csv`; matched-set values from `tables/att_empowerment_main_table.csv` |

**Numbers quoted in the text** come from the same files, plus:

| Number in the text | File |
|---|---|
| Mean change in Aspirational and matched districts (Section 7.1) | `tables/att_empowerment_main.csv` (`mean_change_ad`, `mean_change_non_ad`) |
| Districts and control weight lost when an outcome is missing (Section 6.4 footnote) | `tables/att_input_coverage.csv` |
| Top-10 share of the control weight (A.8) | `tables/att_trim_info.csv` (`top10_weight_share`) |
| "9 of 21" states (Sections 7.2 and 8) | `tables/att_loso.csv` (`sample = precovid`, decision-making, women 15-24) |
| Median women per district (Section 8) | `tables/empowerment_cell_sizes.csv` |

**Outputs not used in the thesis.** The pipeline also writes results that are not reported in the
final thesis: the replication of Agarwal and Mishra's (2024) health and nutrition outcomes
(`att_health_main*.csv`, `att_compare_am.csv`, `figures/*health*.png`, `figures/att_loso_full.png`,
`figures/att_loso_precovid.png`), and checks such as `att_index_pooled_vs_n4.csv`,
`att_index_n4_robustness.csv`, `att_bh_separate_vs_pooled.csv`, `att_summary.csv`,
`att_input_match_checks.csv`, `desc_dropped_vs_kept.csv`, `desc_empowerment_districts_by_ad.csv`,
`desc_table2_health_outcomes_*.csv`, `pca_n4_suitability.csv`, `empowerment_pca_loadings.csv`
(pooled PCA) and the `appendix_water_*` files.

## 6. Repository contents

| Path | Contents |
|---|---|
| `ADP_pipeline.Rmd` | The full analysis |
| `ADP_pipeline.html` | The knitted analysis: code and output |
| `run_all.R` | Runs the full analysis |
| `config.R` | Paths and the seed; the NFHS folder is read from `.Renviron` |
| `R/check_dhs.R` | Checks that the NFHS files are in place |
| `R/build_district_links.py` | Builds the NFHS-4 to NFHS-5 district links (run once; its output is in `data/lookups/`) |
| `data/raw/external/` | Non-NFHS inputs as downloaded: SECC 2011, U-DISE 2015-16, Saubhagya |
| `data/lookups/` | Official list of 112 Aspirational Districts, district links and name matches, with their sources (see its README) |
| `outputs/tables/`, `outputs/figures/` | Every table and figure; district-level results only |

## 7. Data sources other than NFHS

- Socio-Economic Caste Census 2011, district tables.
- U-DISE 2015-16, district-wise school data.
- Saubhagya, balance of unelectrified households as on 10 October 2017.
- NITI Aayog, *List of 112 Aspirational Districts* and *Aspirational Districts: Baseline Ranking, March 2018*.
- Local Government Directory (lgdirectory.gov.in) and NIC district websites, for district splits.

## Reference

Agarwal, S. K. and Mishra, S. (2024). Health impact evaluation of Aspirational Districts Program in
India: Evidence from National Family Health Survey. *Economics and Human Biology*, 54, 101411.
