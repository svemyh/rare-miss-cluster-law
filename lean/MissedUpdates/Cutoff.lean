import MissedUpdates.Main

open Matrix Filter
open scoped BigOperators Topology

namespace MissedUpdates.Matrices

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- All genuine gap tuples of one fixed length, with entries at most q. -/
def boundedGaps (q : ℕ) : ℕ → List (List ℕ)
  | 0 => [[]]
  | j+1 => (List.range (q+1)).flatMap (fun g => (boundedGaps q j).map (g :: ·))

theorem mem_boundedGaps (q j : ℕ) (gs : List ℕ) :
    gs ∈ boundedGaps q j ↔ gs.length = j ∧ ∀ g ∈ gs, g ≤ q := by
  induction j generalizing gs with
  | zero => cases gs <;> simp [boundedGaps]
  | succ j ih =>
    simp only [boundedGaps, List.mem_flatMap, List.mem_range, List.mem_map]
    constructor
    · rintro ⟨g, hg, xs, hxs, rfl⟩
      obtain ⟨hlen, hall⟩ := (ih xs).mp hxs
      refine ⟨by simp [hlen], ?_⟩
      intro a ha
      rcases List.mem_cons.mp ha with rfl | ha
      · omega
      · exact hall a ha
    · rintro ⟨hlen, hall⟩
      cases gs with
      | nil => simp at hlen
      | cons g xs =>
        refine ⟨g, by have := hall g (by simp); omega, xs, ?_, rfl⟩
        exact (ih xs).mpr ⟨by simpa using hlen,
          fun a ha => hall a (by simp [ha])⟩

/-- The empty word and every cluster with at most m misses and gaps at most q. -/
def cutoffWords (m q : ℕ) : List (List Bool) :=
  [] :: (List.range m).flatMap (fun j => (boundedGaps q j).map gapWord)

theorem mem_cutoffWords (m q : ℕ) (w : List Bool) :
    w ∈ cutoffWords m q ↔ w = [] ∨
      ∃ gs : List ℕ, gs.length < m ∧ (∀ g ∈ gs, g ≤ q) ∧ gapWord gs = w := by
  simp only [cutoffWords, List.mem_cons, List.mem_flatMap, List.mem_range, List.mem_map]
  constructor
  · rintro (h | ⟨j, hj, gs, hgs, rfl⟩)
    · exact Or.inl h
    · obtain ⟨hlen, hall⟩ := (mem_boundedGaps q j gs).mp hgs
      exact Or.inr ⟨gs, by omega, hall, rfl⟩
  · rintro (h | ⟨gs, hlen, hall, rfl⟩)
    · exact Or.inl h
    · exact Or.inr ⟨gs.length, hlen, gs, (mem_boundedGaps q gs.length gs).mpr ⟨rfl, hall⟩, rfl⟩

theorem cutoffWords_nonempty (m q : ℕ) : (cutoffWords m q).toFinset.Nonempty :=
  ⟨[], by simp [cutoffWords]⟩

noncomputable def cutoffSup {B : Matrix n n ℝ} (F : Frame B)
    (E : Matrix n n ℝ) (m q : ℕ) : ℝ :=
  (cutoffWords m q).toFinset.sup' (cutoffWords_nonempty m q)
    (fun w => gain F.left F.right (wordProduct B E w))

theorem word_gain_le_cutoffSup {B : Matrix n n ℝ} (F : Frame B)
    (E : Matrix n n ℝ) {m q : ℕ} {w : List Bool} (hw : w ∈ cutoffWords m q) :
    gain F.left F.right (wordProduct B E w) ≤ cutoffSup F E m q := by
  unfold cutoffSup
  exact Finset.le_sup' (fun w : List Bool => gain F.left F.right (wordProduct B E w))
    (List.mem_toFinset.mpr hw)

theorem one_le_cutoffSup {B : Matrix n n ℝ} (F : Frame B)
    (E : Matrix n n ℝ) (m q : ℕ) : 1 ≤ cutoffSup F E m q := by
  simpa [wordProduct, gain, F.pairing_one] using
    word_gain_le_cutoffSup F E (by simp [cutoffWords] : [] ∈ cutoffWords m q)

