import MissedUpdates.Growth

open Matrix Filter
open scoped BigOperators Topology

namespace MissedUpdates

def periodic (w : List Bool) (i : ℕ) : Bool := (w[i % w.length]?).getD true

theorem prefixWord_periodic (w : List Bool) : prefixWord (periodic w) w.length = w := by
  apply List.ext_getElem (by simp [prefixWord])
  intro i hi hi'
  simp [prefixWord, periodic, Nat.mod_eq_of_lt hi', List.getElem?_eq_getElem hi']

theorem periodic_add_mul (w : List Bool) (i N : ℕ) :
    periodic w (w.length*N+i) = periodic w i := by
  simp [periodic, Nat.add_mod, Nat.mul_mod]

theorem prefixWord_periodic_succ (w : List Bool) (N : ℕ) :
    prefixWord (periodic w) (w.length*(N+1)) =
      prefixWord (periodic w) (w.length*N) ++ w := by
  have hr : w.length*(N+1) = w.length*N+w.length := by ring
  rw [hr]
  calc
    _ = prefixWord (periodic w) (w.length*N) ++ prefixWord (periodic w) w.length := by
      simp [prefixWord, List.range_add, List.map_map, Function.comp_def, periodic_add_mul]
    _ = _ := by rw [prefixWord_periodic]

theorem prefixWord_count_misses (σ : ℕ → Bool) (N : ℕ) :
    (prefixWord σ N).count false = ((Finset.range N).filter (fun i => σ i = false)).card := by
  rw [prefixWord_decode]
  simp [positionsWord_count, List.count_replicate, missList]

/-- Any repeated word of period at least k and at most m misses satisfies the
actual k-window rule. Modulo is injective on each such window. -/
theorem periodic_admissible (w : List Bool) {m k : ℕ}
    (hp : 0 < w.length) (hk : k ≤ w.length) (hm : w.count false ≤ m) :
    Admissible (periodic w) m k := by
  intro s
  have hcard : ((Finset.range w.length).filter (fun i => periodic w i = false)).card ≤ m := by
    rw [← prefixWord_count_misses, prefixWord_periodic]
    exact hm
  refine le_trans (Finset.card_le_card_of_injOn (fun i => i % w.length) ?_ ?_) hcard
  · intro i hi
    obtain ⟨_, hi⟩ := Finset.mem_filter.mp hi
    apply Finset.mem_filter.mpr
    refine ⟨Finset.mem_range.mpr (Nat.mod_lt _ hp), ?_⟩
    simpa [periodic, Nat.mod_mod] using hi
  · intro i hi j hj hij
    apply Nat.mod_injOn_Ico s w.length ?_ ?_ hij
    · obtain ⟨hi, _⟩ := Finset.mem_filter.mp hi
      obtain ⟨hlo, hhi⟩ := Finset.mem_Ico.mp hi
      exact Finset.mem_Ico.mpr ⟨hlo, by omega⟩
    · obtain ⟨hj, _⟩ := Finset.mem_filter.mp hj
      obtain ⟨hlo, hhi⟩ := Finset.mem_Ico.mp hj
      exact Finset.mem_Ico.mpr ⟨hlo, by omega⟩

namespace Matrices

variable {n : Type*} [Fintype n] [DecidableEq n]

