# Independent adversarial review

September 15, 2026. Initial review covered PLAN.md revision 2 and all of the original THEOREM.md, Sections 1–7. The follow-up below covers the added Section 7 and the five-dimensional example in EXAMPLES.md. Scope is mathematical validity, not novelty. No theorem, plan, example, or checker edits.

## Verdict

No mathematical gap found in the claimed limit for arbitrary fixed dimension, strictly positive fixed modes, and fixed miss budget. The packing, prefix bound, uniform upper estimate, lower-bound quantifiers, and finite-search enclosure survive the checks below. This is an independent classical proof audit, not formal verification.

There is a concrete correction to any stronger interpretation: a budget-three coefficient can be attained strictly with two misses, and the limiting coefficient does not give the exact finite-k rate. An exact rational example below proves both. THEOREM.md already avoids these stronger claims.

## Proof checks

1. **Section 3 packing.** Within one cluster consecutive miss positions differ by at most q. Thus m+1 misses would span at most mq+1 positions, contradicting the protocol when mq+1<=k. A cluster with j<=m misses spans at most 1+(j-1)q<=mq positions. If its first miss belongs to bin t of length L=k-mq, its last miss is at most
   \[
   (t+1)L-1+(mq-1)=tL+k-2<tL+k.
   \]
   All clusters assigned to that bin therefore fit in the same genuine k-window and collectively have at most m misses. This uses window admissibility, not average miss density. There is no missing factor proportional to the number of clusters.

2. **Prefixes and boundaries.** Form clusters within the actual length-N prefix, truncating the final cluster if necessary. Truncation can only reduce span and miss count, and cannot spoil any retained intercluster gap. Bin origins are fixed at position zero, so at most ceil(N/L) bins occur. A bin's containing k-window may extend past N, but it exists in the admissible infinite extension. Likewise the final incomplete k-block has at most m misses. Hence z<=m floor(N/k)+m. Zero-miss prefixes are covered by M_m>=1 and K>=1. No boundary constant grows with N.

3. **Uniformity and norm comparison.** For nonnegative W, its weighted induced norm is max_i (Wr)_i/r_i, while ell^TWr is the weighted average of these ratios with weights ell_i r_i. This proves the stated K bound. Every retained separator has at least q successes, so one common epsilon_q bounds all of them, independent of their lengths, the word, and N. Entrywise replacements preserve inequalities through nonnegative factors. The resulting scalar factors exactly into cluster weights; external success runs disappear. Joining bounds each occupied bin's product by M_m even when individual weights are below one. Fix k and q first, take the N-limsup, and only then send k to infinity. The resulting bound is uniform over words, but not asserted uniformly over varying matrices, m, or dimension.

4. **Unattained suprema and Section 4.** Joining requires only finite clusters and a limit of inserted gaps. If several gaps must diverge, replace them simultaneously by a common h and let h grow. For the lower bound, every fixed finite cluster gives its own inequality for the same liminf. Taking the supremum of those inequalities is valid; it does not require choosing a k-dependent optimizer. Period-k repetition is admissible because every cyclic k-window contains the same j<=m misses. Spectral-radius continuity at PK applies even though PK is rank one. Product orientation does not change the allowed set of finite gap tuples.

5. **Section 5 certificate.** Each candidate containing P is a limit of genuine finite-gap candidates with the same number of misses, proving T<=M_m. Replacing all gaps >=G bounds any genuine candidate by at most (1+epsilon)^(j-1) times a searched candidate. Nonnegativity makes simultaneous replacement valid, and the maximum with one handles j=1 and the no-miss option. Thus both endpoints and the stated logarithmic width are correct, including m=1. A floating eigendecomposition or a check of finitely many tail powers is not a certified tail bound. The section correctly makes certified Perron data and an all-g>=G enclosure prerequisites. P candidates are limiting witnesses unless P is an actual success power; T is not generally a finite-k lower witness.

6. **Other edge checks.** The d=1 case reduces to M_m=max(1,E^m), giving the scalar density law. In d=2 the negative, zero, and positive subdominant-eigenvalue cases all agree with Section 6, with B^0=I understood separately when mu=0. Strict positivity supplies positive Perron weights and convergence of success powers; the proof does not establish the same result for reducible or periodic nonnegative modes.

## Exact budget-three example

In THEOREM.md notation, rank-one successes means **B=P**, not E=P. If E=P literally, then P B^g P=P and every S_j=1, so e_1<1 and e_2>1 are impossible. For the intended rank-one-success example, take lambda=1 and

