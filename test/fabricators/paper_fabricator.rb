Fabricator(:paper) do
  title { sequence(:title) {|i| "Test Paper \##{i}"} }
  abstract <<~ABSTRACT
    OBJECTIVE:
    To determine if the concentrations of ammonia and inflammatory mediators in feline stored whole blood (SWB) increase with duration of storage.

    DESIGN:
    Prospective ex vivo study.

    SETTING:
    University Teaching Hospital.

    ANIMALS:
    Thirteen cats, recruited from the hospital feline donor pool, deemed healthy based on the predonation donor screening process.

    INTERVENTIONS:
    One unit (30 mL) of whole blood was collected from 13 unique blood donor cats, anticoagulated with citrate-phosphate-dextrose, and stored at 4°C. Concentrations of ammonia, interleukin (IL) 6, and IL-10 were measured in 5 units weekly for 4 weeks. Presence of chemokine ligand (CXCL) 8 was measured weekly in 8 other units in the same manner.

    MEASUREMENTS AND MAIN RESULTS:
    The ammonia concentration increased nonlinearly with duration of storage, from a median of 48 μmol/L (range 25-74 μmol/L) on day 0 and 417 μmol/L (324-457 μmol/L) on day 28. IL-6 and IL-10 concentrations were below the lower limits of detection of the assay used (IL-6 < 31.2 pg/mL and IL-10 < 125 pg/mL). CXCL-8 was detected in 4 of 8 SWB units at all time points.

    CONCLUSIONS AND CLINICAL IMPORTANCE:
    Ammonia concentration increases with storage time in feline SWB. The clinical significance of this finding is yet to be determined. The presence of the proinflammatory chemokine CXCL-8 in feline SWB warrants further research to determine whether it can incite an inflammatory response in the recipient. Further research evaluating the epidemiology of transfusion reactions in cats should evaluate the effect of unit age, and should include the possible impact of the presence of CXCL-8.
  ABSTRACT
  doi { sequence(:doi) {|i| "10.1111/test.doi.000000000#{i}"} }
  pubmed_id { sequence(:pubmed_id) {|i| "10000000#{i}"} }
  publication "j vet emerg crit care (san antonio)"
end
