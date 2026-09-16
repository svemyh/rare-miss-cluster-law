# Independent review brief

Document: Rare-miss growth: a finite-cluster law and certified bounds.
Status: internal working draft; priority provisional; author metadata unset.
This brief is a document, not an email or a sent request. No reviewer has been contacted.

## What to assess

The proposed contribution is the exact first-order coefficient for worst-case products of fixed strictly positive matrices when at most m misses occur in every k-slot window, with m fixed and k tending to infinity. The rank-one reset proposition is an application, not a separate novelty claim.

The manuscript is intended to be self-contained. Read it without relying on the development conversation or its earlier AI reviews. The primary review target is the all-word upper bound; the periodic lower construction and finite calculations alone do not settle that bound.

## Mathematical questions

1. Are all quantifiers and limits clear? In particular, are dimension, matrices and m fixed before the k-limit, with the long-product limit taken first?
2. Does the Perron-weighted norm estimate hold for all initial vectors, although the products are nonnegative?
3. Does the cluster definition imply both the cardinality bound and the stated span bound? Check the endpoint counting carefully.
4. Do the bins of length k-mq place every assigned cluster inside one genuine k-window, including a prefix's final cluster and bins extending beyond the observed prefix?
5. Does the joining lemma bound products of cluster gains even when some gains are below one or their suprema are unattained?
6. Is the matrix-to-scalar replacement uniform over all admissible words and arbitrary internal gaps, and does the resulting error vanish at the required k-scaled order?
7. Does the lower argument avoid an unjustified exchange of supremum and limit?
8. Does the new finite-gap clamp give the stated two-sided error, an attained realizable witness, and the required k>=m(q+1) threshold?
9. Is the prescribed-gap construction correct for every t, without implying a fixed-dimension or finite-k conclusion it does not prove?
10. Is the reset proposition valid with weak moment inequalities and at every k>=4, including boundary runs?

## Prior-art questions

- Is the general coefficient already stated, or an immediate consequence of a known result? Please identify the exact theorem and the map between assumptions.
- Could a constrained ergodic-optimization or rare-defect theorem imply the result with a k-dependent hard-window observable?
- Does any hybrid/singular-perturbation result provide the missing uniform approximation while preserving short bursts and the sliding-window budget?
- Is the proposed distinction from fixed-language Berger–Wang/certificate results substantive, or only a routine restatement?
- What publication positioning is justified for a short note if the result survives? No target venue has been selected.

## Sources that still require direct inspection

- Yun Zhao (2019), Constrained ergodic optimization for asymptotically additive potentials. DOI: 10.1016/j.jmaa.2019.01.065.
- Hertneck–Linsenmayer–Allgower (2021), weakly-hard control successor. DOI: 10.1016/j.automatica.2021.109868.
- Gurvits–Samorodnitsky (2005), A note on common quadratic Lyapunov functions for linear inclusions. DOI: 10.1109/CDC.2005.1582513.

The earlier audit also records the Kozyakin 2019 constructive survey and Vrabel 2026 block-stabilization article as full-text gaps. See SOURCE-ACCESS.md. An inaccessible text has not been ruled out by a theorem-level comparison.

## Evidence and review boundary

The core law and quantitative implications under relative-tail data have a 201-declaration Lean audit. The automatic minorization-tail construction and big-O consequence retain classical rather than separate Lean proofs. The exact rational tool checks certificate inputs and computations; it is not an extracted Lean program. Existing internal mathematical reviews are not external specialist approval or a fresh-reader assessment of this revision.

The complete repository includes separate mathematical and formalization briefs in review/, along with a coordinator semantic self-audit. Neither requested human review has been received. A manuscript-only ZIP does not include the complete Lean project; formalization review requires separately approved access to the proof files.

Useful review output should distinguish a concrete gap, a missing assumption, a clarity problem, an equivalent prior theorem, and an optional improvement. A no-gap reading is not itself proof of novelty.
