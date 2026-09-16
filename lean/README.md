# A Lean proof of the rare-miss cluster law

The main theorem is fully proved in `MissedUpdates/Main.lean`, declaration `MissedUpdates.Matrices.rare_miss_cluster_law`. This project supersedes the partial 52-theorem implementation in `../history/lean-4.19/`, whose proof sources remain unchanged.

## What is proved

Let C and D be strictly positive real square matrices on any nonempty finite index type. Write λ for the ordinary complex spectral radius of C, and normalize B=C/λ and E=D/λ. For every fixed miss budget m, the proof establishes

$$
\lim_{k\to\infty} k\log(\rho_{m,k}/\rho(C))=\log\max(1,S_1,\ldots,S_m).
$$

Here ρ is defined literally as the limit superior, over prefix length N, of the supremum of matrix-product norm roots over infinite sequences with at most m misses in every k-window. The matrix norm used in the formal definition is the elementwise maximum norm. The proof constructs positive Perron vectors and proves that λ is the spectral radius over the complex spectrum. `S_j` ranges over every finite list of j−1 nonnegative integer gaps, with the matrix factors ordered exactly as in the manuscript.

The theorem covers every fixed natural m, including the all-success case m=0. It does not assert a joint limit with m growing with k.

## The three requested connections

| Obligation | Checked implementation |
|---|---|
| Actual canonical word to full matrix bound | `Decode.prefixWord_canonical_decode`, then `Assembly.canonical_prefix_gain_bound` and `NormComparison.canonical_prefix_norm_bound` |
| Positivity to Perron convergence | `PerronConvergence.positive_perron_convergence`, including the diagonal similarity and Dobrushin argument |
| Exact constrained rate and both limiting inequalities | `Growth`, `Periodic`, `Limit`, `NormGrowth`, and `Normalization`; assembled in `Main.rare_miss_cluster_law` |

Names in the table use the source module as a reading aid. The full namespaces are printed in `AxiomAudit.lean`. `GapSuprema.clusterSup_eq_paperM` proves that the auxiliary all-word supremum equals the paper's finite maximum. `PerronRadius.normalized_frame_spectralRadius` identifies the normalization using the complex spectrum. No growth bound or convergence conclusion is assumed by the main theorem.

The upper proof keeps each separation threshold fixed, lets k grow, and then makes the Perron-tail error arbitrarily small. The lower proof repeats a fixed witness with k successes between copies, giving period k+length(w). This avoids spectral-radius continuity while preserving the limit in the original statement.

## Reproduce the audit

From this directory:

```sh
python3 check.py
```

The checker uses `.toolchain/bin` if present; otherwise put the pinned Lean toolchain on PATH or set `LEAN_BIN_DIR`. For a fresh checkout, obtain the versions in `lean-toolchain` and `lake-manifest.json`, then run `lake update` and `lake exe cache get`. Do not replace the pins with newer revisions.

The checker rebuilds the library, checks dependency revisions and the hashes of all 20 vendored proof files, audits all 175 exported theorem declarations with `lean --trust=0`, checks a separate symbolic consumer, and requires four intentionally invalid controls to fail for their expected reasons.

Replays write evidence to `build/receipt.json`, `build/axioms-trust-zero.txt`, and `build/main-trust-zero.txt`. Committed snapshots are in `../evidence/lean/`. The main proof's dependency closure uses only `propext`, `Classical.choice`, and `Quot.sound`. There are no `sorry`/`admit` placeholders, custom mathematical axioms, or native-decision shortcuts in the task-owned proof sources.

## Environment and scope

Lean 4.32.2; mathlib commit `905b95818eb32af7874a58b427f50c1711a5e96c`. The constructive Perron and finite-chain convergence proofs are imported from HNBM commit `58b321e9c9b86448e4fdd897a428c8cef7297f5e`. The copied files are byte-identical to that checkout. Original headers, notices, source hashes, and provenance are retained in `licenses/`. Upstream and some local lint warnings do not represent unfinished proofs.

This establishes the main fixed-budget growth law. It does not establish publication novelty, supply human specialist review, or formalize every additional example and finite-search result in the manuscript. The classical theorem, numerical checker, manuscript, and old Lean baseline remain preserved. No submission, publication, paid worker, or spending-limit change was used for this continuation.