theorem periodic_product (B E : Matrix n n ℝ) (w : List Bool) (N : ℕ) :
    wordProduct B E (prefixWord (periodic w) (w.length*N)) = (wordProduct B E w)^N := by
  induction N with
  | zero => simp [prefixWord, wordProduct]
  | succ N ih => rw [prefixWord_periodic_succ, wordProduct_append, ih, pow_succ']

theorem power_right_lower {Q : Matrix n n ℝ} (hQ : Nonnegative Q)
    (r : n → ℝ) {t : ℝ} (ht : 0 ≤ t) (hr : t • r ≤ Q *ᵥ r) (N : ℕ) :
    t^N • r ≤ Q^N *ᵥ r := by
  induction N with
  | zero => simp
  | succ N ih =>
    rw [pow_succ' Q N, ← Matrix.mulVec_mulVec]
    have h₁ := mulVec_mono hQ ih
    rw [Matrix.mulVec_smul] at h₁
    have h₂ : t^N • (t • r) ≤ t^N • (Q *ᵥ r) := by
      intro i
      exact mul_le_mul_of_nonneg_left (hr i) (_root_.pow_nonneg ht N)
    simpa [smul_smul, pow_succ] using h₂.trans h₁

theorem power_gain_lower {B : Matrix n n ℝ} (F : Frame B)
    {Q : Matrix n n ℝ} (hQ : Nonnegative Q) {t : ℝ} (ht : 0 ≤ t)
    (hr : t • F.right ≤ Q *ᵥ F.right) (N : ℕ) : t^N ≤ gain F.left F.right (Q^N) := by
  have h := dotProduct_le_dotProduct_of_nonneg_left (power_right_lower hQ F.right ht hr N)
    (fun i => (F.left_pos i).le)
  simpa [gain, dotProduct_smul, F.pairing_one] using h

theorem periodic_prefixLog_lower {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (w : List Bool)
    {m k : ℕ} (hp : 0 < w.length) (hk : k ≤ w.length) (hm : w.count false ≤ m)
    {t : ℝ} (ht : 0 < t) (hr : t • F.right ≤ wordProduct B E w *ᵥ F.right)
    {N : ℕ} (hN : 0 < N) :
    Real.log t/(w.length : ℝ) ≤ prefixLog F E m k (w.length*N) := by
  have hpow := power_gain_lower F (wordProduct_nonnegative hB hE w) ht.le hr N
  rw [← periodic_product B E w N] at hpow
  have hcap := hpow.trans (prefix_gain_le_sup F hB hE (periodic_admissible w hp hk hm))
  have hl := Real.log_le_log (pow_pos ht N) hcap
  rw [Real.log_pow] at hl
  have hpr : (0 : ℝ) < w.length := by exact_mod_cast hp
  have hNr : (0 : ℝ) < N := by exact_mod_cast hN
  change Real.log t/(w.length : ℝ) ≤
    Real.log (prefixGainSup F E m k (w.length*N))/(w.length*N : ℕ)
  rw [Nat.cast_mul]
  apply (div_le_div_iff₀ hpr (mul_pos hpr hNr)).mpr
  nlinarith

theorem periodic_logRate_lower {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) (w : List Bool)
    {m k : ℕ} (hp : 0 < w.length) (hk : k ≤ w.length) (hm : w.count false ≤ m)
    {t : ℝ} (ht : 0 < t) (hr : t • F.right ≤ wordProduct B E w *ᵥ F.right) :
    Real.log t/(w.length : ℝ) ≤ logRate F E m k := by
  apply le_limsup_of_le (prefixLog_isBounded F hB hE m k)
  intro b hb
  obtain ⟨R, hR⟩ := Filter.eventually_atTop.mp hb
  have hlarge : R ≤ w.length*(R+1) := by nlinarith
  exact (periodic_prefixLog_lower F hB hE w hp hk hm ht hr (by omega : 0 < R+1)).trans
    (hR _ hlarge)

theorem long_gap_right_tendsto {B E : Matrix n n ℝ} (F : Frame B)
    (hconv : ∀ i j, Tendsto (fun g : ℕ => (B^g) i j) atTop
      (𝓝 ((outer F.right F.left) i j))) (w : List Bool) :
    ∀ i, Tendsto (fun k : ℕ => ((B^k * wordProduct B E w) *ᵥ F.right) i) atTop
      (𝓝 (gain F.left F.right (wordProduct B E w) * F.right i)) := by
  have hmat := matrix_mul_tendsto hconv
    (fun i j => tendsto_const_nhds (x := wordProduct B E w i j))
  intro i
  have hv := tendsto_finsetSum Finset.univ (fun j _ => (hmat i j).mul_const (F.right j))
  have heq : ((outer F.right F.left * wordProduct B E w) *ᵥ F.right) i =
      gain F.left F.right (wordProduct B E w) * F.right i := by
    rw [← Matrix.mulVec_mulVec, outer_mulVec]
    rfl
  simpa only [Matrix.mulVec, dotProduct, ← heq] using hv

/-- Each fixed finite word yields eventual lower bounds with period k+length(w). -/
theorem witness_logRate_lower {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E)
    (hconv : ∀ i j, Tendsto (fun g : ℕ => (B^g) i j) atTop
      (𝓝 ((outer F.right F.left) i j)))
    {m : ℕ} (w : List Bool) (hm : w.count false ≤ m) {t : ℝ} (ht : 0 < t)
    (hgain : t < gain F.left F.right (wordProduct B E w)) :
    ∀ᶠ k : ℕ in atTop, Real.log t/(k+w.length : ℕ) ≤ logRate F E m k := by
  have heach : ∀ i, ∀ᶠ k : ℕ in atTop,
      t * F.right i ≤ ((B^k * wordProduct B E w) *ᵥ F.right) i := by
    intro i
    exact (long_gap_right_tendsto F hconv w i).eventually_const_le
      (mul_lt_mul_of_pos_right hgain (F.right_pos i))
  have hall := Filter.eventually_all.mpr heach
  filter_upwards [hall, eventually_gt_atTop 0] with k hk hkpos
  let v := w ++ List.replicate k true
  have hvlen : v.length = k+w.length := by simp [v, Nat.add_comm]
  have hvmiss : v.count false ≤ m := by simpa [v, List.count_replicate] using hm
  have hvprod : wordProduct B E v = B^k * wordProduct B E w := by
    simp [v, wordProduct_append, wordProduct_true]
  have h := periodic_logRate_lower F hB hE v
    (by omega : 0 < v.length) (by omega : k ≤ v.length) hvmiss ht
    (by intro i; simpa only [hvprod, Pi.smul_apply, smul_eq_mul] using hk i)
  simpa only [hvlen] using h

end Matrices
end MissedUpdates
