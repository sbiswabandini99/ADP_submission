# data/lookups

Hand-built inputs read by `ADP_pipeline.Rmd`. Each file has one row per district (or district and
round) and records how every match was made.

## adp_official_list.csv

The official list of Aspirational Districts, one row per district (112 rows).

Sources:
1. NITI Aayog, *List of 112 Aspirational Districts*: current names.
2. NITI Aayog, *Aspirational Districts: Baseline Ranking, March 2018*, "Baseline ranking for the 101
   aspirational districts": 2018 names, rank and composite score.

Columns: position in the 112 list; state; current name; name in the March 2018 ranking; whether the
district is in that ranking; its rank and score; a note explaining any name difference.

All 101 districts in the 2018 ranking match a district in the 112 list one to one; 13 match only after
a name difference, each documented in `name_note` (spellings such as Purnia/Purnea, and districts
renamed after 2018). UNDP, *Aspirational Districts Programme: An Appraisal*, lists the same 112
districts. Wayanad and 10 Odisha districts are on the list of 112 but not in the March 2018 ranking
of 101; they are treated as Aspirational Districts like the rest. No West Bengal district is on the list.

## adp_manual_matches.csv

Matches from the official list to NFHS district codes for the 23 cases where the NFHS name differs
from both the current and the 2018 official name, or where the district did not yet exist. One row per
district and round, with the match type and a note. Every other district is matched automatically on
its current or 2018 name within its state (Stage 02). NFHS names and codes come from the value labels
of `sdistri`, `sdist` and `v024`.

## external_district_matches.csv

Maps every district row in the three external sources to its NFHS-4 district code (2011 boundaries):
SECC 2011 (631 rows), U-DISE 2015-16 (680 rows), Saubhagya unelectrified households (637 rows).
Districts created after 2011 are mapped to their 2011 parent. `match_method` records whether each match
is an automatic name match or a manual one.

Sources: SECC 2011 district tables; U-DISE 2015-16 district file (`2015_16_Districtwise.csv`, with
its metadata file); Saubhagya, "Balance Unelectrified Households as on 10th Oct, 2017", compiled from
the state files into `unelectrified_household_covariate.csv`.

## nfhs4_nfhs5_district_links.csv

One row per NFHS-5 district (707): the NFHS-4 district it continues (`same`, `rename`) or was carved
from (`split_child`, with a second parent where the new district took land from two). Built by
`R/build_district_links.py` from `nfhs5_split_parents_lgd_check.csv`; sources in
`district_split_sources.md`.
