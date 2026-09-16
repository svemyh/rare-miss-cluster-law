import MissedUpdates.Frame
import MissedUpdates.Tail

open Matrix Filter
open scoped BigOperators Topology

namespace MissedUpdates
namespace Matrices

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Physical chronological product: the first symbol acts first, on the right. -/
def wordProduct (B E : Matrix n n ℝ) : List Bool → Matrix n n ℝ
  | [] => 1
  | b::w => wordProduct B E w * (if b then B else E)

theorem wordProduct_append (B E : Matrix n n ℝ) (u v : List Bool) :
    wordProduct B E (u++v) = wordProduct B E v * wordProduct B E u := by
  induction u with
  | nil => simp [wordProduct]
  | cons b u ih => simp [wordProduct, ih, Matrix.mul_assoc]

theorem wordProduct_true (B E : Matrix n n ℝ) (a : ℕ) :
    wordProduct B E (List.replicate a true) = B^a := by
  induction a with
  | zero => simp [wordProduct]
  | succ a ih => simp [List.replicate_succ, wordProduct, ih, pow_succ]

theorem wordProduct_nonnegative {B E : Matrix n n ℝ}
    (hB : Nonnegative B) (hE : Nonnegative E) (w : List Bool) :
    Nonnegative (wordProduct B E w) := by
  induction w with
  | nil => exact one_nonnegative
  | cons b w ih =>
    cases b
    · simpa [wordProduct] using mul_nonneg ih hE
    · simpa [wordProduct] using mul_nonneg ih hB

theorem mulVec_mono {A : Matrix n n ℝ} (hA : Nonnegative A)
    {u v : n → ℝ} (huv : u ≤ v) : A *ᵥ u ≤ A *ᵥ v := by
  intro i
  exact Finset.sum_le_sum fun j _ => mul_le_mul_of_nonneg_left (huv j) (hA i j)

theorem exists_miss_cone_bound {E : Matrix n n ℝ} (hE : Nonnegative E)
    (r : n → ℝ) (hr : ∀ i, 0 < r i) :
    ∃ c : ℝ, 1 ≤ c ∧ E *ᵥ r ≤ c • r := by
  let v := E *ᵥ r
  have hv : ∀ i, 0 ≤ v i := mulVec_nonneg hE (fun i => (hr i).le)
  let c := 1 + ∑ i, v i / r i
  have hs : 0 ≤ ∑ i, v i / r i :=
    Finset.sum_nonneg fun i _ => div_nonneg (hv i) (hr i).le
  refine ⟨c, by dsimp [c]; linarith, ?_⟩
  intro i
  have hi : v i / r i ≤ ∑ j, v j / r j :=
    Finset.single_le_sum (fun j _ => div_nonneg (hv j) (hr j).le) (Finset.mem_univ i)
  have hratio : v i / r i ≤ c := by dsimp [c]; linarith
  exact (div_le_iff₀ (hr i)).mp hratio

theorem word_right_bound {B E : Matrix n n ℝ} (hB : Nonnegative B) (hE : Nonnegative E)
    (r : n → ℝ) (hBr : B *ᵥ r = r) {c : ℝ} (hc : 1 ≤ c)
    (hEr : E *ᵥ r ≤ c • r) (w : List Bool) :
    wordProduct B E w *ᵥ r ≤ c^(w.count false) • r := by
  induction w with
  | nil => simp [wordProduct]
  | cons b w ih =>
    cases b with
    | true => simpa [wordProduct, ← Matrix.mulVec_mulVec, hBr] using ih
    | false =>
      have h₁ := mulVec_mono (wordProduct_nonnegative hB hE w) hEr
      rw [Matrix.mulVec_smul] at h₁
      have h₂ : c • (wordProduct B E w *ᵥ r) ≤ c • (c^(w.count false) • r) := by
        intro i
        exact mul_le_mul_of_nonneg_left (ih i) (by linarith)
      simpa [wordProduct, Matrix.mulVec_mulVec, List.count_cons, smul_smul, pow_succ, mul_comm]
        using h₁.trans h₂

theorem word_gain_bound {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) {c : ℝ} (hc : 1 ≤ c)
    (hEr : E *ᵥ F.right ≤ c • F.right) (w : List Bool) :
    gain F.left F.right (wordProduct B E w) ≤ c^(w.count false) := by
  have h := word_right_bound hB hE F.right F.right_fixed hc hEr w
  have hg := dotProduct_le_dotProduct_of_nonneg_left h (fun i => (F.left_pos i).le)
  simpa [gain, dotProduct_smul, F.pairing_one] using hg

/-- All finite words with at most m misses. Outer successes do not change their frame gain. -/
def gainSet {B : Matrix n n ℝ} (F : Frame B) (E : Matrix n n ℝ) (m : ℕ) : Set ℝ :=
  {x | ∃ w : List Bool, w.count false ≤ m ∧ gain F.left F.right (wordProduct B E w) = x}

noncomputable def clusterSup {B : Matrix n n ℝ} (F : Frame B)
    (E : Matrix n n ℝ) (m : ℕ) : ℝ := sSup (gainSet F E m)

theorem gainSet_nonempty {B : Matrix n n ℝ} (F : Frame B) (E : Matrix n n ℝ) (m : ℕ) :
    (gainSet F E m).Nonempty := by
  refine ⟨1, [], by simp, ?_⟩
  simp [wordProduct, gain, F.pairing_one]

theorem gainSet_bddAbove {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m : ℕ) : BddAbove (gainSet F E m) := by
  obtain ⟨c, hc, hEr⟩ := exists_miss_cone_bound hE F.right F.right_pos
  refine ⟨c^m, ?_⟩
  rintro x ⟨w, hw, rfl⟩
  exact (word_gain_bound F hB hE hc hEr w).trans (pow_le_pow_right₀ hc hw)

theorem word_gain_le_clusterSup {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) {m : ℕ} (w : List Bool)
    (hw : w.count false ≤ m) : gain F.left F.right (wordProduct B E w) ≤ clusterSup F E m := by
  exact le_csSup (gainSet_bddAbove F hB hE m) ⟨w, hw, rfl⟩

theorem one_le_clusterSup {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m : ℕ) : 1 ≤ clusterSup F E m := by
  simpa [wordProduct, gain, F.pairing_one] using
    word_gain_le_clusterSup F hB hE ([] : List Bool) (by simp : [].count false ≤ m)

end Matrices
end MissedUpdates
