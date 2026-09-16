import MissedUpdates.Protocol
import Mathlib.Data.List.SplitBy
import Mathlib.Data.Finset.Sort
import Mathlib.Data.List.Nodup

namespace MissedUpdates

def missList (σ : ℕ → Bool) (N : ℕ) : List ℕ :=
  ((Finset.range N).filter fun i => σ i = false).sort (· ≤ ·)

/-- Canonical clusters of actual prefix misses; adjacency means fewer than q successes. -/
def clusters (σ : ℕ → Bool) (N q : ℕ) : List (List ℕ) :=
  (missList σ N).splitBy (fun a b => decide (b ≤ a+q))

theorem flatten_clusters (σ : ℕ → Bool) (N q : ℕ) :
    (clusters σ N q).flatten = missList σ N := by
  simp [clusters]

theorem cluster_ne_nil {σ : ℕ → Bool} {N q : ℕ} {c : List ℕ}
    (hc : c ∈ clusters σ N q) : c ≠ [] :=
  List.ne_nil_of_mem_splitBy _ hc

theorem cluster_sublist {σ : ℕ → Bool} {N q : ℕ} {c : List ℕ}
    (hc : c ∈ clusters σ N q) : List.Sublist c (missList σ N) := by
  simpa [flatten_clusters] using List.sublist_flatten_of_mem hc

theorem cluster_sorted {σ : ℕ → Bool} {N q : ℕ} {c : List ℕ}
    (hc : c ∈ clusters σ N q) : c.Sorted (· < ·) := by
  have hs : (missList σ N).Sorted (· < ·) := by
    exact Finset.sort_sorted_lt _
  exact hs.sublist (cluster_sublist hc)

theorem cluster_miss {σ : ℕ → Bool} {N q : ℕ} {c : List ℕ}
    (hc : c ∈ clusters σ N q) {i : ℕ} (hi : i ∈ c) : σ i = false := by
  have h := (cluster_sublist hc).subset hi
  simp only [missList, Finset.mem_sort, Finset.mem_filter] at h
  exact h.2

theorem cluster_steps {σ : ℕ → Bool} {N q : ℕ} {c : List ℕ}
    (hc : c ∈ clusters σ N q) : c.Chain' (fun a b => b ≤ a+q) := by
  have h := List.chain'_of_mem_splitBy hc
  simpa [clusters] using h

theorem cluster_separation (σ : ℕ → Bool) (N q : ℕ) :
    (clusters σ N q).Chain' (fun a b =>
      ∃ ha hb, a.getLast ha + q < b.head hb) := by
  simpa [clusters, not_le] using
    List.chain'_getLast_head_splitBy (fun a b => decide (b ≤ a+q)) (missList σ N)

