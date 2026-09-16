# A finite-cluster law for rare missed updates

Status: classical theorem and proof with internal mathematical review, September 15, 2026. Exact finite checks are a separate supporting artifact. No novelty, external peer-review, or proof-assistant claim is made.

## 1. Fixed objects and conclusion

Fix a dimension d>=1, a positive integer m, and entrywise strictly positive real d-by-d matrices C,D. Both matrices and m remain fixed as k tends to infinity. Let Sigma_{m,k} be infinite binary sequences containing at most m zeroes in every k consecutive positions. Define the constrained rate

\[
\rho_{m,k}=\limsup_{N\to\infty}\sup_{\sigma\in\Sigma_{m,k}}
\|A_{\sigma_{N-1}}\cdots A_{\sigma_0}\|^{1/N},
\qquad A_1=C,\quad A_0=D.
\]

Let lambda=rho(C), B=C/lambda, E=D/lambda. Choose Perron vectors r,ell>0 with Br=r, ell^T B=ell^T, ell^T r=1, and P=r ell^T. For j>=1 define the finite-cluster suprema

\[
S_j=\sup_{g_1,\ldots,g_{j-1}\in\mathbb N_0}
\ell^T E B^{g_1}E\cdots B^{g_{j-1}}E r,
\qquad S_1=\ell^TEr,
\]

and M_m=max(1,S_1,...,S_m). All S_j are positive and finite: the powers of B are bounded and j is fixed. Suprema need not be attained at finite gaps.

**Claim.**

\[
\boxed{\lim_{k\to\infty}k\log(\rho_{m,k}/\lambda)=\log M_m.}
\]

This is a limit theorem, not an exact finite-k maximizing-word theorem. The modes are arbitrary positive matrices, not automatically realizable by a specified feedback/packet-loss architecture.

## 2. Two elementary lemmas

**Perron separation.** Since B is strictly positive, B^g tends to P entrywise. For any integer q>=1 define

\[
\epsilon_q=\sup_{g\ge q}\max_{a,b}
\frac{|(B^g-P)_{ab}|}{P_{ab}}.
\]

It is finite and tends to zero. Entrywise, B^g <= (1+epsilon_q)P for every g>=q. In the norm induced by max_i |x_i|/r_i, every nonnegative W satisfies

\[
\|W\|_r\le K\ell^TWr,
\qquad K=(\min_i\ell_i r_i)^{-1}.
\]

**Joining cluster weights.** If finite clusters K_1,...,K_s contain a total j misses, then

\[\prod_{i=1}^s\ell^TK_i r\le S_j.\]

Insert success runs of a common length h between the clusters. The result is a j-miss cluster for every finite h. Let h tend to infinity and use P=r ell^T. This proves the inequality without assuming that any supremum is attained. In particular any collection of clusters with at most m total misses has product of weights at most M_m.

## 3. Cluster packing for the upper bound

Choose q=q(k) tending to infinity with q/k tending to zero. For example q=floor(sqrt(k)). Work at sufficiently large k that m*q+1<=k and L=k-m*q>0. Group consecutive misses whenever the intervening number of successes is less than q.

Every cluster has at most m misses. If m+1 successive misses belonged to one cluster, their span including endpoints would be at most m(q-1)+(m+1)=m*q+1<=k, contradicting the protocol. Thus a cluster's span is at most (m-1)q+1<=m*q, and different clusters are separated by at least q successes.

Assign each cluster to the integer bin of length L containing its first miss: bin t is [tL,(t+1)L-1]. All misses of clusters assigned to this bin lie in the k-window [tL,tL+k-1]. Indeed, the last possible miss is at most (t+1)L-1+(m*q-1)<tL+k. Therefore the assigned clusters collectively contain at most m misses. By the joining lemma, their scalar-weight product is at most M_m. This also holds for a partial final bin.

