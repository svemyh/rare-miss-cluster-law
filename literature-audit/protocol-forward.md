# Protocol, weakly-hard control, and forward-citation audit

Audit date and literature cutoff: September 15, 2026. This report owns only `protocol-forward.md` and `protocol-sources/`. `AUDIT-CONTRACT.md`, `../THEOREM.md`, and `../novelty.md` were read in full. Neither target document was edited.

## Bottom line

No direct equivalent or plug-in corollary giving the general fixed-budget coefficient was located in this lane. The eight core primary theorem/proof reads below do not establish novelty. Confidence is high about what those particular statements provide, moderate about coverage of protocol/control methods, and limited about completeness of the citation databases and the unread sources listed at the end.

The closest exact antecedent remains the constrained Berger-Wang chain, Dai 2012 to Dai 2014 to Kozyakin 2014. It converts the norm growth problem to spectral growth and, for finite-type constraints, to admissible periodic products. It does not bound the relevant periods as the window grows or evaluate their supremum. Bund and Gaukler give actual loss-distribution models and uniform scalar upper bounds, but their reductions discard the internal-gap interactions that define the target coefficient. Philippe and its descendants supply complete certificate frameworks at a fixed symbolic constraint, not the changing-window limit. [1–6, 9–11]

The 2026 papers do not close that gap. Compression proves an over-approximation of the weakly-hard language, with spectral accuracy evaluated empirically. Its Perron limit counts accepted words. The September 10 revision of iterative graph lifting expressly leaves termination and convergence unproved. Its exactness test has an optimum-attainment and tight-subgraph hypothesis, not a theorem that the test succeeds for rare-miss protocols. [7–8]

The defensible surviving claim is narrowly stated: the exact coefficient obtained by uniform Perron separation and sharp sliding-window cluster packing has not been subsumed by the statements audited here. This is a bounded literature-survival assessment. It does not justify a first-in-literature claim.

## Exact comparison target

Write the target window as `k`, the number of observed slots as `N`, and the fixed miss budget as `m`. Matrices `C,D`, their dimension, and `m` remain fixed. With the notation of `THEOREM.md`, the target is

```text
lim[k→∞] k log(rho_{m,k}/lambda) = log M_m,
M_m = max(1,S_1,...,S_m),
S_j = sup[g_1,...,g_{j-1}≥0] ell^T E B^g_1 E ... B^g_{j-1} E r.
```

The loss rule is at most `m` misses in every `k` consecutive slots. It is neither an average-density rule nor a random miss probability. A run of misses occupies several slots but generally causes only two mode changes. Thus a switching-frequency or dwell-time constraint cannot replace the loss rule. The supremum defining `S_j` includes limits of gaps tending to infinity. Period-`k` words supply lower witnesses, not a claimed exact optimizer at finite `k`.

## Source ledger and read depths

All reads and retrieval attempts were performed on September 15, 2026. Page numbers below refer to the downloaded manuscript's printed pages unless explicitly called PDF pages. The eight numbered core reads are substantive, not eight metadata records. The Kozyakin anchor was checked at selected statements after its full reading in the supplied prior audit. Two later coordinator-requested sources received additional targeted theorem-section triage. The thesis was not read cover to cover.

Final reading counts: **1 full paper**, [8]; **9 substantial theorem/proof-section reads**, [1]–[7], [10], [11]; and **1 separate anchor spot-check**, [9]. The original eight core reads comprise the full paper and seven theorem/proof-section reads. The two additions raised the theorem-section total to nine. In addition, the consensus survey received a primary abstract/reference check and the chronological-refinement paper received a primary abstract/date check. Metadata-only records are not included in any of these text-reading counts.

