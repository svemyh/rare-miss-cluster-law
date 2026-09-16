# Does the rare-miss theorem survive a broader prior-art check?

Audit cutoff: September 15, 2026. This is a literature implication assessment, not a proof of priority or an external peer review. The mathematical statement and checker were frozen throughout.

## Bottom line

**No direct duplicate or complete corollary derivation was found in the inspected results. The general theorem remains a plausible specialized contribution, with publication novelty provisional.**

This conclusion is stronger than the earlier eight-paper reconnaissance because it follows named antecedents, actual citing-document records, recent revisions, and theorem/proof sections in neighboring fields. It is weaker than saying the theorem is new. Several relevant originals remain inaccessible and no citation database is complete.

The likely contribution, if priority survives, is the exact first-order growth coefficient for **fixed positive discrete modes and a fixed number of allowed misses as the sliding window grows**, together with the uniform reduction to finite miss clusters. Rank-one multiplication, maximum-cycle methods, Perron-overlap corrections, and periodic approximation are established prior art. The exact reset subfamily should remain an illustrative corollary, not a separate discovery claim.

## What was actually checked

The audit contains 24 substantive primary-work comparisons: five full-paper reads and nineteen targeted theorem/proof-section reads. A separate Kozyakin anchor spot-check brings the inspected-document total to 25. These are distinct works across the three reports; preprint and published versions of Monmarche–Schreiber–Strickler count once. The prior eight-paper audit is not added again. Downloaded-but-unread papers, abstracts and metadata-only records are excluded from these reading totals.

The protocol branch retrieved 303 incoming citation records across its selected databases and seeds. Its rerunnable deduplication gives 171 identifier-linked groups, or 163 groups if exact normalized titles are also merged. These are screening records, not read papers or a global citation census. Date-filtered OpenAlex queries and incompletely dated Semantic Scholar records are distinguished in the report. The main antecedent branch additionally inspected three incoming-edge responses containing 8, 13 and 19 records; these are not added to a purported unique global count.

Coverage included rank-one and weighted-cycle theory, constrained Berger–Wang results, weakly-hard control and a German dissertation, newer symbolic-memory/lifting methods, rare random impurities, probability perturbation, slow periodic/Markov switching, constrained ergodic optimization, boundary measures, and hybrid singular perturbations.

Read-depth ledgers, exact identifiers, theorem/page references, query logs, citation edges and failed-access records are in:

- `antecedents.md`: six substantive text comparisons, one inaccessible original, additional abstract/access checks.
- `protocol-forward.md`: one full paper, nine theorem/proof-section reads, one anchor spot-check.
- `rare-defects.md`: three full papers and five theorem/proof-section reads.

## The statement whose priority is being assessed

Fix strictly positive C,D, dimension d, and miss budget m. Write lambda=rho(C), B=C/lambda, E=D/lambda, P=r ell^T and ell^T r=1. At most m misses are permitted in **every** k-slot window. First take worst-case long-product growth for each k; only then let k grow. The target is

\[
\lim_{k\to\infty} k\log(\rho_{m,k}/\lambda)
=\log\max(1,S_1,\ldots,S_m),
\]

where S_j is the supremum of the Perron-weighted product E B^{g_1}E ... B^{g_{j-1}}E over all finite nonnegative success gaps. Unbounded gaps can arise as limits.

A result that studies a fixed k, an average loss fraction, an i.i.d. probability, a specified periodic cycle, or fixed positive dwell time is not equivalent merely because its vocabulary or projection formulas look similar. Each proposed reduction below was tested against that distinction.

## Strongest comparisons

