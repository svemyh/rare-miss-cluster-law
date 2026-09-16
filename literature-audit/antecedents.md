# Rank-one, weighted-switching and singular-perturbation antecedents

September 15, 2026. Coordinator-owned report under AUDIT-CONTRACT.md. THEOREM.md and verify.py were not changed.

## Verdict

No direct equivalent or complete corollary derivation of the fixed-budget growing-window law was identified in the results inspected here. This is not a priority determination. The rank-one ingredients are definitely older; replacing long success blocks by a dominant projection is also an established technique. The specific remaining comparison is the sharp growth correction while the admissible sliding-window language changes with k.

Seven principal source records appear below. One is inaccessible in its original form. The other six were read at the depths stated; only the three-page Ahmadi–Parrilo paper is counted as a new full-paper read in this report. Introductory and theorem/proof-section reads are not relabeled as full reads. The numerical sections of Liu–Xiao and Protasov–Kamalov were not read.

## A1. Gurvits–Samorodnitsky, 2005: original access unresolved

L. Gurvits and A. Samorodnitsky, *A note on common quadratic Lyapunov functions for linear inclusions: Exact results and Open Problems*, CDC–ECC 2005, pages 2350–2355. DOI `10.1109/CDC.2005.1582513`. Crossref bibliographic query confirmed title, authors and DOI.

The author homepage lists the paper, but its `sevil.ps` link and the alternate author-path form both returned an HTML error page, not PostScript. The failed responses are preserved under descriptive HTML filenames. OpenAlex reports no open-access location; Semantic Scholar reports CLOSED with no PDF URL. Publisher access through web retrieval also failed. The original has **not** been read.

A2's revision appendix explicitly attributes the rank-one maximum-cycle-gain characterization to Appendix A of A1, and also reports a diagonal-scaling characterization. That is verified attribution by a later primary paper, not direct verification of all contents of A1. The exact reset example therefore has a clear pre-2012 antecedent. Nothing in the retrieved evidence establishes that A1 contains our general sparse-miss limit, but its full scope remains an access gap.

## A2. Ahmadi–Parrilo, 2012: full paper read

*Joint Spectral Radius of Rank One Matrices and the Maximum Cycle Mean Problem*, CDC 2012, pages 731–733. DOI `10.1109/CDC.2012.6425992`. Primary author-hosted published PDF, including revision appendix, read in full and archived.

Theorem 2.2 expresses the JSR of a finite rank-one family as its maximum cycle gain. Corollary 2.1 gives finite attainment without repeated factors in a shortest maximizing cycle. Remark 2.2 extends the graph method to constrained switching.

**Implication:** rank-one product factorization and exact weighted-cycle optimization are established, as is constrained use of that machinery. Our finite-k reset result should be a worked application with its pair-packing derivation.

**Remaining step:** C and D need not be rank one, and the relevant clusters form an infinite-gap family. Neither the limiting replacement nor the exact sliding-window packing follows merely by declaring a cycle graph. The formula in Section II.A appears to divide the cycle mean by its length a second time; use Theorem 2.2 and Example 3.1 for the intended normalization.

## A3. Liu–Xiao: rank-one approximation of general families

Jun Liu and Mingqing Xiao, *Rank-one Characterization of Joint Spectral Radius of Finite Matrix Family*. DOI `10.1016/j.laa.2012.12.032`; inspected arXiv `1109.1356v8`, December 29, 2016. Read introduction, all of Sections 2–3, conclusion and references. Archived PDF and extracted text.

Theorem 3 and Corollary 1 establish finiteness for rank-one families and for families with at most one higher-rank member. Theorem 4 obtains a limsup formula by taking special SVD rank-one approximations of all length-h products of a fixed family. Corollary 2 turns that into a limit for a nonnegative family with a primitive product. The conclusion expressly leaves its convergence rate unestimated.

**Nonimplication identified:** their h is product length for a fixed unrestricted family, not our changing constraint window k. A lift may represent each fixed protocol, but its size changes with k; a pointwise limit gives no needed uniform first-order error. Replacing the language by all legal k-blocks also permits illegal concatenations across block boundaries. Correcting either move requires an additional argument. The paper uses an SVD projection selected by trace, not our fixed Perron projection.