| ID | Primary source and exact identifier | Actual depth in this audit | Classification against the target |
|---|---|---|---|
| [1] | X. Dai, *A Gel'fand-type spectral radius formula and stability of linear constrained switching systems*. LAA 436, 1099–1113, 2012. DOI `10.1016/j.laa.2011.07.029`; arXiv `1107.0124v1`, July 1, 2011. | Theorem A and assumptions, pp. 2–6; Section 2, especially Theorems 2.3/2.6 and the proof of A, pp. 7–9; Corollaries 2.7–2.8, stability sections and final questions inspected. The core theorem and proof were read, not just quoted from Kozyakin. | Exact fixed-constraint antecedent; missing changing-window evaluation. |
| [2] | X. Dai, *Robust periodic stability implies uniform exponential stability of Markovian jump linear systems and random linear ordinary differential equations*. J. Franklin Inst. 351, 2910–2937, 2014. DOI `10.1016/j.jfranklin.2014.01.010`; arXiv `1307.4209v2`, December 17, 2013. | Section 1.1, pp. 2–5; entire Section 2, pp. 11–17, including periodic approximation, recurrence/cone argument, and proofs of Theorems 1.4 and 1.2; references. Continuous-time random-ODE part not audited, to avoid the other worker's lane. | Meaningful descendant; exact periodic approximation at fixed finite-type constraint. |
| [3] | Tobias Stefan Bund, *Verifikation sicherheitskritischer Regelsysteme unter Beachtung des Zeitverhaltens einer verteilten Rechenplattform*, Ulm dissertation. DOI `10.18725/oparu-4463`. Title page July 7, 2017; repository publication date August 1, 2017. | Definitions 12–13 and loss-density formula, pp. 53–55; dominant-point discussion and Sätze 7–9, pp. 70–74; Section 6.2.2 in full, pp. 124–134, including Sätze 23–26; complete Appendix C.1 proof of Satz 24, pp. 171–172. Abstract/contents also read. | Close control antecedent; a certified envelope, not exact rare-miss growth. |
| [4] | M. Gaukler, T. Rheinfels, P. Ulbrich, G. Roppenecker, *Convergence Rate Abstractions for Weakly-Hard Real-Time Control*. arXiv `1912.09871v2`, June 24, 2020; original December 20, 2019. | Sections 6.1–6.3 theorem statements and induction proofs, pp. 16–20; Section 7 through scalar criterion and converse discussion, pp. 20–24; references and explicit Bund discussion, p. 14. The later counterexample calculations were not independently rerun. | Close, but upper bound only for the original system. |
| [5] | N. Vreman, P. Pazzaglia, V. Magron, J. Wang, M. Maggio, *Stability of Linear Systems under Extended Weakly-Hard Constraints*. DOI `10.1109/LCSYS.2022.3179960`; arXiv `2101.11312v2`, August 30, 2022. | Introduction, model/constraint definitions, Sections III–IV, especially Definitions 6–9, Lemma 1, Theorems 1–2 and their proofs, Corollaries 1–3, pp. 3–5; references. No numerical replication. | Exact representation and dominance results; no coefficient evaluation. |
| [6] | M. Philippe, R. Essick, G. E. Dullerud, R. M. Jungers, *Stability of discrete-time switching systems with constrained switching sequences*. Automatica 72, 242–250, 2016. DOI `10.1016/j.automatica.2016.05.015`; arXiv `1503.06984v3`, April 21, 2016. | Proposition 2.2 and proof, pp. 3–4; Section 3 approximation, product/memory/SOS lifts and proofs, pp. 4–7; Theorem 3.8 and proof; Section 3.5 Kronecker construction and Proposition 3.9, p. 8; cited Dai link. | Complete fixed-automaton machinery, not the rare-miss coefficient. |
| [7] | R. de Maeyer, H. Hermanns, M. Maggio, *Over-approximation of weakly-hard constraints for control systems verification (Extended)*. arXiv `2605.16959v1`, May 16, 2026. Published-version DOI appearing in citation graph: `10.1007/978-3-032-32537-2_20`. | Intro/model, pp. 1–5; compression definition, Theorem 3.10 proof and Corollary 3.11, pp. 9–11; cardinality theorem statement, p. 12; Appendix A isomorphism and well-definedness proofs, pp. 22–25; Appendix C Perron statements and final counting limit, pp. 30–33; references. Experiments not replicated. | Close in regime, but language inclusion and word counts, not an exact product-growth asymptotic. |
| [8] | L. Ninite, R. M. Jungers, *Iterative graph lifting for automatic design of path-complete stability certificates*. arXiv `2607.00637v2`, September 10, 2026; v1 July 1, 2026. | Full 8-PDF-page manuscript, including Theorems 2–4, tight-support assumptions, algorithm, Remark 2, experiments discussion, references, and Appendix proofs. A truncated extraction was completed by rereading the omitted theorem/proof section. | Related algorithm; conditional exactness, no guaranteed convergence or termination. |
| [9] | V. Kozyakin, *Matrix products with constraints on the sliding block relative frequencies of different factors*. LAA 457, 244–260, 2014. DOI `10.1016/j.laa.2014.05.016`; arXiv `1403.5050v4`, May 28, 2014. | Anchor spot-check: Theorem 1 and proof, p. 9; periodic definition, Theorem 2 and proof, Remark 4, pp. 12–13; references. Not counted as a new full read. | Exact constraint match at each fixed window; no large-window formula. |
| [10] | M. Della Rossa, R. M. Jungers, *Multiple Lyapunov Functions and Memory: A Symbolic Dynamics Approach to Systems and Control*. DOI `10.1137/23M1589244`, SIAM 2024; arXiv `2307.13543v2`, July 23, 2024. | Additional coordinator-requested triage: introduction/definitions; Section 3.1, pp. 5–7, Theorems 1–2 statements; Proposition 4, Theorem 5 and complete proof, pp. 15–17; Section 5.1 equations 18–20, pp. 17–18; positive-template example setup; references. Not a full-paper read. | Broader fixed-shift certificate completeness; missing uniform varying-window evaluation. |
| [11] | M. Della Rossa, M. Pasquini, D. Angeli, *Continuous-time switched systems with switching frequency constraints: Path-complete stability criteria*. DOI `10.1016/j.automatica.2021.110099`; Automatica, March 2022; author manuscript December 9, 2021. | Additional coordinator-requested triage: abstract/introduction, Section 2.1 equations 4–5, pp. 1–2; fixed-time Lyapunov construction inspected; Section 4.1, Theorem 2 and proof, pp. 5–6; related-work discussion. Not a full-paper read. | Different constraint and continuous-time setting; sufficient stability criteria. |

