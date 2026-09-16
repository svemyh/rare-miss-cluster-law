import MissedUpdates.Words
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Fin

open Matrix Filter
open scoped BigOperators Topology

namespace MissedUpdates.Matrices

variable {n : Type*} [Fintype n] [DecidableEq n]

def paddedWords (g : ℕ) : List (List Bool) → List Bool
  | [] => []
  | w::ws => w ++ List.replicate g true ++ paddedWords g ws

theorem paddedWords_count (g : ℕ) (ws : List (List Bool)) :
    (paddedWords g ws).count false = (ws.map (List.count false)).sum := by
  induction ws with
  | nil => simp [paddedWords]
  | cons w ws ih => simp [paddedWords, ih, List.count_replicate]

def joinedMatrix (B E P : Matrix n n ℝ) : List (List Bool) → Matrix n n ℝ
  | [] => 1
  | w::ws => joinedMatrix B E P ws * P * wordProduct B E w

theorem paddedWords_matrix_tendsto {B E P : Matrix n n ℝ}
    (hconv : ∀ i j, Tendsto (fun g : ℕ => (B^g) i j) atTop (𝓝 (P i j)))
    (ws : List (List Bool)) :
    ∀ i j, Tendsto (fun g : ℕ => wordProduct B E (paddedWords g ws) i j) atTop
      (𝓝 (joinedMatrix B E P ws i j)) := by
  induction ws with
  | nil => exact fun _ _ => tendsto_const_nhds
  | cons w ws ih =>
    simpa only [paddedWords, wordProduct_append, wordProduct_true, joinedMatrix,
      Matrix.mul_assoc] using
      matrix_mul_tendsto (matrix_mul_tendsto ih hconv)
        (fun _ _ => tendsto_const_nhds (x := wordProduct B E w _ _))

theorem joinedMatrix_gain {B E : Matrix n n ℝ} (F : Frame B) (ws : List (List Bool)) :
    gain F.left F.right (joinedMatrix B E (outer F.right F.left) ws) =
      (ws.map (fun w => gain F.left F.right (wordProduct B E w))).prod := by
  induction ws with
  | nil => simp [joinedMatrix, gain, F.pairing_one]
  | cons w ws ih => simp [joinedMatrix, gain_insert_reset, ih, mul_comm]

/-- Any finite collection of clusters within one miss budget has product gain at
most the genuine finite-word supremum. Each approximating word is constructed. -/
theorem product_gains_le_clusterSup {B E : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) (hE : Nonnegative E)
    (hconv : ∀ i j, Tendsto (fun g : ℕ => (B^g) i j) atTop
      (𝓝 ((outer F.right F.left) i j)))
    {m : ℕ} (ws : List (List Bool)) (hm : (ws.map (List.count false)).sum ≤ m) :
    (ws.map (fun w => gain F.left F.right (wordProduct B E w))).prod ≤ clusterSup F E m := by
  have ht := gain_tendsto F.left F.right (paddedWords_matrix_tendsto (E := E) hconv ws)
  rw [joinedMatrix_gain F ws] at ht
  apply le_of_tendsto' ht
  intro g
  exact word_gain_le_clusterSup F hB hE (paddedWords g ws)
    (by simpa [paddedWords_count] using hm)

theorem finset_product_gains_le_clusterSup {ι : Type*} [DecidableEq ι]
    {B E : Matrix n n ℝ} (F : Frame B) (hB : Nonnegative B) (hE : Nonnegative E)
    (hconv : ∀ i j, Tendsto (fun g : ℕ => (B^g) i j) atTop
      (𝓝 ((outer F.right F.left) i j)))
    {m : ℕ} (J : Finset ι) (words : ι → List Bool)
    (hm : ∑ i ∈ J, (words i).count false ≤ m) :
    (∏ i ∈ J, gain F.left F.right (wordProduct B E (words i))) ≤ clusterSup F E m := by
  have h := product_gains_le_clusterSup F hB hE hconv (m := m) (J.toList.map words)
  simpa [List.map_map, Function.comp_def] using h (by simpa [List.map_map] using hm)

end MissedUpdates.Matrices
