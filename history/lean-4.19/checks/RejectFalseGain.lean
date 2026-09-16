import MissedUpdates

-- The all-one one-dimensional data has gain one, not two.
example : MissedUpdates.Matrices.gain (fun _ : Fin 1 => (1 : ℝ))
    (fun _ : Fin 1 => (1 : ℝ)) (1 : Matrix (Fin 1) (Fin 1) ℝ) = 2 := by
  norm_num [MissedUpdates.Matrices.gain, Matrix.mulVec, dotProduct]
