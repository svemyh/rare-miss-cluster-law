import MissedUpdates.Assembly

open Matrix

namespace MissedUpdates.Matrices

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Gap parameters are ordered from the leftmost matrix factor to the rightmost. -/
def gapWord : List ℕ → List Bool
  | [] => [false]
  | g::gs => gapWord gs ++ List.replicate g true ++ [false]

def gapMatrix (B E : Matrix n n ℝ) : List ℕ → Matrix n n ℝ
  | [] => E
  | g::gs => E * B^g * gapMatrix B E gs

theorem gapWord_count (gs : List ℕ) : (gapWord gs).count false = gs.length+1 := by
  induction gs with
  | nil => simp [gapWord]
  | cons g gs ih => simp [gapWord, ih, List.count_replicate]

theorem gapWord_product (B E : Matrix n n ℝ) (gs : List ℕ) :
    wordProduct B E (gapWord gs) = gapMatrix B E gs := by
  induction gs with
  | nil => simp [gapWord, wordProduct, gapMatrix]
  | cons g gs ih =>
    simp [gapWord, wordProduct_append, wordProduct_true, wordProduct, ih, gapMatrix, Matrix.mul_assoc]

/-- Every finite binary word is either all successes or an actual finite gap
cluster with leading and trailing success runs. -/
theorem word_gap_decomposition (w : List Bool) :
    (∃ a : ℕ, w = List.replicate a true) ∨
    ∃ a b : ℕ, ∃ gs : List ℕ, w = List.replicate a true ++ gapWord gs ++ List.replicate b true := by
  induction w using List.reverseRecOn with
  | nil => exact Or.inl ⟨0, rfl⟩
  | append_singleton w bit ih =>
    rcases ih with ⟨a, rfl⟩ | ⟨a, b, gs, rfl⟩
    · cases bit
      · exact Or.inr ⟨a, 0, [], by simp [gapWord]⟩
      · exact Or.inl ⟨a+1, by simp [List.replicate_succ']⟩
    · cases bit
      · exact Or.inr ⟨a, 0, b::gs, by simp [gapWord, List.append_assoc]⟩
      · exact Or.inr ⟨a, b+1, gs, by simp [List.replicate_succ', List.append_assoc]⟩

theorem word_gain_gap_decomposition {B E : Matrix n n ℝ} (F : Frame B) (w : List Bool) :
    (w.count false = 0 ∧ gain F.left F.right (wordProduct B E w) = 1) ∨
    ∃ gs : List ℕ, gs.length+1 = w.count false ∧
      gain F.left F.right (gapMatrix B E gs) = gain F.left F.right (wordProduct B E w) := by
  rcases word_gap_decomposition w with ⟨a, rfl⟩ | ⟨a, b, gs, rfl⟩
  · left
    simp [List.count_replicate, wordProduct_true, gain,
      pow_mulVec_fixed B F.right F.right_fixed, F.pairing_one]
  · right
    refine ⟨gs, by simp [gapWord_count, List.count_replicate], ?_⟩
    simp [wordProduct_append, wordProduct_true, gapWord_product,
      ← Matrix.mul_assoc, gain_outer_powers F.left F.right _ B F.left_fixed F.right_fixed]

def gapGainSet {B : Matrix n n ℝ} (F : Frame B) (E : Matrix n n ℝ) (j : ℕ) : Set ℝ :=
  {x | ∃ gs : List ℕ, gs.length+1 = j ∧ gain F.left F.right (gapMatrix B E gs) = x}

/-- The paper's S_j for j at least one. -/
noncomputable def gapSup {B : Matrix n n ℝ} (F : Frame B) (E : Matrix n n ℝ) (j : ℕ) : ℝ :=
  sSup (gapGainSet F E j)

/-- Literal finite maximum M_m = max(1,S_1,...,S_m). -/
noncomputable def paperM {B : Matrix n n ℝ} (F : Frame B) (E : Matrix n n ℝ) : ℕ → ℝ
  | 0 => 1
  | m+1 => max (paperM F E m) (gapSup F E (m+1))

theorem gapGainSet_nonempty {B : Matrix n n ℝ} (F : Frame B) (E : Matrix n n ℝ) (j : ℕ) :
    (gapGainSet F E (j+1)).Nonempty := by
  refine ⟨_, List.replicate j 0, by simp, rfl⟩

theorem gapGainSet_subset {B : Matrix n n ℝ} (F : Frame B) (E : Matrix n n ℝ) (j : ℕ) :
    gapGainSet F E j ⊆ gainSet F E j := by
  rintro x ⟨gs, hgs, rfl⟩
  exact ⟨gapWord gs, by simp [gapWord_count, hgs], gapWord_product B E gs ▸ rfl⟩

theorem gapGainSet_bddAbove {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (j : ℕ) : BddAbove (gapGainSet F E j) :=
  (gainSet_bddAbove F hB hE j).mono (gapGainSet_subset F E j)

theorem clusterSup_zero {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) : clusterSup F E 0 = 1 := by
  apply le_antisymm _ (one_le_clusterSup F hB hE 0)
  apply csSup_le (gainSet_nonempty F E 0)
  rintro x ⟨w, hw, rfl⟩
  rcases word_gain_gap_decomposition F w with ⟨_, hx⟩ | ⟨gs, hgs, _⟩
  · exact hx.le
  · omega

theorem clusterSup_succ {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m : ℕ) :
    clusterSup F E (m+1) = max (clusterSup F E m) (gapSup F E (m+1)) := by
  apply le_antisymm
  · apply csSup_le (gainSet_nonempty F E (m+1))
    rintro x ⟨w, hw, rfl⟩
    by_cases hm : w.count false ≤ m
    · exact (word_gain_le_clusterSup F hB hE w hm).trans (le_max_left _ _)
    · have hc : w.count false = m+1 := by omega
      rcases word_gain_gap_decomposition F w with ⟨hz, _⟩ | ⟨gs, hgs, hg⟩
      · omega
      · apply le_trans _ (le_max_right _ _)
        exact le_csSup (gapGainSet_bddAbove F hB hE (m+1)) ⟨gs, hgs.trans hc, hg⟩
  · apply max_le
    · apply csSup_le (gainSet_nonempty F E m)
      rintro x ⟨w, hw, rfl⟩
      exact word_gain_le_clusterSup F hB hE w (by omega)
    · apply csSup_le (gapGainSet_nonempty F E m)
      intro x hx
      exact le_csSup (gainSet_bddAbove F hB hE (m+1)) (gapGainSet_subset F E (m+1) hx)

/-- The supremum used in the proof is exactly the paper's finite maximum of gap suprema. -/
theorem clusterSup_eq_paperM {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m : ℕ) : clusterSup F E m = paperM F E m := by
  induction m with
  | zero => exact clusterSup_zero F hB hE
  | succ m ih => rw [clusterSup_succ F hB hE, ih, paperM]

end MissedUpdates.Matrices
