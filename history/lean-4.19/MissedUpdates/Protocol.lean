import Mathlib.Order.Interval.Finset.Nat
import Mathlib.Data.Finset.Card
import Mathlib.Tactic

namespace MissedUpdates

/-- The actual infinite sliding-window rule: false is a missed update. -/
def Admissible (σ : ℕ → Bool) (m k : ℕ) : Prop :=
  ∀ s, ((Finset.Ico s (s + k)).filter fun i => σ i = false).card ≤ m

/-- Any finite collection of misses contained in a genuine window obeys the budget. -/
theorem card_le_of_in_window {σ : ℕ → Bool} {m k s : ℕ}
    (hσ : Admissible σ m k) (D : Finset ℕ)
    (hmiss : ∀ i ∈ D, σ i = false)
    (hwindow : D ⊆ Finset.Ico s (s + k)) : D.card ≤ m := by
  apply le_trans (Finset.card_le_card ?_) (hσ s)
  intro i hi
  exact Finset.mem_filter.mpr ⟨hwindow hi, hmiss i hi⟩

/-- Endpoint control for a chain of consecutive gaps bounded by q. -/
theorem chain_span (p : ℕ → ℕ) (q r : ℕ)
    (hstep : ∀ i < r, p (i+1) ≤ p i + q) :
    ∀ i ≤ r, p i ≤ p 0 + i*q := by
  intro i hi
  induction i with
  | zero => simp
  | succ i ih =>
    have hprev := ih (by omega)
    have hnext := hstep i (by omega)
    calc
      p (i+1) ≤ p i + q := hnext
      _ ≤ p 0 + i*q + q := Nat.add_le_add_right hprev q
      _ = p 0 + (i+1)*q := by simp [Nat.add_mul, Nat.add_assoc]

/-- A short increasing chain of misses cannot contain more than a window's budget. -/
theorem short_chain_card_le {σ : ℕ → Bool} {m k q r : ℕ}
    (hσ : Admissible σ m k) (p : ℕ → ℕ) (hp : StrictMono p)
    (hmiss : ∀ i ≤ r, σ (p i) = false)
    (hstep : ∀ i < r, p (i+1) ≤ p i + q)
    (hwidth : r*q+1 ≤ k) : r+1 ≤ m := by
  let D := (Finset.range (r+1)).image p
  have hcard : D.card = r+1 := by
    simp [D, Finset.card_image_of_injective _ hp.injective]
  rw [← hcard]
  apply card_le_of_in_window hσ D
  · intro x hx
    obtain ⟨i, hi, rfl⟩ := Finset.mem_image.mp hx
    exact hmiss i (by simpa using Nat.le_of_lt_succ (Finset.mem_range.mp hi))
  · intro x hx
    obtain ⟨i, hi, rfl⟩ := Finset.mem_image.mp hx
    have hir : i ≤ r := Nat.le_of_lt_succ (Finset.mem_range.mp hi)
    have hlo : p 0 ≤ p i := hp.monotone (Nat.zero_le i)
    have hspan := chain_span p q r hstep i hir
    have hmul := Nat.mul_le_mul_right q hir
    exact Finset.mem_Ico.mpr ⟨hlo, by omega⟩

/-- The forbidden m+1 chain at the threshold used in the paper. -/
theorem no_long_cluster {σ : ℕ → Bool} {m k q : ℕ}
    (hσ : Admissible σ m k) (p : ℕ → ℕ) (hp : StrictMono p)
    (hmiss : ∀ i ≤ m, σ (p i) = false)
    (hstep : ∀ i < m, p (i+1) ≤ p i + q)
    (hwidth : m*q+1 ≤ k) : False := by
  have := short_chain_card_le hσ p hp hmiss hstep hwidth
  omega

/-- The geometric inclusion behind the paper's binning argument. -/
theorem bin_contains_point {t L h k s i : ℕ}
    (hstart : s ∈ Finset.Ico (t*L) ((t+1)*L))
    (hpoint : i ∈ Finset.Ico s (s+h)) (hsize : L+h ≤ k) :
    i ∈ Finset.Ico (t*L) (t*L+k) := by
  obtain ⟨hlo, hhi⟩ := Finset.mem_Ico.mp hstart
  obtain ⟨hilo, hihi⟩ := Finset.mem_Ico.mp hpoint
  have htop : (t+1)*L = t*L+L := by simp [Nat.add_mul]
  exact Finset.mem_Ico.mpr ⟨by omega, by omega⟩

