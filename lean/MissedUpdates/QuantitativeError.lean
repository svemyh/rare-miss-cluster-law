import MissedUpdates.Quantitative

open Matrix Filter
open scoped BigOperators Topology Matrix.Norms.Elementwise

namespace MissedUpdates.Matrices

variable {n : Type*} [Fintype n] [DecidableEq n] [Nonempty n]

theorem coefficient_error_bounds {B E : Matrix n n ℝ} (F : Frame B)
    (hB : ∀ i j, 0 < B i j) (hE : Nonnegative E) {m q k : ℕ} (hm : 1 ≤ m)
    (hq : 0 < q) (hk : m*(q+1) ≤ k) {e : ℝ} (ht : RelativeTail B (outer F.right F.left) q e) :
    -((m-1 : ℕ)*Real.log ((1+e)/(1-e))-Real.log (1-e)) ≤
        (k : ℝ)*Real.log (constrainedRate B E m k)-Real.log (clusterSup F E m) ∧
      (k : ℝ)*Real.log (constrainedRate B E m k)-Real.log (clusterSup F E m) ≤
        (m*q : ℕ)/(k-m*q : ℕ)*Real.log (clusterSup F E m)+(m : ℝ)*Real.log (1+e) := by
  have hB0 := fun i j => (hB i j).le
  rw [constrainedRate_eq_exp_logRate F hB0 hE m k, Real.log_exp]
  have hM : 0 < clusterSup F E m := by linarith [one_le_clusterSup F hB0 hE m]
  have hA : 0 < cutoffSup F E m q := by linarith [one_le_cutoffSup F E m q]
  have hR : 0 < (1+e)/(1-e) := div_pos (by linarith [ht.error_nonneg]) (by linarith [ht.error_lt_one])
  constructor
  · have hlo := finite_window_logRate_lower F hB0 hE hm hk ht
    have hcut := clusterSup_le_cutoff F hB0 hE hm ht.error_nonneg ht.error_lt_one
      (ht.lower q le_rfl) ht.upper
    have hlog := Real.log_le_log hM hcut
    rw [Real.log_mul (pow_pos hR _).ne' hA.ne', Real.log_pow] at hlog
    linarith
  · have hwidth : m*q+1 ≤ k := by nlinarith
    have hkmq : m*q ≤ k := by omega
    have hk0 : 0 < k := by omega
    have hu := mul_le_mul_of_nonneg_left
      (logRate_upper F hB0 hE (F.power_converges hB)
        (by linarith [ht.error_nonneg] : 1 ≤ 1+e) ht.upper hwidth hq) (Nat.cast_nonneg k)
    have hkr : (k : ℝ) ≠ 0 := by exact_mod_cast hk0.ne'
    have hL : (k-m*q : ℕ) ≠ 0 := by omega
    have heq : (k : ℝ)*((m : ℝ)/(k : ℝ)*Real.log (1+e)+
        Real.log (clusterSup F E m)/(k-m*q : ℕ))-Real.log (clusterSup F E m) =
        (m*q : ℕ)/(k-m*q : ℕ)*Real.log (clusterSup F E m)+(m : ℝ)*Real.log (1+e) := by
      rw [Nat.cast_sub hkmq]
      have hLr : (k : ℝ)-(m*q : ℕ) ≠ 0 := by
        rw [← Nat.cast_sub hkmq]
        exact_mod_cast hL
      field_simp [hkr, hLr]
      <;> ring
    linarith

theorem small_relative_log_error {e : ℝ} (he : 0 ≤ e) (hehalf : e ≤ 1/2) :
    Real.log (1+e) ≤ e ∧ -Real.log (1-e) ≤ 2*e := by
  have hepos : 0 < 1-e := by linarith
  constructor
  · have h := Real.log_le_sub_one_of_pos (by linarith : 0 < 1+e)
    linarith
  · have h := Real.log_le_sub_one_of_pos (inv_pos.mpr hepos)
    rw [Real.log_inv] at h
    have hi : (1-e)⁻¹*(1-e) = 1 := inv_mul_cancel₀ hepos.ne'
    have hn := _root_.mul_nonneg he (by linarith : 0 ≤ 1-2*e)
    have hb : (1-e)⁻¹-1 ≤ 2*e := by
      apply (mul_le_mul_iff_of_pos_right hepos).mp
      nlinarith
    linarith

theorem cutoff_log_upper {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) {m q : ℕ} (hm : 1 ≤ m)
    {e : ℝ} (ht : RelativeTail B (outer F.right F.left) q e) :
    Real.log (clusterSup F E m) ≤
      cutoffSup F E m q-1+(m-1 : ℕ)*(((1+e)/(1-e))-1) := by
  have hM : 0 < clusterSup F E m := by linarith [one_le_clusterSup F hB hE m]
  have hA : 0 < cutoffSup F E m q := by linarith [one_le_cutoffSup F E m q]
  have hR : 0 < (1+e)/(1-e) := div_pos (by linarith [ht.error_nonneg]) (by linarith [ht.error_lt_one])
  have h := Real.log_le_log hM (clusterSup_le_cutoff F hB hE hm ht.error_nonneg ht.error_lt_one
    (ht.lower q le_rfl) ht.upper)
  rw [Real.log_mul (pow_pos hR _).ne' hA.ne', Real.log_pow] at h
  have h₁ := Real.log_le_sub_one_of_pos hA
  have h₂ := mul_le_mul_of_nonneg_left (Real.log_le_sub_one_of_pos hR) (Nat.cast_nonneg (m-1))
  linarith

