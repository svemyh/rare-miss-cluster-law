import Mathlib.LinearAlgebra.Matrix.DotProduct
import Mathlib.Data.Matrix.Mul
import Mathlib.Tactic

open Matrix
open scoped BigOperators

namespace MissedUpdates
namespace Matrices

variable {n : Type*} [Fintype n]

def outer (r ℓ : n → ℝ) : Matrix n n ℝ := fun i j => r i * ℓ j

def gain (ℓ r : n → ℝ) (A : Matrix n n ℝ) : ℝ := ℓ ⬝ᵥ (A *ᵥ r)

/-- Entrywise nonnegativity, not positive-semidefinite order. -/
def Nonnegative (A : Matrix n n ℝ) : Prop := ∀ i j, 0 ≤ A i j

def EntrywiseLE (A B : Matrix n n ℝ) : Prop := ∀ i j, A i j ≤ B i j

theorem mul_nonneg {A B : Matrix n n ℝ} (hA : Nonnegative A) (hB : Nonnegative B) :
    Nonnegative (A*B) := by
  intro i j
  exact Finset.sum_nonneg fun s _ => _root_.mul_nonneg (hA i s) (hB s j)

theorem mul_mono_left {A B C : Matrix n n ℝ} (hAB : EntrywiseLE A B) (hC : Nonnegative C) :
    EntrywiseLE (C*A) (C*B) := by
  intro i j
  exact Finset.sum_le_sum fun s _ => mul_le_mul_of_nonneg_left (hAB s j) (hC i s)

theorem mul_mono_right {A B C : Matrix n n ℝ} (hAB : EntrywiseLE A B) (hC : Nonnegative C) :
    EntrywiseLE (A*C) (B*C) := by
  intro i j
  exact Finset.sum_le_sum fun s _ => mul_le_mul_of_nonneg_right (hAB i s) (hC s j)

theorem mulVec_nonneg {A : Matrix n n ℝ} {r : n → ℝ}
    (hA : Nonnegative A) (hr : 0 ≤ r) : 0 ≤ A *ᵥ r := by
  intro i
  exact Finset.sum_nonneg fun j _ => _root_.mul_nonneg (hA i j) (hr j)

theorem gain_nonneg {ℓ r : n → ℝ} {A : Matrix n n ℝ}
    (hℓ : 0 ≤ ℓ) (hr : 0 ≤ r) (hA : Nonnegative A) : 0 ≤ gain ℓ r A := by
  exact dotProduct_nonneg_of_nonneg hℓ (mulVec_nonneg hA hr)

theorem gain_mono {ℓ r : n → ℝ} {A B : Matrix n n ℝ}
    (hℓ : 0 ≤ ℓ) (hr : 0 ≤ r) (hAB : EntrywiseLE A B) : gain ℓ r A ≤ gain ℓ r B := by
  apply dotProduct_le_dotProduct_of_nonneg_left _ hℓ
  intro i
  exact Finset.sum_le_sum fun j _ => mul_le_mul_of_nonneg_right (hAB i j) (hr j)

theorem outer_mulVec (r ℓ v : n → ℝ) :
    outer r ℓ *ᵥ v = (ℓ ⬝ᵥ v) • r := by
  ext i
  change (∑ j, (r i * ℓ j) * v j) = (∑ j, ℓ j * v j) * r i
  simp_rw [mul_assoc]
  rw [← Finset.mul_sum]
  ring

/-- Exact rank-one factorization, in arbitrary finite dimension. -/
theorem gain_insert_reset (ℓ r : n → ℝ) (A B : Matrix n n ℝ) :
    gain ℓ r (A * outer r ℓ * B) = gain ℓ r A * gain ℓ r B := by
  unfold gain
  rw [← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec]
  rw [outer_mulVec, Matrix.mulVec_smul, dotProduct_smul]
  simp only [smul_eq_mul]
  ring

variable [DecidableEq n]

theorem pow_mulVec_fixed (B : Matrix n n ℝ) (r : n → ℝ)
    (hr : B *ᵥ r = r) (a : ℕ) : B^a *ᵥ r = r := by
  induction a with
  | zero => simp
  | succ a ih => rw [pow_succ, ← Matrix.mulVec_mulVec, hr, ih]

