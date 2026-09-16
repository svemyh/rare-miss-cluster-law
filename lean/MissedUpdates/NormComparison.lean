import MissedUpdates.Growth
import Mathlib.Analysis.Matrix.Normed

open Matrix Filter
open scoped BigOperators Topology Matrix.Norms.Elementwise

namespace MissedUpdates.Matrices

variable {n : Type*} [Fintype n] [DecidableEq n]

theorem gain_eq_sum (l r : n → ℝ) (A : Matrix n n ℝ) :
    gain l r A = ∑ i, ∑ j, (l i*r j)*A i j := by
  simp only [gain, Matrix.mulVec, dotProduct, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro j _; ring

/-- Two uniform comparison constants between a positive-frame gain and a genuine
matrix norm. Neither constant depends on the word or its length. -/
theorem exists_norm_gain_comparison {B : Matrix n n ℝ} (F : Frame B) :
    ∃ K L : ℝ, 1 ≤ K ∧ 1 ≤ L ∧ ∀ A : Matrix n n ℝ, Nonnegative A →
      ‖A‖ ≤ K*gain F.left F.right A ∧ gain F.left F.right A ≤ L*‖A‖ := by
  let weight : n → n → ℝ := fun i j => F.left i*F.right j
  have hw : ∀ i j, 0 < weight i j := fun i j => mul_pos (F.left_pos i) (F.right_pos j)
  let K := 1 + ∑ i, ∑ j, (weight i j)⁻¹
  let L := 1 + ∑ i, ∑ j, weight i j
  have hK : 1 ≤ K := by
    dsimp [K]; linarith [Finset.sum_nonneg (fun i (_ : i ∈ Finset.univ) =>
      Finset.sum_nonneg (fun j (_ : j ∈ Finset.univ) => (inv_pos.mpr (hw i j)).le))]
  have hL : 1 ≤ L := by
    dsimp [L]; linarith [Finset.sum_nonneg (fun i (_ : i ∈ Finset.univ) =>
      Finset.sum_nonneg (fun j (_ : j ∈ Finset.univ) => (hw i j).le))]
  refine ⟨K, L, hK, hL, ?_⟩
  intro A hA
  have hg : 0 ≤ gain F.left F.right A :=
    gain_nonneg (fun i => (F.left_pos i).le) (fun i => (F.right_pos i).le) hA
  constructor
  · apply (Matrix.norm_le_iff (_root_.mul_nonneg (by linarith : 0 ≤ K) hg)).mpr
    intro i j
    have hterm : weight i j*A i j ≤ gain F.left F.right A := by
      rw [gain_eq_sum]
      exact (Finset.single_le_sum (fun b _ => _root_.mul_nonneg (hw i b).le (hA i b))
        (Finset.mem_univ j)).trans
        (Finset.single_le_sum (fun a _ => Finset.sum_nonneg
          (fun b _ => _root_.mul_nonneg (hw a b).le (hA a b))) (Finset.mem_univ i))
    have hcoeff : (weight i j)⁻¹ ≤ K := by
      have h₁ := Finset.single_le_sum (fun b (_ : b ∈ Finset.univ) => (inv_pos.mpr (hw i b)).le)
        (Finset.mem_univ j)
      have h₂ := Finset.single_le_sum (fun a (_ : a ∈ Finset.univ) =>
        Finset.sum_nonneg (fun b (_ : b ∈ Finset.univ) => (inv_pos.mpr (hw a b)).le))
          (Finset.mem_univ i)
      dsimp [K]; linarith
    have ha : A i j ≤ (weight i j)⁻¹ * gain F.left F.right A := by
      rw [inv_mul_eq_div]
      exact (le_div_iff₀ (hw i j)).mpr (by simpa [mul_comm] using hterm)
    simpa [Real.norm_eq_abs, abs_of_nonneg (hA i j)] using
      ha.trans (mul_le_mul_of_nonneg_right hcoeff hg)
  · rw [gain_eq_sum]
    calc
      _ ≤ ∑ i, ∑ j, weight i j*‖A‖ := by
        apply Finset.sum_le_sum
        intro i _
        apply Finset.sum_le_sum
        intro j _
        apply mul_le_mul_of_nonneg_left _ (hw i j).le
        exact (le_abs_self _).trans (Matrix.norm_entry_le_entrywise_sup_norm A)
      _ = (∑ i, ∑ j, weight i j)*‖A‖ := by simp [Finset.sum_mul]
      _ ≤ L*‖A‖ := by
        apply mul_le_mul_of_nonneg_right _ (norm_nonneg A)
        dsimp [L]; linarith

/-- The actual complete matrix-product upper bound, with a word-independent norm constant. -/
theorem canonical_prefix_norm_bound {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E)
    (hconv : ∀ i j, Tendsto (fun g : ℕ => (B^g) i j) atTop
      (𝓝 ((outer F.right F.left) i j))) :
    ∃ K : ℝ, 1 ≤ K ∧ ∀ {q : ℕ} {t : ℝ}, 1 ≤ t →
      (∀ g ≥ q, EntrywiseLE (B^g) (t • outer F.right F.left)) →
      ∀ {σ : ℕ → Bool} {m k N : ℕ}, Admissible σ m k → m*q+1 ≤ k → 0 < q →
        ‖wordProduct B E (prefixWord σ N)‖ ≤
          K * (t^(m*(N/k+1)) * (clusterSup F E m)^(N/(k-m*q)+1)) := by
  obtain ⟨K, L, hK, _, hcomp⟩ := exists_norm_gain_comparison F
  refine ⟨K, hK, ?_⟩
  intro q t ht htail σ m k N hσ hwidth hq
  exact (hcomp _ (wordProduct_nonnegative hB hE _)).1.trans
    (mul_le_mul_of_nonneg_left (canonical_prefix_gain_bound F hB hE hconv ht htail hσ hwidth hq)
      (by linarith))

end MissedUpdates.Matrices