Core source files are retained as matching `.pdf` and mechanically extracted `.txt` files in `protocol-sources/`. A download is not itself counted as a read. No solver, new numerical example, cloud job, author contact, or service was used.

## Implication tests

### Dai's original theorem and its actual descendants

Dai [1, Theorem A] assumes a continuous matrix assignment over an invariant compact subset of the one-sided shift. For our fixed `k`, the alphabet is finite and the forbidden-window conditions define a closed, shift-invariant, nonempty subset. Therefore the theorem applies, without requiring positivity. It equates the target norm growth with a limsup of spectral radii of admissible prefixes. The distinction matters: an admissible prefix need not admit periodic repetition. Dai explicitly discusses that issue in Remark 1.5 and Question 1.

Dai [2, Theorem 1.4] strengthens this for finite-type constraints to periodically admissible products. Its proof uses Theorem 2.1, approximating ergodic exponents by periodic laws. The approximation sequence is selected for a fixed transition matrix and fixed cocycle. There is no upper bound on its periods in terms of our `k,m`. Corollary 1.5 is continuity with the transition matrix held fixed, not a continuity theorem uniform over growing automata.

This is an actual reference chain. Kozyakin [9, reference 1] cites [2]; [2, reference 16 and proof of Theorem 1.4] uses [1, Corollary 2.7]. Kozyakin's Theorem 2 recodes the sliding-block shift as a one-step Markov shift and invokes Dai. Its Remark 4 permits an arbitrary allowed-block set, so one can use precisely the binary `k`-words with at most `m` zeroes without a frequency-interior technical detour.

The exact consequence is, schematically,

```text
rho_{m,k}/lambda
  = sup over cyclically legal finite words w of rho(W(w))^(1/|w|).
```

Repetition of any legal cycle justifies replacing the periodic limsup by this supremum. This formula still ranges over arbitrarily long cycles, with potentially arbitrarily many misses as `|w|` increases. It does not reduce to a maximum over clusters with at most `m` misses.

The standard periodic/Perron lower-bound route does work. For each fixed finite `j`-miss cluster `K`, `j≤m`, repeat a period-`k` word with product `B^(k-|K|)K`. Every cyclic `k`-window has exactly `j` misses. The product tends to `PK`, whose nonzero eigenvalue is `ell^T K r`. Thus each such cluster yields the corresponding lower coefficient. This reproduces the target's existing Section 4 reasoning, not a new claimed theorem from this audit. The missing implication is the reverse bound over **all** admissible cycles or words, uniformly as `k` grows. Neither [1], [2], nor [9] supplies that cluster bound.

### Bund: a real interval-loss model, followed by a conservative reduction

Bund [3, Definition 13] bounds losses on every event interval, not only in an average-frequency sense. Satz 9 specializes this to at most `m` losses in `k` events. Its equation 5.16 is equivalent to

```text
dD^+(N) = m floor(N/k) + min(m, N mod k).
```

That is prior art for sharp scalar loss counting. It is not the target's weighted cluster-packing lemma.

The strongest plausible overlap is Section 6.2.2. Satz 23 first retains temporal dependence in a convolution inequality for equivalent disturbances generated by earlier losses. Equations 6.24 and 6.28 then upper-bound the sensitivity and initial-condition kernels by exponential envelopes with common exponent `lambda_v`. Satz 24 and Appendix C.1 derive

```text
|v_N^(z)| ≤ alpha_theta (1+alpha_mu)^(z-1) exp(-lambda_v N) |x_0|,
```

where `z` is the number of losses up to slot `N`. Inserting the interval loss count yields an upper exponent `-lambda_v + (m/k) log(1+alpha_mu)` for this disturbance bound. Sätze 25–26 convert the envelope into signal-density/stability criteria using the loss-interval function and its dominant point.

This does not identify the original system's CJSR, equate `lambda_v` and the target normalization in all admissible models, or prove sharpness of the envelope. The model is a specific networked feedback architecture and does not assume arbitrary strictly positive mode matrices. Above all, the exponential envelope removes the detailed gap-dependent kernel that would be needed to identify `S_j`. A large observation horizon for a fixed loss-density curve is not the target's family of increasing protocol windows. Gaukler's actual text points to precisely Bund Chapters 6.1 and 6.2.2, so this was a bibliographic traversal, not a guessed thesis connection. [3; 4, p. 14]

I do not use Bund's non-strict boundary in Satz 26 to infer an exact stability boundary for the target. An upper disturbance envelope is insufficient evidence for such an identification.

### Gaukler: what its exact scalar rate actually implies

Theorems 6.2–6.3 give sound scalar abstractions; Theorem 6.4 transfers their exponential bounds. In Theorem 7.2 the paper's `m` counts required successes, not misses. Translating to our convention gives scalar rate

```text
q_success^(1-m/k) q_miss^(m/k), when q_miss ≥ q_success.
```

This rate is exact for the comparison recursion. The theorem gives only an upper bound for the original dynamics. Section 7 explicitly discusses failure of a general converse at equal loss ratios. [4, pp. 20–24]

