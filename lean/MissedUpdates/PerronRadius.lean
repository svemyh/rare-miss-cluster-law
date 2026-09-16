import MissedUpdates.PerronConvergence

open Matrix
open scoped ENNReal NNReal

namespace MissedUpdates.Matrices

variable {n : Type*} [Fintype n] [DecidableEq n] [Nonempty n]

/-- Ordinary complex spectral radius of a real matrix, not just its real spectrum. -/
noncomputable def ordinarySpectralRadius (C : Matrix n n ℝ) : ℝ :=
  (spectralRadius ℂ (C.map (algebraMap ℝ ℂ))).toReal

theorem positive_eigenvalue_spectralRadius {C : Matrix n n ℝ}
    (hC : ∀ i j, 0 < C i j) {lam : ℝ} (hlam : 0 < lam)
    {r : n → ℝ} (hr : ∀ i, 0 < r i) (hCr : C *ᵥ r = lam • r) :
    spectralRadius ℂ (C.map (algebraMap ℝ ℂ)) = ENNReal.ofReal lam := by
  have hirr := (positive_isPrimitive hC).isIrreducible
  have hnn := fun i j => (hC i j).le
  have hlamPF := Matrix.eigenvalue_is_perron_root_of_positive_eigenvector hirr hnn hlam hr hCr
  let rc : n → ℂ := fun i => (r i : ℂ)
  have hrc : rc ≠ 0 := by
    intro h
    have hi := congrFun h (Classical.arbitrary n)
    change (r (Classical.arbitrary n) : ℂ) = 0 at hi
    have hz : r (Classical.arbitrary n) = 0 := by exact_mod_cast hi
    exact (hr _).ne' hz
  have hcEig : (C.map (algebraMap ℝ ℂ)) *ᵥ rc = (lam : ℂ) • rc := by
    ext i
    have hi := congrFun hCr i
    simpa [rc, Matrix.mulVec, dotProduct, Matrix.map_apply, smul_eq_mul] using
      congrArg (fun x : ℝ => (x : ℂ)) hi
  have hmem := Matrix.mem_spectrum_of_eigenvalue hrc hcEig
  unfold spectralRadius
  apply le_antisymm
  · apply iSup₂_le
    intro z hz
    rw [← ENNReal.ofReal_coe_nnreal]
    exact ENNReal.ofReal_le_ofReal
      ((Matrix.eigenvalue_abs_le_perron_root hirr hnn hz).trans_eq hlamPF.symm)
  · have h : (‖(lam : ℂ)‖₊ : ℝ≥0∞) ≤
        ⨆ z ∈ spectrum ℂ (C.map (algebraMap ℝ ℂ)), (‖z‖₊ : ℝ≥0∞) :=
      le_iSup_of_le (lam : ℂ) (le_iSup_of_le hmem le_rfl)
    simpa only [← ENNReal.ofReal_coe_nnreal, coe_nnnorm, Complex.norm_real,
      Real.norm_eq_abs, abs_of_pos hlam] using h

theorem normalized_frame_spectralRadius {C : Matrix n n ℝ}
    (hC : ∀ i j, 0 < C i j) {lam : ℝ} (hlam : 0 < lam) (F : Frame (lam⁻¹ • C)) :
    ordinarySpectralRadius C = lam := by
  have hCr : C *ᵥ F.right = lam • F.right := by
    have h := congrArg (fun v : n → ℝ => lam • v) F.right_fixed
    simpa [Matrix.smul_mulVec, smul_smul, hlam.ne'] using h
  rw [ordinarySpectralRadius, positive_eigenvalue_spectralRadius hC hlam F.right_pos hCr,
    ENNReal.toReal_ofReal hlam.le]

end MissedUpdates.Matrices
