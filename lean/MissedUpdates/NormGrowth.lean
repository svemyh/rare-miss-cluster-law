import MissedUpdates.NormComparison
import MissedUpdates.Limit
import Mathlib.Topology.Algebra.Order.LiminfLimsup
import Mathlib.Analysis.SpecialFunctions.Pow.Continuity

open Matrix Filter
open scoped BigOperators Topology Matrix.Norms.Elementwise

namespace MissedUpdates.Matrices

variable {n : Type*} [Fintype n] [DecidableEq n]

def normPrefixSet (B E : Matrix n n ℝ) (m k N : ℕ) : Set ℝ :=
  {x | ∃ σ : ℕ → Bool, Admissible σ m k ∧ ‖wordProduct B E (prefixWord σ N)‖ = x}

noncomputable def normPrefixSup (B E : Matrix n n ℝ) (m k N : ℕ) : ℝ :=
  sSup (normPrefixSet B E m k N)

noncomputable def normPrefixLog (B E : Matrix n n ℝ) (m k N : ℕ) : ℝ :=
  Real.log (normPrefixSup B E m k N)/(N : ℝ)

noncomputable def rootPrefixSup (B E : Matrix n n ℝ) (m k N : ℕ) : ℝ :=
  sSup {x : ℝ | ∃ σ : ℕ → Bool, Admissible σ m k ∧
    ‖wordProduct B E (prefixWord σ N)‖ ^ (1/(N : ℝ)) = x}

/-- The literal norm-root definition, with the supremum inside the limsup. -/
noncomputable def constrainedRate (B E : Matrix n n ℝ) (m k : ℕ) : ℝ :=
  limsup (rootPrefixSup B E m k) atTop

theorem normPrefixSet_nonempty (B E : Matrix n n ℝ) (m k N : ℕ) :
    (normPrefixSet B E m k N).Nonempty :=
  ⟨_, fun _ => true, all_success_admissible m k, rfl⟩

theorem normPrefixSet_nonneg (B E : Matrix n n ℝ) (m k N : ℕ) :
    ∀ x ∈ normPrefixSet B E m k N, 0 ≤ x := by
  rintro x ⟨σ, _, rfl⟩; exact norm_nonneg _

theorem normPrefixSet_bddAbove {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m k N : ℕ) :
    BddAbove (normPrefixSet B E m k N) := by
  obtain ⟨K, L, hK, _, hcomp⟩ := exists_norm_gain_comparison F
  refine ⟨K*prefixGainSup F E m k N, ?_⟩
  rintro x ⟨σ, hσ, rfl⟩
  exact (hcomp _ (wordProduct_nonnegative hB hE _)).1.trans
    (mul_le_mul_of_nonneg_left (prefix_gain_le_sup F hB hE hσ) (by linarith))

theorem norm_gain_sup_comparison {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) {K L : ℝ} (hK : 1 ≤ K) (hL : 1 ≤ L)
    (hcomp : ∀ A : Matrix n n ℝ, Nonnegative A →
      ‖A‖ ≤ K*gain F.left F.right A ∧ gain F.left F.right A ≤ L*‖A‖) (m k N : ℕ) :
    normPrefixSup B E m k N ≤ K*prefixGainSup F E m k N ∧
      prefixGainSup F E m k N ≤ L*normPrefixSup B E m k N := by
  constructor
  · apply csSup_le (normPrefixSet_nonempty B E m k N)
    rintro x ⟨σ, hσ, rfl⟩
    exact (hcomp _ (wordProduct_nonnegative hB hE _)).1.trans
      (mul_le_mul_of_nonneg_left (prefix_gain_le_sup F hB hE hσ) (by linarith))
  · apply prefixGainSup_le F E
    intro σ hσ
    exact (hcomp _ (wordProduct_nonnegative hB hE _)).2.trans
      (mul_le_mul_of_nonneg_left
        (le_csSup (normPrefixSet_bddAbove F hB hE m k N) ⟨σ, hσ, rfl⟩) (by linarith))