There is a useful explicit specialization. Take the squared Perron-weighted vector norm as the admissible `V` in Theorem 6.3. Then `||C||_r=lambda`; choose `h=max(1,||E||_r)` and `q_miss=lambda h`. The abstraction gives

```text
rho_{m,k}/lambda ≤ h^(m/k),
limsup[k→∞] k log(rho_{m,k}/lambda) ≤ m log h.
```

This is a genuine bound obtainable from the cited machinery. It does not show `M_m=h^m`: the norm gain optimizes directions separately at each miss and discards their compatibility through intervening successes. Positivity makes the weighted nominal norm exact; it does not make all miss gains or all clusters exact. Recovering `M_m` by replacing these one-step gains with history-dependent sharp cluster gains would require the disputed additional reduction, rather than follow from Theorem 7.2 alone.

### Vreman's forward citation: lifting is exact, dominance is not an evaluation

Vreman et al. [5] explicitly cite Gaukler as reference 6 and Philippe as reference 20. Their Definition 6 includes the exact at-most-`m`-missing-completions-in-every-`k`-intervals constraint, with additional handling-strategy semantics. Section IV-A lifts a deterministic automaton via `F_alpha ⊗ A_alpha`, preserving the constrained JSR. Theorems 1–2 and their proofs establish monotonicity under language inclusion and under adding constraints.

For our fixed matrices, the first monotonicity immediately says that increasing the window at fixed miss budget cannot increase `rho_{m,k}`. It neither gives the first-order decrease nor implies existence of `k log(rho_{m,k}/lambda)`. The matrix dimension and automaton grow with the constraint representation, and the paper uses numerical JSR/SOS bounds after lifting. Its statements are uniform over words for each fixed constraint, but do not supply a uniform scalar approximation whose error vanishes after multiplication by `k`.

This source substantially improves the prior audit's forward-control coverage. It does not kill the proposed coefficient. Its explicit successor references identify the remaining Hertneck/Linsenmayer line and the 2021 burst/performance work, rather than supporting a generic claim that no later work exists.

### Philippe: the quantitative precision requirement

Philippe et al. [6, Proposition 2.2] characterize CJSR exactly by an infimum over multinorms. Their Theorem 3.2 gives, for a product-lift length `T` and original state dimension `d`,

```text
rho_{m,k} ≤ U_{k,T} ≤ d^(1/(2T)) rho_{m,k}.
```

Consequently the uncertainty in a coefficient computed from that bound is at most

```text
k log(U_{k,T}/lambda) - k log(rho_{m,k}/lambda) ≤ k log(d)/(2T).
```

For fixed `d>1`, the displayed guarantee vanishes if `T/k→∞`. Corollary 3.6 gives the parallel memory-lift statement. Thus the literature can certify the coefficient to arbitrarily high precision at each chosen window, in principle. It does not analytically evaluate its limit. Taking certificate accuracy to zero for each fixed `k` is a different operation from establishing the proposed exact changing-window formula.

Theorem 3.8 is an exactness certificate if the tight edges of an attained optimal quadratic multinorm form a simple cycle. It does not prove that these hypotheses hold for every large-window positive pair. Section 3.5's Kronecker construction encodes legal words; it does not replace long nominal blocks by the Perron projection. No rank-one novelty claim is assessed here, since that lane belongs to the coordinator.

### The 2026 compression paper: closest application regime, different asymptotic

The paper [7] explicitly motivates large windows with small fixed budgets and uses the notation `AnyMiss(m,k)`. Its Theorem 3.10 proves that the compressed automaton simulates the exact one; Corollary 3.11 gives language inclusion. `c=1` is the exact, uncompressed case; otherwise extra words may be admitted. Theorem 3.13 counts compressed states. These are exact combinatorial results, but they do not establish an exact spectral error bound for the physical mode matrices.

In particular, the Perron formulas of Remark 3.12 and Appendix C are about `|L^N(G)|`, the **number** of accepted words, using the adjacency matrix. The target concerns the maximum norm of a matrix product over those words. Word-count entropy, adjacency spectral radius, and CJSR are different quantities. The appendix takes word length to infinity for a fixed automaton. The target changes the window and therefore the automaton.

Even a sound compressed upper bound would need an error `log(rho_compressed/rho_exact)=o(1/k)` to preserve the coefficient. No such theorem appears in the inspected claims or their proofs. Taking `c=1` simply recovers the original constrained problem. This paper should be cited for the application regime and scalability motivation, not as an antecedent that already evaluates `M_m`. It is an actual forward citation of Philippe, reference 26.

### The September 10, 2026 lifting revision

Ninite–Jungers [8] treats arbitrary switching using path-complete certificate graphs. Theorem 2 preserves path-completeness under a local node split. Theorem 3 proves that the optimal bound cannot worsen. Theorem 4 proves exactness when an optimum is attained and every node of its tight subgraph has at most one outgoing edge. The proof reduces strongly connected components to cycles and compares their values with JSR.

