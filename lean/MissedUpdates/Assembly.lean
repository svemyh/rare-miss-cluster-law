import MissedUpdates.Decode
import MissedUpdates.Joining
import MissedUpdates.PerronConvergence

open Matrix Filter
open scoped BigOperators Topology

namespace MissedUpdates.Matrices

variable {n : Type*} [Fintype n] [DecidableEq n]

theorem gain_smul (l r : n → ℝ) (A : Matrix n n ℝ) (t : ℝ) :
    gain l r (t • A) = t * gain l r A := by
  simp [gain, Matrix.smul_mulVec, dotProduct_smul]

theorem Frame.gain_mul_power {B : Matrix n n ℝ} (F : Frame B)
    (A : Matrix n n ℝ) (a : ℕ) : gain F.left F.right (A * B^a) = gain F.left F.right A := by
  simpa using gain_outer_powers F.left F.right A B F.left_fixed F.right_fixed 0 a

theorem Frame.gain_power_mul {B : Matrix n n ℝ} (F : Frame B)
    (A : Matrix n n ℝ) (a : ℕ) : gain F.left F.right (B^a * A) = gain F.left F.right A := by
  simpa using gain_outer_powers F.left F.right A B F.left_fixed F.right_fixed a 0

theorem gap_gain_le {B : Matrix n n ℝ} (F : Frame B)
    {A C : Matrix n n ℝ} (hA : Nonnegative A) (hC : Nonnegative C)
    {g : ℕ} {t : ℝ} (htail : EntrywiseLE (B^g) (t • outer F.right F.left)) :
    gain F.left F.right (A * B^g * C) ≤
      t * (gain F.left F.right A * gain F.left F.right C) := by
  have h := gain_mono (fun i => (F.left_pos i).le) (fun i => (F.right_pos i).le)
    (mul_mono_right (mul_mono_left htail hA) hC)
  simpa [Matrix.mul_smul, Matrix.smul_mul, gain_smul, gain_insert_reset] using h

theorem decode_cons_product (B E : Matrix n n ℝ) (a : ℕ)
    (c : List ℕ) (cs : List (List ℕ)) (hc : c ≠ []) :
    wordProduct B E (positionsWord a (c::cs).flatten) =
      wordProduct B E (positionsWord (cursor 0 c) cs.flatten) *
        wordProduct B E (clusterWord c) * B^(c.head!-a) := by
  rw [List.flatten_cons, positionsWord_append, wordProduct_append,
    positionsWord_leading a c hc, wordProduct_append, wordProduct_true,
    cursor_nonempty a 0 c hc, Matrix.mul_assoc]

theorem decode_gain_two {B E : Matrix n n ℝ} (F : Frame B) (a : ℕ)
    (c d : List ℕ) (cs : List (List ℕ)) (hc : c ≠ []) (hd : d ≠ []) :
    gain F.left F.right (wordProduct B E (positionsWord a (c::d::cs).flatten)) =
      gain F.left F.right
        (wordProduct B E (positionsWord d.head! (d::cs).flatten) *
          B^(d.head!-cursor 0 c) * wordProduct B E (clusterWord c)) := by
  have ht : (d::cs).flatten ≠ [] := by simp [List.flatten_cons, hd]
  have hh : ((d::cs).flatten).head! = d.head! := by
    simpa only [List.flatten_cons] using List.head!_append cs.flatten hd
  rw [decode_cons_product B E a c (d::cs) hc, F.gain_mul_power]
  rw [positionsWord_leading (cursor 0 c) (d::cs).flatten ht, wordProduct_append,
    wordProduct_true, hh]
  simp only [clusterWord, hh]

/-- Every separated cluster decomposition has the matrix-derived gain bound. -/
theorem separated_gain_bound {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E) {q : ℕ} {t : ℝ} (ht : 1 ≤ t)
    (htail : ∀ g ≥ q, EntrywiseLE (B^g) (t • outer F.right F.left))
    (cs : List (List ℕ)) (hne : ∀ c ∈ cs, c ≠ [])
    (hsep : cs.IsChain (fun c d => ∃ hc hd, c.getLast hc + q < d.head hd)) (a : ℕ) :
    gain F.left F.right (wordProduct B E (positionsWord a cs.flatten)) ≤
      t^cs.length * (cs.map (fun c => gain F.left F.right (wordProduct B E (clusterWord c)))).prod := by
  induction cs generalizing a with
  | nil => simp [positionsWord, wordProduct, gain, F.pairing_one]
  | cons c cs ih =>
    have hc := hne c (by simp)
    have hK : 0 ≤ gain F.left F.right (wordProduct B E (clusterWord c)) :=
      gain_nonneg (fun i => (F.left_pos i).le) (fun i => (F.right_pos i).le)
        (wordProduct_nonnegative hB hE _)
    cases cs with
    | nil =>
      rw [decode_cons_product B E a c [] hc, F.gain_mul_power]
      simpa [positionsWord, wordProduct] using mul_le_mul_of_nonneg_right ht hK
    | cons d ds =>
      have hd := hne d (by simp)
      obtain ⟨hcd, hrest⟩ := List.isChain_cons_cons.mp hsep
      obtain ⟨hc', hd', hgap⟩ := hcd
      have hq : q ≤ d.head! - cursor 0 c := by
        rw [cursor_eq_getLast 0 c hc']
        have hh : d.head! = d.head hd' := by cases d <;> simp_all
        rw [hh]
        omega
      rw [decode_gain_two F a c d ds hc hd]
      have hg := gap_gain_le F (wordProduct_nonnegative hB hE
        (positionsWord d.head! (d::ds).flatten)) (wordProduct_nonnegative hB hE (clusterWord c))
        (htail _ hq)
      have hi := ih (fun e he => hne e (by simp [he])) hrest d.head!
      have hmul := mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_right hi hK)
        (show 0 ≤ t by linarith)
      exact hg.trans (by simpa [List.length_cons, List.map_cons, List.prod_cons,
        pow_succ, mul_assoc, mul_left_comm, mul_comm] using hmul)

