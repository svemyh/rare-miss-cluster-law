import MissedUpdates.Normalization
import MissedUpdates.PerronRadius
import MissedUpdates.GapSuprema

open Matrix Filter
open scoped Topology Matrix.Norms.Elementwise

namespace MissedUpdates.Matrices

variable {n : Type*} [Fintype n] [DecidableEq n] [Nonempty n]

/-- The main fixed-budget cluster law for arbitrary strictly positive finite
real matrices. The rate is the literal norm-root limsup over infinite admissible
sequences, the normalization is the complex spectral radius, and `paperM` is
the finite maximum of the genuine integer-gap suprema. Perron data is obtained
from positivity; neither convergence nor a growth bound is a premise. -/
theorem rare_miss_cluster_law (C D : Matrix n n ℝ)
    (hC : ∀ i j, 0 < C i j) (hD : ∀ i j, 0 < D i j) :
    0 < ordinarySpectralRadius C ∧
    ∃ F : Frame ((ordinarySpectralRadius C)⁻¹ • C),
      ∀ m : ℕ, Tendsto
        (fun k : ℕ => (k : ℝ)*Real.log (constrainedRate C D m k / ordinarySpectralRadius C))
        atTop (𝓝 (Real.log (paperM F ((ordinarySpectralRadius C)⁻¹ • D) m))) := by
  obtain ⟨lam, hlam, ⟨F⟩⟩ := positive_frame_exists hC
  have hρ := normalized_frame_spectralRadius hC hlam F
  rw [hρ]
  refine ⟨hlam, F, ?_⟩
  intro m
  have hB : Nonnegative (lam⁻¹ • C) := fun i j => (mul_pos (inv_pos.mpr hlam) (hC i j)).le
  have hE : Nonnegative (lam⁻¹ • D) := fun i j => (mul_pos (inv_pos.mpr hlam) (hD i j)).le
  simpa only [clusterSup_eq_paperM F hB hE m] using
    original_cluster_limit hC (fun i j => (hD i j).le) hlam F m

/-- The same limit holds for every normalized positive Perron frame. -/
theorem rare_miss_cluster_law_for_frame (C D : Matrix n n ℝ)
    (hC : ∀ i j, 0 < C i j) (hD : ∀ i j, 0 < D i j)
    {lam : ℝ} (hlam : 0 < lam) (F : Frame (lam⁻¹ • C)) (m : ℕ) :
    ordinarySpectralRadius C = lam ∧
      Tendsto (fun k : ℕ => (k : ℝ)*Real.log (constrainedRate C D m k / lam)) atTop
        (𝓝 (Real.log (paperM F (lam⁻¹ • D) m))) := by
  refine ⟨normalized_frame_spectralRadius hC hlam F, ?_⟩
  have hB : Nonnegative (lam⁻¹ • C) := fun i j => (mul_pos (inv_pos.mpr hlam) (hC i j)).le
  have hE : Nonnegative (lam⁻¹ • D) := fun i j => (mul_pos (inv_pos.mpr hlam) (hD i j)).le
  simpa only [clusterSup_eq_paperM F hB hE m] using
    original_cluster_limit hC (fun i j => (hD i j).le) hlam F m

end MissedUpdates.Matrices
