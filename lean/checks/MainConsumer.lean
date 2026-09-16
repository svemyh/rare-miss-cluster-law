import MissedUpdates

open Matrix Filter
open scoped Topology Matrix.Norms.Elementwise
open MissedUpdates.Matrices

-- A separate symbolic consumer of the exported theorem. No numerical fixture.
example {n : Type*} [Fintype n] [DecidableEq n] [Nonempty n]
    (C D : Matrix n n ℝ) (hC : ∀ i j, 0 < C i j) (hD : ∀ i j, 0 < D i j) :
    0 < ordinarySpectralRadius C ∧
      ∃ F : Frame ((ordinarySpectralRadius C)⁻¹ • C),
        ∀ m : ℕ, Tendsto
          (fun k : ℕ => (k : ℝ)*Real.log (constrainedRate C D m k / ordinarySpectralRadius C))
          atTop (𝓝 (Real.log (paperM F ((ordinarySpectralRadius C)⁻¹ • D) m))) :=
  rare_miss_cluster_law C D hC hD
