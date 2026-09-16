# Full theorem verified

The complete main cluster law is implemented and audited. `python3 check.py` passed on September 16, 2026 UTC. The corresponding local date was September 15 in America/Los_Angeles; the receipt records the exact UTC timestamp.

Main declaration: `MissedUpdates.Matrices.rare_miss_cluster_law` in `MissedUpdates/Main.lean`. Its assumptions are strict entrywise positivity of C and D on a nonempty finite index type. It constructs the normalized Perron frame, identifies the ordinary complex spectral radius, and proves the actual norm-root growth-rate limit for every fixed miss budget.

All three requested obligations are complete. The canonical split is connected to the original word, the matrix bound and the genuine cluster suprema. Perron convergence follows from positivity. Both limiting inequalities and the equivalence between gain growth and the literal matrix-norm rate are proved. The auxiliary coefficient is proved equal to max(1,S_1,...,S_m).

Verification: 175 exported theorem declarations checked with Lean trust level zero; only propext, Classical.choice and Quot.sound in their dependency closures; a separate symbolic consumer passed; four invalid controls were rejected. All 20 vendored proof sources match the pinned upstream checkout byte-for-byte. See `build/receipt.json` and the raw audit logs.

Environment: Lean 4.32.2, mathlib 905b95818eb32af7874a58b427f50c1711a5e96c, HNBM 58b321e9c9b86448e4fdd897a428c8cef7297f5e. The imported files are PF/ and MCMC/{Core,TotalVariation,Convergence}.lean. Their original notices and hashes are preserved. The official compiler archive SHA-256 was checked before extraction: ea99ead969901b9fe4c7e7bf350b812a0249e9a5cea20474a737c0cc64746bc0.

No formalization obligation remains for the main theorem's stated scope. The exact norm is the elementwise maximum norm. This status does not extend to every separate manuscript application, publication novelty, or human specialist review. The old Lean 4.19 baseline and the frozen classical artifacts remain unchanged. No background worker or recurring task is active.