## A4. Protasov–Kamalov: removal of upper switching-interval bounds

*How do the lengths of switching intervals influence the stability of a dynamical system?* Inspected arXiv `2312.10506v2`, June 29, 2024. DOI `10.1016/j.automatica.2024.111929`. Read abstract, introduction, Sections 2–3 with proofs, Theorem 3 and its proof in Section 4, and references.

Theorem 2 says that a continuous-time system with mode-dependent positive minimum dwell times is stable exactly when its modes are Hurwitz and the system remains stable with suitable finite upper cutoffs on switching intervals. The proof uses unchanged Lyapunov multinorms when trajectory tails lie inside an earlier convex hull.

**Nonimplication:** this is an exact stability reduction, not a formula for the first-order rare-miss growth coefficient. Its admissible signals have per-mode interval restrictions, not at-most-m slots per every k slots. General positive discrete matrices are not necessarily real matrix exponentials. Our existing planar B has determinant -1/2, whereas det(exp(A)) is positive for real A; any proposed continuous-flow reduction needs an explicit embedding or extension. This observation does not exclude broader hybrid methods with discrete jumps.

## A5. Chitour et al.: weighted and impulsive Berger–Wang theory

Y. Chitour, J. Daafouz, I. Haidar, P. Mason and M. Sigalotti, *A Berger–Wang formula for impulsive switched systems*. Inspected arXiv `2507.02434v3`, version header February 6, 2026; manuscript title page February 9, 2026. Read introduction, definitions, main Theorem 1, Section 3's assumptions and Corollary 2 proof, Proposition 4's statement and opening proof, Section 4.5's continuity statement, and references.

For a fixed weighted system, Corollary 2 characterizes its maximal Lyapunov exponent by a maximum of a single-mode asymptotic contribution and generalized spectral growth. Proposition 6 establishes continuity for bounded impulsive mode sets at fixed positive dwell time.

**Nonimplication:** this justifies periodic spectral methods and duration accounting but does not evaluate our coefficient. Its repeated weighted words are unrestricted unless a valid state/language construction is supplied. Fixed-dwell continuity in a fixed-dimensional mode space does not itself establish k times a difference of exponents for changing sliding-window automata.

## A6. Chitour et al., CDC 2024: necessary singular-perturbation conditions

*Necessary conditions for the stability of singularly perturbed linear systems with switching slow-fast behaviors*. DOI `10.1109/CDC56724.2024.10886229`, HAL `hal-04806068v1`, deposited December 20, 2024. Read abstract, introduction, Sections 3.1–3.2, Theorem 8, Corollary 10, and supporting flow-approximation lemmas in Section 4.

Theorem 8 transfers exponential instability of a reduced switched system to the original continuous-time slow-fast family for sufficiently small perturbation. The model permits changes in which state coordinates are fast.

**Nonimplication:** an instability-transfer criterion is not a matching rare-miss exponent. Its asymptotic parameter changes differential dynamics, not a discrete miss-count language. A7 is the stronger follow-up and must be used before making any claim about what this research line lacks.

## A7. Haidar et al., 2025/2026: the stronger hybrid follow-up

I. Haidar, Y. Chitour, J. Daafouz, P. Mason and M. Sigalotti, *Stability criteria for singularly perturbed impulsive linear switched systems*. Inspected arXiv `2507.02446v3`, February 6, 2026; title page February 9. The earlier citation used the title *Stability criteria for hybrid linear systems with singular perturbations*. Read abstract, introduction, model and main-result sections, Theorem 2, Section 6.2's short/long-interval proof strategy, and the relevant comparison statements. Archived PDF and text; not counted as a full-paper read.

Theorem 2 supplies an upper bound by an auxiliary reduced system under fixed positive dwell time and another upper bound under a fast-subsystem stability condition with unrestricted switching. Together with the lower bounds it yields exact exponent convergence in the fixed-positive-dwell case. Its proof already uses reduced dynamics and uniform treatment of transient intervals.

