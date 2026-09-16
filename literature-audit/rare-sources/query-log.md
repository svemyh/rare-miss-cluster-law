# Query and access log

Date for every entry: September 15, 2026. Worker scope: `rare-defects.md` and `rare-sources/`. Exa was unavailable. Searches used `web.run`; substantive reads used primary PDFs downloaded by curl and extracted by pdftotext. Repeated queries are deduplicated below, not counted as independent coverage.

## Search execution limits

Many web calls returned no visible content. Others returned generic domain homepages instead of article URLs, sometimes with a useful title but sometimes with unrelated medical, lattice-model, or engineering results. Those are discovery attempts, not paper reads. The query list records what was attempted, not what was successfully searched exhaustively. No citation-count figures from snippets were used.

Procedural deviation: the visible `web.run` request payloads do not contain the explicitly requested `response_length` parameter. The audit therefore does not claim compliance with that detail of the contract. It also does not treat the many blank or shallow responses as negative evidence that a theorem does not exist. Direct primary reads supplied the actual comparisons.

The deep-research skill's referenced methodology and report-template files were absent at their listed local paths. The user-supplied audit contract governed the output. No generic minimum-source quota, extra HTML/PDF report, separate agent, or cloud workflow was substituted.

## Exact query strings

### Rare defects and stochastic perturbations

```text
Lyapunov exponent random matrix products rare impurities low density expansion
positive random matrices Lyapunov exponent analytic probability zero Peres
"Peres" "Analytic dependence" "Lyapunov"
"Lyapunov" "rare" "positive matrices"
"cycle expansion" "Lyapunov exponent" "random matrices"
"Lyapunov" "small frequency" OR "small occupation"
"Domains of analytic continuation for the top Lyapunov exponent" pdf
"Domains of analytic continuation" "Lyapunov"
"Cycle expansion" "Mainieri" Lyapunov
"Ruelle" "Analyticity properties" "1979" pdf
Ruelle 1979 analyticity properties characteristic exponents random matrix products pdf
"Ruelle" "Analyticity properties of the characteristic exponents" pdf
site:ihes.fr Ruelle publications
"maximal Lyapunov exponents for random matrix products" pdf
"low density expansion for Lyapunov exponents"
"rare" "positive matrices" "Lyapunov"
"rare defects" "matrix products"
"rare defects" "positive matrix"
"rare-defect" "matrix products"
"small occupation" "Lyapunov"
"small occupation frequency" Lyapunov
"positive matrices" "Lyapunov" "perturbation"
```

Outcome: Schulz-Baldes was found as a concrete low-density lead and its primary arXiv PDF was read completely. Peres and Mainieri were retrieved directly using primary identifiers and verified by their contents. Keyword matches alone were not used to infer a theorem. Peres's references supplied the actual Ruelle/Hennion antecedents; the guessed Ruelle bibliography endpoint failed.

### Occupation, relative maximization, and boundary measures

```text
constrained ergodic optimization near Dirac measure small frequency rotation set
"constrained ergodic optimization"
"Garibaldi" "Lopes" "2007" "constraint"
"Functions for relative maximization" pdf
"Functions for relative maximization"
"Constrained ergodic optimization for asymptotically additive" pdf
"Constrained ergodic optimization for asymptotically additive"
"Constrained ergodic optimization" "Zhao"
Zhao constrained ergodic optimization asymptotically additive potentials arxiv 2019
"Zhao" "Constrained ergodic optimization for asymptotically additive potentials"
"Constrained ergodic optimization" "2019" "10.1016"
"constrained ergodic optimization" "Dirac"
"Ground states and zero-temperature measures at the boundary of rotation sets"
"rare" "Lyapunov" "Dirac"
"asymptotically additive potentials" "Zhao"
"Conditional Ergodic Averages" "Constrained ergodic optimization"
"Ground states and zero-temperature measures" "2019"
"sliding window" "ergodic optimization"
```

Outcome: Garibaldi–Lopes and Motonaga–Shinoda were read at the depths recorded in the report. Motonaga–Shinoda's actual references identified both Kucherenko–Wolf and Zhao 2019. Kucherenko–Wolf's main boundary theorem and proof were then read. Zhao's exact journal identity was verified through Crossref, but the publisher full-text attempts failed. A search lead titled *Conditional Ergodic Averages* was not read and was not assumed to be the same work.

### Slow switching, sparse impulses, and renewal

```text
deterministic sparse impulses maximal Lyapunov exponent rare switching
"Lyapunov" "rare switching" "expansion"
deterministic sparse impulses density Lyapunov exponent stability impulses
"impulsive" "zero density" "stability"
"sparse impulses" "Lyapunov"
"Lyapunov" "renewal" "positive matrices"
"deterministic" "sparse" "impulses" stability
"renewal" "Lyapunov exponent" "positive" matrices
"deterministic sparse impulses"
"impulsive systems" "zero" "frequency" Lyapunov
"Volterra" "impulsive renewal systems"
"small" "frequency" "constrained joint spectral radius"
"linear time-varying impulsive systems" "fixed and unrestricted impulse times"
"Stability of linear time-varying impulsive systems with fixed and unrestricted impulse times"
"Volterra Integral Approach" "Impulsive Renewal"
"impulsive renewal systems"
```

