import MissedUpdates

open Matrix Filter
open scoped Topology Matrix.Norms.Elementwise
open MissedUpdates.Matrices

-- Deliberately invalid: the quantitative theorem cannot drop its window threshold.
example {n : Type*} [Fintype n] [DecidableEq n] [Nonempty n]
    {B E : Matrix n n ℝ} (F : Frame B) (hB : ∀ i j, 0 < B i j) (hE : Nonnegative E)
    (ht : RelativeTail B (outer F.right F.left) 1 0) :
    max 0 (Real.log (cutoffSup F E 3 1)+Real.log (1-(0 : ℝ))) ≤
      (5 : ℝ)*Real.log (constrainedRate B E 3 5) := by
  exact (finite_window_rate_bounds F hB hE (m := 3) (q := 1) (k := 5)
    (by norm_num) (by norm_num) (by norm_num) ht).1