**Nonimplication under the written assumptions:** fixed positive separation excludes our arbitrarily close bursts after time rescaling. The unrestricted case admits words excluded by the sliding-window budget and imposes separate fast stability. Applying either theorem would require a construction preserving that budget and a uniform comparison at the k-scaled order. The general principle of approximating fast transients by resets is not new.

## Actual citation traversal and bibliographic screening

Semantic Scholar citation endpoints returned complete first pages, with no next cursor, containing 8 records for A1, 13 for A3, and 19 for the 2019/2021 Chitour weighted-dwell paper. Raw responses are archived. These are 40 returned records, not 40 unique read papers or exhaustive worldwide coverage. The A1 graph contains a nominally 2003 item citing a 2005 source, and a journal-title-like record. Such index anomalies were not treated as clean temporal citations.

Serious leads followed include A3, A5, A6, A7, A4, and Altschuler–Parrilo's rank-one ergodic paper, assigned to the rare-defect worker. Symbolic-memory and path-complete frequency papers were assigned to the protocol worker. Algorithmic min-mean-cycle complexity, consensus, observer convergence and bibliography-only titles were screened as background or handed off when relevant; metadata is not evidence that their proofs were read.

Kozyakin's author-maintained JSR bibliography was downloaded and searched for rank-one, dwell, frequency, rare and perturbation terminology. Its records supplied corroborating identifiers and leads. It is a discovery aid, not a primary theorem source; its abstracts were not substituted for original proofs.

## Query log

Web queries were issued in batches. Some returned empty, shallow or irrelevant results; source retrieval and citation APIs were therefore used in addition. Representative exact query strings:

```text
Gurvits Samorodnitsky 2005 joint spectral radius rank one Appendix A
"Gurvits" "Samorodnitsky" "2005" "stability"
"A note on common quadratic Lyapunov functions for linear inclusions"
"Gurvits" "Samorodnitsky" "linear inclusions" pdf
Gurvits Samorodnitsky common quadratic Lyapunov 2005 7359
"sevil.ps"
10.1109/CDC.2005.1582513 pdf
"joint spectral radius" "large dwell time"
"maximal Lyapunov exponent" "dwell time" "asymptotic"
"large dwell-time" "Lyapunov"
"slow switching" "Perron"
"rare switching" "Lyapunov"
"dwell time" "asymptotic expansion"
"Slow- and Fast-Limit Approximations of Lyapunov Exponents"
"Stability criteria for hybrid linear systems with singular perturbations"
"Haidar" "Chitour" "singular perturbations" 2025
```

Crossref supplied A1's exact DOI using a bibliographic query. OpenAlex supplied its access metadata. Semantic Scholar supplied actual forward edges. The rare-defect worker owns the slow-switching paper found via these queries; it is not counted a second time here.

## Access and coverage limits

The Gurvits–Samorodnitsky original remains unread. The later primary attribution and independent proofs sharply identify the rank-one antecedent but do not prove that no other result in the original matters. Citation indexes have incomplete coverage and merged/preprint/publication records; no exact global citation count is claimed. This report does not claim completeness of the large impulsive, ergodic or control literature.

The most defensible implication verdict is: existing results recover several ingredients and the reset subfamily; a direct derivation of the complete fixed-budget growing-window theorem has not been located in the inspected statements.

### Final targeted access checks

For Yun Zhao's 2019 JMAA paper, DOI `10.1016/j.jmaa.2019.01.065`, OpenAlex and Semantic Scholar independently return only the same publisher PDF location, with no repository copy. The rare-defect worker's publisher retrieval returned 403. No alternative primary full text was obtained, and no theorem-level exclusion is asserted.

For Robert Vrabel's *Spectral interaction criteria for block stabilization of discrete-time switched linear systems with unstable and marginal modes*, DOI `10.1093/imamci/dnag016`, Crossref confirms July 14, 2026 publication and supplies the primary abstract. That abstract describes sufficient criteria and scaling laws for periodic block stability, not an advertised worst-case sliding-window coefficient. The advertised publisher PDF returned 403 and OpenAlex lists no repository copy. This remains **abstract-level triage**, not a full-text exclusion or an additional technical read.
