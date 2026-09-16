import MissedUpdates.Assembly
import Mathlib.Topology.Order.LiminfLimsup
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecificLimits.Basic

open Matrix Filter
open scoped BigOperators Topology

namespace MissedUpdates.Matrices

variable {n : Type*} [Fintype n] [DecidableEq n]

def prefixGainSet {B : Matrix n n ℝ} (F : Frame B) (E : Matrix n n ℝ)
    (m k N : ℕ) : Set ℝ :=
  {x | ∃ σ : ℕ → Bool, Admissible σ m k ∧
    gain F.left F.right (wordProduct B E (prefixWord σ N)) = x}

noncomputable def prefixGainSup {B : Matrix n n ℝ} (F : Frame B)
    (E : Matrix n n ℝ) (m k N : ℕ) : ℝ := sSup (prefixGainSet F E m k N)

noncomputable def prefixLog {B : Matrix n n ℝ} (F : Frame B)
    (E : Matrix n n ℝ) (m k N : ℕ) : ℝ := Real.log (prefixGainSup F E m k N) / N

/-- Auxiliary log rate of the actual infinite sliding-window language. Its
equivalence to norm growth is a separate obligation, not part of this definition. -/
noncomputable def logRate {B : Matrix n n ℝ} (F : Frame B)
    (E : Matrix n n ℝ) (m k : ℕ) : ℝ := limsup (prefixLog F E m k) atTop

theorem all_success_admissible (m k : ℕ) : Admissible (fun _ => true) m k := by
  intro s; simp

theorem prefixGainSet_one {B : Matrix n n ℝ} (F : Frame B) (E : Matrix n n ℝ)
    (m k N : ℕ) : 1 ∈ prefixGainSet F E m k N := by
  refine ⟨fun _ => true, all_success_admissible m k, ?_⟩
  have hw : prefixWord (fun _ => true) N = List.replicate N true := by simp [prefixWord]
  rw [hw, wordProduct_true]
  simp [gain, pow_mulVec_fixed B F.right F.right_fixed N, F.pairing_one]

theorem prefixGainSet_bddAbove {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m k N : ℕ) :
    BddAbove (prefixGainSet F E m k N) := by
  apply (gainSet_bddAbove F hB hE N).mono
  rintro x ⟨σ, _, rfl⟩
  refine ⟨prefixWord σ N, ?_, rfl⟩
  simpa [prefixWord] using List.count_le_length (a := false) (l := prefixWord σ N)

theorem prefixGainSup_ge_one {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m k N : ℕ) :
    1 ≤ prefixGainSup F E m k N :=
  le_csSup (prefixGainSet_bddAbove F hB hE m k N) (prefixGainSet_one F E m k N)

theorem prefix_gain_le_sup {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E)
    {σ : ℕ → Bool} {m k N : ℕ} (hσ : Admissible σ m k) :
    gain F.left F.right (wordProduct B E (prefixWord σ N)) ≤ prefixGainSup F E m k N :=
  le_csSup (prefixGainSet_bddAbove F hB hE m k N) ⟨σ, hσ, rfl⟩

theorem prefixGainSup_le {B : Matrix n n ℝ} (F : Frame B) (E : Matrix n n ℝ)
    {m k N : ℕ} {a : ℝ}
    (h : ∀ σ, Admissible σ m k →
      gain F.left F.right (wordProduct B E (prefixWord σ N)) ≤ a) :
    prefixGainSup F E m k N ≤ a := by
  apply csSup_le ⟨1, prefixGainSet_one F E m k N⟩
  rintro x ⟨σ, hσ, rfl⟩
  exact h σ hσ

theorem prefixLog_nonneg {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m k N : ℕ) :
    0 ≤ prefixLog F E m k N :=
  div_nonneg (Real.log_nonneg (prefixGainSup_ge_one F hB hE m k N)) (Nat.cast_nonneg N)