theorem cone_log_upper {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) {c : ℝ} (hc : 1 ≤ c)
    (hEr : E *ᵥ F.right ≤ c • F.right) (m : ℕ) :
    Real.log (clusterSup F E m) ≤ (m : ℝ)*(c-1) := by
  have hM : 0 < clusterSup F E m := by linarith [one_le_clusterSup F hB hE m]
  have hbound : clusterSup F E m ≤ c^m := by
    apply csSup_le (gainSet_nonempty F E m)
    rintro x ⟨w, hw, rfl⟩
    exact (word_gain_bound F hB hE hc hEr w).trans (pow_le_pow_right₀ hc hw)
  have hlog := Real.log_le_log hM hbound
  rw [Real.log_pow] at hlog
  exact hlog.trans (mul_le_mul_of_nonneg_left
    (Real.log_le_sub_one_of_pos (by linarith : 0 < c)) (Nat.cast_nonneg m))

theorem simplified_error_bounds {B E : Matrix n n ℝ} (F : Frame B)
    (hB : ∀ i j, 0 < B i j) (hE : Nonnegative E) {m q k : ℕ} (hm : 1 ≤ m)
    (hq : 0 < q) (hk : m*(q+1) ≤ k) (hk2 : 2*(m*q) ≤ k)
    {e : ℝ} (ht : RelativeTail B (outer F.right F.left) q e) (hehalf : e ≤ 1/2)
    {H : ℝ} (hH : Real.log (clusterSup F E m) ≤ H) :
    -((3*(m : ℝ)-1)*e) ≤
        (k : ℝ)*Real.log (constrainedRate B E m k)-Real.log (clusterSup F E m) ∧
      (k : ℝ)*Real.log (constrainedRate B E m k)-Real.log (clusterSup F E m) ≤
        2*(m*q : ℕ)*H/(k : ℝ)+(m : ℝ)*e := by
  obtain ⟨hlo, hhi⟩ := coefficient_error_bounds F hB hE hm hq hk ht
  obtain ⟨hlt, hle⟩ := small_relative_log_error ht.error_nonneg hehalf
  have hlogM : 0 ≤ Real.log (clusterSup F E m) :=
    Real.log_nonneg (one_le_clusterSup F (fun i j => (hB i j).le) hE m)
  have hlogR : Real.log ((1+e)/(1-e)) ≤ 3*e := by
    rw [Real.log_div (by linarith [ht.error_nonneg] : 1+e ≠ 0)
      (by linarith [ht.error_lt_one] : 1-e ≠ 0)]
    linarith
  constructor
  · have hx := mul_le_mul_of_nonneg_left hlogR (Nat.cast_nonneg (m-1))
    rw [Nat.cast_sub hm] at hx hlo
    push_cast at hx hlo
    nlinarith
  · have hk0 : 0 < k := by nlinarith
    have hkmq : m*q ≤ k := by omega
    have hwidth : m*q+1 ≤ k := by nlinarith
    have hL : 0 < k-m*q := by omega
    have hkreal : (0 : ℝ) < k := by exact_mod_cast hk0
    have hLreal : (0 : ℝ) < (k-m*q : ℕ) := by exact_mod_cast hL
    have hk2real : (2 : ℝ)*(m*q : ℕ) ≤ (k : ℝ) := by exact_mod_cast hk2
    have hkrange : (0 : ℝ) ≤ (k : ℝ)-2*(m*q : ℕ) := sub_nonneg.mpr hk2real
    have hcoef : (m*q : ℕ)/(k-m*q : ℕ) ≤ (2*(m*q : ℕ))/(k : ℝ) := by
      apply (div_le_div_iff₀ hLreal hkreal).mpr
      rw [Nat.cast_sub hkmq]
      nlinarith [_root_.mul_nonneg (Nat.cast_nonneg (m*q)) hkrange]
    have hp := mul_le_mul hcoef hH hlogM (div_nonneg (by positivity) (Nat.cast_nonneg k))
    have he := mul_le_mul_of_nonneg_left hlt (Nat.cast_nonneg m)
    apply hhi.trans
    simpa [div_mul_eq_mul_div] using add_le_add hp he

/-- A finite list of scalar checks yields a certified accuracy guarantee for all later windows. -/
theorem all_later_windows_accuracy {B E : Matrix n n ℝ} (F : Frame B)
    (hB : ∀ i j, 0 < B i j) (hE : Nonnegative E) {m q k0 : ℕ} (hm : 1 ≤ m)
    (hq : 0 < q) (hk0 : m*(q+1) ≤ k0) (hk02 : 2*(m*q) ≤ k0)
    {e : ℝ} (ht : RelativeTail B (outer F.right F.left) q e) (hehalf : e ≤ 1/2)
    {H delta : ℝ} (hH : Real.log (clusterSup F E m) ≤ H) (hdelta : 0 < delta)
    (he : 6*(m : ℝ)*e ≤ delta) (hsize : 4*(m*q : ℕ)*H ≤ (k0 : ℝ)*delta) :
    ∀ k ≥ k0, |(k : ℝ)*Real.log (constrainedRate B E m k)-Real.log (clusterSup F E m)| ≤ delta := by
  intro k hk
  obtain ⟨hlo, hhi⟩ := simplified_error_bounds F hB hE hm hq (hk0.trans hk) (hk02.trans hk) ht hehalf hH
  have hkpos : 0 < k := by nlinarith
  have hkreal : (0 : ℝ) < k := by exact_mod_cast hkpos
  have hscale : (k0 : ℝ)*delta ≤ (k : ℝ)*delta :=
    mul_le_mul_of_nonneg_right (by exact_mod_cast hk) hdelta.le
  have hfrac : 2*(m*q : ℕ)*H/(k : ℝ) ≤ delta/2 := by
    apply (div_le_iff₀ hkreal).mpr
    nlinarith
  apply abs_le.mpr
  constructor
  · nlinarith [ht.error_nonneg]
  · linarith

end MissedUpdates.Matrices
