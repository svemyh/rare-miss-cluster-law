import MissedUpdates

example : MissedUpdates.Admissible (fun _ => true) 0 5 := by
  intro s
  simp
