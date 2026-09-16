import MissedUpdates.Perron
import MissedUpdates.Frame
import MCMC.Convergence

open Matrix Filter
open scoped BigOperators Topology

namespace MissedUpdates.Matrices

variable {n : Type*} [Fintype n] [DecidableEq n] [Nonempty n]

/-- Existence of a normalized Perron frame, with no convergence premise. -/
theorem positive_frame_exists {C : Matrix n n ℝ} (hC : ∀ i j, 0 < C i j) :
    ∃ lam : ℝ, 0 < lam ∧ Nonempty (Frame (lam⁻¹ • C)) := by
  obtain ⟨lam, r, l, hlam, hr, hl, hlr, hCr, hlC⟩ :=
    positive_left_right_eigenvectors hC
  refine ⟨lam, hlam, ⟨⟨r, l, hr, hl, ?_, ?_, hlr⟩⟩⟩
  · rw [Matrix.smul_mulVec, hCr, smul_smul, inv_mul_cancel₀ hlam.ne']
    exact one_smul _ _
  · rw [Matrix.vecMul_smul, hlC, smul_smul, inv_mul_cancel₀ hlam.ne']
    exact one_smul _ _

/-- Diagonal similarity taking a positive fixed right vector to the all-ones vector. -/
noncomputable def stochasticConjugate (r : n → ℝ) (A : Matrix n n ℝ) : Matrix n n ℝ :=
  fun i j => (r i)⁻¹ * A i j * r j

theorem stochasticConjugate_mul (r : n → ℝ) (hr : ∀ i, r i ≠ 0)
    (A D : Matrix n n ℝ) :
    stochasticConjugate r (A * D) =
      stochasticConjugate r A * stochasticConjugate r D := by
  ext i j
  simp only [stochasticConjugate, Matrix.mul_apply, Finset.mul_sum, Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro k _
  field_simp [hr]

theorem stochasticConjugate_one (r : n → ℝ) (hr : ∀ i, r i ≠ 0) :
    stochasticConjugate r (1 : Matrix n n ℝ) = 1 := by
  ext i j
  by_cases h : i = j
  · subst j; simp [stochasticConjugate, hr]
  · simp [stochasticConjugate, Matrix.one_apply, h]

theorem stochasticConjugate_pow (r : n → ℝ) (hr : ∀ i, r i ≠ 0)
    (A : Matrix n n ℝ) (g : ℕ) :
    stochasticConjugate r (A^g) = (stochasticConjugate r A)^g := by
  induction g with
  | zero => simpa using stochasticConjugate_one r hr
  | succ g ih => rw [pow_succ, stochasticConjugate_mul r hr, ih, pow_succ]

theorem stochasticConjugate_recover (r : n → ℝ) (hr : ∀ i, r i ≠ 0)
    (A : Matrix n n ℝ) (i j : n) :
    r i * stochasticConjugate r A i j / r j = A i j := by
  dsimp [stochasticConjugate]
  field_simp [hr]

theorem Frame.conjugate_stochastic {B : Matrix n n ℝ} (F : Frame B)
    (hB : Nonnegative B) : IsStochastic (stochasticConjugate F.right B) := by
  constructor
  · intro i j
    exact _root_.mul_nonneg (_root_.mul_nonneg (inv_nonneg.mpr (F.right_pos i).le)
      (hB i j)) (F.right_pos j).le
  · intro i
    have h := congrFun F.right_fixed i
    change (∑ j, B i j * F.right j) = F.right i at h
    simp only [stochasticConjugate, mul_assoc, ← Finset.mul_sum, h]
    exact inv_mul_cancel₀ (F.right_pos i).ne'

noncomputable def Frame.stationaryVector {B : Matrix n n ℝ} (F : Frame B) :
    stdSimplex ℝ n :=
  ⟨fun i => F.left i * F.right i,
    fun i => _root_.mul_nonneg (F.left_pos i).le (F.right_pos i).le, F.pairing_one⟩

theorem Frame.conjugate_stationary {B : Matrix n n ℝ} (F : Frame B) :
    IsStationary (stochasticConjugate F.right B) F.stationaryVector := by
  unfold IsStationary
  ext j
  change (∑ i, ((F.right i)⁻¹ * B i j * F.right j) *
    (F.left i * F.right i)) = F.left j * F.right j
  calc
    _ = (∑ i, F.left i * B i j) * F.right j := by
      rw [Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro i _
      field_simp [(F.right_pos i).ne']
    _ = _ := by
      have h := congrFun F.left_fixed j
      change (∑ i, F.left i * B i j) = F.left j at h
      rw [h]

/-- Positivity plus fixed Perron vectors implies convergence; convergence is derived
from the kernel-checked Dobrushin contraction proof, not assumed in `Frame`. -/
theorem Frame.power_converges {B : Matrix n n ℝ} (F : Frame B)
    (hB : ∀ i j, 0 < B i j) :
    ∀ i j, Tendsto (fun g : ℕ => (B^g) i j) atTop
      (𝓝 ((outer F.right F.left) i j)) := by
  let P := stochasticConjugate F.right B
  have hP : ∀ i j, 0 < P i j := fun i j =>
    mul_pos (mul_pos (inv_pos.mpr (F.right_pos i)) (hB i j)) (F.right_pos j)
  have hprim := positive_isPrimitive hP
  have hM : IsMCMC P F.stationaryVector :=
    ⟨F.conjugate_stochastic (fun i j => (hB i j).le),
      F.conjugate_stationary, hprim.isIrreducible, hprim⟩
  have hconv := convergence_to_stationarity P F.stationaryVector hM
  intro i j
  have hc := ((tendsto_pi_nhds.mp (tendsto_pi_nhds.mp hconv i) j).const_mul
    (F.right i)).div_const (F.right j)
  have hseq (g : ℕ) : F.right i * (P^g) i j / F.right j = (B^g) i j := by
    rw [← stochasticConjugate_pow F.right (fun t => (F.right_pos t).ne') B g]
    exact stochasticConjugate_recover F.right (fun t => (F.right_pos t).ne') _ i j
  have hlim : F.right i * LimitMatrix F.stationaryVector i j / F.right j =
      (outer F.right F.left) i j := by
    dsimp [LimitMatrix, Frame.stationaryVector, outer]
    field_simp [(F.right_pos j).ne']
  simpa only [hseq, hlim] using hc

/-- Complete positivity-to-normalized-Perron-convergence bridge. -/
theorem positive_perron_convergence {C : Matrix n n ℝ} (hC : ∀ i j, 0 < C i j) :
    ∃ (lam : ℝ) (_ : 0 < lam) (F : Frame (lam⁻¹ • C)),
      ∀ i j, Tendsto (fun g : ℕ => ((lam⁻¹ • C)^g) i j) atTop
        (𝓝 ((outer F.right F.left) i j)) := by
  obtain ⟨lam, hlam, ⟨F⟩⟩ := positive_frame_exists hC
  exact ⟨lam, hlam, F, F.power_converges
    (fun i j => mul_pos (inv_pos.mpr hlam) (hC i j))⟩

end MissedUpdates.Matrices
