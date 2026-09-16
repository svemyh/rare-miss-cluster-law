# Reproducibility

## Formal proof

Use `make check-lean`. The current project requires Lean 4.32.2 and mathlib commit `905b95818eb32af7874a58b427f50c1711a5e96c`. All transitive revisions are in `lean/lake-manifest.json`. The 20 vendored PF/MCMC files are from HNBM commit `58b321e9c9b86448e4fdd897a428c8cef7297f5e`; their hashes and licenses are preserved.

Install the pinned toolchain, run `lake update` and `lake exe cache get` inside `lean/`, then run the checker. `LEAN_BIN_DIR` can select an existing directory containing the matching `lean` and `lake` binaries. Caches and toolchains are not committed.

The checker verifies dependency identities, rebuilds the project, audits all theorem declarations with `--trust=0`, prints the main theorem's definitions, compiles a separate consumer, and rejects four invalid proof controls. Their expected failures concern an illegal protocol, a false gain, a shifted coefficient and missing strict positivity.

The logical axioms are `propext`, `Classical.choice`, and `Quot.sound`. Verification also relies on the Lean kernel, runtime and hardware functioning correctly. The formal norm is the elementwise maximum norm. Not every separate manuscript proposition has been formalized.

## Exact checks and manuscript

`make check-exact` runs the frozen Python checker normally and in isolated optimized mode, then requires byte-identical receipts. The frozen theorem hash is `4acd0ef06ece65c0471d70b727b7dc152f73b469f7aedae5d79a4ca285a10e34`; the checker hash is `a27bd934b0546e89c8a660beec11f6a19fed10e86670d06689b89b4841c7332e`. These tests are fixture-specific.

`make paper` requires Tectonic and Poppler. It builds the bibliography, rejects unresolved references/overfull boxes, checks expected text, renders every page and reruns the exact checks. Every changed PDF needs visual inspection. Metadata timestamps can change between builds, so independently rebuilt PDF bytes need not be identical.

## Evidence

Committed Lean receipt paths are relative to `lean/`; manuscript receipt paths are relative to `paper/`. The packaged PDF's hash and inspected page list are in `evidence/manuscript/`. New runs write ignored outputs to `build/` directories.

`make check-package` verifies the Git-tracked inventory, portable Markdown links, evidence hashes, frozen inputs and common accidental secret/cache inclusions. It is not an exhaustive secret detector. No automatic GitHub Actions workflow is installed.