For a length-N prefix, let z be its number of misses. Since it extends to an admissible infinite sequence, z<=m*floor(N/k)+m. Its nonempty cluster bins number at most ceil(N/L). Replace intercluster success runs by (1+epsilon_q)P. All factors are nonnegative, so scalar multiplication preserves the inequality. Outer success runs vanish in ell^T W r. The product splits into cluster weights. There are at most z intercluster gaps. Hence

\[
\|W\|_r\le K(1+\epsilon_q)^z M_m^{\lceil N/L\rceil}
\]

for every normalized admissible product, including zero-miss products. Taking the supremum, N-th roots, and limit superior gives

\[
\log(\rho_{m,k}/\lambda)
\le\frac{\log M_m}{k-mq}+\frac{m}{k}\log(1+\epsilon_q).
\]

Multiplication by k and the assumptions on q prove the desired upper limit. This packing argument does not replace the sliding-window rule by an average loss-rate constraint.

## 4. Periodic witnesses for the lower bound

The all-success sequence gives rho_{m,k}/lambda>=1. Fix any finite cluster K with j<=m misses and length a. For k>a repeat a length-k word whose product is B^{k-a}K. Every cyclic length-k window has exactly j misses, so the infinite repetition is admissible.

Repeating this word and taking longer prefixes yields

\[
\rho_{m,k}/\lambda\ge\rho(B^{k-a}K)^{1/k}.
\]

As k tends to infinity, B^{k-a}K tends to PK. Its nonzero eigenvalue is ell^T K r>0. Spectral-radius continuity gives

\[
\liminf_{k\to\infty} k\log(\rho_{m,k}/\lambda)\ge\log(\ell^TKr).
\]

This holds for every fixed finite cluster. Taking the supremum over its gaps, then the finite maximum over j<=m, and including the all-success word proves the lower limit log M_m. No interchange of a varying maximizing cluster and the k-limit is needed.

## 5. A certified finite search for the limiting coefficient

Fix G>=1 and a certified epsilon>=0 satisfying B^g <= (1+epsilon)P for every g>=G. Form the finite set

\[\mathcal F_G=\{I,B,\ldots,B^{G-1},P\}.\]

For each j<=m compute the maximum T_j of ell^T E F_1 E ... F_{j-1}E r over all F_i in this set, and let T=max(1,T_1,...,T_m). Then

\[
\boxed{T\le M_m\le(1+\epsilon)^{m-1}T.}
\]

For the lower inequality, every occurrence of P is a limit of success powers; thus every finite-search value lies in the closure of genuine cluster values. For the upper inequality replace each gap g>=G by its entrywise bound. There are at most j-1 such factors, and multiplication by nonnegative factors preserves the bound.

Consequently the log-coefficient interval has width at most (m-1)log(1+epsilon). The number of cases is sum_{j=1}^m (G+1)^{j-1}; no claim of scalability in growing m or dimension is made. With rational B,E,P and a rational tail enclosure, all endpoint calculations can be exact. For general inputs, certified Perron data and a certified tail bound are additional tasks, not assumed outputs of a floating eigensolver.

Combining the upper endpoint with Section 3 also gives a computable finite-k upper bound whenever its separate epsilon_q is certified. A matching finite-k lower rate comes from explicit periodic words, not from treating P as a realizable finite gap.

## 6. Recovery of the historical planar formula

For d=2, B^g=P+mu^g(I-P), with real |mu|<1. Write a=ell^T E r, b_g=ell^T E B^g E r. Then b_g=a^2+beta*mu^g, so S_2=max(a^2,b_0,b_1). Since max(1,a^2)>=a, M_2=max(1,a^2,b_0,b_1), exactly the historical formula.

This finite three-gap reduction is special to the planar eigenvalue structure. The general theorem retains a gap supremum and a certified truncation rule. Higher-dimensional examples must not be checked against the planar formula.

## 7. There is no dimension-independent finite list of optimal pair gaps

