import MissedUpdates.Matrix
import Mathlib.Topology.Instances.Real.Lemmas
import Mathlib.Topology.Order.OrderClosed
import Mathlib.Order.Filter.Finite
import Mathlib.Topology.Algebra.Monoid

open Filter Matrix
open scoped Topology

namespace MissedUpdates
namespace Matrices

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Coordinate convergence to a strictly positive matrix gives one tail bound
uniform over every coordinate and every later power. This does not assume
the main growth-rate bound or assert Perron–Frobenius existence. -/
theorem uniform_power_tail {B P : Matrix n n ℝ}
    (hP : ∀ i j, 0 < P i j)
    (hconv : ∀ i j, Tendsto (fun g : ℕ => (B^g) i j) atTop (𝓝 (P i j)))
    {ε : ℝ} (hε : 0 < ε) :
    ∃ q : ℕ, ∀ g ≥ q, EntrywiseLE (B^g) ((1+ε) • P) := by
  have each : ∀ i j, ∀ᶠ g : ℕ in atTop, (B^g) i j ≤ (1+ε)*P i j := by
    intro i j
    have hlt : P i j < (1+ε)*P i j := by nlinarith [hP i j]
    exact (hconv i j).eventually_le_const hlt
  have all : ∀ᶠ g : ℕ in atTop, ∀ i j, (B^g) i j ≤ (1+ε)*P i j :=
    Filter.eventually_all.mpr fun i => Filter.eventually_all.mpr fun j => each i j
  obtain ⟨q, hq⟩ := Filter.eventually_atTop.mp all
  refine ⟨q, ?_⟩
  intro g hg i j
  exact hq g hg i j

omit [DecidableEq n] in
/-- Matrix multiplication preserves coordinate convergence in finite dimension. -/
theorem matrix_mul_tendsto {F G : ℕ → Matrix n n ℝ} {A B : Matrix n n ℝ}
    (hF : ∀ i j, Tendsto (fun k => F k i j) atTop (𝓝 (A i j)))
    (hG : ∀ i j, Tendsto (fun k => G k i j) atTop (𝓝 (B i j))) :
    ∀ i j, Tendsto (fun k => (F k * G k) i j) atTop (𝓝 ((A*B) i j)) := by
  intro i j
  change Tendsto (fun k => ∑ s, F k i s * G k s j) atTop
    (𝓝 (∑ s, A i s * B s j))
  exact tendsto_finsetSum _ fun s _ => (hF i s).mul (hG s j)

omit [DecidableEq n] in
theorem gain_tendsto (ℓ r : n → ℝ) {F : ℕ → Matrix n n ℝ} {P : Matrix n n ℝ}
    (hF : ∀ i j, Tendsto (fun k => F k i j) atTop (𝓝 (P i j))) :
    Tendsto (fun k => gain ℓ r (F k)) atTop (𝓝 (gain ℓ r P)) := by
  change Tendsto (fun k => ∑ i, ℓ i * (∑ j, F k i j * r j)) atTop
    (𝓝 (∑ i, ℓ i * (∑ j, P i j * r j)))
  apply tendsto_finsetSum
  intro i _
  apply tendsto_const_nhds.mul
  exact tendsto_finsetSum _ fun j _ => (hF i j).mul tendsto_const_nhds

/-- The analytic two-cluster joining step, with the convergence premise visible. -/
theorem padded_gain_tendsto (ℓ r : n → ℝ) (A B C : Matrix n n ℝ)
    (hconv : ∀ i j, Tendsto (fun g : ℕ => (B^g) i j) atTop
      (𝓝 ((outer r ℓ) i j))) :
    Tendsto (fun g : ℕ => gain ℓ r (A * B^g * C)) atTop
      (𝓝 (gain ℓ r A * gain ℓ r C)) := by
  have hleft : ∀ i j, Tendsto (fun g : ℕ => (A*B^g) i j) atTop
      (𝓝 ((A*outer r ℓ) i j)) :=
    matrix_mul_tendsto (fun _ _ => tendsto_const_nhds) hconv
  have hboth : ∀ i j, Tendsto (fun g : ℕ => (A*B^g*C) i j) atTop
      (𝓝 ((A*outer r ℓ*C) i j)) :=
    matrix_mul_tendsto hleft (fun _ _ => tendsto_const_nhds)
  simpa [gain_insert_reset] using gain_tendsto ℓ r hboth

/-- A bound on every finite joined cluster also bounds its limiting product gain. -/
theorem joined_gain_le (ℓ r : n → ℝ) (A B C : Matrix n n ℝ)
    (hconv : ∀ i j, Tendsto (fun g : ℕ => (B^g) i j) atTop
      (𝓝 ((outer r ℓ) i j))) {S : ℝ}
    (hS : ∀ g : ℕ, gain ℓ r (A*B^g*C) ≤ S) :
    gain ℓ r A * gain ℓ r C ≤ S := by
  exact le_of_tendsto' (padded_gain_tendsto ℓ r A B C hconv) hS

end Matrices
end MissedUpdates
