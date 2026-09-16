# Publication-focused manuscript

[Read the revised PDF](rare_misses.pdf). Source and bibliography are rare_misses.tex and references.bib.

The revision makes uniform cluster packing the first part of the main proof, adds an effective finite-cutoff and two-sided finite-window theorem, and gives a full definition-to-Lean map with upstream attribution. The prescribed-gap and reset examples remain because they explain limitations of the result.

The main law and quantitative implications under relative-tail data are checked in the [Lean development](../lean/README.md). The automatic minorization tail, big-O corollary and additional examples are not all separately formalized. [QUANTITATIVE.md](../QUANTITATIVE.md) gives the derivation and boundary.

Run make paper from the repository root to rebuild with Tectonic and Poppler. Fresh outputs are in paper/build/; the committed PDF is the visually inspected copy. [Verification evidence](../evidence/manuscript/receipt.json) is separate from human review.

Publication novelty, human specialist reviews, authorship and venue remain open. [Review coordination](../review/REVIEW_COORDINATION.md) records candidates, not appointed reviewers. No manuscript has been sent or submitted.
