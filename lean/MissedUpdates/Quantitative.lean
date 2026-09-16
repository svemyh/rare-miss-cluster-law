import MissedUpdates.Cutoff

open Matrix Filter
open scoped BigOperators Topology Matrix.Norms.Elementwise

namespace MissedUpdates.Matrices

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Uniform two-sided entrywise tail data; no product-growth conclusion is a field. -/
structure RelativeTail (B P : Matrix n n ℝ) (q : ℕ) (e : ℝ) : Prop where
  error_nonneg : 0 ≤ e
  error_lt_one : e < 1
  lower : ∀ g ≥ q, EntrywiseLE ((1-e) • P) (B^g)
  upper : ∀ g ≥ q, EntrywiseLE (B^g) ((1+e) • P)

theorem positive_relative_tail_exists [Nonempty n] {B : Matrix n n ℝ}
    (F : Frame B) (hB : ∀ i j, 0 < B i j) {e : ℝ} (he : 0 < e) (he1 : e < 1) :
    ∃ q : ℕ, 0 < q ∧ RelativeTail B (outer F.right F.left) q e := by
  have hconv := F.power_converges hB
  have each : ∀ i j, ∀ᶠ g : ℕ in atTop,
      (1-e)*(F.right i*F.left j) ≤ (B^g) i j := by
    intro i j
    apply (hconv i j).eventually_const_le
    change (1-e)*(F.right i*F.left j) < F.right i*F.left j
    nlinarith [mul_pos (F.right_pos i) (F.left_pos j)]
  have hall := Filter.eventually_all.mpr (fun i => Filter.eventually_all.mpr (each i))
  obtain ⟨qlo, hqlo⟩ := Filter.eventually_atTop.mp hall
  obtain ⟨qhi, hqhi⟩ := uniform_power_tail
    (fun i j => mul_pos (F.right_pos i) (F.left_pos j)) hconv he
  refine ⟨max 1 (max qlo qhi), by omega, he.le, he1, ?_, ?_⟩
  · intro g hg i j
    exact hqlo g (by omega) i j
  · intro g hg i j
    exact hqhi g (by omega) i j

/-- An attaining finite-cutoff word gives an actual admissible period-k witness. -/
theorem cutoff_period_witness {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) {m q k : ℕ} (hm : 1 ≤ m)
    (hk : m*(q+1) ≤ k) {e : ℝ} (ht : RelativeTail B (outer F.right F.left) q e) :
    ∃ v : List Bool, v.length = k ∧ v.count false ≤ m ∧
      ((1-e)*cutoffSup F E m q) • F.right ≤ wordProduct B E v *ᵥ F.right := by
  obtain ⟨w, hw, hgain⟩ := cutoffSup_attained F E m q
  obtain ⟨hmiss, hlen⟩ := cutoffWord_bounds hw
  have hmq : (m-1)*q+q = m*q := by
    calc
      _ = (m-1+1)*q := by ring
      _ = m*q := by rw [Nat.sub_add_cancel hm]
  have hgap : q ≤ k-w.length := by
    simp only [Nat.mul_add, Nat.mul_one] at hk
    omega
  have hwk : w.length ≤ k := by
    simp only [Nat.mul_add, Nat.mul_one] at hk
    omega
  let v := w ++ List.replicate (k-w.length) true
  have hv : v.length = k := by simp [v]; omega
  have hvm : v.count false ≤ m := by simpa [v, List.count_replicate] using hmiss
  have hvprod : wordProduct B E v = B^(k-w.length)*wordProduct B E w := by
    simp [v, wordProduct_append, wordProduct_true]
  have hew := mul_mono_right (ht.lower _ hgap) (wordProduct_nonnegative hB hE w)
  have hvec : (((1-e) • outer F.right F.left)*wordProduct B E w) *ᵥ F.right ≤
      (B^(k-w.length)*wordProduct B E w) *ᵥ F.right := by
    intro i
    exact Finset.sum_le_sum (fun j _ => mul_le_mul_of_nonneg_right (hew i j) (F.right_pos j).le)
  have heq : (((1-e) • outer F.right F.left)*wordProduct B E w) *ᵥ F.right =
      ((1-e)*cutoffSup F E m q) • F.right := by
    rw [Matrix.smul_mul, Matrix.smul_mulVec, ← Matrix.mulVec_mulVec, outer_mulVec]
    change (1-e) • (gain F.left F.right (wordProduct B E w) • F.right) = _
    rw [hgain, smul_smul]
  rw [heq] at hvec
  exact ⟨v, hv, hvm, by simpa only [hvprod] using hvec⟩

theorem finite_window_logRate_lower {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) {m q k : ℕ} (hm : 1 ≤ m)
    (hk : m*(q+1) ≤ k) {e : ℝ} (ht : RelativeTail B (outer F.right F.left) q e) :
    Real.log (cutoffSup F E m q)+Real.log (1-e) ≤ (k : ℝ)*logRate F E m k := by
  obtain ⟨v, hv, hvm, hvr⟩ := cutoff_period_witness F hB hE hm hk ht
  have hk0 : 0 < k := by nlinarith
  have hA : 0 < cutoffSup F E m q := by linarith [one_le_cutoffSup F E m q]
  have he : 0 < 1-e := sub_pos.mpr ht.error_lt_one
  have h := periodic_logRate_lower F hB hE v (m := m) (k := k)
    (by omega) (by omega) hvm (mul_pos he hA) hvr
  rw [hv] at h
  have hh := (div_le_iff₀ (by exact_mod_cast hk0 : (0 : ℝ) < k)).mp h
  simpa [Real.log_mul he.ne' hA.ne', mul_comm, add_comm] using hh