theorem cutoffSup_attained {B : Matrix n n ℝ} (F : Frame B)
    (E : Matrix n n ℝ) (m q : ℕ) :
    ∃ w ∈ cutoffWords m q, gain F.left F.right (wordProduct B E w) = cutoffSup F E m q := by
  obtain ⟨w, hw, hmax⟩ := Finset.exists_mem_eq_sup' (cutoffWords_nonempty m q)
    (fun w => gain F.left F.right (wordProduct B E w))
  exact ⟨w, List.mem_toFinset.mp hw, hmax.symm⟩

theorem gapWord_length (gs : List ℕ) : (gapWord gs).length = gs.sum+gs.length+1 := by
  induction gs with
  | nil => simp [gapWord]
  | cons g gs ih => simp [gapWord, ih]; omega

theorem sum_gaps_le {q : ℕ} (gs : List ℕ) (hgs : ∀ g ∈ gs, g ≤ q) :
    gs.sum ≤ gs.length*q := by
  induction gs with
  | nil => simp
  | cons g gs ih =>
    have hg := hgs g (by simp)
    have hs := ih (fun a ha => hgs a (by simp [ha]))
    simp only [List.sum_cons, List.length_cons, Nat.add_mul]
    omega

theorem cutoffWord_bounds {m q : ℕ} {w : List Bool} (hw : w ∈ cutoffWords m q) :
    w.count false ≤ m ∧ w.length ≤ m+(m-1)*q := by
  rcases (mem_cutoffWords m q w).mp hw with rfl | ⟨gs, hlen, hall, rfl⟩
  · simp
  · constructor
    · simp [gapWord_count]; omega
    · rw [gapWord_length]
      have hs := sum_gaps_le gs hall
      have hm := Nat.mul_le_mul_right q (show gs.length ≤ m-1 by omega)
      omega

theorem cutoffSup_le_clusterSup {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m q : ℕ) :
    cutoffSup F E m q ≤ clusterSup F E m := by
  apply Finset.sup'_le
  intro w hw
  exact word_gain_le_clusterSup F hB hE w (cutoffWord_bounds (List.mem_toFinset.mp hw)).1

theorem gapMatrix_nonnegative {B E : Matrix n n ℝ}
    (hB : Nonnegative B) (hE : Nonnegative E) (gs : List ℕ) :
    Nonnegative (gapMatrix B E gs) := by
  rw [← gapWord_product]
  exact wordProduct_nonnegative hB hE _

/-- Every long gap can be replaced by q under a two-sided relative tail. -/
theorem power_clamp_le {B : Matrix n n ℝ} (F : Frame B) (hB : Nonnegative B)
    {q : ℕ} {e : ℝ} (he : 0 ≤ e) (he1 : e < 1)
    (hlo : EntrywiseLE ((1-e) • outer F.right F.left) (B^q))
    (hhi : ∀ g ≥ q, EntrywiseLE (B^g) ((1+e) • outer F.right F.left)) (g : ℕ) :
    EntrywiseLE (B^g) (((1+e)/(1-e)) • B^(min g q)) := by
  have hd : 0 < 1-e := by linarith
  have hR : 1 ≤ (1+e)/(1-e) := (le_div_iff₀ hd).mpr (by linarith)
  by_cases hg : g ≤ q
  · rw [Nat.min_eq_left hg]
    intro i j
    exact le_mul_of_one_le_left (pow_nonnegative B hB g i j) hR
  · rw [Nat.min_eq_right (by omega : q ≤ g)]
    intro i j
    have hl := hlo i j
    have hu := hhi g (by omega) i j
    change (1-e)*(F.right i*F.left j) ≤ (B^q) i j at hl
    change (B^g) i j ≤ (1+e)*(F.right i*F.left j) at hu
    change (B^g) i j ≤ ((1+e)/(1-e))*(B^q) i j
    apply hu.trans
    rw [div_mul_eq_mul_div]
    apply (le_div_iff₀ hd).mpr
    nlinarith [mul_le_mul_of_nonneg_left hl (by linarith : 0 ≤ 1+e)]

