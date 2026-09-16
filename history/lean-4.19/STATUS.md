# Lean implementation status

Started and checkpointed September 15, 2026 after the user explicitly requested an implementation attempt. This is a separate local project, not a claim that the whole paper is already formalized.

Target: kernel-checked proof components leading to the main fixed-budget cluster law, without `sorry`, custom mathematical axioms, or assuming the claimed all-word upper bound as a substitute for proving it. Standard Lean logical axioms are permitted and will be reported.

Environment: Lean 4.19.0 and mathlib commit c44e0c8ee63ca166450922a373c7409c5d26b00b. The existing toolchain is reused read-only; cached dependencies are copied into this project's .lake directory. No project spend limit is changed and no paid worker is launched.

Initial library reconnaissance found no Perron–Frobenius theorem in the pinned mathlib source. That is a named analysis obligation, not permission to assume the final result.

Completed: 52 theorem declarations across four modules, built and audited at Lean trust level zero. The canonical cluster construction and actual per-bin packing theorem are proved, as are prefix/total miss accounting, occupied-bin count, matrix monotonicity, rank-one factorization, fixed-vector power identities, and conditional coordinate/gain limit lemmas. The final axiom audit allows only propext, Classical.choice and Quot.sound. Both deliberately false controls were rejected.

Remaining: positivity-to-Perron data/convergence; the word-to-matrix and cluster-supremum assembly for the all-word upper bound; formal constrained growth rate and final upper/lower limit argument. The analytic helpers explicitly assume convergence; the unconditional full theorem is absent, not filled with a placeholder.

Next useful action: assemble canonical words into their alternating matrix products and connect the finite cluster gain supremum, using the checked packing and replacement lemmas. A recent external Perron formalization is a potential source, not yet imported or verified. Full details and reproducible commands are in README.md; machine evidence is in build/receipt.json.

Implementation notes: an initial broad Mathlib import began rebuilding unnecessary modules and was stopped in the task-owned process; imports were narrowed. Early type/syntax errors were fixed through compiler feedback. Entrywise matrix order is explicitly defined to avoid confusing it with positive-semidefinite order. Only successfully compiled declarations appear in the audited library. No paid worker or spending-limit change was used.
