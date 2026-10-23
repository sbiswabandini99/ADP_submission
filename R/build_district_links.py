"""
Build data/lookups/nfhs4_nfhs5_district_links.csv: one row per NFHS-5 district, linking it to the
NFHS-4 (Census 2011) district it continues or was carved from. Run once; the Rmd only reads the output.

Inputs (all in the project):
  data/intermediate/district_panel_adp.csv        NFHS district codes and names (Stage 02, from DHS value labels)
  data/lookups/nfhs5_split_parents_lgd_check.csv  the 70 splits and their LGD check
Renames and secondary parents are listed below with their evidence. Sources: data/lookups/district_split_sources.md.
"""
import pandas as pd, re, sys
ROOT = sys.argv[1] if len(sys.argv) > 1 else "."
norm = lambda s: re.sub(r"[^a-z]", "", str(s).lower().replace("&", "and"))

P = pd.read_csv(f"{ROOT}/data/intermediate/district_panel_adp.csv")
n4 = P[P.survey_round == "nfhs4"][["distcode", "state_name", "district_name"]].copy()
n5 = P[P.survey_round == "nfhs5"][["distcode", "state_name", "district_name"]].copy()
SPL = pd.read_csv(f"{ROOT}/data/lookups/nfhs5_split_parents_lgd_check.csv")

# NFHS-5 state labels that differ from NFHS-4 (UT reorganisations)
STATE = {"ladakh": "jammuandkashmir", "nctofdelhi": "delhi",
         "dadraandnagarhavelianddamananddiu": "dadraandnagarhaveli"}
# Same district, different spelling in the two rounds' value labels (state, NFHS-5 name, NFHS-4 name)
RENAME = [("andamanandnicobarislands", "north  & middle andaman", "north & middle andaman"),
          ("arunachalpradesh", "papum pare", "papumpare"),
          ("chhattisgarh", "dantewada", "dakshin bastar dantewada"),
          ("chhattisgarh", "kabeerdham", "kabirdham"),
          ("chhattisgarh", "koriya", "korea (koriya)"),
          ("gujarat", "banas kantha", "banaskantha"),
          ("gujarat", "panch mahals", "panchmahal"),
          ("gujarat", "sabar kantha", "sabarkantha"),
          ("himachalpradesh", "lahul & spiti", "lahul and spiti"),
          ("jharkhand", "saraikela-kharsawan", "saraikela kharsawan"),
          ("manipur", "senapati", "senapati (excluding 3 sub-divisions)"),
          ("telangana", "mahabubnagar", "mahbubnagar"),
          ("telangana", "ranga reddy", "rangareddy"),
          ("uttarpradesh", "siddharthnagar", "siddharth nagar"),
          ("jammuandkashmir", "leh(ladakh)", "leh")]
REN = {(s, norm(a)): norm(b) for s, a, b in RENAME}
# Second parent of multi-parent splits: (state, NFHS-5 child, NFHS-4 secondary parent, evidence)
SECONDARY = [("arunachalpradesh", "siang", "west siang", "LGD sub-district codes"),
             ("gujarat", "botad", "bhavnagar", "LGD sub-district codes"),
             ("gujarat", "mahisagar", "kheda", "LGD sub-district codes"),
             ("uttarpradesh", "amethi", "rae bareli", "LGD sub-district codes"),
             ("telangana", "siddipet", "karimnagar", "LGD sub-district codes"),
             ("gujarat", "morbi", "surendranagar", "unofficial district list only"),
             ("telangana", "jayashankar bhupalapally", "karimnagar", "unofficial district list only"),
             ("telangana", "vikarabad", "mahbubnagar", "unofficial district list only"),
             ("uttarpradesh", "sambhal", "budaun", "unofficial district list only"),
             ("delhi", "shahdara", "east", "unofficial district list only")]
SRC = {"CONFIRMED": "LGD sub-district codes confirm parent",
       "CONSISTENT": "LGD sub-district codes consistent with parent",
       "NO EVIDENCE": "Tripura NIC district website (district_split_sources.md)",
       "LGD name not found": "unofficial district list only (Delhi)", "CONFLICT": "unofficial district list only (Delhi)"}

for d in (n4, n5):
    d["s"] = d.state_name.map(norm).map(lambda s: STATE.get(s, s))
    d["k"] = d.district_name.map(norm)
n5.loc[n5.k.isin(["daman", "diu"]), "s"] = "damananddiu"
key4 = {(s, k): (c, n) for s, k, c, n in zip(n4.s, n4.k, n4.distcode, n4.district_name)}
split = {(norm(s), norm(c)): (norm(p), SRC[chk]) for s, c, p, chk in
         zip(SPL.state, SPL.nfhs5_child, SPL.old_parent, SPL.lgd_check)}
sec = {(s, norm(c)): (norm(p), e) for s, c, p, e in SECONDARY}

rows = []
for _, r in n5.iterrows():
    s, k = r.s, r.k
    if (s, k) in split:
        p, src = split[(s, k)]; typ = "split_child"
    elif (s, k) in REN:
        p, src, typ = REN[(s, k)], "same district, spelling differs between rounds", "rename"
    else:
        p, src, typ = k, "same name and state in both rounds", "same"
    c4, nm4 = key4[(s, p)]                                   # KeyError here = unlinked district
    c4b = nm4b = src_b = None
    if (s, k) in sec:
        p2, src_b = sec[(s, k)]; c4b, nm4b = key4[(s, norm(p2))]
    rows.append(dict(nfhs5_distcode=r.distcode, nfhs5_state=r.state_name, nfhs5_district=r.district_name,
                     link_type=typ, nfhs4_distcode=c4, nfhs4_district=nm4, link_source=src,
                     nfhs4_second_parent_distcode=c4b, nfhs4_second_parent=nm4b, second_parent_source=src_b))
L = pd.DataFrame(rows).sort_values("nfhs5_distcode")
L["nfhs4_second_parent_distcode"] = L.nfhs4_second_parent_distcode.astype("Int64")
assert len(L) == 707 and L.nfhs5_distcode.is_unique
assert L.nfhs4_distcode.isin(n4.distcode).all() and set(n4.distcode) <= set(L.nfhs4_distcode)
L.to_csv(f"{ROOT}/data/lookups/nfhs4_nfhs5_district_links.csv", index=False)
print(L.link_type.value_counts().to_string())
