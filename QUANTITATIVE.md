# Quantitative finite-window bounds

Status: the finite-cutoff, two-sided finite-window, coefficient-error and all-later-windows accuracy implications are kernel-checked in the 201-declaration development. The explicit automatic minorization-tail construction and the O(log(k)/k) corollary have classical proofs here but are not separately Lean-formalized. Publication novelty and human review remain unresolved.

## Data and finite cutoff

Fix the main theorem's positive normalized matrices B,E and positive Perron frame r,l, with Br=r, lB=l, lr=1 and P=rl. Fix m>=1 and q>=1. Suppose a certified number 0<=e<1 satisfies, entrywise,

$$
(1-e)P\le B^g\le(1+e)P\qquad(g\ge q).
$$

Define R=(1+e)/(1-e), and define the genuine finite maximum

$$
A_m(q)=\max\left(1,\ \max_{1\le j\le m}\ \max_{g_1,\ldots,g_{j-1}\in\{0,\ldots,q\}}
 l E B^{g_1}E\cdots B^{g_{j-1}}E r\right).
$$

This search contains only realizable finite gaps. It has 1+sum_{j=1}^m(q+1)^(j-1) candidates before duplicate values are removed. Denote the existing limiting coefficient by M=M_m and write H=log M and a_k=k log(rho_{m,k}/lambda).

## Cutoff lemma

$$
1\le A_m(q)\le M\le R^{m-1} A_m(q).
$$

Proof. If g>=q, the two tail inequalities give B^g<=(1+e)P<=R B^q. If g<=q, nonnegativity and R>=1 give B^g<=R B^g. Clamp each internal gap to min(g,q), multiply the entrywise inequalities through nonnegative factors, and take the Perron gain. A j-miss word has j-1 internal gaps, so its gain is at most R^(j-1) A_m(q)<=R^(m-1) A_m(q). The empty word contributes 1. Every finite-cutoff candidate is also an admissible candidate in the definition of M, proving the reverse comparison. No infinite-gap supremum is assumed attained.

## Two-sided finite-window theorem

For every integer k>=m(q+1), let L=k-mq>0. Then

$$
\max\{0,\log A_m(q)+\log(1-e)\}
\ \le\ a_k\ \le\
\frac{k}{k-mq}\bigl(\log A_m(q)+(m-1)\log R\bigr)+m\log(1+e).
$$

Proof of the lower bound. A finite maximum is attained by a word W with at most m misses and length a<=m+(m-1)q. If the maximum is the empty-word value, choose W=I and a=0. The condition k>=m(q+1) gives k-a>=q. Repeat W followed by k-a successes. Every k-window is one full period, so the sequence is admissible. Its period matrix Q=B^(k-a)W satisfies Qr>=(1-e)PWr=(1-e)A_m(q)r. Nonnegative multiplication gives Q^N r>=((1-e)A_m(q))^N r. The norm/gain comparison and the definition of the constrained rate give a_k>=log((1-e)A_m(q)). The all-success sequence also gives a_k>=0.

Proof of the upper bound. The existing uniform cluster-packing theorem gives a_k<=k log M/(k-mq)+m log(1+e), since mq+1<=k. Substitute the cutoff lemma. This bound is over every admissible sequence, not just the constructed periodic word.

## Error relative to the limiting coefficient

The same argument yields the sharper M-based bounds

$$
-\bigl((m-1)\log R-\log(1-e)\bigr)
\le a_k-\log M
\le\frac{mq}{k-mq}\log M+m\log(1+e).
$$

Thus if 0<=e<=1/2, k>=max(m(q+1),2mq), and a verified Hbar>=log M is available,

$$
-(3m-1)e\le a_k-\log M\le\frac{2mq\,\overline H}{k}+me.
$$

Here log(1+e)<=e and -log(1-e)<=2e. One rationally computable choice is Hbar=m(c-1) whenever c>=1 and Er<=cr, because M<=c^m and log c<=c-1. If the finite cutoff has been evaluated, the alternative Hbar=A_m(q)-1+(m-1)(R-1) follows from the cutoff lemma and can be much smaller.

For a requested accuracy delta>0, choose q with e<=min(1/2,delta/(6m)), and then

$$
k_0=\max\left\{m(q+1),\ 2mq,\ 1,\ \left\lceil\frac{4mq\,\overline H}{\delta}\right\rceil\right\}.
$$

For every k>=k_0 the absolute error is at most delta. In particular, the lower error is at most delta/2 and the upper error is at most 2delta/3. These are conservative sufficient thresholds, not exact smallest windows.

## An explicit relative-tail certificate

This construction uses only positive normalized matrix/frame data. Put pi_i=l_i r_i, pi_min=min_i pi_i, eta=min_{i,j} B_ij/P_ij, alpha=eta/2 and theta=1-alpha. Then 0<eta<=1, 0<alpha<=1/2 and 0<theta<1. Set Q=(B-alpha P)/theta. It is nonnegative, Qr=r, lQ=l, QP=PQ=P, and

$$
B^g=P+\theta^g(Q^g-P).
$$

For every i,j,g, nonnegativity and Q^g r=r imply 0<=(Q^g)_ij/P_ij<=1/pi_j. Consequently

$$
\left|\frac{(B^g)_{ij}}{P_{ij}}-1\right|\le\frac{\theta^g}{\pi_{\min}},
\qquad e_q=\frac{\theta^q}{\pi_{\min}}.
$$

The identity follows by induction from the absorbing-projector equations; the entry bound follows from a single term in the nonnegative row sum. This is a global certificate for all g>=q, not a finite sampling of powers. When B=P, the exact certificate e_q=0 is available for every q>=1.

For rational normalized data and a rational Perron frame, this certificate, a cone bound c=max(1,max_i(Er)_i/r_i), and the accuracy threshold above can all be checked with rational arithmetic. General real or algebraic inputs need certified input enclosures or exact arithmetic; ordinary floating eigensolvers are not certificates.

With e_q=C theta^q, choose q=O(log k) so e_q<=1/k. The error bounds imply a_k=log M+O(log k/k), with constants depending on the fixed matrices and m. This is a quantitative consequence to verify, not a uniform assertion in growing m or varying matrices.

## Rational stability and instability tests

For rational lambda,A=A_m(q),e, put U=A R^(m-1) and L=k-mq. No transcendental evaluation is needed for the sufficient stability test

$$
\lambda^{kL} U^k(1+e)^{mL}<1\quad\Longrightarrow\quad\rho_{m,k}<1.
$$

Likewise lambda^k max(1,(1-e)A)>=1 proves rho_{m,k}>=1 and excludes uniform exponential stability. The maximum includes the all-success sequence. Failure of either sufficient test is inconclusive. The tests do not assert that the period-k witness is optimal, or that the chosen k is the minimum stable window.

## Verification boundary

The original asymptotic theorem remains unchanged. The new checked statements are in Cutoff.lean, Quantitative.lean and QuantitativeError.lean, including original_finite_window_rate_bounds and all_later_windows_accuracy. RelativeTail explicitly requires a bound for every later power. The rational tool checks the finite identities underlying the classical automatic tail formula, enumerates the genuine cutoff and verifies the scalar threshold conditions; this front end is not itself a Lean extraction. The geometric tail construction, integer-power certificate algebra and big-O consequence are classically justified rather than separately formalized. No successful check implies human specialist approval or publication novelty.