theorem finite_window_logRate_upper [Nonempty n] {B E : Matrix n n ℝ} (F : Frame B)
    (hB : ∀ i j, 0 < B i j) (hE : Nonnegative E) {m q k : ℕ} (hm : 1 ≤ m)
    (hq : 0 < q) (hk : m*(q+1) ≤ k) {e : ℝ} (ht : RelativeTail B (outer F.right F.left) q e) :
    (k : ℝ)*logRate F E m k ≤
      (k : ℝ)/(k-m*q : ℕ)*(Real.log (cutoffSup F E m q)+
        (m-1 : ℕ)*Real.log ((1+e)/(1-e)))+(m : ℝ)*Real.log (1+e) := by
  have hB0 := fun i j => (hB i j).le
  have hwidth : m*q+1 ≤ k := by nlinarith
  have hk0 : 0 < k := by nlinarith
  have hL : 0 < k-m*q := by omega
  have hA : 0 < cutoffSup F E m q := by linarith [one_le_cutoffSup F E m q]
  have hM : 0 < clusterSup F E m := by linarith [one_le_clusterSup F hB0 hE m]
  have hR : 0 < (1+e)/(1-e) := div_pos (by linarith [ht.error_nonneg]) (by linarith [ht.error_lt_one])
  have hbound := clusterSup_le_cutoff F hB0 hE hm ht.error_nonneg ht.error_lt_one
    (ht.lower q le_rfl) ht.upper
  have hlog := Real.log_le_log hM hbound
  rw [Real.log_mul (pow_pos hR _).ne' hA.ne', Real.log_pow] at hlog
  have hu := logRate_upper F hB0 hE (F.power_converges hB)
    (by linarith [ht.error_nonneg] : 1 ≤ 1+e) ht.upper hwidth hq
  have hu' := mul_le_mul_of_nonneg_left (hu.trans
    (add_le_add le_rfl (div_le_div_of_nonneg_right hlog (by positivity : (0 : ℝ) ≤ (k-m*q : ℕ)))))
    (Nat.cast_nonneg k)
  have hkr : (k : ℝ) ≠ 0 := by exact_mod_cast hk0.ne'
  refine hu'.trans_eq ?_
  field_simp [hkr]
  <;> ring

/-- Two-sided computable bounds for the literal constrained norm-growth rate. -/
theorem finite_window_rate_bounds [Nonempty n] {B E : Matrix n n ℝ} (F : Frame B)
    (hB : ∀ i j, 0 < B i j) (hE : Nonnegative E) {m q k : ℕ} (hm : 1 ≤ m)
    (hq : 0 < q) (hk : m*(q+1) ≤ k) {e : ℝ} (ht : RelativeTail B (outer F.right F.left) q e) :
    max 0 (Real.log (cutoffSup F E m q)+Real.log (1-e)) ≤
        (k : ℝ)*Real.log (constrainedRate B E m k) ∧
      (k : ℝ)*Real.log (constrainedRate B E m k) ≤
        (k : ℝ)/(k-m*q : ℕ)*(Real.log (cutoffSup F E m q)+
          (m-1 : ℕ)*Real.log ((1+e)/(1-e)))+(m : ℝ)*Real.log (1+e) := by
  rw [constrainedRate_eq_exp_logRate F (fun i j => (hB i j).le) hE m k, Real.log_exp]
  refine ⟨max_le ?_ (finite_window_logRate_lower F (fun i j => (hB i j).le) hE hm hk ht),
    finite_window_logRate_upper F hB hE hm hq hk ht⟩
  exact _root_.mul_nonneg (Nat.cast_nonneg k) (logRate_nonneg F (fun i j => (hB i j).le) hE m k)

theorem original_finite_window_rate_bounds [Nonempty n] {C D : Matrix n n ℝ}
    (hC : ∀ i j, 0 < C i j) (hD : Nonnegative D) {lam : ℝ} (hlam : 0 < lam)
    (F : Frame (lam⁻¹ • C)) {m q k : ℕ} (hm : 1 ≤ m) (hq : 0 < q) (hk : m*(q+1) ≤ k)
    {e : ℝ} (ht : RelativeTail (lam⁻¹ • C) (outer F.right F.left) q e) :
    max 0 (Real.log (cutoffSup F (lam⁻¹ • D) m q)+Real.log (1-e)) ≤
        (k : ℝ)*Real.log (constrainedRate C D m k / lam) ∧
      (k : ℝ)*Real.log (constrainedRate C D m k / lam) ≤
        (k : ℝ)/(k-m*q : ℕ)*(Real.log (cutoffSup F (lam⁻¹ • D) m q)+
          (m-1 : ℕ)*Real.log ((1+e)/(1-e)))+(m : ℝ)*Real.log (1+e) := by
  rw [original_rate_normalization hlam F (fun i j => (hC i j).le) hD m k]
  exact finite_window_rate_bounds F (fun i j => mul_pos (inv_pos.mpr hlam) (hC i j))
    (fun i j => _root_.mul_nonneg (inv_pos.mpr hlam).le (hD i j)) hm hq hk ht

end MissedUpdates.Matrices