theorem prefixLog_bounded {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m k : ℕ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ N, prefixLog F E m k N ≤ C := by
  obtain ⟨c, hc, hEr⟩ := exists_miss_cone_bound hE F.right F.right_pos
  refine ⟨Real.log c, Real.log_nonneg hc, ?_⟩
  intro N
  by_cases hN : N = 0
  · simp [prefixLog, hN, Real.log_nonneg hc]
  have hp : (0 : ℝ) < N := by exact_mod_cast Nat.pos_of_ne_zero hN
  have hsup : prefixGainSup F E m k N ≤ c^N := by
    apply prefixGainSup_le F E
    intro σ _
    exact (word_gain_bound F hB hE hc hEr _).trans (pow_le_pow_right₀ hc
      (by simpa [prefixWord] using List.count_le_length (a := false) (l := prefixWord σ N)))
  have hl := Real.log_le_log (by linarith [prefixGainSup_ge_one F hB hE m k N]) hsup
  rw [Real.log_pow] at hl
  exact (div_le_iff₀ hp).mpr (by simpa [mul_comm] using hl)

theorem prefixLog_isBounded {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m k : ℕ) :
    atTop.IsBoundedUnder (· ≤ ·) (prefixLog F E m k) := by
  obtain ⟨C, _, hC⟩ := prefixLog_bounded F hB hE m k
  change ∃ C : ℝ, ∀ᶠ N : ℕ in atTop, prefixLog F E m k N ≤ C
  exact ⟨C, Filter.Eventually.of_forall hC⟩

theorem prefixLog_isCobounded {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m k : ℕ) :
    atTop.IsCoboundedUnder (· ≤ ·) (prefixLog F E m k) := by
  exact isCoboundedUnder_le_of_le atTop (prefixLog_nonneg F hB hE m k)

theorem logRate_nonneg {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (m k : ℕ) : 0 ≤ logRate F E m k := by
  exact le_limsup_of_frequently_le
    (Filter.Eventually.of_forall (prefixLog_nonneg F hB hE m k)).frequently
    (prefixLog_isBounded F hB hE m k)

theorem real_cast_div_le (N k : ℕ) (hk : 0 < k) :
    (N/k : ℕ) ≤ (N : ℝ)/(k : ℝ) := by
  apply (le_div_iff₀ (by exact_mod_cast hk : (0 : ℝ) < k)).mpr
  exact_mod_cast Nat.div_mul_le_self N k

theorem prefixLog_upper {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E)
    (hconv : ∀ i j, Tendsto (fun g : ℕ => (B^g) i j) atTop
      (𝓝 ((outer F.right F.left) i j)))
    {q : ℕ} {t : ℝ} (ht : 1 ≤ t)
    (htail : ∀ g ≥ q, EntrywiseLE (B^g) (t • outer F.right F.left))
    {m k N : ℕ} (hwidth : m*q+1 ≤ k) (hq : 0 < q) (hN : 0 < N) :
    prefixLog F E m k N ≤
      (m : ℝ)/(k : ℝ)*Real.log t + Real.log (clusterSup F E m)/(k-m*q : ℕ) +
        ((m : ℝ)*Real.log t + Real.log (clusterSup F E m))/(N : ℝ) := by
  let M := clusterSup F E m
  have hM : 1 ≤ M := one_le_clusterSup F hB hE m
  have hsup : prefixGainSup F E m k N ≤ t^(m*(N/k+1))*M^(N/(k-m*q)+1) :=
    prefixGainSup_le F E (fun _ hσ => canonical_prefix_gain_bound F hB hE hconv ht htail hσ hwidth hq)
  have hl := Real.log_le_log (by linarith [prefixGainSup_ge_one F hB hE m k N]) hsup
  rw [Real.log_mul (pow_ne_zero _ (by linarith : t ≠ 0))
    (pow_ne_zero _ (by linarith : M ≠ 0)), Real.log_pow, Real.log_pow] at hl
  push_cast at hl
  have hk : 0 < k := by omega
  have hL : 0 < k-m*q := by omega
  have hd₁ := real_cast_div_le N k hk
  have hd₂ := real_cast_div_le N (k-m*q) hL
  have hlogt := Real.log_nonneg ht
  have hlogM := Real.log_nonneg hM
  have hup : Real.log (prefixGainSup F E m k N) ≤
      (m : ℝ)*((N : ℝ)/(k : ℝ)+1)*Real.log t +
        ((N : ℝ)/(k-m*q : ℕ)+1)*Real.log M := by
    calc
      _ ≤ _ := hl
      _ ≤ _ := add_le_add
        (mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left
          (by simpa [add_comm] using add_le_add_right hd₁ 1) (Nat.cast_nonneg m)) hlogt)
        (mul_le_mul_of_nonneg_right
          (by simpa [add_comm] using add_le_add_right hd₂ 1) hlogM)
  have hNr : (0 : ℝ) < N := by exact_mod_cast hN
  apply (div_le_iff₀ hNr).mpr
  refine hup.trans_eq ?_
  dsimp [M]
  field_simp
  <;> ring

theorem limsup_le_of_tendsto_upper {f g : ℕ → ℝ} {a : ℝ}
    (hf : atTop.IsCoboundedUnder (· ≤ ·) f)
    (hg : Tendsto g atTop (𝓝 a)) (hfg : ∀ᶠ N in atTop, f N ≤ g N) :
    limsup f atTop ≤ a := by
  apply le_of_forall_gt
  intro b hab
  obtain ⟨c, hac, hcb⟩ := exists_between hab
  apply lt_of_le_of_lt (b := c) _ hcb
  apply limsup_le_of_le hf
  filter_upwards [hfg, hg.eventually_le_const hac] with N h₁ h₂
  exact h₁.trans h₂

theorem logRate_upper {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E)
    (hconv : ∀ i j, Tendsto (fun g : ℕ => (B^g) i j) atTop
      (𝓝 ((outer F.right F.left) i j)))
    {q : ℕ} {t : ℝ} (ht : 1 ≤ t)
    (htail : ∀ g ≥ q, EntrywiseLE (B^g) (t • outer F.right F.left))
    {m k : ℕ} (hwidth : m*q+1 ≤ k) (hq : 0 < q) :
    logRate F E m k ≤
      (m : ℝ)/(k : ℝ)*Real.log t + Real.log (clusterSup F E m)/(k-m*q : ℕ) := by
  apply limsup_le_of_tendsto_upper (prefixLog_isCobounded F hB hE m k)
  · simpa using tendsto_const_nhds.add
      (tendsto_const_nhds.div_atTop tendsto_natCast_atTop_atTop :
        Tendsto (fun N : ℕ => ((m : ℝ)*Real.log t + Real.log (clusterSup F E m))/(N : ℝ))
          atTop (𝓝 0))
  · filter_upwards [eventually_gt_atTop 0] with N hN
    exact prefixLog_upper F hB hE hconv ht htail hwidth hq hN

end MissedUpdates.Matrices
