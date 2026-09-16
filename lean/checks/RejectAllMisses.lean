import MissedUpdates

-- This file is an intentional compile failure and is not part of the library.
example : MissedUpdates.Admissible (fun _ => false) 2 3 := by
  intro s
  norm_num
