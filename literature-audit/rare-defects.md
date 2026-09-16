# Rare defects, occupation constraints, and Lyapunov perturbations

Audit date: September 15, 2026. Scope follows `AUDIT-CONTRACT.md`. The comparison target is Sections 1–4 of `../THEOREM.md`; both that document and `../novelty.md` were read completely and left unchanged.

## Implication verdict

No direct equivalent or explicit corollary giving the general fixed-m, growing-k formula was established from the eight primary works examined. This is a bounded implication assessment, not evidence sufficient to establish priority. Three works were read in full; five received theorem/proof-section reads with the limits recorded below. The two versions of Monmarché–Schreiber–Strickler count as one work. Mainieri is a full read but ultimately an excluded random-cycle branch, not an additional positive match.

The strongest comparisons are these.

- Peres covers the zero-probability boundary for strictly positive matrices. His result and proof give the ordinary Bernoulli expansion `L(p) = p log(ell^T E r) + O(p^2)`. This is a real implication, derived below, but it is not the adversarial window coefficient. [R1]
- Altschuler–Parrilo gives exact rank-one i.i.d., stationary-ergodic, and Markov formulas. Its circulation argument also gives a deterministic maximum-cycle reduction after imposing allowed transitions. This supplies an exact finite-k result when all slot matrices are rank one, after the explicit graph reduction below. It does not supply the uniform replacement of general positive products by rank-one clusters. [R2]
- Monmarché–Schreiber–Strickler gives first-order Perron-overlap coefficients for slow periodic and Markov switching. The algebra is close, but its slow limit stretches the retained environmental dwell intervals. Our defect clusters have fixed duration, and arbitrary positive discrete-time matrices need not embed into real continuous-time flows. [R3]
- Relative maximization and boundary-ground-state results organize average occupation and limiting measures. Their statements do not evaluate the growing-memory hard constraint at order `1/k`. [R4–R6]

Confidence is high in these specified nonimplications. Confidence in overall literature coverage is limited, especially for deterministic sparse impulses, renewal models with deterministic timing constraints, and Zhao's asymptotically additive constrained optimization paper. The strongest unread sources are ranked at the end.

## Exact comparison target

Keep the dimension, strictly positive matrices C,D, and positive integer m fixed. Set `lambda = rho(C)`, `B = C/lambda`, `E = D/lambda`, `Br = r`, `ell^T B = ell^T`, and `ell^T r = 1`. A word is admissible only if every consecutive k-slot window contains at most m defects. First take the supremum over admissible words and the long-product growth limsup for each k. Then let k grow. The target is

```text
lim_{k -> infinity} k log(rho_{m,k}/lambda) = log M_m,
M_m = max(1,S_1,...,S_m),
S_j = sup_{g_1,...,g_{j-1} in Z_{>=0}}
      ell^T E B^{g_1} E ... B^{g_{j-1}} E r.
```

The distinction is not merely probabilistic versus deterministic terminology. An i.i.d. law with any positive defect probability permits forbidden bursts. An occupation constraint fixes an integral or long-run count, not every window. A small transition rate does not make the occupation of a state small. A lower dwell bound forbids short gaps that our m>1 model permits. None can replace the stated constraint without a proof.

## Primary-source ledger

All retrievals and reads below took place on September 15, 2026. Page numbers are the paper's printed pages or PDF page numbers when the paper uses them. Cached files are in the owned `rare-sources/` directory. No abstract-only source is counted as a substantive read.

