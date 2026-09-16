# Main and quantitative implications verified

The current development checks 201 exported declarations at Lean trust level zero. The main theorem rare_miss_cluster_law is unchanged. The added Cutoff, Quantitative and QuantitativeError modules contain 26 declarations, including the genuine cutoff comparison, finite-window rate bounds, coefficient-error estimates and all_later_windows_accuracy.

The quantitative implications explicitly require RelativeTail, which asserts both entrywise inequalities for every power beyond q with error in [0,1), plus stated integer/scalar conditions. It does not contain the desired growth bound. Positivity also implies existence of such tails for any positive tolerance below one.

The automatic minorization-tail formula, integer-power certificate algebra and the O(log(k)/k) corollary are classically justified in QUANTITATIVE.md but not separately Lean-formalized. The rational Python front end is not an extracted Lean verifier. This boundary is stated in the manuscript.

The audit permits only propext, Classical.choice and Quot.sound. A separate symbolic main-theorem consumer passes, and five invalid controls are rejected. Pinned Lean 4.32.2, mathlib and all 20 vendored PF/MCMC source identities remain unchanged. Fresh audit output is in build/; committed evidence is in ../evidence/lean/.

The earlier 175-declaration package is preserved in Git history. The older 52-declaration Lean 4.19 proof is under ../history/lean-4.19/. Human semantic/novelty review is pending and no publication priority is claimed.
