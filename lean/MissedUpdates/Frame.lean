import MissedUpdates.Matrix

open Matrix

namespace MissedUpdates
namespace Matrices

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Normalized positive eigenvectors. Convergence and the growth bound are not fields. -/
structure Frame (B : Matrix n n ℝ) where
  right : n → ℝ
  left : n → ℝ
  right_pos : ∀ i, 0 < right i
  left_pos : ∀ i, 0 < left i
  right_fixed : B *ᵥ right = right
  left_fixed : left ᵥ* B = left
  pairing_one : left ⬝ᵥ right = 1

end Matrices
end MissedUpdates
