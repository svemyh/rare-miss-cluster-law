# Lean proof components for the rare-miss theorem

Status: **52 kernel-checked theorem declarations; the complete growth-rate theorem is not yet formalized.** These are general proofs with symbolic parameters, not checks of 52 numerical instances. Many declarations are supporting lemmas, not separate research results.

## What is actually proved

| Module | Scope |
|---|---|
| `MissedUpdates/Protocol.lean` | The infinite sliding-window rule, prefix miss count, short-chain cardinality/span, and bin capacity |
| `MissedUpdates/Clusters.lean` | A canonical split of the actual prefix misses; flattening, ordering, short steps, separation, derived length/span bounds, disjointness, per-bin capacity, occupied-bin count, and total miss accounting |
| `MissedUpdates/Matrix.lean` | Entrywise nonnegative multiplication and monotonicity, exact rank-one gain factorization, fixed-vector power identities, a row-ratio bound, and sound simultaneous factor replacement |
| `MissedUpdates/Tail.lean` | Uniform coordinate tail bounds and gain/joining limits **given coordinate convergence** |

The central discrete result is `MissedUpdates.canonical_bin_budget`. Its inputs are the actual admissible sequence and the inequalities `m*q+1 <= k`, `0 < q`. It constructs the canonical clusters and proves that their lengths in each paper bin sum to at most m. It does not assume the desired cluster lengths or per-bin cardinality conclusion.

`canonical_total_misses` proves that the split loses and duplicates no misses. `canonical_bin_count_le` uses the sufficient floor-plus-one bound `N/L+1`; this is at most one bin weaker than the paper's ceiling bound and has the same asymptotic rate. The full rate assembly has not yet been carried out.

## Check the project

```sh
python3 check.py
```

The script builds the Lean library, checks the pinned dependency revisions and clean source trees, audits **every declared theorem** through `AxiomAudit.lean`, and invokes Lean with `--trust=0`. In this Lean version, trust level zero type-checks imported modules as well. It also compiles a positive control and requires two false statements to fail compilation.

The final `#print axioms` results contain only standard logical foundations: `propext`, `Classical.choice`, and `Quot.sound`. No custom mathematical axiom or `sorryAx` appears. The own-source scan rejects `sorry`, `admit`, `axiom`, `unsafe`, and `native_decide`.

Evidence:

- `build/receipt.json`: precise theorem inventory, axioms per theorem, versions and source hashes.
- `build/axioms-trust-zero.txt`: unedited Lean output, including key theorem types.
- `build/RejectAllMisses.txt`: rejection of an all-miss sequence under a two-in-three budget.
- `build/RejectFalseGain.txt`: rejection of a false matrix-gain equality.

The negative files under `checks/` intentionally do not compile. They are not imports of the library and must not be presented as completed proofs.

## Pinned environment

- Lean: `leanprover/lean4:v4.19.0`.
- Mathlib: `c44e0c8ee63ca166450922a373c7409c5d26b00b`.
- Transitive revisions: `lake-manifest.json`.

On this machine, `.toolchain` points to the already-installed compiler from the earlier OBS project. It is used read-only. The dependency source/build cache was copied into this project's `.lake/packages` using local copy-on-write; the old project was not changed. A clean source checkout can use a normal installation of the pinned Lean toolchain, restore the pinned Lake dependencies and mathlib cache, then run `python3 check.py`. `LEAN_BIN_DIR` can select an explicit directory containing the matching `lake` and `lean` executables. No paid model worker is needed to recheck the proofs.

## What remains unproved

1. A bridge from arbitrary strictly positive C,D to the normalized Perron data and convergence required by the analytic lemmas. The pinned mathlib search did not locate that theorem.
2. The complete matrix product representation of every canonical word and its combination with the cluster suprema S_j to establish the paper's all-word growth bound. The discrete packing and factor-replacement lemmas are proved, but their full assembly is not.
3. The exact formal definition of the paper's constrained growth rate, both scaled limit bounds, and their final equality. There is no Lean declaration pretending this final theorem is complete.

The hypotheses `hconv` in `uniform_power_tail`, `padded_gain_tendsto` and `joined_gain_le` are visible premises, not derived Perron–Frobenius results. The project does not turn them into an axiom or silently treat a conditional helper as the unconditional paper theorem.

An external lead for the missing foundation is Section 4.5 of *Formalized Hopfield Networks and Boltzmann Machines*, arXiv:2512.07766v1 (December 8, 2025), which describes a Lean Perron–Frobenius development. Its implementation has not been imported, built or audited here. The paper's anonymized repository link is not sufficient to establish a compatible dependency. Primary source: `https://arxiv.org/html/2512.07766v1`.

The next implementation step is the word-to-matrix/supremum assembly, while independently locating and checking a reusable Perron foundation or proving that bridge. No additional sampling of numerical examples substitutes for these obligations.

The original manuscript and numerical verification artifacts remain unchanged. Publication novelty and human specialist review are separate questions from this partial formalization.