theorem list_chain_span (q a : ℕ) (l : List ℕ)
    (h : (a::l).Chain' (fun x y => y ≤ x+q)) :
    ∀ x ∈ a::l, x ≤ a+l.length*q := by
  induction l generalizing a with
  | nil => simp
  | cons b l ih =>
    obtain ⟨hab, hrest⟩ := List.chain'_cons.mp h
    intro x hx
    rcases List.mem_cons.mp hx with rfl | hx
    · omega
    · have hs := ih b hrest x hx
      simp only [List.length_cons]
      calc
        x ≤ b+l.length*q := hs
        _ ≤ (a+q)+l.length*q := Nat.add_le_add_right hab _
        _ = a+(l.length+1)*q := by ring

/-- No cardinality hypothesis is supplied: the window rule bounds every sorted short-step list. -/
theorem admissible_list_length {σ : ℕ → Bool} {m k q : ℕ}
    (hσ : Admissible σ m k) (hwidth : m*q+1 ≤ k) (c : List ℕ)
    (hsorted : c.Sorted (· < ·))
    (hmiss : ∀ i ∈ c, σ i = false)
    (hsteps : c.Chain' (fun a b => b ≤ a+q)) : c.length ≤ m := by
  cases c with
  | nil => simp
  | cons a l =>
    by_contra hlen
    have hml : m ≤ l.length := by simpa using Nat.le_of_lt_succ (Nat.lt_of_not_ge hlen)
    let pref := a::l.take m
    have hsub : List.Sublist pref (a::l) := by
      simpa [pref] using List.take_sublist (m+1) (a::l)
    have hnodup : (a::l).Nodup := hsorted.imp fun h => ne_of_lt h
    have hnd : pref.Nodup := hsub.nodup hnodup
    have hcard : pref.toFinset.card = m+1 := by
      rw [List.toFinset_card_of_nodup hnd]
      simp [pref, List.length_take, Nat.min_eq_left hml]
    have hchain : pref.Chain' (fun x y => y ≤ x+q) := by
      simpa [pref] using hsteps.take (m+1)
    have hcap := card_le_of_in_window hσ pref.toFinset
      (fun i hi => hmiss i (hsub.subset (List.mem_toFinset.mp hi)))
      (s := a) (by
        intro i hi
        have hip : i ∈ pref := List.mem_toFinset.mp hi
        have his : i ∈ a::l := hsub.subset hip
        have hlo : a ≤ i := by
          rcases List.mem_cons.mp his with rfl | his
          · rfl
          · exact le_of_lt ((List.pairwise_cons.mp hsorted).1 i his)
        have hspan := list_chain_span q a (l.take m) hchain i hip
        have hsize : (l.take m).length = m := by simp [List.length_take, Nat.min_eq_left hml]
        rw [hsize] at hspan
        exact Finset.mem_Ico.mpr ⟨hlo, by omega⟩)
    omega

theorem canonical_cluster_length_le {σ : ℕ → Bool} {m k q N : ℕ}
    (hσ : Admissible σ m k) (hwidth : m*q+1 ≤ k) {c : List ℕ}
    (hc : c ∈ clusters σ N q) : c.length ≤ m :=
  admissible_list_length hσ hwidth c (cluster_sorted hc)
    (fun _ hi => cluster_miss hc hi) (cluster_steps hc)

theorem canonical_cluster_span {σ : ℕ → Bool} {m k q N : ℕ}
    (hσ : Admissible σ m k) (hwidth : m*q+1 ≤ k) (hq : 0 < q) {c : List ℕ}
    (hc : c ∈ clusters σ N q) :
    c.toFinset ⊆ Finset.Ico c.head! (c.head!+m*q) := by
  cases c with
  | nil => exact (cluster_ne_nil hc rfl).elim
  | cons a l =>
    intro i hi
    have hi' : i ∈ a::l := List.mem_toFinset.mp hi
    have hlen := canonical_cluster_length_le hσ hwidth hc
    have hlt : l.length < m := by simpa using hlen
    have hmul := Nat.mul_lt_mul_of_pos_right hlt hq
    have hspan := list_chain_span q a l (cluster_steps hc) i hi'
    have hlo : a ≤ i := by
      rcases List.mem_cons.mp hi' with rfl | hi'
      · rfl
      · exact le_of_lt ((List.pairwise_cons.mp (cluster_sorted hc)).1 i hi')
    change i ∈ Finset.Ico a (a+m*q)
    exact Finset.mem_Ico.mpr ⟨hlo, by omega⟩

def clusterAt (σ : ℕ → Bool) (N q : ℕ)
    (i : Fin (clusters σ N q).length) : List ℕ := (clusters σ N q).get i

/-- The canonical split contains disjoint actual miss sets. -/
theorem canonical_clusters_disjoint (σ : ℕ → Bool) (N q : ℕ) :
    (Finset.univ : Finset (Fin (clusters σ N q).length)).toSet.PairwiseDisjoint
      (fun i => (clusterAt σ N q i).toFinset) := by
  have hflat : (clusters σ N q).flatten.Nodup := by
    rw [flatten_clusters]
    exact Finset.sort_nodup _ _
  have hp := (List.nodup_flatten.mp hflat).2
  intro i _ j _ hij
  have hd : List.Disjoint (clusterAt σ N q i) (clusterAt σ N q j) := by
    rcases lt_or_gt_of_ne hij with hlt | hgt
    · exact List.pairwise_iff_get.mp hp i j hlt
    · exact (List.pairwise_iff_get.mp hp j i hgt).symm
  apply Finset.disjoint_left.mpr
  intro x hx hy
  exact List.disjoint_left.mp hd (List.mem_toFinset.mp hx) (List.mem_toFinset.mp hy)

/-- Fully instantiated packing bound for the actual canonical decomposition
of any admissible prefix, not a supplied collection of hypothetical clusters. -/
theorem canonical_bin_budget {σ : ℕ → Bool} {m k q N t : ℕ}
    (hσ : Admissible σ m k) (hwidth : m*q+1 ≤ k) (hq : 0 < q) :
    ∑ i ∈ (Finset.univ : Finset (Fin (clusters σ N q).length)).filter
      (fun i => (clusterAt σ N q i).head! / (k-m*q) = t),
      (clusterAt σ N q i).length ≤ m := by
  let J := (Finset.univ : Finset (Fin (clusters σ N q).length)).filter
    (fun i => (clusterAt σ N q i).head! / (k-m*q) = t)
  let D := fun i => (clusterAt σ N q i).toFinset
  have hmem : ∀ i, clusterAt σ N q i ∈ clusters σ N q := fun i => List.get_mem _ i
  have hcards : (∑ i ∈ J, (clusterAt σ N q i).length) = ∑ i ∈ J, (D i).card := by
    apply Finset.sum_congr rfl
    intro i _
    symm
    exact List.toFinset_card_of_nodup ((cluster_sorted (hmem i)).imp fun h => ne_of_lt h)
  change (∑ i ∈ J, (clusterAt σ N q i).length) ≤ m
  rw [hcards]
  apply paper_bin_budget hσ hwidth J D (fun i => (clusterAt σ N q i).head!)
  · intro c _ i hi
    exact cluster_miss (hmem c) (List.mem_toFinset.mp hi)
  · intro c hc
    exact (Finset.mem_filter.mp hc).2
  · intro c _
    exact canonical_cluster_span hσ hwidth hq (hmem c)
  · intro i _ j _ hij
    exact canonical_clusters_disjoint σ N q (Finset.mem_univ i) (Finset.mem_univ j) hij

theorem cluster_index_lt {σ : ℕ → Bool} {N q : ℕ} {c : List ℕ}
    (hc : c ∈ clusters σ N q) {i : ℕ} (hi : i ∈ c) : i < N := by
  have h := (cluster_sublist hc).subset hi
  simp only [missList, Finset.mem_sort, Finset.mem_filter, Finset.mem_range] at h
  exact h.1

theorem canonical_bin_label_lt (σ : ℕ → Bool) (N q L : ℕ)
    (i : Fin (clusters σ N q).length) :
    (clusterAt σ N q i).head! / L < N/L+1 := by
  have hc : clusterAt σ N q i ∈ clusters σ N q := List.get_mem _ i
  have hhead := List.head!_mem_self (cluster_ne_nil hc)
  have hlt := cluster_index_lt hc hhead
  have hdiv : (clusterAt σ N q i).head! / L ≤ N/L :=
    Nat.div_le_div_right (Nat.le_of_lt hlt)
  omega

/-- The occupied-bin count has the asymptotically equivalent floor-plus-one bound. -/
theorem canonical_bin_count_le (σ : ℕ → Bool) (N q L : ℕ) :
    ((Finset.univ : Finset (Fin (clusters σ N q).length)).image
      (fun i => (clusterAt σ N q i).head! / L)).card ≤ N/L+1 := by
  have hsub : ((Finset.univ : Finset (Fin (clusters σ N q).length)).image
      (fun i => (clusterAt σ N q i).head! / L)) ⊆ Finset.range (N/L+1) := by
    intro t ht
    obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp ht
    exact Finset.mem_range.mpr (canonical_bin_label_lt σ N q L i)
  simpa only [Finset.card_range] using Finset.card_le_card hsub

/-- The split neither loses nor duplicates any prefix miss. -/
theorem canonical_total_misses (σ : ℕ → Bool) (N q : ℕ) :
    ((clusters σ N q).map List.length).sum =
      ((Finset.range N).filter fun i => σ i = false).card := by
  rw [← List.length_flatten, flatten_clusters]
  simp [missList]

theorem canonical_total_misses_le {σ : ℕ → Bool} {m k : ℕ}
    (hσ : Admissible σ m k) (hk : 0 < k) (N q : ℕ) :
    ((clusters σ N q).map List.length).sum ≤ m*(N/k+1) := by
  rw [canonical_total_misses]
  exact prefix_count_le hσ hk N

end MissedUpdates
