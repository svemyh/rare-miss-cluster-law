import MissedUpdates.NormGrowth

open Matrix Filter
open scoped BigOperators Topology Matrix.Norms.Elementwise

namespace MissedUpdates.Matrices

variable {n : Type*} [Fintype n] [DecidableEq n]

theorem wordProduct_smul (B E : Matrix n n ℝ) (lam : ℝ) (w : List Bool) :
    wordProduct (lam • B) (lam • E) w = lam^w.length • wordProduct B E w := by
  induction w with
  | nil => simp [wordProduct]
  | cons b w ih =>
    cases b <;> simp [wordProduct, ih, Matrix.smul_mul, Matrix.mul_smul, smul_smul,
      pow_succ, mul_comm]

theorem prefix_norm_root_smul (B E : Matrix n n ℝ) {lam : ℝ} (hlam : 0 < lam)
    (σ : ℕ → Bool) {N : ℕ} (hN : 0 < N) :
    ‖wordProduct (lam • B) (lam • E) (prefixWord σ N)‖^(1/(N : ℝ)) =
      lam * ‖wordProduct B E (prefixWord σ N)‖^(1/(N : ℝ)) := by
  rw [wordProduct_smul, norm_smul, Real.norm_eq_abs, abs_of_pos (pow_pos hlam _)]
  simp only [prefixWord, List.length_map, List.length_range]
  rw [Real.mul_rpow (pow_pos hlam _).le (norm_nonneg _), one_div,
    Real.pow_rpow_inv_natCast hlam.le (Nat.ne_of_gt hN)]

theorem rootPrefixSet_bddAbove {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m k N : ℕ) :
    BddAbove {x : ℝ | ∃ σ : ℕ → Bool, Admissible σ m k ∧
      ‖wordProduct B E (prefixWord σ N)‖^(1/(N : ℝ)) = x} := by
  refine ⟨(normPrefixSup B E m k N)^(1/(N : ℝ)), ?_⟩
  rintro x ⟨σ, hσ, rfl⟩
  apply Real.rpow_le_rpow (norm_nonneg _)
    (le_csSup (normPrefixSet_bddAbove F hB hE m k N) ⟨σ, hσ, rfl⟩)
  positivity

theorem rootPrefixSup_smul {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) {lam : ℝ} (hlam : 0 < lam)
    (m k : ℕ) {N : ℕ} (hN : 0 < N) :
    rootPrefixSup (lam • B) (lam • E) m k N = lam*rootPrefixSup B E m k N := by
  let S := {x : ℝ | ∃ σ : ℕ → Bool, Admissible σ m k ∧
    ‖wordProduct B E (prefixWord σ N)‖^(1/(N : ℝ)) = x}
  have hS : S.Nonempty := ⟨_, fun _ => true, all_success_admissible m k, rfl⟩
  have heq : {x : ℝ | ∃ σ : ℕ → Bool, Admissible σ m k ∧
      ‖wordProduct (lam • B) (lam • E) (prefixWord σ N)‖^(1/(N : ℝ)) = x} =
        (fun x => lam*x) '' S := by
    ext x
    constructor
    · rintro ⟨σ, hσ, rfl⟩
      refine ⟨_, ⟨σ, hσ, rfl⟩, ?_⟩
      exact (prefix_norm_root_smul B E hlam σ hN).symm
    · rintro ⟨y, ⟨σ, hσ, rfl⟩, rfl⟩
      exact ⟨σ, hσ, prefix_norm_root_smul B E hlam σ hN⟩
  unfold rootPrefixSup
  rw [heq]
  exact (Monotone.map_csSup_of_continuousAt
    (continuous_const.mul continuous_id).continuousAt
    (fun x y h => mul_le_mul_of_nonneg_left h hlam.le) hS
    (rootPrefixSet_bddAbove F hB hE m k N)).symm

theorem rootPrefixSup_isBounded {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m k : ℕ) :
    atTop.IsBoundedUnder (· ≤ ·) (rootPrefixSup B E m k) := by
  obtain ⟨C, hC⟩ : ∃ C : ℝ, ∀ᶠ N : ℕ in atTop, normPrefixLog B E m k N ≤ C :=
    (normPrefixLog_bounds F hB hE m k).1
  change ∃ C : ℝ, ∀ᶠ N : ℕ in atTop, rootPrefixSup B E m k N ≤ C
  refine ⟨Real.exp C, ?_⟩
  filter_upwards [hC] with N hN
  rw [root_sup_eq F hB hE]
  exact Real.exp_monotone hN

theorem rootPrefixSup_isCobounded {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m k : ℕ) :
    atTop.IsCoboundedUnder (· ≤ ·) (rootPrefixSup B E m k) := by
  apply isCoboundedUnder_le_of_le atTop (x := 0)
  intro N
  rw [root_sup_eq F hB hE]
  exact (Real.exp_pos _).le

theorem constrainedRate_smul {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) {lam : ℝ} (hlam : 0 < lam) (m k : ℕ) :
    constrainedRate (lam • B) (lam • E) m k = lam*constrainedRate B E m k := by
  have hmap := Monotone.map_limsup_of_continuousAt
    (fun x y h => mul_le_mul_of_nonneg_left h hlam.le) (rootPrefixSup B E m k)
    (continuous_const.mul continuous_id).continuousAt
    (rootPrefixSup_isBounded F hB hE m k) (rootPrefixSup_isCobounded F hB hE m k)
  unfold constrainedRate
  calc
    _ = limsup (fun N : ℕ => lam*rootPrefixSup B E m k N) atTop := by
      apply limsup_congr
      filter_upwards [eventually_gt_atTop 0] with N hN
      exact rootPrefixSup_smul F hB hE hlam m k hN
    _ = _ := hmap.symm

theorem original_rate_normalization {C D : Matrix n n ℝ} {lam : ℝ} (hlam : 0 < lam)
    (F : Frame (lam⁻¹ • C)) (hC : Nonnegative C) (hD : Nonnegative D) (m k : ℕ) :
    constrainedRate C D m k / lam = constrainedRate (lam⁻¹ • C) (lam⁻¹ • D) m k := by
  have hB : Nonnegative (lam⁻¹ • C) := fun i j =>
    _root_.mul_nonneg (inv_pos.mpr hlam).le (hC i j)
  have hE : Nonnegative (lam⁻¹ • D) := fun i j =>
    _root_.mul_nonneg (inv_pos.mpr hlam).le (hD i j)
  have h := constrainedRate_smul F hB hE hlam m k
  simp only [smul_smul, mul_inv_cancel₀ hlam.ne', one_smul] at h
  rw [h]
  field_simp

theorem original_cluster_limit [Nonempty n] {C D : Matrix n n ℝ} (hC : ∀ i j, 0 < C i j)
    (hD : Nonnegative D) {lam : ℝ} (hlam : 0 < lam) (F : Frame (lam⁻¹ • C)) (m : ℕ) :
    Tendsto (fun k : ℕ => (k : ℝ)*Real.log (constrainedRate C D m k / lam)) atTop
      (𝓝 (Real.log (clusterSup F (lam⁻¹ • D) m))) := by
  simp_rw [original_rate_normalization hlam F (fun i j => (hC i j).le) hD]
  exact constrainedRate_cluster_limit F
    (fun i j => mul_pos (inv_pos.mpr hlam) (hC i j))
    (fun i j => _root_.mul_nonneg (inv_pos.mpr hlam).le (hD i j)) m

end MissedUpdates.Matrices
