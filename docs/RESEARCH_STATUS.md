# Research status

The main fixed-budget rare-miss cluster law is fully proved in Lean for arbitrary strictly positive finite real matrices. The formal definition includes the actual sliding-window language, norm-root growth, the complex spectral radius, and genuine finite integer-gap suprema. The implementation and its separate consumer use no custom mathematical axioms.

The exact checker covers 408 admissible-word matrix/packing cases and 7,767 reset run-replacement cases. These support the examples; they do not replace the general proof. The readable classical argument, internal review and current manuscript are included.

Publication novelty is provisional. The literature assessment contains 24 substantive primary-work comparisons and a separate anchor spot-check, with explicit access and coverage gaps. Human specialist review, a fresh independent review of the typeset manuscript, authorship, affiliations and a venue remain unresolved. The additional finite-search and example propositions have not all been formalized.

The project progressed from a classical proof and exact examples, through 52 supporting Lean 4.19 declarations, to the complete 175-declaration Lean 4.32.2 proof. The historical proof is in `history/lean-4.19/`. The frozen theorem and numerical checker remain byte-identical to their original verified inputs. The packaged manuscript updates only its proof-status disclosures.

Private hosting under `svemyh` was requested by the owner. It is not public publication or submission. No author contact, reviewer invitation, paid model run or automatic cloud job is part of this package.