The qualifications are material. Remark 1 discusses the need for a support set and the possibility of non-attainment. Remark 2 states that there is no termination or convergence guarantee. A numerical stopping tolerance is not the theorem's exactness condition.

Applying this algorithm to an automaton lift of the target would leave the physical modes, all legal words, the growing graph, and the rare-miss evaluation problem intact. Its exactness test is neither shown to trigger on this family nor uniform in `k`. This was found through the prior scout and title/version retrieval. The paper's bibliography does not cite Philippe 2016; it is **related work**, not a verified direct forward edge from Philippe. Its resemblance to Philippe's conditional cycle certificate should not be misreported as a documented citation path.

## Added symbolic-protocol triage requested by the coordinator

The user requested a broad, thorough audit. The coordinator selected the following two sources and supplied the Chitour citation graph; these exact citations were not separately requested by the user.

### Della Rossa–Jungers 2024, memory and symbolic dynamics

The coordinator supplied its incoming edge from Chitour in `antecedent-sources/dwell-citations.json`; I read that edge, fetched the primary paper, and also found it among the Philippe incoming records. Its reference 38 is Philippe 2016. [10]

Theorem 5, called an asymptotic converse Lyapunov theorem, fixes a shift of finite type `Z`. For a switched linear system on `Z`, uniform exponential decay at every rate above a threshold is equivalent to quadratic certificates on sufficiently long mixed past/future De Bruijn coverings. The proof selects a horizon long enough that the terminal term in a finite observability-Gramian sum is dominated by the identity. This selection uses the uniform bound for the **given** system and shift.

For the target one can take `Z=Z_{m,k}` separately at each `k`, after a harmless two-sided presentation of the same admissible language. That establishes certificate completeness for every fixed window. The certificate horizon in Theorem 5 is not the protocol window. Equation 20 restates exact CJSR as a Lyapunov infimum, not as a Perron-cluster expression. The positive-system example uses copositive templates on a fixed golden-mean shift; it does not assert that positivity makes finite-memory bounds exact in the changing-window regime.

Classification: close methodological descendant, not an evaluated limit. It strengthens the warning that generic memory/certificate completeness is established prior art. It leaves the same missing comparison between all legal products and the finite-cluster weights.

### Della Rossa–Pasquini–Angeli, frequency criteria

The coordinator-supplied Chitour edge was verified in the shared metadata file. A primary full manuscript was obtained through the Imperial repository handle returned by Semantic Scholar, not inferred from the DOI's year. The manuscript is dated December 9, 2021; the repository identifies the journal publication as March 2022. It explicitly discusses Philippe 2016 Section 3 and Chitour's graph formulation. [11]

Equations 4–5 distinguish two signal classes: switching intervals that are integer multiples of a fixed clock step `tau`, and switching intervals at least `tau`. Section 4.1, Theorem 2, gives sufficient uniform asymptotic stability under the latter through path-complete inequalities on flow segments of duration in `[tau,2 tau)`. The proof subdivides arbitrary dwell intervals into such segments.

These hypotheses do not impose a budget of miss **slots** in every sliding window. Nor do they permit an automatic identification of a discrete positive pair with continuous-time flows: arbitrary strictly positive matrices need not arise as the required flow maps. The graph certificates are relevant background, but the theorem cannot be substituted for the target's cluster packing. No expansion into the coordinator's dwell-time audit was made.

## Actual citation graph, counts, and traversal

### Database retrieval, distinguished from reading

OpenAlex was queried with `cites:<seed>,to_publication_date:2026-09-15`, `per-page=200`. No topic filter was applied to the incoming-edge responses. Every returned title was screened. All returned records fit in one response; there was no omitted second page. Counts are database edges, not unique papers, primary full reads, or worldwide citation totals. Preprint/publisher duplication and database incompleteness remain possible.

| Seed | OpenAlex seed ID | Seed count / filtered incoming edges returned | Semantic Scholar result |
|---|---|---|---|
| Kozyakin 2014 | `W2096086062` | 1 / 1 | 2 advertised, 2 embedded citing records returned |
| Gaukler preprint | `W2994915743` | 3 / 3 | Repeated exact-arXiv requests returned HTTP/API 429; DOI-form lookup returned not found. No S2 edge census claimed. |
| Philippe journal record | `W1497233851` | 148 / 148 | 149 advertised, 149 embedded citing records returned; all titles screened. |
| Philippe preprint duplicates | `W2951275211`, `W4300657989` | 0 / 0 each | Not separate full reads or additional citations. |

The successful S2 query returned citing `year`, not full dates. Its Philippe response has 9 records labeled 2026 and 3 without a year. It was **not** server-filtered to September 15. A follow-up request for `citations.publicationDate` returned 429 and is preserved. Thus the date-filtered counts above belong only to OpenAlex. The two specifically inspected new arXiv records, compression and chronological refinement, have primary dates May 16 and September 12, 2026, respectively. Do not equate the 149 S2 rows with 149 fully date-verified eligible citations.

Raw graph receipts are retained in `protocol-sources/*-forward-openalex.json` and `*-forward-s2*.json`, including error responses. The OpenAlex search initially used broad full-text search, which returned 56,886 candidate records and five displayed hits; that was seed discovery, **not** citation traversal. Subsequent exact title search found one Gaukler record, three Philippe records, and one Kozyakin record.