Outcome: Monmarché–Schreiber–Strickler's preprint was read, followed by the published version supplied by the coordinator. Its actual references supplied arXiv:2112.07005 and arXiv:2309.16464. No primary theorem was read for the unrestricted-impulse-time or Volterra-renewal leads. Their source-index hits are coverage gaps, not ruled-out theorem branches.

## Primary opens and retrieval receipts

The web tool was also asked to open the following exact primary endpoints. Several responses were blank, so the successful PDF retrievals below are the read receipts. A successful curl download was followed by PDF metadata inspection and the actual page reads.

```text
https://arxiv.org/pdf/math-ph/0607027
https://www.numdam.org/item/?id=AIHPB_1992__28_1_131_0
https://www.numdam.org/item/AIHPB_1992__28_1_131_0.pdf
https://arxiv.org/pdf/math/0608432
https://arxiv.org/abs/2408.11179
https://arxiv.org/html/2408.11179v1
https://arxiv.org/pdf/2408.11179
https://arxiv.org/abs/1905.07531
```

| Exact retrieval endpoint | Result and saved artifact |
|---|---|
| `https://arxiv.org/pdf/math-ph/0607027` | Success, 8 pages, `schulz-baldes-2006.pdf`. |
| `https://www.numdam.org/item/AIHPB_1992__28_1_131_0.pdf` | Success, 19 PDF pages including archive cover, `peres-1992.pdf`. OCR omits many equations. Printed pp.132 and 136 rendered and visually read as `peres-p132.png`, `peres-p136.png`. An annotation warning did not prevent extraction. |
| `https://arxiv.org/pdf/math/0608432` | Success, 22 pages, `garibaldi-lopes-2006.pdf`. |
| `https://arxiv.org/pdf/chao-dyn/9301001` | Success, 9 pages, `mainieri-1993.pdf`. |
| `https://arxiv.org/pdf/2211.11932` | Success, returned v4, 15 pages, `motonaga-shinoda-2024.pdf`. |
| `https://arxiv.org/pdf/2408.11179` | Success, returned v1, 30 pages, `monmarche-schreiber-strickler-2024.pdf`. |
| `https://dspace.mit.edu/bitstreams/8ef93ba2-5a4e-4fa4-a15f-38037a8569d1/download` | HTTP 405. No successful MIT PDF read; fallback used next row. Supplied by coordinator as an actual GS2005 forward-citation lead. |
| `https://arxiv.org/pdf/1905.07531` | Success, returned v1, 19 pages, `altschuler-parrilo.pdf`. Reference 27 verifies the GS2005 edge; reference 33 confirms Liu–Xiao attribution. |
| `https://arxiv.org/pdf/1604.06512` | Success, returned v1, 26 pages, `kucherenko-wolf.pdf`. Followed R5's actual KW19 citation. |
| `https://schreiber.faculty.ucdavis.edu/wp-content/uploads/sites/568/2025/07/BMB-2025.pdf` | Success, published 34-page paper, `monmarche-schreiber-strickler-2025-published.pdf`. First page explicitly verifies DOI, May 20, 2025 publication date, and author names. |
| `https://www.ihes.fr/~ruelle/publications.html` | Guessed author bibliography URL, HTTP 404. No author publication list or paper obtained from it. |
| `https://doi.org/10.1016/j.jmaa.2019.01.065` | Redirect markup only, not article text. Identified PII `S0022247X1930099X`. |
| `https://www.sciencedirect.com/science/article/pii/S0022247X1930099X` | HTTP 403. |
| `https://api.elsevier.com/content/article/PII:S0022247X1930099X?httpAccept=text/plain` | HTTP 400. Crossref advertised this text-mining endpoint; no full text obtained. |

Crossref metadata query, not a theorem read:

```text
https://api.crossref.org/works?query.title=Constrained%20ergodic%20optimization%20for%20asymptotically%20additive%20potentials&rows=2
```

It returned Yun Zhao's exact title, DOI `10.1016/j.jmaa.2019.01.065`, JMAA 474(1), 612–639, issued June 2019, and the Elsevier endpoints. Its second result, *Typical properties of ergodic optimization for asymptotically additive potentials*, was not read and was not counted.

## Count and exclusion discipline

Eight primary works have substantive reads. There are nine cached PDFs because R3 has both a preprint and a published version. Of the eight works, three have full-paper reads and five have explicitly scoped theorem/proof-section reads. Mainieri's full read is retained as an honest excluded branch. Ruelle, Zhao, deterministic unrestricted-impulse-time work, Volterra renewal work, and the referenced deterministic/probabilistic gap paper are not included in the count. No forward-citation census was completed.
