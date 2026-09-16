# Targeted novelty audit

September 15, 2026. Inputs: PLAN.md revision 1, ../protocol-scout.md, and the coordinator's subsequent rank-one subfamily statement. Eight primary papers read in full through PDF text extraction, including proofs and references. Only this file was written. This is a bounded literature audit, not a priority determination or an independent review of THEOREM.md.

## Verdict

**General positive-matrix limit: novelty unresolved.** None of the eight read papers states the claimed fixed-miss-budget, large-window formula or supplies its uniform cluster reduction as an immediately applicable theorem. The closest results supply the constraint model, periodic approximation, scalar upper bounds, and exact rank-one algebra. The potentially distinguishable contribution is the uniform Perron approximation combined with sharp sliding-window packing, not those ingredients separately.

**Exact finite-k rank-one subfamily: an elementary corollary/application of established weighted-automaton and maximum-cycle machinery.** Its pair-packing argument is worth presenting as a worked example or sharpness test, not as a separate novelty claim.

These are implication assessments of the statements actually read. Failure to find the exact formula does not establish novelty.

## Comparison target

Fix strictly positive C,D, lambda=rho(C), B=C/lambda, E=D/lambda, Br=r, ell^T B=ell^T, ell^T r=1. Under at most m misses in **every** length-k window, compare

~~~text
lim_{k -> infinity} k log(rho_{m,k}/lambda) = log M_m,
M_m = max(1, sup_{1 <= j <= m; g_i in Z_{>=0}}
                  ell^T E B^{g_1} E ... B^{g_{j-1}} E r).
~~~

Matrices, dimension, and m remain fixed. Infinite-gap closure uses B^g -> P=r ell^T. An average-frequency constraint or exact finite-k attainment is a different question.

## Primary-source findings

### 1. Gaukler, Rheinfels, Ulbrich, Roppenecker