\[
r=\begin{pmatrix}1\\1\end{pmatrix},\qquad
\ell^T=\begin{pmatrix}99/100&1/100\end{pmatrix},\qquad
B=P=\begin{pmatrix}99/100&1/100\\99/100&1/100\end{pmatrix},
\]
\[
E=\begin{pmatrix}1/10&1/10\\20&1/10\end{pmatrix}.
\]

Both modes are strictly positive. Writing e_j=ell^T E^j r gives exactly

\[
e_1=399/1000=0.399,\qquad
e_2=10349/5000=2.0698,\qquad
e_3=120797/100000=1.20797.
\]

Every positive-length success gap is exactly P. Consequently

\[
S_1=e_1,\quad S_2=\max(e_2,e_1^2)=e_2,\quad
S_3=\max(e_3,e_1e_2,e_1^3)=e_3<e_2,
\]

and M_3=e_2 is attained by two consecutive misses. No three-miss gap configuration ties it. The budget means at most three, not exactly three; S_j need not increase with j. Section 5 certifies this example exactly with G=1, epsilon=0, and F_G={I,P}.

There is also an exact finite-k conclusion for this example:

\[
\boxed{\rho_{3,k}=e_2^{1/(k-1)}\quad\text{for every integer }k\ge4.}
\]

For the lower bound repeat the word 00 followed by k-3 successes, of period k-1. Each k-window is one full period plus one position, hence has at most three misses. Its period product is PE^2 and has spectral radius e_2.

For the upper bound, every admissible prefix has miss runs of length at most three. Its Perron scalar is the product of the corresponding e_j. Change isolated misses to successes and one endpoint of each three-miss run to a success. This preserves admissibility and increases that scalar, since e_1<1 and e_3<e_2. Only double-miss runs remain. Two such runs must start at least k-1 positions apart, otherwise their four misses fit in one k-window. Therefore there are at most N/(k-1)+1 pairs, and the norm is at most K e_2^(N/(k-1)+1). Taking N-th roots proves the upper bound.

Thus rho_{3,k}>M_3^(1/k), while k log rho_{3,k} tends to log M_3 as claimed. For k>=4 even the best period-k word has rate only e_2^(1/k): its cyclic miss runs give one of 1, e_1, e_2, e_1^2, e_3, e_1e_2, e_1^3. Period-k witnesses suffice asymptotically but need not maximize at finite k. This example does not establish anything about feedback realizability or the general finite-k optimizer.

## Verification record and remaining limits

Independent in-memory Python checks used exact Fraction arithmetic for the displayed e_j and S_j. Exhaustive binary-prefix checks covered k=2,...,8, m=1,...,min(3,k-1), every q>=1 with mq+1<=k, and N=2k+1. All 39,531 admissible word/parameter cases passed the cluster-size, span, bin-containment, bin-capacity, bin-count, and prefix miss-count assertions. Extension admissibility was checked by appending successes, including constraints on short suffixes. All cyclic k-windows of the period-k-1 example were also checked for k=4,...,30. These finite tests support the audit; the arguments above supply the arbitrary-parameter proofs.

The coordinator's concurrent checker was not inspected or modified. Its reproducibility and tail-certificate implementation remain separate gates. No literature or novelty claim was assessed. No correction to the stated general limit or Section 5 enclosure is required by this review.

## Follow-up: prescribed gaps and the five-dimensional example

No gap found in the added Section 7 corollary or the unused-third-miss example. The following calculations independently check the sign convention, normalization, all-gap optimization, and finite-k implications.

For Section 7, n=t+1>=2 and R shifts e_0 to e_{-1 mod n}. Both B and E are strictly positive; B is doubly stochastic with Perron data r=ones and ell=ones/n. The identities RP=PR=P and P^2=P give

\[
B^g=P+2^{-g}(R^g-P),\qquad g\ge0.
\]

Since ell^T v=2 and w^T r=2n, a=2 and

\[
b_g=\frac{w^T B^g v}{n},\qquad
w^T P v=4n,\qquad
w^T R^g v=3n+n^2\mathbf1_{g\equiv-1\pmod n}.
\]

Thus the stated formula and residue t=n-1 are correct, including g=0. Off that residue b_g<4. On it, g=t+hn with h>=0 and

\[
b_{t+hn}=4+t\,2^{-(t+hn)}.
\]

These values decrease strictly. Therefore S_2=M_2=4+t/2^t, uniquely attained at g=t, exceeding both a=2 and the separated-pair limit a^2=4. Given any fixed finite list of literal gap lengths, choose a positive t outside it. The resulting example defeats that list even if the infinite gap is also allowed. This does not rule out dimension-dependent bounds or adaptive candidate selection. It gives uniqueness for the limiting pair weight, not a finite-k optimizing-word theorem. Each t and its dimension stay fixed while k tends to infinity; the advantage t/2^t over the infinite-gap value shrinks as t grows.