Deduplication of the successful incoming-edge receipts was run with the retained, read-only script `protocol-sources/count-citation-records.mjs`. It joins records sharing normalized DOI, arXiv ID, OpenAlex/MAG ID, or S2 paper ID. A separately reported second pass also joins exact normalized titles, using Unicode normalization, lowercasing, and removal of punctuation/whitespace. There is no fuzzy matching.

| Seed receipts combined | Raw incoming records | Identifier-deduplicated | Also merging exact normalized titles |
|---|---:|---:|---:|
| Kozyakin | 3 | 2 | 2 |
| Gaukler | 3 | 3 | 3 |
| Philippe | 297 | 167 | 159 |
| All three seeds, cross-seed deduplication | 303 | **171** | **163** |

These are reproducible **metadata-record clusters**, not claimed reads. The 171 count is conservative about version records lacking a shared identifier. The 163 title-assisted count may also merge same-title versions; it is not a manually verified count of distinct scholarly works. The combined counts inherit the unfiltered/partially dated S2 records and must not be advertised as a completely date-verified census through the cutoff.

### Edges actually followed

1. **Backward:** Kozyakin 2014 reference 1 → Dai 2014 → Dai 2012 reference 16 and proof invocation. All relevant primary theorem sections read.
2. **Backward:** Gaukler 2020, p. 14 and `[Bun17]` → Bund DOI → Ulm repository → dissertation download → relevant loss-density and proof sections.
3. **Forward:** Gaukler OpenAlex incoming edges → Vreman et al. extended weakly-hard → primary paper reference 6 confirms Gaukler; reference 20 confirms Philippe. Theorem/proof sections read.
4. **Forward:** Philippe OpenAlex and S2 incoming edges → 2026 compression → reference 26 confirms Philippe. Simulation proof and Perron-counting appendix read.
5. **Forward:** Kozyakin OpenAlex/S2 → Kozyakin–Kuznetsov–Chebotarev 2019 Part III → publisher reference metadata `CR52` explicitly confirms the sliding-block paper. Publisher abstract and reference entry inspected; full text not obtained.
6. **Forward:** Kozyakin S2 second edge → *Topological Entropy of Switched Systems*, year 2018, paper ID `78724b10f463bc953df4b87acc514539d5415873`. Follow-up metadata request returned 429. No primary statement inferred.
7. **Forward plus coordinator-supplied graph:** Chitour receipt → [10] and [11]; also Philippe incoming metadata → both titles. Their primary texts were obtained and targeted sections read. The shared Chitour receipt was read-only.
8. **Recent incoming edge:** Philippe S2 → Y. Li and Y. Wang, *Chronological stability for nonstationary matrix refinement*, arXiv `2609.13981v1`, submitted September 12, 2026. Primary abstract/date read. It concerns changing refinement operators/matching spaces and summable matching defects, not a stated sliding-window loss budget. Abstract-level triage only; not counted as a theorem read or definitively excluded by full text.
9. **Related, not a forward edge:** prior scout → Ninite–Jungers [8]. Version history checked directly, latest available revision at the cutoff September 10, 2026.

The other two Gaukler incoming edges are Hertneck–Linsenmayer–Allgöwer 2021, DOI `10.1016/j.automatica.2021.109868`, and *Performance-Driven Post-Processing of Control Loop Execution Schedules*, DOI `10.1145/3421505`, 2020. They are recorded leads, not full reads.

The Philippe title census also returned algebraic lifting, DOI `10.1109/TAC.2020.3020580`, arXiv `1807.03965`; high-growth trajectory construction, arXiv `2009.12948`; weakly-hard `l2` performance, DOI `10.1016/j.ejcon.2024.101056`; and July 2026 block stabilization, DOI `10.1093/imamci/dnag016`. Those are explicit remaining leads, not sources silently counted as audited. Dwell-time, random-product and rank-one titles were left to the assigned workers.

## Query and access log

Every entry below was issued on September 15, 2026. Web search was frequently empty or shallow. A failed search is not evidence of absence. The following are the exact substantive search strings used, grouped for readability; repeated versions of a query do not count as independent searches or sources. These searches preceded or supplemented the graph queries; they are not labeled a forward-citation census.

