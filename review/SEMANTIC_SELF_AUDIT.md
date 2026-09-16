# Coordinator statement-correspondence audit

This is a coordinator review of the actual definitions and printed theorem types. It is not an independent specialist assessment. The human review gate remains open.

| Point | Checked correspondence / boundary |
|---|---|
| Domain | Nonempty finite index type; strict entrywise positivity in the original main theorem. Quantitative helpers also allow nonnegative miss matrices, a harmless generalization when restricted to the paper. |
| Protocol | Admissible counts false entries in every Ico(s,s+k) of an infinite natural-indexed sequence. It does not substitute average density. |
| Products | prefixWord has length N; wordProduct reverses chronological list order. gapWord_product handles gap-order reversal explicitly. |
| Suprema/rate | Relevant gain/norm sets are nonempty and bounded. The literal norm-root supremum and limsup are identified with the auxiliary gain rate; real suprema are not used outside proved boundedness conditions. |
| Norm | The formal norm is elementwise maximum. The paper now states this choice explicitly, then separately notes standard finite-dimensional norm independence. |
| Spectral radius | Complexification and the full complex spectrum are used. Equality to the positive eigenvalue is proved before the ENNReal-to-real conversion, avoiding an unproved finiteness premise. |
| Quantifiers | m is fixed outside Tendsto in k. Extra formal cases m=0 or small k do not change the paper domain or the limit. The quantitative theorem explicitly requires m,q>=1 and k>=m(q+1). |
| Packing | Canonical decoding, lengths, separation, bin budgets and total misses are derived from the actual prefix. The floor-plus-one bound differs from the paper ceiling by a vanishing boundary constant. |
| Finite cutoff | cutoffWords enumerates the empty word and all gap tuples with length<m and entries<=q. Attainment, miss count and maximum length are proved. The gain comparison clamps genuine powers, not an unrealizable projector. |
| Certificate scope | RelativeTail requires two-sided bounds for every g>=q, not sampled powers. all_later_windows_accuracy quantifies over every k beyond the supplied scalar threshold. |
| Classical boundary | The exact rational front end checks finite identities supporting the classical minorization proof. That generator and the big-O corollary are not separately Lean-formalized; the manuscript says so. |
| Trust | The actual main/quantitative theorem types and all 201 axiom closures were inspected. Only propext, Classical.choice and Quot.sound appear. The original 20 imported proof files retain their hashes and attribution. |

No concrete statement mismatch was found in this coordinator pass. This does not prove novelty or replace the requested independent semantic review. The review brief asks a specialist to challenge exactly these points and identify any missed difference.