The family also has an exact all-tail certificate for Section 5:

\[
\epsilon_G=(n-1)2^{-G},\qquad G\ge1.
\]

Indeed each entry of R^g is zero or one, so the largest relative entrywise error from P is exactly (n-1)2^{-g}. Taking C=lambda B and D=lambda E with 0<lambda<1 makes rho(C)=lambda<1 and leaves the normalized example unchanged. No correction to Section 7 is needed.

For the five-dimensional example, direct exact multiplication confirms

\[
e_1=\frac{983}{1000},\quad
e_2=\frac{119573}{100000},\quad
e_3=\frac{3284649}{40000000},\quad
e_1e_2=\frac{117540259}{100000000}.
\]

Because B=P, the exhaustive three-miss possibilities are e_3, e_1e_2, and e_1^3. Their maximum is e_1e_2, strictly below e_2. Thus M_2=M_3=e_2 and no exactly-three-miss cluster attains this maximum. The displayed period-k comparison is valid already for every k>=4, not merely for sufficiently large k. A cyclic word then has a success, allowing exact rank-one factorization at that position.

The finite-k proof in this review applies to this example too, since it only needs B=P, e_1<1<e_2, and e_3<e_2. In fact, for k>=4,

\[
\rho_{2,k}=e_2^{1/k},\qquad
\rho_{3,k}=e_2^{1/(k-1)}>\rho_{2,k}.
\]

For the budget-two upper bound, replace isolated misses by successes, increasing the Perron scalar. Remaining double-miss runs must start at least k positions apart: if their start distance were at most k-1, the last miss of the first pair and both misses of the second would fit in one k-window. Thus at most N/k+1 pairs remain. Period-k repetition of one adjacent pair attains the bound. The budget-three argument was proved above. Equal leading coefficients therefore coexist with strictly different finite-k rates. The rejected density-based coefficient also remains false.

Follow-up verification used independent in-memory Fraction arithmetic. All 215 direct matrix checks for t=1,...,10 and g=0,...,3(t+1)+1 matched the prescribed-gap identity, and all five-dimensional fractions and comparisons matched. These are diagnostics beside the all-gap algebra above. The coordinator reports a checker PASS with 408 finite-word bounds and three negative controls; that report is not an independent checker audit or a proof of the general theorem. Only review.md was changed.

## Final scoped audit: verify.py

Read all 321 lines of verify.py, including the added nonuniform-Perron reset check. Snapshot SHA-256: `a27bd934b0546e89c8a660beec11f6a19fed10e86670d06689b89b4841c7332e`. This supersedes the earlier not-inspected status. No correctness gap found in the requested bracket or tail calculations on the actual fixed-fixture domain. Section 7 remains valid as audited above. Section 8 also permits the stated weak inequalities, including e_2=1.

- `spectral_bracket` is rigorous for its strictly positive period products. Starting from a positive vector, every iterate stays positive, so the component ratios enclose the Perron root at each step. Intersecting those intervals remains valid. Dividing the next vector by its largest entry is a positive rescaling and does not affect the next ratio enclosure. All arithmetic is rational; convergence in 12 iterations is not assumed. The outputs enclose period spectral radii, not per-step rates. The appropriate k-th roots give the latter.

- The tail epsilon=(n-1) theta^G is certified by the cycle fixture's algebra, not by checking powers only through 16. Its constructor gives P^2=P, RP=PR=P, and permutation R, hence B^g=P+theta^g(R^g-P) for every g. For the used theta in {0,1/2}, the maximum relative error at g>=1 is exactly (n-1) theta^g and decreases with g. Thus the finite-search endpoints and finite-word epsilon_q are valid, including theta=0. The g=0 calculation at theta=0 uses Python's 0^0=1, which correctly produces B^0=I here.

- These are fixture-specific helpers, not generic input certificates. `finite_cluster_bounds` does not validate its supplied B,P,theta against the cycle construction. `perron_weight` and the finite-word factor K=n assume uniform Perron weights. All current callers satisfy those assumptions. The nonuniform reset example correctly computes weights with its explicit ell and does not pass through these uniform-weight helpers. No change is required for the current run.

Independent targeted execution confirmed all three planar period brackets against the exact quadratic-root inequalities, and all three three-state brackets against the exact rank-one eigenvalue, at k=8,16,32. It also checked the tail construction identities and 36 selected tail instances, plus exact bracket collapse to 10349/5000 for the nonuniform reset product PE^2. No output artifact was generated and no checker code was changed. The full coordinator rerun and its reported 408 word bounds remain separate from these targeted checks; neither substitutes for the mathematical proof.