| ID | Exact work and primary identifier | Actual read depth | Relevant statement and classification |
|---|---|---|---|
| R1 | Yuval Peres, *Domains of analytic continuation for the top Lyapunov exponent*, Annales de l'I.H.P. Probabilités et Statistiques 28(1), 131–148, 1992. [NUMDAM primary PDF](https://www.numdam.org/item/AIHPB_1992__28_1_131_0.pdf), identifier `AIHPB_1992__28_1_131_0`. | Complete text-extraction pass, but many scanned equations are absent in the OCR. Counted conservatively as a theorem/proof-section read: Theorem 1 and its proof, pp.132–136, with visual verification of pp.132 and 136; boundary remark p.135; Theorem 2, p.137, textual inspection and references pp.147–148. | Analyticity in probabilities, including the closed simplex when all matrices are positive. Close stochastic boundary; does not imply hard-window maximum. |
| R2 | Jason M. Altschuler and Pablo A. Parrilo, *Lyapunov Exponent of Rank One Matrices: Ergodic Formula and Inapproximability of the Optimal Distribution*. [arXiv:1905.07531v1](https://arxiv.org/pdf/1905.07531), May 18, 2019, 19 pages. | pp.1–7 and 11–19, including proofs of Theorems 2.1, 5.1, 5.3 and Lemmas 5.1–5.2. Hardness proof pp.8–10 not read. | Theorem 2.1, pp.4–5; Theorem 5.1, p.12; Markov equation 5.11, p.14; Theorem 5.3 and circulation proofs, pp.16–17. Exact rank-one stochastic result and a restricted deterministic-control corollary. |
| R3 | Pierre Monmarché, Sebastian J. Schreiber, Édouard Strickler, *Impacts of Tempo and Mode of Environmental Fluctuations on Population Growth: Slow- and Fast-Limit Approximations of Lyapunov Exponents for Periodic and Random Environments*. Bulletin of Mathematical Biology 87:81, published May 20, 2025. DOI [10.1007/s11538-025-01443-z](https://doi.org/10.1007/s11538-025-01443-z). [Author-hosted published PDF](https://schreiber.faculty.ucdavis.edu/wp-content/uploads/sites/568/2025/07/BMB-2025.pdf); [arXiv:2408.11179v1](https://arxiv.org/pdf/2408.11179), August 20, 2024. | Preprint pp.1–8, 19–22, references 28–30. Published pp.1, 5–9, 21–26, covering setup, slow theorems and both slow proofs. Application sections not fully read. | Published Theorem 1 parts 1 and 3, pp.7–8, equations 8 and 10; Section 6.1, pp.22–23; Proposition 4 and Lemma 4, pp.24–26. Close Perron-overlap antecedent; different singular limit. |
| R4 | Eduardo Garibaldi and Artur O. Lopes, *Functions for relative maximization*, Dynamical Systems 22(4), 511–528, 2007. [arXiv:math/0608432v1](https://arxiv.org/pdf/math/0608432), archive stamp August 16, 2006, 22 pages. Journal metadata also confirmed by R5's reference GL07. | Full 22-page read, including proofs and references. The downloaded manuscript has a June 30, 2018 date in its body despite its v1 archive stamp; the source version is recorded rather than treating that body date as a publication date. | Theorem 10, pp.12–13; Proposition 14, p.16; Theorem 17, pp.19–20. Close average-occupation framework, not growing-window law. |
| R5 | Shoya Motonaga and Mao Shinoda, *Constrained ergodic optimization for generic continuous functions*. [arXiv:2211.11932v4](https://arxiv.org/pdf/2211.11932), March 22, 2024, 15 pages. | pp.1–9, including the complete proof of Theorem 1; references and Appendix B, pp.14–15. Theorem 2's statement read, its genericity proof not read. | Theorems 1–2, pp.3–4; proof of Theorem 1, pp.7–9. Exact periodic-density theorem at rational interior rotation vectors, but no boundary rate or uniformity in growing memory. |
| R6 | Tamara Kucherenko and Christian Wolf, *Ground states and zero-temperature measures at the boundary of rotation sets*. [arXiv:1604.06512v1](https://arxiv.org/pdf/1604.06512), April 21, 2016, 26 pages. Published ETDS 39(1), 201–224, 2019, as recorded in R5 reference KW19. | pp.1–11, including Theorem 1 and its complete proof; Theorems A–C and 2 read. Later constructed examples and proofs not read. | Theorem A, p.3; Theorem 1, pp.9–11; Theorem 2, p.11. Boundary-measure background, not a defect-action expansion. |
| R7 | Hermann Schulz-Baldes, *Low density expansion for Lyapunov exponents*. [arXiv:math-ph/0607027v1](https://arxiv.org/pdf/math-ph/0607027), July 12, 2006, 8 pages. | Full paper, including proof, density-of-states section, references. | Unnumbered theorem in Section 3, p.4; proof pp.5–7. Genuine low-density expansion, excluded as an equivalent because the stochastic model and nominal dynamics differ. |
| R8 | Ronnie Mainieri, *Zeta function for the Lyapunov exponent of a product of random matrices*, Physical Review Letters 68, 1965, 1992. [arXiv:chao-dyn/9301001v1](https://arxiv.org/pdf/chao-dyn/9301001), January 11, 1993, 9 pages. Journal attribution verified in R2 reference 34. | Full 9-page manuscript, including references. No numbered main theorem. | Equations 2–11, pp.3–4. Random cycle-expansion branch; excluded as a theorem supplying the target. |

## R1. Positive random matrices at p=0

Peres's Theorem 1 allows a finite family of row-allowable nonnegative matrices with a strictly contracting member. Its analytic domain is

```text
Omega(F) = {z : sum_j z_j = 1, sum_j tau(A_j) |z_j| < 1},
```

where tau is the Hilbert-metric contraction coefficient. The p.135 remark explicitly includes the closed probability simplex if every matrix is strictly positive. Thus the boundary law concentrated entirely on B is covered; rejecting this paper merely because p=0 lies on a simplex boundary would be wrong. The proof uses locally uniform convergence of a projective transfer operator. [R1, Theorem 1 and pp.135–136]

An explicit consequence, not a quotation of a separately numbered theorem, is the Bernoulli first-order formula. Use the weighted norm `||x||_ell = sum_i ell_i |x_i|`, and the projective increments

```text
f_B(x) = log(||Bx||_ell / ||x||_ell) = 0  for x>0,
f_E(x) = log(ell^T E x / ell^T x).
```

Peres's proof, Step 3 on p.136, writes the exponent as the probability-weighted stationary expectation of these increments. Therefore, with E chosen independently with probability p,

```text
L(p) = p nu_p(f_E).
```

At p=0 the projective B dynamics contracts to r, so `nu_0(f_E) = log(ell^T E r)`. The operator analyticity gives

```text
L(p) = p log S_1 + O(p^2).
```

This consequence concerns `lim_{N->infinity} (1/N) E log ||W_N||`. It does not concern the worst admissible W_N. For any fixed p>0, runs of m+1 defects have positive probability, and independent disjoint trials make such runs occur almost surely. For k>=m+1 the process therefore violates the hard budget almost surely. Substituting p=m/k computes `m log S_1`, not `log max(1,S_1,...,S_m)`. Optimizing an i.i.d. probability in an interval does not introduce adversarial cluster correlations.

The Markov extension holds a finite transition structure fixed. It does not provide a uniform estimate over the growing k-window automata. The scanned equation 12 on p.136 appears to print `log E ||...||`, unlike equation 1's `E log ||...||`; no annealed-exponent conclusion is taken from that display. The Bernoulli derivation above uses Theorem 1 and the visually checked Step 3, avoiding that transcription/printing issue.

## R2. Exact stochastic formulas and deterministic control

For rank-one matrices `A_i = u_i v_i^T`, Theorem 2.1 gives

```text
L_iid(p) = sum_{i,j} p_i p_j log |v_j^T u_i|.
```

Theorem 5.1 replaces the product probabilities by the stationary adjacent-pair law under integrability assumptions. Equation 5.11 gives the Markov case

```text
L(Q) = sum_{i,j} pi_i Q_ij log |v_j^T u_i|.
```

Theorem 5.3 minimizes this expression over Markov laws, using a normalized-circulation linear program and a minimum cycle. These are exact identities, not estimates. Strict positivity of a finite family makes the relevant logarithms finite. The source does not require positivity in general. [R2, Theorems 2.1, 5.1, 5.3; Lemmas 5.1–5.2]

### Explicit constrained deterministic reduction

This is a corollary of the paper's product identity and circulation argument, with the reduction made explicit. Assume every slot mode is rank one. For fixed k, build the finite history graph H_k that retains the last `max(k-1,1)` symbols and allows an appended symbol only when the new k-window obeys the budget. Write a(s) for the last symbol at state s. Give an allowed edge s→t the weight

```text
w_st = log |v_{a(t)}^T u_{a(s)}|.
```

The exact rank-one product identity, R2 equation 2.2, expresses the log norm along a graph path as the sum of these edge weights plus endpoint terms. There are finitely many positive modes, so the endpoints are uniformly bounded independently of path length. If F_st is a normalized stationary edge flow, the optimization is

```text
maximize  sum_{s,t} F_st w_st
subject to F_st >= 0, F_st = 0 on forbidden edges,
           sum_t F_st = sum_t F_ts,  sum_{s,t} F_st = 1.
```

The cycle-decomposition proof of Lemma 5.2 applies to this graph with forbidden edges removed, and applies to maximization as well as minimization. Hence the value is the maximum cycle mean. A deterministic periodic path around an optimal cycle attains it. Conversely, decomposing any long path into cycles and a bounded residual path proves the same uniform upper growth bound. Thus Markov optimization on the expanded graph and deterministic constrained growth agree in this all-rank-one setting. One may restrict to a recurrent component; irreducibility on every unused graph state is unnecessary. This is a fixed-k exact reduction, not a growing-k asymptotic theorem.

An ordinary two-state Markov law on the original mode alphabet does not encode a general k-window budget. The history expansion is essential. For general positive B,E, the endpoint-plus-adjacent-edge identity fails because neither factor need be rank one. Replacing long B powers by P is an additional argument, and its error must remain negligible after maximizing over words and multiplying by k. The theorem does not provide that step.

For an exact stochastic boundary calculation, if `B=P` and E is also rank one, put `a=ell^T E r` and `b=rho(E)`. The i.i.d. formula reduces directly to

```text
L(p) = p(1-p) log a + p^2 log b.
```

It recovers R1's derivative and displays why pair probabilities, not merely the existence of a favorable pair, govern the random problem.

Two attribution cautions matter. R2's Remark 5.1 says “minimum” for the JSR graph, but its introduction and reference 2 identify maximum-cycle mean; the worst-growth calculation above uses maximum throughout. R2 reference 33 correctly identifies *Rank-one characterization of joint spectral radius of finite matrix family* as Jun Liu and Mingqing Xiao, LAA 438(8), 3258–3277, 2013. That work, arXiv:1109.1356, belongs to the main agent and was not read or counted here.

## R3. Slow periodic and Markov switching

The published Theorem 1 considers continuous-time switching between irreducible Metzler generators A_i. With fixed occupation proportions alpha_i, it gives

```text
Lambda_periodic(omega)
  = sum_i alpha_i lambda(A_i)
    + omega sum_i log(y_{i+1}^T x_i) + o(omega),

Lambda_Markov(omega)
  = sum_i alpha_i lambda(A_i)
    + omega sum_{i,j} alpha_i q_ij log(y_j^T x_i) + o(omega).
```

Indices in the periodic sum are cyclic. The periodic proof projects the normalized long semigroups onto `x_i y_i^T`. Proposition 4 expresses the Markov correction as an integrated relaxation after a switch, and Lemma 4 evaluates that integral as the logarithmic Perron overlap. [R3, published pp.7–8 and 22–26]

This is the strongest overlap-action antecedent read in this branch. It establishes that a first-order slow-switching correction can be the logarithm of a product of Perron pairings. It should be cited when explaining the method, not dismissed because the application is population biology.

The exact nonimplication has three separate parts.

1. Each retained dwell duration is `alpha_i/omega`. With a fixed positive alpha_i it diverges as omega→0. A fixed-duration defect requires `alpha_defect(omega) = O(omega)`. That changes the regime. Section 2.1 permits nonnegative alpha_i, but the proof projects each retained positive-duration block using a decaying error in `alpha_i/omega`; it gives no uniform remainder under this simultaneous vanishing-proportion substitution.
2. The theorem evaluates a specified periodic schedule or a specified Markov switching model, not the supremum over all sequences satisfying a sliding-window budget. It supplies neither a uniform cluster decomposition nor sharp packing of clusters of varying size.
3. The discrete matrices in the target need not be real flow maps. In the existing planar instance supplied by the coordinator during this audit, `B=[[1/4,3/4],[3/4,1/4]]` has determinant `-1/2`. For any real A, `det(exp A)=exp(trace A)>0`. Therefore that B is not exp(A), even without requiring A to be Metzler. This uses an existing example, not a new numerical experiment.

There is a precise pointwise relation. For any fixed defect cluster K, nominal recovery gives `B^n K -> PK`, whose nonzero eigenvalue is `ell^T K r`. The period-k witness in THEOREM.md therefore has first-order log gain `log(ell^T K r)`. R3 performs closely related projection algebra for a fixed collection of long flow blocks. Taking the supremum over internal gaps, over j<=m, and over all legal concatenations still requires the target's uniform upper-bound argument. Calling that a direct substitution into R3 would omit the main issue.

The May 20, 2025 published version retains the two slow formulas. Its pp.8–9 remark is more cautious than the preprint about deducing monotonicity from a first-order expansion. No monotonicity claim is used here.

## R4–R6. Occupation optimization and proximity to a Dirac measure

Garibaldi–Lopes defines the relative optimum `beta(h)=sup{integral A dmu : integral phi dmu=h}`. Theorem 10 approximates an ergodic measure's action by periodic measures at the same rational rotation vector under local constancy, a Walters potential, and joint recurrence. Proposition 14 gives a periodic supremum for a scalar rational interior rotation number. Theorem 17 relates the derivative of the dual alpha function to an optimal trajectory's average constraint. It does not differentiate the maximum at a zero-occupation Dirac measure or give an excursion coefficient capped by m. [R4]

Motonaga–Shinoda's Theorem 1 gives density of periodic measures in an entire rational interior rotation class for a rational locally constant constraint on an irreducible SFT. Theorem 2 gives a generic zero-entropy conclusion there. For each positive rational h tending to zero one may apply the first theorem on a fixed full shift, but neither the period nor the approximation error is controlled uniformly as h→0. Generic-potential conclusions also do not assert anything for every prescribed positive-matrix cocycle. [R5]

Kucherenko–Wolf's Theorem 1 locates ground-state rotation vectors on the appropriate supporting face and characterizes their entropy there. Theorem 2 specializes to exposed boundary points. These statements concern weak limits of equilibrium states as inverse temperature grows, not a first-order expansion in hard-window width. Even identification of the all-success Dirac measure as a limit would leave the k-scaled action undetermined. [R6]

Two possible reductions deserve explicit treatment rather than silent rejection. First, positivity allows the matrix growth to be represented using a continuous projective-direction observable; setting up that additive representation would not change the constraint issue. Second, a hard window can itself be encoded as an integral constraint. Set

```text
psi_{m,k}(x) = 1{the first k symbols contain more than m defects}.
```

For a shift-invariant measure, `integral psi_{m,k} dmu=0` is equivalent to being supported on the admissible subshift, since every shifted forbidden event then has measure zero. Thus the general language of constrained optimization is broad enough to express the problem. But psi changes with k and zero is a boundary value. This observation does not produce the required uniform first-order calculation.

By contrast, taking `phi=1{current symbol is a defect}` and `integral phi dmu=m/k` is only an average constraint. It allows arbitrarily large finite bursts separated by compensating long success runs. It does not retain the cluster cardinality cutoff j<=m. The obstruction is structural, not a lack of suitable terminology.

## R7–R8. Low-density and cluster-expansion branches

Schulz-Baldes studies i.i.d. Anderson transfer matrices with impurity law `(1-rho) delta_0 + rho p_tilde`. For interior-band energy `E_energy=-2 cos(theta)`, its Section 3 theorem gives `gamma(rho,E_energy)=rho gamma_hat(E_energy)+O(rho^2)`, with different effective coefficients for rational and suitably Diophantine phases. The proof uses phase averages and oscillatory sums. These are signed SL(2,R) transfer matrices with an elliptic nominal rotation, not a strictly positive nominal matrix contracting to P. Both the dynamics and the sampling law differ. [R7]

This is a genuine rare-strong-defect perturbation theorem. It does not bound the maximum over all impurity configurations, and its probability-weighted effective exponent is not a finite cluster supremum. Its references to random polymers and correlated low-density disorder are leads, not theorems independently verified here.

Mainieri develops a prime-cycle zeta expansion with weights containing `Prob(G)` and derivatives selecting an expected logarithmic growth rate. Its equations 7–11 are not a maximum over a hard admissible language. The paper also calls the largest eigenvalue modulus a norm in its derivation; that replacement and its broad convergence claim are not independently validated in this audit. There is no usable theorem here controlling a k-dependent constrained language uniformly through the limit. [R8]

A zero-temperature or pressure limit might turn suitable weighted sums into maxima in another argument. That would introduce an additional limit and require uniform control with k. Neither R7 nor R8 states such a transfer for this target. Renewal rewards per event likewise need conversion to rewards per slot and a deterministic packing constraint; an expected interarrival law cannot supply those by itself.

## Actual citation paths and search limitations

The full exact-query and access log is in `rare-sources/query-log.md`. Search result pages were often empty or returned generic host homepages and irrelevant matches. Those responses were not counted as literature coverage. Primary PDFs, not search snippets, carry the comparisons above.

The following edges were verified in the actual read bibliographies or remarks.

- R2 reference 27 cites Gurvits–Samorodnitsky 2005. This verifies the forward edge supplied by the coordinator. R2 also cites Ahmadi–Parrilo 2012 as reference 2, Mainieri as reference 34, and Liu–Xiao as reference 33. Only Mainieri was followed by this worker; the others belong to the main agent's scope.
- R5 reference GL07 and Remark 1.1 explicitly cite R4, especially its Theorem 10. R5 also cites R6 as KW19 and Zhao 2019 as Zha19. R4 and R6 were read; Zhao's metadata was verified but the full text was not obtained.
- R3 cites the deterministic/probabilistic gap paper by Chitour, Mazanti, Monmarché, Sigalotti, arXiv:2112.07005, and high-frequency expansion arXiv:2309.16464. Neither was counted as read. R3's Markov proof uses the renewal/skeleton-chain identity attributed there to Davis 1993, Theorem 34.31, p.123; the book itself was not read.
- R1 directly cites Ruelle 1979 and Hennion's 1990 preprint. Ruelle's guessed author bibliography URL failed. These are actual antecedents but not independently read theorem sources here.
- R7's Jitomirskaya–Schulz-Baldes–Stolz random-polymer citation and R8's longer Mainieri cycle-expansion preprint are retained as unread branches.

This is targeted backward and forward citation chasing, not a forward-citation census. In particular, there was no complete citing-document export from a scholarly index.

## Remaining coverage gaps, strongest first

1. Yun Zhao, *Constrained ergodic optimization for asymptotically additive potentials*, JMAA 474(1), 612–639, June 2019, DOI [10.1016/j.jmaa.2019.01.065](https://doi.org/10.1016/j.jmaa.2019.01.065). Actual citation in R5 and exact Crossref metadata verified. The DOI landing retrieval produced only redirect markup; ScienceDirect returned 403 and the Crossref-advertised Elsevier text endpoint returned 400. This is the strongest unread technical source because its potential class is closer to matrix growth than the additive papers. No theorem or nonimplication is claimed from its abstract.
2. Deterministic sparse-impulse stability and exponent theorems with unrestricted impulse times. The exact-title search *Stability of linear time-varying impulsive systems with fixed and unrestricted impulse times* returned bibliographic leads, but no primary theorem was read. This branch remains open; generic dwell-time bounds are not enough to close it.
3. Deterministic/probabilistic Lyapunov optimization comparison, arXiv:2112.07005, an actual R3 reference. It may sharpen which Markov families can approximate adversarial optimization, but its theorem was not read here. Even a fixed-system variational equality would still need a k-uniform first-order argument.
4. Impulsive renewal systems, including the searched *Volterra Integral Approach to Impulsive Renewal Systems: Application to Networked Control*. Discovery-level lead only, no primary theorem read. R3's skeleton-chain calculation was read, but it is not a substitute for a systematic renewal-literature audit.
5. Zhao's separate search lead *Conditional Ergodic Averages* and boundary rotation-pressure asymptotics beyond R6. No identification of an arXiv preprint with the 2019 JMAA paper is assumed.
6. Ruelle 1979, Hennion's differentiability work, and later probability-perturbation derivatives beyond R1. Their absence does not undermine R1's verified Bernoulli consequence, but it limits the review of general correlated rare-defect laws.

The claim surviving this audit is narrow: none of the verified statements above supplies the general hard-window finite-cluster formula without the additional uniform separation and packing argument. Perron overlaps, rank-one edge rewards, and constrained-optimization formulations themselves are established antecedents.

## Artifact verification

Only this report and files under `rare-sources/` were authored or downloaded by this worker. No theorem edits, numerical examples, solver runs, author contact, cloud jobs, recurring tasks, or execution loops were performed. The determinant observation above was supplied by the coordinator from an existing example.

Baseline SHA-256 before this audit's file writes:

```text
THEOREM.md  4acd0ef06ece65c0471d70b727b7dc152f73b469f7aedae5d79a4ca285a10e34
novelty.md  b09bc0c934cf2e18bb306d8c300ff3e2b06e8490cff5eed2b545531b9ea708fb
```

The completion audit rechecked both hashes and found them unchanged. Final read accounting is three full works, R4/R7/R8, and five theorem/proof-section works, R1/R2/R3/R5/R6. The query log, access failures, and nine PDF copies for those eight works are present. Zhao 2019 remains a full-text access gap pending the coordinator's separate OA-location check.