theorem gapMatrix_clamp_le {B E : Matrix n n ℝ} (hB : Nonnegative B) (hE : Nonnegative E)
    {q : ℕ} {R : ℝ} (hR : 0 ≤ R)
    (hpow : ∀ g, EntrywiseLE (B^g) (R • B^(min g q))) (gs : List ℕ) :
    EntrywiseLE (gapMatrix B E gs) (R^gs.length • gapMatrix B E (gs.map (fun g => min g q))) := by
  induction gs with
  | nil => intro i j; simp [gapMatrix]
  | cons g gs ih =>
    have h₁ := mul_mono_right (mul_mono_left (hpow g) hE) (gapMatrix_nonnegative hB hE gs)
    have h₂ := mul_mono_left ih (mul_nonneg hE (pow_nonnegative B hB (min g q)))
    intro i j
    have h₂' := mul_le_mul_of_nonneg_left (h₂ i j) hR
    have h₁' := h₁ i j
    simp only [Matrix.mul_smul, Matrix.smul_mul, Matrix.smul_apply, smul_eq_mul] at h₁' h₂'
    simpa [gapMatrix, Matrix.mul_smul, Matrix.smul_mul, smul_smul, pow_succ,
      mul_assoc, mul_comm, mul_left_comm] using h₁'.trans h₂'

/-- The genuine finite cutoff bounds the full unattained-gap supremum. -/
theorem clusterSup_le_cutoff {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) {m q : ℕ} (hm : 1 ≤ m)
    {e : ℝ} (he : 0 ≤ e) (he1 : e < 1)
    (hlo : EntrywiseLE ((1-e) • outer F.right F.left) (B^q))
    (hhi : ∀ g ≥ q, EntrywiseLE (B^g) ((1+e) • outer F.right F.left)) :
    clusterSup F E m ≤ ((1+e)/(1-e))^(m-1) * cutoffSup F E m q := by
  let R := (1+e)/(1-e)
  have hd : 0 < 1-e := by linarith
  have hR : 1 ≤ R := (le_div_iff₀ hd).mpr (by linarith)
  have hA := one_le_cutoffSup F E m q
  apply csSup_le (gainSet_nonempty F E m)
  rintro x ⟨w, hw, rfl⟩
  rcases word_gain_gap_decomposition F w with ⟨_, hg⟩ | ⟨gs, hlen, hg⟩
  · rw [hg]
    exact hA.trans (le_mul_of_one_le_left (by linarith) (one_le_pow₀ hR))
  · have hgs : gs.length < m := by omega
    have hmem : gapWord (gs.map (fun g => min g q)) ∈ cutoffWords m q := by
      apply (mem_cutoffWords _ _ _).mpr
      refine Or.inr ⟨_, by simpa using hgs, ?_, rfl⟩
      intro g h
      obtain ⟨a, _, rfl⟩ := List.mem_map.mp h
      exact min_le_right _ _
    have hgain := gain_mono (fun i => (F.left_pos i).le) (fun i => (F.right_pos i).le)
      (gapMatrix_clamp_le hB hE (by linarith : 0 ≤ R) (power_clamp_le F hB he he1 hlo hhi) gs)
    rw [gain_smul, hg] at hgain
    have hfinite := word_gain_le_cutoffSup F E hmem
    rw [gapWord_product] at hfinite
    have hpow := pow_le_pow_right₀ hR (show gs.length ≤ m-1 by omega)
    exact hgain.trans (mul_le_mul hpow hfinite
      (gain_nonneg (fun i => (F.left_pos i).le) (fun i => (F.right_pos i).le)
        (gapMatrix_nonnegative hB hE _)) (pow_nonneg (by linarith : 0 ≤ R) _))

end MissedUpdates.Matrices