*Convergence Rate Abstractions for Weakly-Hard Real-Time Control*, submitted December 20, 2019; v2 June 24, 2020. [Primary report, 34 pages](https://arxiv.org/pdf/1912.09871v2).

Theorems 6.2–6.3 construct sound scalar dynamics from perturbation bounds or Lyapunov-induced gains. Theorem 6.4 transfers exponential bounds to the original system. Theorem 7.2, equations 100–106, gives rate q_success^((K-b)/K) q_miss^(b/K), where b counts misses. Their m counts required successes. This rate is exact for the scalar comparison system, but only sufficient for the original dynamics. Pages 24–26 explicitly disprove a general converse using different stability at equal miss ratios.

**Nonimplication:** nominal-rate exactness does not identify cluster gains or make the miss multiplier sharp. This paper does not give the target equality. Its closest cited antecedents are [2] and [3]. The nonlinear proof sketch in Theorem 3.4 is unnecessary for this comparison.

### 2. Huang, Li, Zhu

*Formal Verification of Weakly-Hard Systems*, HSCC, April 2019, pages 197–207. [Primary accepted manuscript, 11 pages](https://par.nsf.gov/servlets/purl/10109979), DOI 10.1145/3302504.3311811.

Definition 3.1 uses our at-most-m-misses convention. Proposition 4.2 and Remark 3 distinguish sliding-window legality from arbitrary concatenation of legal K-blocks. Theorems 4.3–4.4 give sufficient local-safety and inductiveness conditions. Theorems 5.3, 5.5 and 5.8 establish soundness of radius/LP bounds and the safe initial set. Section 6.1 discusses fixed m and growing K for the computed safety radius, not the spectral exponent.

**Nonimplication:** no exact rare-miss growth law. Its block relaxation is precisely a step that cannot simply be assumed sharp for our coefficient.

### 3. van Horssen, Baghban Behrouzian, Goswami, Antunes, Basten, Heemels

*Performance analysis and controller improvement for linear systems with (m,k)-firm data losses*, ECC, June 29–July 1, 2016, pages 2571–2577. [Primary author-hosted paper](https://heemels.tue.nl/assets/content/papers/HorBeh_ECC16a.pdf), DOI 10.1109/ECC.2016.7810677.

Section IV models the protocol as a constrained switched linear system. Theorem 1 gives graph-indexed quadratic sufficient conditions. Theorem 2, equations 15–19, gives a conservative analytic quadratic-cost bound and exponential stability when the product of per-mode quadratic gains over a window is below one. Their m counts successes; rho_i bound quadratic storage, not vector norm growth. Theorem 4 gives monotone controller improvement.

**Nonimplication:** neither the automaton nor the scalar bound evaluates the proposed coefficient. Important prior art for application framing; weakly-hard automaton modeling itself is not a contribution here.

### 4. Kozyakin

*Matrix products with constraints on the sliding block relative frequencies of different factors*, submitted March 20, 2014; v4 May 28, 2014; Linear Algebra and its Applications 457, 244–260, 2014. [Primary paper, 15 pages](https://arxiv.org/pdf/1403.5050v4).

Theorem 1 identifies the constraints with a finite-type symbolic system. Theorem 2 equates its CJSR with the limsup of spectral radii over periodically extendable words. Our dropout interval is [0,m/k], success interval [1-m/k,1]; for 0<m<k the required auxiliary interior frequencies exist. Remark 4 also covers arbitrary allowed-block sets.

**Implication:** periodic approximation for each fixed k. **Nonimplication:** no optimal period bound, period-k attainment, or interchange with k -> infinity. Periodic words can contain arbitrarily many windows and misses. Reducing all of them to bounded clusters requires another argument. This is the closest exact match to our constraint; its long-product limit is not the proposed growing-window limit.

### 5. Philippe, Essick, Dullerud, Jungers

*Stability of discrete-time switching systems with constrained switching sequences*, 2015 preprint; v3 April 21, 2016; Automatica 72, 242–250, 2016. [Primary paper, 10 pages](https://arxiv.org/pdf/1503.06984v3).

Proposition 2.2 characterizes CJSR via multinorms. Theorem 3.2 and Corollary 3.3 give arbitrary relative accuracy through product lifts; Corollary 3.6 gives memory-lift bounds. Theorem 3.8 supplies sufficient exactness when tight quadratic constraints form a simple cycle. Section 3.5 describes the Kronecker lift to unconstrained JSR.

**Nonimplication:** these fixed-automaton results do not evaluate the asymptotic coefficient. Numerical extraction needs relative error o(1/k), followed by a separate limit argument. The cycle exactness condition is not guaranteed for these protocols. An edge lift retains the rank of its mode matrix; it does not make general positive modes rank one.

### 6. Morris

*Rank one matrices do not contribute to the failure of the finiteness property*, September 21, 2011 preprint. [Primary paper, 6 pages](https://arxiv.org/pdf/1109.4648v1).

Theorem 1.1 proves finite attainment when the higher-rank subset has smaller JSR, with each rank-one element used at most once. Corollary 1.3 covers finite families with at most one higher-rank member. Corollary 1.4 gives, for rank-one A, either JSR({A,B})=rho(B) or JSR=rho(AB^n)^(1/(n+1)) for some n>=0.

**Nonimplication:** applying the corollary to {P,E} ignores the miss constraint. An automaton lift generally introduces multiple higher-rank edge matrices, losing the one-higher-rank hypothesis. For general positive B,E, only long success blocks approach rank one. This paper does not transfer exact reset algebra uniformly to those blocks in a growing-window limit.

### 7. Ahmadi, Parrilo

*Joint Spectral Radius of Rank One Matrices and the Maximum Cycle Mean Problem*, CDC, December 10–13, 2012, pages 731–733. [Primary author-hosted paper](https://www.mit.edu/~parrilo/pubs/files/AhmadiParrilo-Joint%20spectral%20radius%20of%20rank%20one%20matrices%20and%20the%20maximum%20cycle%20mean%20problem.pdf).

Lemma 2.1 and Theorem 2.2 reduce rank-one product spectral radii to cycle gains. Corollary 2.1 bounds an attaining product's length by the family size. Remark 2.2 explicitly extends the method to constrained switching. The revision appendix acknowledges an earlier independent maximum-cycle characterization by Gurvits and Samorodnitsky, CDC 2005, Appendix A; that antecedent was not independently read here.

**Implication:** exact scalar/reset cycle optimization is established. **Nonimplication:** the infinite family of limiting clusters, slot durations, and approximation error still require handling. Use Theorem 2.2's cycle-gain expression: Section II.A's displayed conversion appears to divide by cycle length twice after defining lambda* as a mean. The intended expression is exp(maximum cycle mean), as in Example 3.1.

### 8. Chitour, Guglielmi, Protasov, Sigalotti

*Switching systems with dwell time: computation of the maximal Lyapunov exponent*, December 21, 2019 preprint. [Primary paper, 28 pages](https://arxiv.org/pdf/1912.10214v1).

Theorem 2.7 reduces weighted JSR to a scalar normalization equation for ordinary JSR. Theorem 2.12 supplies extremal/invariant norms; Section 4 develops weighted graph systems. Theorem 5.1 represents guaranteed mode-dependent dwell times as a mixed graph system. Theorem 3.15 concerns error as discretization time tends to zero, not dwell time tending to infinity.

**Implication:** duration-aware graph machinery. **Nonimplication:** no fixed-budget rare-miss coefficient. Minimum separation between every pair of misses matches m=1, not general m, which allows bursts. A minimum success gap between bursts is an extra constraint unless derived from sliding-window legality. Switching frequency counts transitions rather than missed slots.

## Exact rank-one subfamily from the review

This is our mathematical implication assessment, not a claim that a source prints the particular formula.

Let B=P=r ell^T, e_j=ell^T E^j r. Under budget 3 and k>=4, every internal consecutive-miss run has length at most three. Every nonempty success run equals P, and P E^j P=e_j P. Thus complete run products are scalar gain products, apart from bounded endpoints. Their protocol is a finite weighted automaton. Collapsing runs gives scalar edges with slot durations, covered by [7]'s cycle optimization and [8]'s duration accounting after this explicit reduction.

If e_1<1<e_2 and e_3<e_2, replacing single runs by successes and triple runs by pairs increases scalar gain and preserves admissibility, since misses are only removed. Pair starts must differ by at least k-1, or a length-k window contains four misses. Their density is at most 1/(k-1), up to endpoints. Repeating two misses followed by k-3 successes is legal and attains the bound:

~~~text
rho_{3,k}/rho(C) = e_2^(1/(k-1)).
~~~

This is a short cycle-selection/packing corollary, not a direct application of Morris to an unconstrained pair. It also cautions against assuming optimal period k. Here M_3=e_2: competing reset gains include e_1, e_1^2, e_1^3, e_1 e_2, and e_3, all smaller. The exact result therefore matches the proposed asymptotic coefficient log e_2.

## Gap between the read literature and the general theorem

The additional work beyond the read results is uniformity over all admissible words and internal gaps when replacing long B-runs by P; sharp packing of variable-size clusters with boundary terms; and matching periodic lower bounds, including split clusters through infinite-gap closure. These are not reported gaps in the coordinator's completed proof. Pointwise Perron convergence, total miss density, and ordinary JSR continuity alone do not establish that k-scaled limit on changing automata. The identity PWP=(ell^T W r)P and periodic approximation themselves are classical.

## Search limits

Queries covered exact Gaukler/Huang titles and antecedents, rank-one JSR/resets, sliding-block frequencies, sparse switching, rare defects in positive matrix products, and large/minimum dwell-time exponents. Exa was unavailable. web.run search/open repeatedly returned empty or shallow results; primary author/repository pages and streamed curl-to-pdftotext retrieval supplied full reads. Truncated extraction outputs were followed by bounded page reads. No PDFs or extraction files were written locally.

Stopped at eight full papers. Not independently read: Gurvits–Samorodnitsky, Dai's underlying constrained Berger–Wang proof, Bund's thesis, or the wider ergodic-optimization, random rare-defect, singular-perturbation and impulsive-control literature. The 2026 compression/lifting papers in protocol-scout.md were not reread. No comprehensive forward-citation search was completed. A general rare-defect theorem elsewhere remains a real possibility.

Recommended positioning: a fixed-budget rare-miss asymptotic for strictly positive modes, with publication novelty unconfirmed. Avoid priority claims and do not promote the exact reset example as independent novelty.