/-- A collection of actual miss sets assigned to one bin obeys one genuine window budget. -/
theorem bin_union_card_le {ι : Type*} [DecidableEq ι]
    {σ : ℕ → Bool} {m k t L h : ℕ}
    (hσ : Admissible σ m k) (J : Finset ι)
    (D : ι → Finset ℕ) (start : ι → ℕ)
    (hmiss : ∀ c ∈ J, ∀ i ∈ D c, σ i = false)
    (hstart : ∀ c ∈ J, start c ∈ Finset.Ico (t*L) ((t+1)*L))
    (hspan : ∀ c ∈ J, D c ⊆ Finset.Ico (start c) (start c+h))
    (hsize : L+h ≤ k) : (J.biUnion D).card ≤ m := by
  apply card_le_of_in_window hσ (J.biUnion D)
  · intro i hi
    obtain ⟨c, hc, hic⟩ := Finset.mem_biUnion.mp hi
    exact hmiss c hc i hic
  · intro i hi
    obtain ⟨c, hc, hic⟩ := Finset.mem_biUnion.mp hi
    exact bin_contains_point (hstart c hc) (hspan c hc hic) hsize

/-- Disjoint cluster cardinalities in a bin sum to at most m. -/
theorem bin_sum_card_le {ι : Type*} [DecidableEq ι]
    {σ : ℕ → Bool} {m k t L h : ℕ}
    (hσ : Admissible σ m k) (J : Finset ι)
    (D : ι → Finset ℕ) (start : ι → ℕ)
    (hmiss : ∀ c ∈ J, ∀ i ∈ D c, σ i = false)
    (hstart : ∀ c ∈ J, start c ∈ Finset.Ico (t*L) ((t+1)*L))
    (hspan : ∀ c ∈ J, D c ⊆ Finset.Ico (start c) (start c+h))
    (hsize : L+h ≤ k) (hdisjoint : J.toSet.PairwiseDisjoint D) :
    ∑ c ∈ J, (D c).card ≤ m := by
  rw [← Finset.card_biUnion hdisjoint]
  exact bin_union_card_le hσ J D start hmiss hstart hspan hsize

/-- Integer division selects the genuine half-open bin containing a point. -/
theorem mem_div_bin (s L : ℕ) (hL : 0 < L) :
    s ∈ Finset.Ico ((s/L)*L) ((s/L+1)*L) := by
  have hd := (Nat.div_eq_iff hL).mp (rfl : s/L = s/L)
  have ht : (s/L+1)*L = (s/L)*L+L := by simp [Nat.add_mul]
  exact Finset.mem_Ico.mpr ⟨hd.1, by omega⟩

