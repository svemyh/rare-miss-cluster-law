# Rare-miss growth under sliding-window constraints

A mathematical research package with a complete Lean proof of the main fixed-budget cluster law, a readable paper, exact example checks, and a provisional prior-art assessment.

For fixed strictly positive real matrices C,D and a fixed miss budget m, let ρₘ,ₖ be the worst asymptotic product growth under at most m misses in every k-slot window. The result is

$$
\lim_{k\to\infty} k\log\!\left(\frac{\rho_{m,k}}{\rho(C)}\right)
=\log\max(1,S_1,\ldots,S_m).
$$

The Sⱼ are Perron-weighted suprema over every finite integer-gap cluster containing j misses. The formal rate uses the actual infinite sliding-window language, the elementwise maximum matrix norm, and the ordinary complex spectral radius.

## Start here

- [Paper PDF](paper/rare_misses.pdf) and [editable LaTeX](paper/rare_misses.tex).
- [Main Lean theorem](lean/MissedUpdates/Main.lean) and [proof map](lean/README.md).
- [Audit receipt](evidence/lean/receipt.json) and [raw kernel output](evidence/lean/main-trust-zero.txt).
- [Classical theorem](THEOREM.md), [exact examples](EXAMPLES.md), and [internal mathematical review](review.md).
- [Literature assessment](literature-audit/AUDIT.md) and [scope/status](docs/RESEARCH_STATUS.md).

The full formalization checks 175 exported declarations at Lean trust level zero. It uses only `propext`, `Classical.choice`, and `Quot.sound`, with no proof placeholders or custom mathematical axioms. Four invalid proof controls are required to fail. Positivity-to-Perron convergence, the canonical matrix bound, and both limiting inequalities are connected in the final theorem.

## Reproduce

Python 3 is sufficient for the exact checks and package audit:

```sh
make check-exact
make check-package
```

For the full proof, install Lean **4.32.2** as specified in `lean/lean-toolchain`, then fetch the locked dependencies:

```sh
cd lean
lake update
lake exe cache get
cd ..
make check-lean
```

`make check` runs all three checks. The proof checker verifies dependency commits, all 20 vendored proof hashes, the full axiom inventory, a separate theorem consumer, and the invalid controls. Replays write new evidence to `lean/build/`; committed snapshots are in `evidence/lean/`.

With Tectonic and Poppler installed, `make paper` rebuilds the PDF, checks its references, renders every page, and reruns the exact checks. Its outputs go to `paper/build/`; `paper/rare_misses.pdf` is the inspected package copy. See [reproducibility notes](docs/REPRODUCIBILITY.md).

## Layout

| Directory | Contents |
|---|---|
| `lean/` | Complete proof, pinned manifests, audit scripts and upstream proof licenses |
| `paper/` | Current manuscript source, PDF, bibliography and local build script |
| `evidence/` | Lean, exact-arithmetic and manuscript verification records |
| `literature-audit/` | Authored comparisons, query logs and citation metadata |
| `history/lean-4.19/` | Earlier partial proof, separated from the current implementation |
| `docs/` | Scope, reproducibility, packaging and third-party notices |

## Status and limits

This is a private research repository, not a public release or submitted paper. The main theorem is formally proved. Publication novelty remains provisional and human specialist review is pending. The separate finite-search and example propositions have not all been formalized.

The frozen `THEOREM.md` retains its historical status header; [FORMALIZATION.md](FORMALIZATION.md) gives the current proof status. Mathematical authorship and an original-work distribution license have not been assigned by this packaging step. Third-party files retain their original licenses; see [notices](docs/THIRD_PARTY_NOTICES.md).
