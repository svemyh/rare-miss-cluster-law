# Research status

The main fixed-budget cluster law remains fully proved in Lean. The publication revision adds 26 checked declarations for a genuine finite-gap cutoff, two-sided finite-window norm-rate bounds, coefficient-error estimates and an accuracy implication for every later window. The current audit covers 201 declarations with only the three standard logical axioms and five invalid controls rejected.

The quantitative implications have explicit uniform relative-tail and scalar preconditions. An exact rational tool validates normalized positive data, constructs a minorization tail, enumerates cutoff words and checks stability and accuracy certificates. Nine tests pass, including conservative/inconclusive behavior and corrupted inputs. The automatic tail construction and O(log(k)/k) corollary have classical proofs, not separate Lean formalizations.

The revised paper centers the combinatorial packing argument, retains the prescribed-gap and reset examples, and explains the formal correspondence and imported PF/MCMC work. The frozen original theorem and numerical checker are unchanged.

One exact primary-text gap, Kozyakin–Kuznetsov–Chebotarev 2019 Part III, has been closed at relevant theorem-section depth. Four exact targets remain unclosed. Two earlier preprints were inspected without silently identifying them with later journal versions. See literature-audit/REMAINING-GAPS.md.

Human mathematical and formalization reviews have not been received. Candidate reviewers and separate briefs are prepared in review/. The owner must select reviewers and authorize the sharing scope; no one has been contacted. Authorship, affiliations, venue, public artifact licensing and submission remain undecided. Novelty remains provisional.

The repository stays private. The current publication-revision branch does not imply a public release, accepted paper, paid worker restart or reviewer endorsement.