theorem canonical_product_gains_bound {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E)
    (hconv : ∀ i j, Tendsto (fun g : ℕ => (B^g) i j) atTop
      (𝓝 ((outer F.right F.left) i j)))
    {σ : ℕ → Bool} {m k q N : ℕ} (hσ : Admissible σ m k)
    (hwidth : m*q+1 ≤ k) (hq : 0 < q) :
    ((clusters σ N q).map (fun c =>
      gain F.left F.right (wordProduct B E (clusterWord c)))).prod ≤
      (clusterSup F E m)^(N/(k-m*q)+1) := by
  let f : Fin (clusters σ N q).length → ℝ := fun i =>
    gain F.left F.right (wordProduct B E (clusterWord (clusterAt σ N q i)))
  let label : Fin (clusters σ N q).length → ℕ :=
    fun i => (clusterAt σ N q i).head! / (k-m*q)
  have hmap : ∀ i ∈ Finset.univ, label i ∈ Finset.range (N/(k-m*q)+1) := by
    intro i _
    exact Finset.mem_range.mpr (canonical_bin_label_lt σ N q (k-m*q) i)
  have hf : ∀ i, 0 ≤ f i := fun i => gain_nonneg
    (fun j => (F.left_pos j).le) (fun j => (F.right_pos j).le)
    (wordProduct_nonnegative hB hE _)
  have hb (b : ℕ) :
      (∏ i ∈ Finset.univ.filter (fun i => label i = b), f i) ≤ clusterSup F E m := by
    apply finset_product_gains_le_clusterSup F hB hE hconv
    simpa [clusterWord_count] using
      (canonical_bin_budget (N := N) (t := b) hσ hwidth hq)
  have heq : ((clusters σ N q).map (fun c =>
      gain F.left F.right (wordProduct B E (clusterWord c)))).prod = ∏ i, f i := by
    rw [← Fin.prod_ofFn]
    congr 1
    change (clusters σ N q).map (fun c =>
      gain F.left F.right (wordProduct B E (clusterWord c))) =
      List.ofFn (fun i : Fin (clusters σ N q).length =>
        gain F.left F.right (wordProduct B E (clusterWord ((clusters σ N q).get i))))
    exact (List.ofFn_getElem_eq_map (clusters σ N q)
      (fun c => gain F.left F.right (wordProduct B E (clusterWord c)))).symm
  rw [heq, ← Finset.prod_fiberwise_of_maps_to hmap f]
  calc
    _ ≤ ∏ _b ∈ Finset.range (N/(k-m*q)+1), clusterSup F E m := by
      apply Finset.prod_le_prod
      · intro b _
        exact Finset.prod_nonneg (fun i _ => hf i)
      · intro b _; exact hb b
    _ = _ := by simp

/-- Uniform bound on every actual admissible prefix, including boundary success runs. -/
theorem canonical_prefix_gain_bound {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E)
    (hconv : ∀ i j, Tendsto (fun g : ℕ => (B^g) i j) atTop
      (𝓝 ((outer F.right F.left) i j)))
    {q : ℕ} {t : ℝ} (ht : 1 ≤ t)
    (htail : ∀ g ≥ q, EntrywiseLE (B^g) (t • outer F.right F.left))
    {σ : ℕ → Bool} {m k N : ℕ} (hσ : Admissible σ m k)
    (hwidth : m*q+1 ≤ k) (hq : 0 < q) :
    gain F.left F.right (wordProduct B E (prefixWord σ N)) ≤
      t^(m*(N/k+1)) * (clusterSup F E m)^(N/(k-m*q)+1) := by
  rw [prefixWord_canonical_decode σ N q, wordProduct_append, wordProduct_true, F.gain_power_mul]
  have h₁ := separated_gain_bound F hB hE ht htail (clusters σ N q)
    (fun _ hc => cluster_ne_nil hc) (cluster_separation σ N q) 0
  have h₂ := canonical_product_gains_bound F hB hE hconv hσ hwidth hq (N := N)
  have hlen : (clusters σ N q).length ≤ m*(N/k+1) := by
    have hl := List.length_le_sum_of_one_le ((clusters σ N q).map List.length) (by
      intro j hj
      obtain ⟨c, hc, rfl⟩ := List.mem_map.mp hj
      exact List.length_pos_iff.mpr (cluster_ne_nil hc))
    simp only [List.length_map] at hl
    exact hl.trans (canonical_total_misses_le hσ (by omega) N q)
  have hM := one_le_clusterSup F hB hE m
  exact h₁.trans (mul_le_mul (pow_le_pow_right₀ ht hlen) h₂
    (List.prod_nonneg (fun x hx => by
      obtain ⟨c, _, rfl⟩ := List.mem_map.mp hx
      exact gain_nonneg (fun i => (F.left_pos i).le) (fun i => (F.right_pos i).le)
        (wordProduct_nonnegative hB hE _)))
    (pow_nonneg (by linarith : 0 ≤ t) _))

end MissedUpdates.Matrices
