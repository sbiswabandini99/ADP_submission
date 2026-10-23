# Sources for NFHS-4 to NFHS-5 district splits

Accessed 30 September 2026.

## Local Government Directory (Ministry of Panchayati Raj, lgdirectory.gov.in)
- `All_Districtof_India_2026-09-30_18-04-20.xlsx`: all current districts with their Census 2011 code (0 = created after 2011).
- `All_Sub_Districtof_India_2026-09-30_18-08-03.xlsx`: all current sub-districts with their Census 2011 code.
- `alldistrictbyDate2026_09_29_12_34_45_109.xls`, `allSubDistrictofIndiabyDate2026_09_29_12_56_05_568.xls`: modifications from 1 January 2011 to 31 March 2021 (incomplete; not used to define the sample).
- Result for each split: `nfhs5_split_parents_lgd_check.csv`.

## Tripura (no Census 2011 sub-district codes in LGD): official district websites (NIC)
- Unakoti, https://unakoti.nic.in/history/ : created in 2012 from North Tripura.
- Gomati, https://gomati.nic.in/history/ : created in 2012 from South Tripura.
- Sepahijala, https://sepahijala.nic.in/history/ : created at the end of 2011 from West Tripura.
- Khowai, https://khowai.nic.in/history/ : the page does not name its parent; West Tripura as parent rests on the Sepahijala page's description of West Tripura being divided into three districts.
- Dhalai, https://dhalai.nic.in/history/ : created in 1995; no later change is mentioned, and none of the four new districts' pages names Dhalai as a parent, so Dhalai is kept.

## Delhi
No official source was found for the 2012 creation of Shahdara and South East. Their parents (North East, East, South) rest on an unofficial district list; LGD shows only Delhi's later 13-district layout. The six Delhi districts that did not split are kept as non-Aspirational controls.