```text
Dai constrained Berger Wang formula 2012 arbitrary switching constraints
Bund thesis weakly hard control stability
"Kozyakin" "sliding block" "cited"
"Convergence Rate Abstractions" "cited by"
"Dai" "Gel’fand-type"
"Bund" "thesis" "weakly-hard"
"Kozyakin" "sliding block relative frequencies"
"Convergence Rate Abstractions for Weakly-Hard"
"A Gel'fand-type spectral-radius formula"
"Bund" "Verifikation sicherheitskritischer"
"Dai" "Berger-Wang" "constrained"
"Tobias Bund" "2017" "pdf"
"Dai" "Robust periodic stability"
"Matrix products with constraints on the sliding block" -site:researchgate.net -site:arxiv.org -site:sciencedirect.com -site:kozyakin.github.io
Tobias Bund "Stability of Networked Control Systems" thesis pdf
"Tobias Bund" dissertation
"Weakly-Hard Constraints" "Bund" thesis
"10.18725/oparu-4463"
"Gaukler" "weakly-hard" "2024"
"Kozyakin" "sliding block" "2025"
"Matrix products with constraints" "2020"
OpenAlex API filter cites work documentation
"Convergence Rate Abstractions" "2021"
"Kozyakin" "sliding block" "2018"
"Stability of discrete-time switching systems with constrained switching sequences" "2026"
"Dai" "A Gel’fand-type spectral"
"Bund" "Verifikation sicherheitskritischer Regelsysteme"
"Efficient stability analysis approaches for nonlinear weakly-hard" arxiv
"Iterative graph lifting" Ninite Jungers
"Efficient stability analysis approaches" Hertneck Allgower arxiv
"Consensus in Asynchronous Multiagent Systems. III"
"Stability of Linear Systems Under Extended Weakly-Hard Constraints"
"Kozyakin" "sliding block relative frequencies" "2017"
"Hertneck" "Efficient stability"
"Kozyakin" "Kuznetsov" "Consensus" 2019 pdf
"Topological entropy of switched systems" 2018
"2609.13981"
"Efficient stability analysis approaches for nonlinear" "pdf"
"Hertneck" "weakly-hard" "arxiv.org"
"Consensus in Asynchronous Multiagent Systems" "Kozyakin" "2019"
"TOPOLOGICAL ENTROPY OF SWITCHED SYSTEMS" "2018"
"Consensus in Asynchronous Multiagent Systems. III. Constructive Stability and Stabilizability"
"TOPOLOGICAL ENTROPY OF SWITCHED SYSTEMS"
"Efficient stability analysis approaches for nonlinear weakly-hard real-time control systems"
```

Reproducible graph request patterns, with the exact seed IDs given above:

```text
https://api.openalex.org/works?search=Matrix%20products%20with%20constraints%20on%20the%20sliding%20block&per-page=5
https://api.openalex.org/works?filter=title.search:<URL-encoded exact seed title>&per-page=20
https://api.openalex.org/works?filter=cites:<seed ID>,to_publication_date:2026-09-15&per-page=200
https://api.semanticscholar.org/graph/v1/paper/DOI:10.1016/j.laa.2014.05.016?fields=title,year,openAccessPdf,url,citationCount,citations.title,citations.year,citations.externalIds
https://api.semanticscholar.org/graph/v1/paper/DOI:10.1016/j.automatica.2016.05.015?fields=title,year,openAccessPdf,url,citationCount,citations.title,citations.year,citations.externalIds
https://api.semanticscholar.org/graph/v1/paper/ARXIV:1912.09871?fields=title,year,openAccessPdf,url,citationCount,citations.title,citations.year,citations.externalIds
https://api.semanticscholar.org/graph/v1/paper/d40ee1a618cfe5ce032f4a850b8130699f526ae0?fields=title,citationCount,citations.title,citations.publicationDate,citations.year,citations.externalIds
```

The OpenAlex `cites` direction and date-filter semantics were checked in its official `ourresearch/openalex-docs` repository, file `api-entities/works/filter-works.md`. No credentials were requested or used. Exact-title seed strings were the three titles in the graph table.

Additional access facts:

- Bund DOI resolved to Ulm item `a17c1058-95ba-4fcc-bee0-cc2a1569eebb`. Its `citation_pdf_url` gave the successful dissertation download. Earlier generic Bund searches were unhelpful.
- The Kozyakin 2019 PDF endpoint returned HTTP 200 **HTML**, not a PDF. The author publication page confirmed the article and supplied DOI links but no full-text copy for this item. Publisher abstract/reference metadata were accessible. Error response retained.
- Hertneck 2021: OpenAlex has no OA location; S2 returned an empty OA URL. DOI redirected to Elsevier linkinghub `S0005109821003903`, an HTML response, not a usable full text. The arXiv site's own search for `Efficient stability analysis approaches for nonlinear weakly-hard` returned no results. This does not rule out an author or institutional copy under another title.
- Coordinator-supplied update, also recorded in `antecedents.md`: Robert Vrabel 2026, DOI `10.1093/imamci/dnag016`, received a DOI metadata/primary-abstract check; its publisher PDF returned 403. This remains an abstract-level gap, not a full-text exclusion. It adds no primary-text read to this worker's counts.
- S2 exact Gaukler queries returned 429 on initial and spaced retries; the arXiv-DOI variant returned not found. A failed lookup does not mean the paper lacks citations.
- The frequency paper's S2 OA URL was a repository **landing page**, not the PDF. I followed that page's actual `citation_pdf_url` and downloaded the manuscript successfully.
- PDF text output was sometimes truncated. Omitted theorem/proof ranges were reread separately; unread surrounding material is not represented as a full read. No inaccessible PDF is counted among the eight core reads.
- The coordinator-written audit contract governed the report format and file ownership. No HTML/PDF report, browser session, or extra task was created.

## Remaining coverage gaps, strongest unread first