theorem vecMul_pow_fixed (B : Matrix n n ℝ) (ℓ : n → ℝ)
    (hℓ : ℓ ᵥ* B = ℓ) (a : ℕ) : ℓ ᵥ* B^a = ℓ := by
  induction a with
  | zero => simp
  | succ a ih => rw [pow_succ, ← Matrix.vecMul_vecMul, ih, hℓ]

/-- Outer success runs disappear exactly under the left/right fixed-vector equations. -/
theorem gain_outer_powers (ℓ r : n → ℝ) (A B : Matrix n n ℝ)
    (hℓ : ℓ ᵥ* B = ℓ) (hr : B *ᵥ r = r) (a b : ℕ) :
    gain ℓ r (B^a * A * B^b) = gain ℓ r A := by
  unfold gain
  rw [← Matrix.mulVec_mulVec, pow_mulVec_fixed B r hr b]
  rw [← Matrix.mulVec_mulVec, Matrix.dotProduct_mulVec]
  rw [vecMul_pow_fixed B ℓ hℓ a]

omit [DecidableEq n] in
/-- The coordinate bound underlying the weighted operator-norm comparison. -/
theorem row_ratio_le_gain {ℓ r : n → ℝ} {A : Matrix n n ℝ} {δ : ℝ}
    (hℓ : ∀ i, 0 < ℓ i) (hr : ∀ i, 0 < r i) (hA : Nonnegative A)
    (hδ : 0 < δ) (hlower : ∀ i, δ ≤ ℓ i * r i) (i : n) :
    (A *ᵥ r) i / r i ≤ gain ℓ r A / δ := by
  have hrow : 0 ≤ (A *ᵥ r) i := mulVec_nonneg hA (fun j => le_of_lt (hr j)) i
  have hterm : ℓ i * (A *ᵥ r) i ≤ gain ℓ r A := by
    exact Finset.single_le_sum
      (fun j _ => _root_.mul_nonneg (le_of_lt (hℓ j))
        (mulVec_nonneg hA (fun t => le_of_lt (hr t)) j)) (Finset.mem_univ i)
  apply (le_div_iff₀ hδ).mpr
  have hprod := mul_le_mul_of_nonneg_right (hlower i) hrow
  have hratio : ((A *ᵥ r) i / r i) * δ ≤ ℓ i * (A *ᵥ r) i := by
    rw [div_mul_eq_mul_div]
    apply (div_le_iff₀ (hr i)).mpr
    nlinarith
  exact hratio.trans hterm

omit [Fintype n] in
theorem one_nonnegative : Nonnegative (1 : Matrix n n ℝ) := by
  intro i j
  simp only [Matrix.one_apply]
  split_ifs <;> norm_num

theorem pow_nonnegative (B : Matrix n n ℝ) (hB : Nonnegative B) (a : ℕ) :
    Nonnegative (B^a) := by
  induction a with
  | zero => simpa using (one_nonnegative (n := n))
  | succ a ih => simpa only [pow_succ] using mul_nonneg ih hB

theorem list_prod_nonnegative (xs : List (Matrix n n ℝ))
    (hxs : ∀ A ∈ xs, Nonnegative A) : Nonnegative xs.prod := by
  induction xs with
  | nil => simpa using (one_nonnegative (n := n))
  | cons A xs ih =>
    have hA := hxs A (by simp)
    have htail := ih (fun B hB => hxs B (by simp [hB]))
    simpa only [List.prod_cons] using mul_nonneg hA htail

/-- Simultaneous entrywise replacement of factors is sound for nonnegative products. -/
theorem list_prod_mono {xs ys : List (Matrix n n ℝ)}
    (hxy : List.Forall₂ EntrywiseLE xs ys)
    (hxs : ∀ A ∈ xs, Nonnegative A)
    (hys : ∀ A ∈ ys, Nonnegative A) : EntrywiseLE xs.prod ys.prod := by
  induction hxy with
  | nil => exact fun _ _ => le_rfl
  | @cons A B xs ys hAB hrest ih =>
    have hx := fun C (hC : C ∈ xs) => hxs C (by simp [hC])
    have hy := fun C (hC : C ∈ ys) => hys C (by simp [hC])
    have htail := ih hx hy
    have hfirst := mul_mono_right hAB (list_prod_nonnegative xs hx)
    have hsecond := mul_mono_left htail (hys B (by simp))
    intro i j
    exact (hfirst i j).trans (hsecond i j)

end Matrices
end MissedUpdates
