# Formalization review brief

Unsent material. No formalization specialist has reviewed this revision.

The kernel checks proof terms; this review asks whether the formal statements express the intended mathematics. Start at lean/MissedUpdates/Main.lean and the added cutoff/quantitative modules, then inspect definitions and audits.

- The nonempty finite index type represents positive dimension. Positivity is entrywise, not positive-semidefinite order.
- `Admissible` quantifies over every starting slot of an infinite sequence. False denotes a miss. This is not an average-density condition.
- `prefixWord` takes N symbols; `wordProduct` places the earliest action on the right. Check `gapWord_product` and gap-order reversal.
- `constrainedRate` is the literal limsup of suprema of matrix norm roots. `NormGrowth` identifies it with the auxiliary gain rate.
- The formal norm is the elementwise maximum norm. The paper's any-fixed-norm observation uses finite-dimensional norm equivalence; do not report formal quantification over every norm if it is absent.
- `ordinarySpectralRadius` uses the complex spectrum of the complexified real matrix. Equality to the normalizer is proved.
- The main theorem constructs Perron data from positivity. `Frame` does not assume convergence or the desired growth bound. The m quantifier lies outside the k-limit.
- `paperM` is the finite maximum including 1 and genuine integer-gap suprema. The auxiliary all-word supremum is proved equivalent.
- `cutoffWords` contains the empty word and all bounded-gap clusters within the miss budget. Attainment and word length are proved.
- `RelativeTail` requires both inequalities for every g>=q and 0<=e<1. These are explicit certificate inputs, not the desired growth conclusion. Identify exactly which tail-construction and threshold results are formalized.
- The quantitative lower bound uses an actual period-k word; the upper bound covers every admissible sequence. Check logarithm positivity and boundary conditions.

Run the pinned checker and inspect actual theorem types and axiom output, not only PASS. Only propext, Classical.choice and Quot.sound are permitted. Check the unchanged 20 upstream PF/MCMC hashes and attribution. Imported results must not be described as original work.

Distinguish the existing core proof, new quantitative proofs, rational calculations and classical-only consequences. Record the commit, modules examined, prose/definition mismatches and unreviewed dependencies. Invalid controls should fail for the intended reason.
