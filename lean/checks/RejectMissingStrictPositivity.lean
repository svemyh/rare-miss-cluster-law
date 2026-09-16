import MissedUpdates

open Matrix
open MissedUpdates.Matrices

-- Deliberately wrong: nonnegativity alone cannot instantiate the positive theorem.
example {n : Type*} [Fintype n] [DecidableEq n] [Nonempty n]
    (C D : Matrix n n ℝ) (hC : Nonnegative C) (hD : ∀ i j, 0 < D i j) :
    0 < ordinarySpectralRadius C := by
  exact (rare_miss_cluster_law C D hC hD).1