/-- The prefix miss count is derived from the infinite window rule, not assumed. -/
theorem prefix_count_le {σ : ℕ → Bool} {m k : ℕ}
    (hσ : Admissible σ m k) (hk : 0 < k) (N : ℕ) :
    ((Finset.range N).filter fun i => σ i = false).card ≤ m*(N/k+1) := by
  let pieces := fun j => (Finset.Ico (j*k) (j*k+k)).filter fun i => σ i = false
  have hcover : ((Finset.range N).filter fun i => σ i = false) ⊆
      (Finset.range (N/k+1)).biUnion pieces := by
    intro i hi
    obtain ⟨hiN, hmiss⟩ := Finset.mem_filter.mp hi
    have hiN' : i < N := Finset.mem_range.mp hiN
    have hdiv : i/k ≤ N/k := Nat.div_le_div_right (Nat.le_of_lt hiN')
    apply Finset.mem_biUnion.mpr
    refine ⟨i/k, Finset.mem_range.mpr (by omega), ?_⟩
    apply Finset.mem_filter.mpr
    refine ⟨?_, hmiss⟩
    simpa [Nat.add_mul] using mem_div_bin i k hk
  calc
    _ ≤ ((Finset.range (N/k+1)).biUnion pieces).card := Finset.card_le_card hcover
    _ ≤ ∑ j ∈ Finset.range (N/k+1), (pieces j).card := Finset.card_biUnion_le
    _ ≤ ∑ _j ∈ Finset.range (N/k+1), m := by
      exact Finset.sum_le_sum fun j _ => hσ (j*k)
    _ = m*(N/k+1) := by simp [Nat.mul_comm]

/-- The exact bin labeling and width chosen in the paper yield the cluster budget. -/
theorem paper_bin_budget {ι : Type*} [DecidableEq ι]
    {σ : ℕ → Bool} {m k q t : ℕ}
    (hσ : Admissible σ m k) (hwidth : m*q+1 ≤ k)
    (J : Finset ι) (D : ι → Finset ℕ) (start : ι → ℕ)
    (hmiss : ∀ c ∈ J, ∀ i ∈ D c, σ i = false)
    (hlabel : ∀ c ∈ J, start c / (k-m*q) = t)
    (hspan : ∀ c ∈ J, D c ⊆ Finset.Ico (start c) (start c+m*q))
    (hdisjoint : J.toSet.PairwiseDisjoint D) :
    ∑ c ∈ J, (D c).card ≤ m := by
  have hL : 0 < k-m*q := by omega
  apply bin_sum_card_le hσ J D start hmiss
  · intro c hc
    have h := mem_div_bin (start c) (k-m*q) hL
    simpa [hlabel c hc] using h
  · exact hspan
  · omega
  · exact hdisjoint

/-- Cluster length follows from the forbidden prefix, without assuming a total-span bound. -/
theorem cluster_length_le {σ : ℕ → Bool} {m k q r : ℕ}
    (hσ : Admissible σ m k) (p : ℕ → ℕ) (hp : StrictMono p)
    (hmiss : ∀ i ≤ r, σ (p i) = false)
    (hstep : ∀ i < r, p (i+1) ≤ p i + q)
    (hwidth : m*q+1 ≤ k) : r+1 ≤ m := by
  by_contra h
  have hmr : m ≤ r := by omega
  apply no_long_cluster hσ p hp
  · intro i hi
    exact hmiss i (hi.trans hmr)
  · intro i hi
    exact hstep i (lt_of_lt_of_le hi hmr)
  · exact hwidth

/-- Every miss in a genuine short-step cluster lies inside its mq-slot span. -/
theorem cluster_mem_span {σ : ℕ → Bool} {m k q r : ℕ}
    (hσ : Admissible σ m k) (p : ℕ → ℕ) (hp : StrictMono p)
    (hmiss : ∀ i ≤ r, σ (p i) = false)
    (hstep : ∀ i < r, p (i+1) ≤ p i + q)
    (hwidth : m*q+1 ≤ k) (hq : 0 < q) {i : ℕ} (hi : i ≤ r) :
    p i ∈ Finset.Ico (p 0) (p 0+m*q) := by
  have hlen := cluster_length_le hσ p hp hmiss hstep hwidth
  have him : i < m := by omega
  have hmul : i*q < m*q := Nat.mul_lt_mul_of_pos_right him hq
  have hspan := chain_span p q r hstep i hi
  have hlo := hp.monotone (Nat.zero_le i)
  exact Finset.mem_Ico.mpr ⟨hlo, by omega⟩

/-- Paper's bin-packing lemma for increasing miss chains. Cardinality and span
are derived from admissibility and short steps, not supplied as conclusions. -/
theorem chain_bin_budget {ι : Type*} [DecidableEq ι]
    {σ : ℕ → Bool} {m k q t : ℕ} (hσ : Admissible σ m k)
    (hwidth : m*q+1 ≤ k) (hq : 0 < q)
    (J : Finset ι) (p : ι → ℕ → ℕ) (last : ι → ℕ)
    (hp : ∀ c ∈ J, StrictMono (p c))
    (hmiss : ∀ c ∈ J, ∀ i ≤ last c, σ (p c i) = false)
    (hstep : ∀ c ∈ J, ∀ i < last c, p c (i+1) ≤ p c i + q)
    (hlabel : ∀ c ∈ J, p c 0 / (k-m*q) = t)
    (hdisjoint : J.toSet.PairwiseDisjoint
      (fun c => (Finset.range (last c+1)).image (p c))) :
    ∑ c ∈ J, (last c+1) ≤ m := by
  let D := fun c => (Finset.range (last c+1)).image (p c)
  have hcard : ∑ c ∈ J, (last c+1) = ∑ c ∈ J, (D c).card := by
    apply Finset.sum_congr rfl
    intro c hc
    simp [D, Finset.card_image_of_injective _ (hp c hc).injective]
  rw [hcard]
  apply paper_bin_budget hσ hwidth J D (fun c => p c 0)
  · intro c hc x hx
    obtain ⟨i, hi, rfl⟩ := Finset.mem_image.mp hx
    exact hmiss c hc i (Nat.le_of_lt_succ (Finset.mem_range.mp hi))
  · exact hlabel
  · intro c hc x hx
    obtain ⟨i, hi, rfl⟩ := Finset.mem_image.mp hx
    exact cluster_mem_span hσ (p c) (hp c hc) (hmiss c hc) (hstep c hc)
      hwidth hq (Nat.le_of_lt_succ (Finset.mem_range.mp hi))
  · exact hdisjoint

end MissedUpdates