theorem normPrefixSup_pos {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m k N : ℕ) : 0 < normPrefixSup B E m k N := by
  obtain ⟨K, L, hK, hL, hcomp⟩ := exists_norm_gain_comparison F
  have h := (norm_gain_sup_comparison F hB hE hK hL hcomp m k N).2
  have h1 := prefixGainSup_ge_one F hB hE m k N
  by_contra hn
  have hnon : normPrefixSup B E m k N ≤ 0 := le_of_not_gt hn
  nlinarith

theorem normLog_comparison {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m k : ℕ) :
    ∃ K L : ℝ, 1 ≤ K ∧ 1 ≤ L ∧ ∀ N : ℕ,
      normPrefixLog B E m k N ≤ Real.log K/(N : ℝ)+prefixLog F E m k N ∧
      prefixLog F E m k N ≤ Real.log L/(N : ℝ)+normPrefixLog B E m k N := by
  obtain ⟨K, L, hK, hL, hcomp⟩ := exists_norm_gain_comparison F
  refine ⟨K, L, hK, hL, ?_⟩
  intro N
  have hp : 0 < prefixGainSup F E m k N := by linarith [prefixGainSup_ge_one F hB hE m k N]
  have hn := normPrefixSup_pos F hB hE m k N
  obtain ⟨h₁, h₂⟩ := norm_gain_sup_comparison F hB hE hK hL hcomp m k N
  have hl₁ := div_le_div_of_nonneg_right (Real.log_le_log hn h₁) (Nat.cast_nonneg N)
  have hl₂ := div_le_div_of_nonneg_right (Real.log_le_log hp h₂) (Nat.cast_nonneg N)
  rw [Real.log_mul (by linarith : K ≠ 0) hp.ne', add_div] at hl₁
  rw [Real.log_mul (by linarith : L ≠ 0) hn.ne', add_div] at hl₂
  exact ⟨hl₁, hl₂⟩

theorem limsup_le_with_vanishing_error {u v e : ℕ → ℝ}
    (hu : atTop.IsCoboundedUnder (· ≤ ·) u)
    (hv : atTop.IsBoundedUnder (· ≤ ·) v) (hv' : atTop.IsCoboundedUnder (· ≤ ·) v)
    (he : Tendsto e atTop (𝓝 0)) (h : ∀ N, u N ≤ e N+v N) :
    limsup u atTop ≤ limsup v atTop := by
  have h₁ := limsup_le_limsup (Filter.Eventually.of_forall h) hu
    (isBoundedUnder_le_add he.isBoundedUnder_le hv)
  have h₂ := limsup_add_le (u := e) (v := v) he.isBoundedUnder_ge he.isBoundedUnder_le hv' hv
  simpa [he.limsup_eq] using h₁.trans h₂

theorem normPrefixLog_bounds {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m k : ℕ) :
    atTop.IsBoundedUnder (· ≤ ·) (normPrefixLog B E m k) ∧
      atTop.IsCoboundedUnder (· ≤ ·) (normPrefixLog B E m k) := by
  obtain ⟨K, L, _, _, hcomp⟩ := normLog_comparison F hB hE m k
  have hK := (tendsto_const_div_atTop_nhds_zero_nat (Real.log K)).eventually_le_const (by norm_num : (0 : ℝ) < 1)
  have hL := (tendsto_const_div_atTop_nhds_zero_nat (Real.log L)).eventually_le_const (by norm_num : (0 : ℝ) < 1)
  constructor
  · obtain ⟨C, _, hC⟩ := prefixLog_bounded F hB hE m k
    change ∃ a : ℝ, ∀ᶠ N : ℕ in atTop, normPrefixLog B E m k N ≤ a
    refine ⟨C+1, ?_⟩
    filter_upwards [hK] with N hN
    have h := (hcomp N).1
    linarith [hC N]
  · apply isCoboundedUnder_le_of_eventually_le atTop (x := -1)
    filter_upwards [hL] with N hN
    have h := (hcomp N).2
    linarith [prefixLog_nonneg F hB hE m k N]

theorem norm_logRate_eq {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m k : ℕ) :
    limsup (normPrefixLog B E m k) atTop = logRate F E m k := by
  obtain ⟨K, L, _, _, hcomp⟩ := normLog_comparison F hB hE m k
  obtain ⟨hn, hn'⟩ := normPrefixLog_bounds F hB hE m k
  apply le_antisymm
  · exact limsup_le_with_vanishing_error hn' (prefixLog_isBounded F hB hE m k)
      (prefixLog_isCobounded F hB hE m k) (tendsto_const_div_atTop_nhds_zero_nat (Real.log K))
      (fun N => (hcomp N).1)
  · exact limsup_le_with_vanishing_error (prefixLog_isCobounded F hB hE m k) hn hn'
      (tendsto_const_div_atTop_nhds_zero_nat (Real.log L)) (fun N => (hcomp N).2)

theorem root_sup_eq {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m k N : ℕ) :
    rootPrefixSup B E m k N = Real.exp (normPrefixLog B E m k N) := by
  unfold rootPrefixSup
  have hpos := normPrefixSup_pos F hB hE m k N
  have hset : {x : ℝ | ∃ σ : ℕ → Bool, Admissible σ m k ∧
      ‖wordProduct B E (prefixWord σ N)‖ ^ (1/(N : ℝ)) = x} =
      (fun x : ℝ => x^(1/(N : ℝ))) '' normPrefixSet B E m k N := by
    ext x
    constructor
    · rintro ⟨σ, hσ, rfl⟩; exact ⟨_, ⟨σ, hσ, rfl⟩, rfl⟩
    · rintro ⟨y, ⟨σ, hσ, rfl⟩, rfl⟩; exact ⟨σ, hσ, rfl⟩
  rw [hset, ← MonotoneOn.map_csSup_of_continuousWithinAt
    (Real.continuousAt_rpow_const _ (1/(N : ℝ)) (Or.inl hpos.ne')).continuousWithinAt
    (fun x hx y _ hxy => Real.rpow_le_rpow (normPrefixSet_nonneg B E m k N x hx) hxy
      (by positivity : 0 ≤ 1/(N : ℝ)))
    (normPrefixSet_nonempty B E m k N) (normPrefixSet_bddAbove F hB hE m k N)]
  change (normPrefixSup B E m k N)^(1/(N : ℝ)) = Real.exp (normPrefixLog B E m k N)
  rw [Real.rpow_def_of_pos hpos]
  simp [normPrefixLog, normPrefixSup, div_eq_mul_inv]

/-- Equality between the literal norm-root rate and the auxiliary gain rate. -/
theorem constrainedRate_eq_exp_logRate {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m k : ℕ) :
    constrainedRate B E m k = Real.exp (logRate F E m k) := by
  unfold constrainedRate
  change limsup (fun N : ℕ => rootPrefixSup B E m k N) atTop = Real.exp (logRate F E m k)
  simp_rw [root_sup_eq F hB hE m k]
  have h := Monotone.map_limsup_of_continuousAt Real.exp_monotone
    (normPrefixLog B E m k) Real.continuous_exp.continuousAt
    (normPrefixLog_bounds F hB hE m k).1 (normPrefixLog_bounds F hB hE m k).2
  simpa [Function.comp_def, norm_logRate_eq F hB hE m k] using h.symm

theorem constrainedRate_cluster_limit [Nonempty n]
    {B E : Matrix n n ℝ} (F : Frame B) (hB : ∀ i j, 0 < B i j)
    (hE : Nonnegative E) (m : ℕ) :
    Tendsto (fun k : ℕ => (k : ℝ)*Real.log (constrainedRate B E m k)) atTop
      (𝓝 (Real.log (clusterSup F E m))) := by
  simpa [constrainedRate_eq_exp_logRate F (fun i j => (hB i j).le) hE, Real.log_exp] using
    positive_scaled_logRate_tendsto F hB hE m

end MissedUpdates.Matrices