Fix any desired gap t>=1. Put n=t+1, let R be the cyclic permutation matrix with R_{i,i+1 mod n}=1, and P=ones*ones^T/n. Define

\[
B=\tfrac12R+\tfrac12P,\quad v=\mathbf1+n e_0,\quad
w=\mathbf1+n e_1,\quad E=vw^T/(2n).
\]

These are strictly positive matrices. Take r=ones and ell=ones/n. Then a=ell^T E r=2 and B^g=P+2^{-g}(R^g-P). Since R^g e_0=e_{-g mod n}, direct multiplication gives

\[
b_g=\ell^TEB^gEr=4+2^{-g}\bigl(n\mathbf1_{g\equiv t\pmod n}-1\bigr).
\]

Every gap outside the residue class t has b_g<4. Inside that class the values are greater than 4 and strictly decrease with g. Thus g=t uniquely maximizes b_g over all finite nonnegative gaps, and its value exceeds the infinite-gap value a^2=4. For the two-miss limit the unique maximizing cluster gap is therefore t.

Consequently no fixed finite list of success-gap lengths suffices for all dimensions, even with only two misses and a rank-one dropout matrix. This does not preclude dimension-dependent bounds or adaptive certified truncation. Scaling both B and E by a common lambda in (0,1) yields a strictly stable nominal success mode without changing the normalized conclusion.

## 8. Exact finite-window rate for a rank-one success mode

Suppose B=P=r ell^T is strictly positive with ell^T r=1, and put e_j=ell^T E^j r. Assume e_1<=1, e_2>=1 and e_3<=e_2. For budget m=3 and every integer k>=4,

\[\boxed{\rho_{3,k}=\lambda e_2^{1/(k-1)}.}\]

To prove the lower bound, repeat two misses followed by k-3 successes. Its period is k-1; a k-window consists of one period plus one position, hence contains at most three misses. Its normalized period product is PE^2, of spectral radius e_2.

For the upper bound, every admissible word has miss runs of length at most three. Since every positive-length success run is P, the scalar ell^T W r is the product of the e_j corresponding to its miss runs, including boundary runs. Replace isolated misses by successes and one endpoint of each triple by a success. The scalar cannot decrease, because e_1<=1 and e_3<=e_2; admissibility is preserved because misses are only removed. The remaining runs are pairs. Their starting positions must be at least k-1 apart; otherwise four misses would fit in one k-window. Thus there are at most N/(k-1)+1 pairs, and

\[\|W\|_r\le K e_2^{N/(k-1)+1}.\]

Taking rates proves the exact upper bound. If e_2>1, this rate is strictly greater than lambda*M_3^{1/k}, even though the limiting coefficient is M_3=e_2. Thus the period-k lower witnesses in Section 4 need not be optimal at finite k.

In this subfamily, for 0<lambda<1, uniform exponential stability is equivalent to the exact scalar inequality lambda^{k-1} e_2<1. Equality is not exponential stability. This conclusion concerns the prescribed discrete switched model only.

For budget two in the same subfamily, rho_{2,k}=lambda e_2^{1/k} for k>=4. Delete isolated misses; all remaining miss runs are pairs, whose starts must be at least k apart. Otherwise the last miss of one pair and both misses of the next lie in one k-window. This gives the upper bound, and a pair repeated every k slots attains it. Thus when e_2>1, increasing the allowed budget from two to three strictly worsens the finite-k rate even though M_2=M_3=e_2.

## 9. Limits of the result

The theorem requires strict positivity, fixed modes, fixed dimension, and fixed m. It does not cover arbitrary signed matrices, increasing m/k ratios, stochastic loss probabilities, measurement noise, changing controllers, or nonlinear dynamics. It concerns asymptotic growth under a discrete protocol, not continuous intersample safety.

The argument is elementary once the cluster packing lemma is identified. Whether the statement is an existing theorem or immediate corollary remains a separate literature question. The historical draft is preserved as the m=2 planar case; this document does not retroactively attribute the new general argument to the earlier work.
