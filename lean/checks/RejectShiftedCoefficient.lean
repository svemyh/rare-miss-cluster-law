import MissedUpdates

open Matrix Filter
open scoped Topology Matrix.Norms.Elementwise
open MissedUpdates.Matrices

-- Deliberately wrong: the proved limit cannot be shifted by one.
example {n : Type*} [Fintype n] [DecidableEq n] [Nonempty n]
    (C D : Matrix n n ℝ) (hC : ∀ i j, 0 < C i j) (hD : ∀ i j, 0 < D i j)
    {lam : ℝ} (hlam : 0 < lam) (F : Frame (lam⁻¹ • C)) (m : ℕ) :
    Tendsto (fun k : ℕ => (k : ℝ)*Real.log (constrainedRate C D m k / lam)) atTop
      (𝓝 (Real.log (paperM F (lam⁻¹ • D) m)+1)) := by
  exact (rare_miss_cluster_law_for_frame C D hC hD hlam F m).2