1. **Hertneck–Linsenmayer–Allgöwer 2021**, DOI `10.1016/j.automatica.2021.109868`. This is a confirmed direct Gaukler citation and a control-method successor, not a speculative title. Obtain the primary text and inspect the actual converse/necessity scope, any linear specialization, and the exact role of the weakly-hard window. Access attempts above did not obtain it. The companion *Linear weakly hard real-time control systems: Time- and event-triggered stabilization*, cited by [5, reference 15], is also unread here.
2. **Kozyakin–Kuznetsov–Chebotarev 2019, Part III**, DOI `10.1134/S0005117919060018`. Its actual reference 52 cites the exact sliding-block paper. The publisher identifies it as the final part of a survey on constructive stability/stabilizability; full text could expose an overlooked constructive positive-matrix subclass or antecedent. Only abstract/reference metadata were accessible. The other S2 Kozyakin edge, *Topological Entropy of Switched Systems*, remains unidentified beyond title/year/paper ID.
3. **Recent/directly related performance and block results.** The 2024 weakly-hard `l2` paper, DOI `10.1016/j.ejcon.2024.101056`, Robert Vrabel's July 2026 spectral-interaction/block-stabilization paper, DOI `10.1093/imamci/dnag016`, and the September 12, 2026 chronological-refinement paper were not theorem-audited. The coordinator checked Vrabel's DOI metadata and primary abstract, but the publisher PDF returned 403; Vrabel therefore remains an abstract-level gap. The chronological paper is an abstract-level scope mismatch, not a full-text exclusion. The 2020 control-schedule post-processing paper is a confirmed Gaukler forward edge, but also unread.
4. **Broader descendants.** Algebraic lifting `1807.03965`, high-growth trajectories `2009.12948`, the positive-matrix nonlinear-eigenproblem hierarchy DOI `10.3934/mcrf.2020011`, and other Philippe incoming papers were title-screened, not comprehensively read. The existing representation/completeness results make algorithm-only overlap unsurprising; that is not evidence about every theorem in these texts.
5. **Citation coverage.** OpenAlex and S2 disagree and have duplicate/version/date issues. S2 full-date retrieval was rate-limited. No complete Google Scholar, Scopus, Web of Science, or MathSciNet citation census was performed. The tiny Kozyakin incoming counts in particular should not be interpreted as exhaustive scholarly attention.

Gurvits/rank-one, weighted dwell time, rare-defect/ergodic/random products, Protasov interval lengths, the 2025 impulsive Berger-Wang result, and the Chitour slow-fast work are deliberately outside this report's ownership. Their absence here is not an audit gap to be filled by duplicating the other workers.

## Primary retrieval addresses

These are exact sources used, not substitute secondary summaries.

```text
[1] https://arxiv.org/pdf/1107.0124
[2] https://arxiv.org/pdf/1307.4209v2
[3] https://doi.org/10.18725/oparu-4463
    https://oparu.uni-ulm.de/items/a17c1058-95ba-4fcc-bee0-cc2a1569eebb
    https://oparu.uni-ulm.de/bitstreams/b67503ef-9341-49fd-bc34-ca9e81e59966/download
[4] https://arxiv.org/pdf/1912.09871v2
[5] https://arxiv.org/pdf/2101.11312
[6] https://arxiv.org/pdf/1503.06984v3
[7] https://arxiv.org/pdf/2605.16959v1
    https://arxiv.org/abs/2605.16959
[8] https://arxiv.org/pdf/2607.00637v2
    https://arxiv.org/abs/2607.00637
[9] https://arxiv.org/pdf/1403.5050v4
[10] https://arxiv.org/pdf/2307.13543
[11] https://hdl.handle.net/10044/1/93796
     https://spiral.imperial.ac.uk/bitstreams/fd552cd5-1c4a-4db7-9c32-708e8afdcf70/download
Other primary pages:
https://kozyakin.github.io/en/publications
https://link.springer.com/article/10.1134/S0005117919060018
https://link.springer.com/content/pdf/10.1134/S0005117919060018.pdf
https://doi.org/10.1016/j.automatica.2021.109868
https://arxiv.org/abs/2609.13981
https://raw.githubusercontent.com/ourresearch/openalex-docs/main/api-entities/works/filter-works.md
```

## Handoff

No general novelty killer was found in the read statements. The decisive positive finding is that fixed-window spectral/periodic representation, interval loss counting, scalar abstractions, and arbitrarily accurate symbolic certificates are established prior art. The decisive negative comparison is precise: those results do not evaluate the uniformly optimized, gap-dependent cluster coefficient as the window changes. Any novelty claim should attach only to that narrow combination until the unread direct control successors and the other workers' lanes have been reconciled.

The strongest inaccessible control-method item is Hertneck–Linsenmayer–Allgöwer 2021, DOI `10.1016/j.automatica.2021.109868`. Final receipts: 1 full paper, 9 substantial theorem/proof-section reads, 1 anchor spot-check; 303 incoming metadata rows reduce to 171 identifier-linked groups or 163 groups with exact-title merging. The report and count script were read back and the counts rerun. No new literature branch was opened after the coordinator requested completion.
