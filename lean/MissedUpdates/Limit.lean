import MissedUpdates.Periodic

open Matrix Filter
open scoped BigOperators Topology

namespace MissedUpdates.Matrices

variable {n : Type*} [Fintype n] [DecidableEq n]

theorem nat_ratio_sub_tendsto (c : ℕ) :
    Tendsto (fun k : ℕ => (k : ℝ)/(k-c : ℕ)) atTop (𝓝 1) := by
  have h := tendsto_natCast_div_add_atTop (-(c : ℝ))
  apply h.congr'
  filter_upwards [eventually_ge_atTop c] with k hk
  simp [Nat.cast_sub hk, sub_eq_add_neg]

theorem nat_ratio_add_tendsto (c : ℕ) :
    Tendsto (fun k : ℕ => (k : ℝ)/(k+c : ℕ)) atTop (𝓝 1) := by
  simpa [Nat.cast_add] using tendsto_natCast_div_add_atTop (c : ℝ)

theorem scaled_logRate_eventually_lower {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E)
    (hconv : ∀ i j, Tendsto (fun g : ℕ => (B^g) i j) atTop
      (𝓝 ((outer F.right F.left) i j)))
    (m : ℕ) {a : ℝ} (ha : a < Real.log (clusterSup F E m)) :
    ∀ᶠ k : ℕ in atTop, a < (k : ℝ)*logRate F E m k := by
  obtain ⟨b, hab, hbM⟩ := exists_between ha
  let t := Real.exp b
  have ht : 0 < t := Real.exp_pos b
  have hMpos : 0 < clusterSup F E m := by linarith [one_le_clusterSup F hB hE m]
  have htM : t < clusterSup F E m := by
    simpa [t, Real.exp_log hMpos] using Real.exp_lt_exp.mpr hbM
  obtain ⟨x, ⟨w, hm, hx⟩, htx⟩ :=
    exists_lt_of_lt_csSup (gainSet_nonempty F E m) htM
  have hw := witness_logRate_lower F hB hE hconv w hm ht (by simpa [hx] using htx)
  have hlim : Tendsto (fun k : ℕ => (k : ℝ)*(Real.log t/(k+w.length : ℕ)))
      atTop (𝓝 b) := by
    have h := (nat_ratio_add_tendsto w.length).mul_const (Real.log t)
    simpa [t, Real.log_exp, div_eq_mul_inv, mul_comm, mul_left_comm, mul_assoc] using h
  filter_upwards [hw, hlim.eventually_const_lt hab] with k hk hka
  exact hka.trans_le (mul_le_mul_of_nonneg_left hk (Nat.cast_nonneg k))

theorem scaled_logRate_eventually_upper {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E)
    (hconv : ∀ i j, Tendsto (fun g : ℕ => (B^g) i j) atTop
      (𝓝 ((outer F.right F.left) i j)))
    (m : ℕ) {b : ℝ} (hb : Real.log (clusterSup F E m) < b) :
    ∀ᶠ k : ℕ in atTop, (k : ℝ)*logRate F E m k < b := by
  let M := clusterSup F E m
  let d := (b-Real.log M)/(2*((m : ℝ)+1))
  let t := Real.exp d
  have hd : 0 < d := div_pos (sub_pos.mpr hb) (by positivity)
  have ht : 1 < t := by simpa [t] using Real.one_lt_exp_iff.mpr hd
  have hsmall : (m : ℝ)*Real.log t + Real.log M < b := by
    have hddef : d*(2*((m : ℝ)+1)) = b-Real.log M :=
      div_mul_cancel₀ _ (by positivity)
    have hm : 0 ≤ (m : ℝ) := Nat.cast_nonneg m
    rw [show Real.log t = d by simp [t]]
    nlinarith
  obtain ⟨q₀, hq₀⟩ := uniform_power_tail
    (fun i j => mul_pos (F.right_pos i) (F.left_pos j)) hconv (sub_pos.mpr ht)
  let q := max q₀ 1
  have hq : 0 < q := lt_of_lt_of_le (by norm_num) (le_max_right _ _)
  have htail : ∀ g ≥ q, EntrywiseLE (B^g) (t • outer F.right F.left) := by
    intro g hg i j
    have h := hq₀ g ((le_max_left _ _).trans hg) i j
    change (B^g) i j ≤ (1+(t-1))*(F.right i*F.left j) at h
    change (B^g) i j ≤ t*(F.right i*F.left j)
    linarith
  have hlim : Tendsto (fun k : ℕ =>
      (m : ℝ)*Real.log t + (k : ℝ)/(k-m*q : ℕ)*Real.log M) atTop
      (𝓝 ((m : ℝ)*Real.log t + Real.log M)) := by
    simpa using tendsto_const_nhds.add ((nat_ratio_sub_tendsto (m*q)).mul_const (Real.log M))
  filter_upwards [eventually_ge_atTop (m*q+1), hlim.eventually_lt_const hsmall] with k hk hkb
  have hu := mul_le_mul_of_nonneg_left (logRate_upper F hB hE hconv ht.le htail hk hq)
    (Nat.cast_nonneg k)
  have hkr : (k : ℝ) ≠ 0 := by exact_mod_cast (show k ≠ 0 by omega)
  have heq : (k : ℝ)*((m : ℝ)/(k : ℝ)*Real.log t + Real.log M/(k-m*q : ℕ)) =
      (m : ℝ)*Real.log t + (k : ℝ)/(k-m*q : ℕ)*Real.log M := by
    field_simp
    <;> ring
  exact (hu.trans_eq heq).trans_lt hkb

/-- The complete cluster law for the auxiliary log rate, with both limiting
inequalities proved from the actual protocol and finite-word witnesses. -/
theorem scaled_logRate_tendsto {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E)
    (hconv : ∀ i j, Tendsto (fun g : ℕ => (B^g) i j) atTop
      (𝓝 ((outer F.right F.left) i j))) (m : ℕ) :
    Tendsto (fun k : ℕ => (k : ℝ)*logRate F E m k) atTop
      (𝓝 (Real.log (clusterSup F E m))) := by
  exact tendsto_order.mpr ⟨
    fun _ ha => scaled_logRate_eventually_lower F hB hE hconv m ha,
    fun _ hb => scaled_logRate_eventually_upper F hB hE hconv m hb⟩

theorem positive_scaled_logRate_tendsto [Nonempty n]
    {B E : Matrix n n ℝ} (F : Frame B) (hB : ∀ i j, 0 < B i j)
    (hE : Nonnegative E) (m : ℕ) :
    Tendsto (fun k : ℕ => (k : ℝ)*logRate F E m k) atTop
      (𝓝 (Real.log (clusterSup F E m))) :=
  scaled_logRate_tendsto F (fun i j => (hB i j).le) hE (F.power_converges hB) m

end MissedUpdates.Matrices
