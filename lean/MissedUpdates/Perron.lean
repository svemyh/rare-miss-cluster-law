import MissedUpdates.Tail
import PF.PerronFrobenius.Primitive

open Matrix Filter
open scoped BigOperators Topology

namespace MissedUpdates
namespace Matrices

variable {n : Type*} [Fintype n] [DecidableEq n] [Nonempty n]

theorem positive_isPrimitive {C : Matrix n n ℝ} (hC : ∀ i j, 0 < C i j) :
    C.IsPrimitive := by
  refine ⟨fun i j => (hC i j).le, 1, by norm_num, ?_⟩
  simpa using hC

/-- Constructive Perron existence, using the imported proof rather than a new axiom. -/
theorem positive_eigenvector_exists {C : Matrix n n ℝ}
    (hC : ∀ i j, 0 < C i j) :
    ∃ (lam : ℝ) (r : n → ℝ), 0 < lam ∧ (∀ i, 0 < r i) ∧ C *ᵥ r = lam • r := by
  exact Matrix.exists_positive_eigenvector_of_primitive (positive_isPrimitive hC)
    (fun i j => (hC i j).le)

theorem positive_dot_pos {ℓ r : n → ℝ}
    (hℓ : ∀ i, 0 < ℓ i) (hr : ∀ i, 0 < r i) : 0 < ℓ ⬝ᵥ r := by
  exact Finset.sum_pos (fun i _ => mul_pos (hℓ i) (hr i)) Finset.univ_nonempty

theorem positive_left_right_eigenvectors {C : Matrix n n ℝ}
    (hC : ∀ i j, 0 < C i j) :
    ∃ (lam : ℝ) (r ℓ : n → ℝ), 0 < lam ∧ (∀ i, 0 < r i) ∧
      (∀ i, 0 < ℓ i) ∧ ℓ ⬝ᵥ r = 1 ∧ C *ᵥ r = lam • r ∧ ℓ ᵥ* C = lam • ℓ := by
  obtain ⟨lam, r, hlam, hr, hCr⟩ := positive_eigenvector_exists hC
  obtain ⟨μ, l, hμ, hl, hCtl⟩ := positive_eigenvector_exists (fun i j => hC j i)
  change Cᵀ *ᵥ l = μ • l at hCtl
  have hlC : l ᵥ* C = μ • l := by simpa only [Matrix.mulVec_transpose] using hCtl
  have hd := positive_dot_pos hl hr
  have heq : lam = μ := by
    have h := Matrix.dotProduct_mulVec l C r
    rw [hCr, hlC, dotProduct_smul, smul_dotProduct] at h
    simp only [smul_eq_mul] at h
    nlinarith
  subst μ
  let ℓ : n → ℝ := (l ⬝ᵥ r)⁻¹ • l
  refine ⟨lam, r, ℓ, hlam, hr, ?_, ?_, hCr, ?_⟩
  · intro i
    exact mul_pos (inv_pos.mpr hd) (hl i)
  · simp [ℓ, smul_dotProduct, ne_of_gt hd]
  · simp only [ℓ, Matrix.smul_vecMul, hlC, smul_smul]
    congr 1
    ring

end Matrices
end MissedUpdates
