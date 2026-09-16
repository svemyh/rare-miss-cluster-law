# Exact examples and what they establish

September 15, 2026. All matrices below are normalized by the success-mode spectral radius. Scaling both modes by any fixed lambda in (0,1) makes the nominal success mode strictly stable and preserves the normalized conclusions. These are positive switched systems, not automatically a particular networked-feedback realization.

## Historical planar example

The baseline is preserved in ../protocol-proof-draft.md. It gives M_2=313/200 with one success between the worst pair of misses. verify.py checks the exact pair identity for gaps 0 through 31, but the all-gap result follows from the planar eigenvalue calculation, not those finite tests.

## Three states require a different gap

Let R be the three-cycle with R_{i,i+1 mod 3}=1 and P=ones*ones^T/3. Let

\[
B=(R+P)/2,\quad v=(3,1,1)^T,\quad w=(1,3,1)^T,\quad E=vw^T/5.
\]

All entries of B and E are strictly positive, B is doubly stochastic, r=ones and ell=ones/3. We have a=5/3 and

\[
b_0=7/3,\quad b_1=23/9,\quad b_2=3,\quad a^2=25/9.
\]

The first three values follow by exact rational multiplication. The all-gap proof uses B^g=P+2^{-g}(R^g-P), giving

\[
b_g=25/9+2^{-g}c_{g\bmod3},\qquad
(c_0,c_1,c_2)=(-4/9,-4/9,8/9).
\]

The g congruent to 0 or 1 branches are below 25/9. The remaining branch decreases to 25/9 from above and first reaches 3 at g=2. Hence S_2=M_2=3 exactly. The planar candidate list, with maximum 25/9, is false in this positive three-state example.

Repeating a period-k word with two misses separated by two successes is admissible. Its exact normalized period spectral radii for k=8,16,32 are respectively 297/100, 76797/25600, and 5033164797/1677721600. They approach 3; their k-th roots give achieved per-step rates. These finite values do not establish exact finite-k CJSR optimality.

THEOREM.md Section 7 strengthens this example to an explicit family with any prescribed optimal finite pair gap t>=1 in dimension t+1. That conclusion is an algebraic corollary, not an empirical extrapolation from three states.

## An allowed third miss need not increase the leading worst growth

Take dimension five, B=P=ones*ones^T/5. Set every entry of E to 1/200 except E_{0,1}=E_{1,2}=12/5. These matrices are strictly positive. With e_j=ell^T E^j r, exact arithmetic gives

\[
e_1=983/1000<1,\quad
e_2=119573/100000>1,\quad
e_3=3284649/40000000<e_2.
\]

Because B^g=P for every g>=1, every cluster gap either has zero successes, joining adjacent E factors, or at least one success, which splits the scalar weight. Therefore

\[
S_1=e_1,\quad S_2=\max(e_2,e_1^2)=e_2,\quad
S_3=\max(e_3,e_1e_2,e_1^3)=e_1e_2=117540259/100000000.
\]

Thus M_2=M_3=e_2>S_3. The leading rare-loss correction is unchanged when the window budget rises from two to three. A two-adjacent-miss periodic construction attains the limiting coefficient.

For sufficiently large k, a period-k word with exactly three misses is strictly worse than the two-adjacent-miss construction: such a word has a success, so cyclically splitting at a success makes its period spectral radius a product of E-run weights belonging to the exact three-miss list above. With two adjacent misses and at least one success, the period spectral radius is exactly e_2. This is a comparison of these periodic classes, not a claim that every nonperiodic sequence using some third misses is strictly worse.

This example also refutes the naive leading coefficient 3/2 times log(e_2) obtained by multiplying pair gain-per-miss by the density bound 3/k. The sliding-window rule prevents that packing.

The exact finite-window formulas in THEOREM.md Section 8 sharpen this: for k>=4, the normalized rates are e_2^(1/k) for budget two and e_2^(1/(k-1)) for budget three. The additional allowed miss worsens finite-window stability despite leaving the leading asymptotic coefficient unchanged.

## A two-state reset example with an exact stability threshold

The independent reviewer supplied the simpler nonuniform-Perron reset example

\[
B=P=\begin{pmatrix}99/100&1/100\\99/100&1/100\end{pmatrix},\quad
E=\begin{pmatrix}1/10&1/10\\20&1/10\end{pmatrix}.
\]

Here r=ones, ell^T=(99/100,1/100), and

\[e_1=399/1000,\quad e_2=10349/5000,\quad e_3=120797/100000.\]

Take C=(9/10)B and D=(9/10)E. For budget three and k>=4, the exact rate is (9/10)(10349/5000)^(1/(k-1)). At k=7 the stability comparison is 5499882909/5000000000>1; at k=8 it is 49498946181/50000000000<1. Since this comparison decreases with k, eight is the first exponentially stable window in k>=4. Seven admits a growing periodic trajectory; eight guarantees exponential decay for every admissible sequence in this exact discrete model.

The maximizing pattern has two misses followed by k-3 successes, of period k-1. These assertions come from the all-word upper proof and matching periodic construction, not from a finite trajectory simulation.

## Verification contract

Run `python3 verify.py --output check-results.json` from this directory. The generated record includes rational matrices, certified finite-search enclosures, spectral-radius brackets for specified period products, rejected negative controls, and input hashes. Python's optimized mode does not disable checks; they raise explicit exceptions rather than relying on assert.

The checker validates finite arithmetic and finite instances of the proof's packing and norm bounds. It does not prove the general limit theorem, establish literature novelty, or validate a continuous-time physical system.