| Prior result | What the inspected statement provides | Why it does not complete the target derivation |
|---|---|---|
| Gurvits–Samorodnitsky 2005, via verified later attribution; Ahmadi–Parrilo 2012; Liu–Xiao 2013/2016 | Exact rank-one cycle formulas and general fixed-family rank-one approximation | Does not identify the uniform large-window reduction or the legal packing of variable-sized clusters. The 2005 original remains unread. [A1–A3] |
| Dai 2012/2014 and Kozyakin 2014 | Exact norm/spectral representation; admissible periodic approximation for each fixed finite-type language | Leaves an unbounded collection of cycles, with arbitrarily many windows and misses. No finite-cluster upper coefficient is evaluated. [P1–P2, P9] |
| Bund 2017 and Gaukler 2020 | Interval loss bounds, time-sensitive disturbance inequalities, sound scalar growth envelopes | The envelope gains lose the internal-gap interaction and are not proved sharp for the original matrix products. [P3–P4] |
| Philippe 2016; symbolic memory 2024; compression/lifting 2026 | Fixed-language representations, certificate completeness, approximations or conditional exactness | A changing-window coefficient needs an error vanishing after multiplication by k; language inclusion or a numerical cycle test does not supply that. [P5–P8, P10] |
| Peres 1992 and rank-one ergodic formulas | Genuine probability-boundary derivatives and exact stationary pair-reward identities | Bernoulli/Markov averaging uses probabilities of clusters, not the maximum over a hard window language. Expanded fixed-k rank-one graphs are covered, general positive clusters are not. [R1–R2] |
| Monmarche–Schreiber–Strickler 2025 | First-order slow-switching corrections built from Perron overlaps | Retained dwell intervals grow, occupation proportions are fixed, and a periodic/Markov law is specified. Fixed-duration rare bursts plus uniform adversarial packing require another argument. [R3] |
| Hybrid singular perturbation, February 2026 revision | Reduced-dynamics bounds and exact exponent convergence under fixed positive dwell time | Does not preserve the hard miss-slot budget through the proposed time rescaling; unrestricted switching and fixed positive dwell are different classes. [A6–A7] |
| Relative/constrained ergodic optimization and boundary ground states | Variational descriptions, periodic density at specified interior rotation vectors, and boundary measure limits | Do not evaluate the first-order action for a k-dependent hard-window observable at the boundary. [R4–R6] |

References use the stable local IDs in the three reports, which give complete titles, dates, original URLs and read depths. The table compresses the comparisons; it does not assert that no other theorem exists in those fields.

## The three most important failed shortcuts

### 1. Periodic approximation is not an evaluated limit

The constrained Berger–Wang chain gives the worst rate as a supremum over cyclically legal words for each fixed window. Our period-k construction supplies the lower bound for each fixed finite cluster. Those are established or elementary steps. The missing implication from the cited results is the matching upper bound over every legal cycle or word while k grows. Declaring the optimizer periodic does not bound its period or the number of misses it contains.

Likewise, arbitrary relative-accuracy certificates do not by themselves identify the coefficient. Philippe's product-lift guarantee has multiplicative uncertainty d^{1/(2T)}. The uncertainty in k times the logarithm is therefore at most k log(d)/(2T). For d>1 that guarantee vanishes only if T/k tends to infinity. The result can support high-accuracy computations, but it is not an analytic evaluation of the proposed limit. This is our explicit comparison of the cited bound, not a missing theorem alleged in Philippe's paper.

### 2. Rare random defects are a different optimization problem

The positive-matrix probability perturbation theory is genuinely close: the Bernoulli derivative at zero defect probability is log(ell^T E r), as derived in the rare-defect report from Peres's theorem and projective formula. Substituting p=m/k produces m times that derivative, not the cluster maximum. An i.i.d. process at any positive p admits forbidden runs almost surely. Giving a process the correct average occupation does not impose the sliding-window rule.

There is also an exact finite-k rank-one graph reduction from stationary pair rewards to maximum cycle mean. The audit writes out the history graph and circulation program rather than dismissing the stochastic paper by terminology. That reduction confirms old machinery for the reset cases. It does not perform the uniform Perron replacement for general positive modes.

### 3. A similar Perron formula can arise in a different singular limit

