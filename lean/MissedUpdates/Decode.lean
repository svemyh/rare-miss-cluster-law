import MissedUpdates.Clusters
import MissedUpdates.Words

namespace MissedUpdates

def prefixWord (σ : ℕ → Bool) (N : ℕ) : List Bool := (List.range N).map σ

/-- The next position after decoding a list of absolute miss positions. -/
def cursor : ℕ → List ℕ → ℕ
  | a, [] => a
  | _, p::ps => cursor (p+1) ps

/-- Decode absolute positions into the actual success/miss word, stopping at the last miss. -/
def positionsWord : ℕ → List ℕ → List Bool
  | _, [] => []
  | a, p::ps => List.replicate (p-a) true ++ false :: positionsWord (p+1) ps

theorem cursor_append (a : ℕ) (ps qs : List ℕ) :
    cursor a (ps++qs) = cursor (cursor a ps) qs := by
  induction ps generalizing a with
  | nil => rfl
  | cons p ps ih => exact ih (p+1)

theorem positionsWord_append (a : ℕ) (ps qs : List ℕ) :
    positionsWord a (ps++qs) =
      positionsWord a ps ++ positionsWord (cursor a ps) qs := by
  induction ps generalizing a with
  | nil => rfl
  | cons p ps ih => simp [positionsWord, cursor, ih, List.append_assoc]

theorem positionsWord_count (a : ℕ) (ps : List ℕ) :
    (positionsWord a ps).count false = ps.length := by
  induction ps generalizing a with
  | nil => simp [positionsWord]
  | cons p ps ih => simp [positionsWord, ih, List.count_replicate]

theorem cursor_le {a N : ℕ} {ps : List ℕ} (ha : a ≤ N)
    (hps : ∀ p ∈ ps, p < N) : cursor a ps ≤ N := by
  induction ps generalizing a with
  | nil => exact ha
  | cons p ps ih =>
    exact ih (by have := hps p (by simp); omega) (fun q hq => hps q (by simp [hq]))

theorem cursor_nonempty (a b : ℕ) (ps : List ℕ) (h : ps ≠ []) :
    cursor a ps = cursor b ps := by
  cases ps <;> simp_all [cursor]

theorem cursor_eq_getLast (a : ℕ) (ps : List ℕ) (h : ps ≠ []) :
    cursor a ps = ps.getLast h + 1 := by
  induction ps generalizing a with
  | nil => contradiction
  | cons p ps ih =>
    cases ps with
    | nil => simp [cursor]
    | cons q qs => simpa [cursor] using ih (q+1) (by simp)

theorem missList_filter (σ : ℕ → Bool) (N : ℕ) :
    missList σ N = (List.range N).filter (fun i => σ i = false) := by
  apply List.SortedLT.eq_of_mem_iff
  · exact Finset.sortedLT_sort _
  · exact ((List.sortedLT_range N).pairwise.filter _).sortedLT
  · intro i
    simp [missList]

theorem missList_succ (σ : ℕ → Bool) (N : ℕ) :
    missList σ (N+1) = missList σ N ++ (if σ N then [] else [N]) := by
  simp only [missList_filter, List.range_succ, List.filter_append, List.filter_singleton]
  cases h : σ N <;> simp [h]

theorem prefixWord_succ (σ : ℕ → Bool) (N : ℕ) :
    prefixWord σ (N+1) = prefixWord σ N ++ [σ N] := by
  simp [prefixWord, List.range_succ]

theorem missList_cursor_le (σ : ℕ → Bool) (N : ℕ) :
    cursor 0 (missList σ N) ≤ N := by
  apply cursor_le (Nat.zero_le N)
  intro p hp
  simp only [missList, Finset.mem_sort, Finset.mem_filter, Finset.mem_range] at hp
  exact hp.1

/-- Exact decoding of the original prefix, including both boundary success runs. -/
theorem prefixWord_decode (σ : ℕ → Bool) (N : ℕ) :
    prefixWord σ N = positionsWord 0 (missList σ N) ++
      List.replicate (N-cursor 0 (missList σ N)) true := by
  induction N with
  | zero => simp [prefixWord, missList, positionsWord, cursor]
  | succ N ih =>
    rw [prefixWord_succ, missList_succ, ih]
    have hle := missList_cursor_le σ N
    cases h : σ N with
    | false => simp [h, positionsWord_append, cursor_append, positionsWord, cursor,
        List.append_assoc]
    | true =>
      have heq : N+1-cursor 0 (missList σ N) = (N-cursor 0 (missList σ N))+1 := by omega
      simp [h, heq, List.replicate_succ', List.append_assoc]

/-- The canonical cluster split decodes to the actual word, not a hypothetical product. -/
theorem prefixWord_canonical_decode (σ : ℕ → Bool) (N q : ℕ) :
    prefixWord σ N = positionsWord 0 (clusters σ N q).flatten ++
      List.replicate (N-cursor 0 (clusters σ N q).flatten) true := by
  simpa [flatten_clusters] using prefixWord_decode σ N

def clusterWord (c : List ℕ) : List Bool := positionsWord c.head! c

theorem clusterWord_count (c : List ℕ) : (clusterWord c).count false = c.length :=
  positionsWord_count _ _

theorem positionsWord_leading (a : ℕ) (c : List ℕ) (hc : c ≠ []) :
    positionsWord a c = List.replicate (c.head!-a) true ++ clusterWord c := by
  cases c with
  | nil => contradiction
  | cons p ps => simp [positionsWord, clusterWord]

end MissedUpdates
