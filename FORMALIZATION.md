# The main cluster law now has a Lean proof

The completed implementation is in `lean/`. The entry point is `MissedUpdates/Main.lean`, theorem `MissedUpdates.Matrices.rare_miss_cluster_law`. Reproduction instructions and a proof map are in `lean/README.md`.

For arbitrary strictly positive finite real matrices C,D and every fixed miss budget m, Lean proves

$$
\lim_{k\to\infty} k\log(\rho_{m,k}/\rho(C))=\log\max(1,S_1,\ldots,S_m).
$$

The formal rate uses the supremum over actual infinite sliding-window-admissible sequences and then the limit superior of matrix norm roots. The formal norm is the elementwise maximum norm. The normalizing quantity is the ordinary complex spectral radius. The S_j use genuine finite nonnegative integer gaps. Positivity supplies the Perron data and convergence inside the proof.

The final audit checked 175 exported theorem declarations at Lean trust level zero. Their dependency closures contain only the standard logical axioms propext, Classical.choice and Quot.sound. The code does not use proof placeholders, custom mathematical axioms, or an assumed upper bound in place of the theorem. Four invalid proof controls were rejected, including a shifted limit coefficient and an attempt to drop strict positivity. A separate symbolic consumer of the exported theorem passed.

Committed evidence: `evidence/lean/receipt.json`, `evidence/lean/axioms-trust-zero.txt`, and `evidence/lean/main-trust-zero.txt`. Replays write fresh outputs to `lean/build/`. The exact environment and byte-verified third-party proof provenance are recorded with the code.

This supersedes the earlier partial-formalization status for the main law. The old proof is in `history/lean-4.19/`; `THEOREM.md` and `verify.py` remain frozen. The packaged manuscript updates its proof-status disclosures but not its mathematics. The other manuscript applications and finite-search theorem have not all been formalized.

Mathematical novelty remains provisional, and human specialist review is still pending. A kernel-checked proof does not settle publication priority. No paper was submitted, published, or sent to anyone.