The slow-switching paper retains environmental proportions alpha_i and stretches dwell intervals to alpha_i/omega. To hold a defect duration fixed as omega tends to zero, alpha_defect must simultaneously tend to zero. A pointwise expansion at fixed proportions does not justify that substitution without a uniform remainder. The theorem also evaluates a specified periodic or Markov law rather than maximizing over every budget-admissible word.

Continuous-time flow embeddings require care as well. The already-existing planar B in the program has determinant -1/2, whereas every real matrix exponential has positive determinant. This rules out a direct flow-map identification for the whole target class. It does not rule out hybrid embeddings with jumps; those must still preserve the timing budget and prove the scaled error estimate.

## What the candidate can and cannot claim

A defensible provisional description is:

> We derive a fixed-budget rare-miss growth law for strictly positive discrete-time modes. The proof combines Perron separation with a uniform sliding-window cluster bound and matching periodic witnesses.

That describes the work without asserting priority. If the remaining literature check supports it, a short paper can position the changing-window coefficient as the contribution.

Do not claim the first use of Perron overlaps, the first rank-one certificate, new maximum-cycle machinery, novel constrained Berger–Wang theory, general finite-k optimality, or a solved control problem for arbitrary signed/nonlinear systems. Do not present the numerical checker or the exact reset example as sufficient evidence that the general theorem is new. The audit has not evaluated journal acceptance prospects.

## Important remaining access gaps

1. **Yun Zhao, 2019**, *Constrained ergodic optimization for asymptotically additive potentials*, DOI `10.1016/j.jmaa.2019.01.065`. This is the strongest unread ergodic-theory source. Both metadata services point only to the publisher PDF; no usable full text or repository copy was obtained. Its contents could sharpen the variational relationship. No theorem-level exclusion is claimed.
2. **Hertneck–Linsenmayer–Allgower, 2021**, DOI `10.1016/j.automatica.2021.109868`, a verified direct Gaukler successor. Full text unavailable in this audit. The linear specialization and any necessity/converse statement merit checking.
3. **Gurvits–Samorodnitsky, 2005**, DOI `10.1109/CDC.2005.1582513`. Original inaccessible; later primary attribution confirms the rank-one result but is not a complete inspection of the original.
4. **Kozyakin–Kuznetsov–Chebotarev, 2019 Part III**, DOI `10.1134/S0005117919060018`, a verified direct sliding-block citation. Abstract/reference metadata were available, full text was not.
5. **Vrabel, July 14, 2026**, DOI `10.1093/imamci/dnag016`, spectral interaction criteria for periodic block stabilization. The primary abstract is narrower than our advertised conclusion, but the PDF was inaccessible; it remains abstract-level triage.

The reports retain other screened-but-unread descendants and the incomplete correlated-renewal/sparse-impulse branch. They are coverage limits, not known counterexamples or evidence that our theorem is already solved. No restricted-source access was bypassed and no author was contacted.

## Recommendation

**Continue with this as a candidate short mathematical note, not an announced breakthrough.** The broader audit found a specific statement that survives the inspected antecedents, rather than only a new presentation of rank-one algebra. Its significance is still best described as specialized.

Before making an unqualified publication-novelty claim, obtain the strongest missing texts and have a specialist check the precise statement and reference positioning. Further numerical examples will not resolve that gate. This turn did not rewrite the theorem, launch experiments, or prepare an external submission.

## Evidence and integrity

- Detailed reports and primary source copies live in this directory and its three source subdirectories.
- `protocol-sources/count-citation-records.mjs` reproduces that branch's metadata counts; metadata deduplication is not mathematical verification.
- Failed publisher/author responses are distinguished from actual PDFs.
- `THEOREM.md` SHA-256 remains `4acd0ef06ece65c0471d70b727b7dc152f73b469f7aedae5d79a4ca285a10e34`.
- `verify.py` SHA-256 remains `a27bd934b0546e89c8a660beec11f6a19fed10e86670d06689b89b4841c7332e`.

The original proof evidence and earlier novelty report remain intact. This audit supersedes the earlier report only as the current literature assessment.
