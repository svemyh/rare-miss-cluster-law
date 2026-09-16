import MissedUpdates

open Matrix Filter
open scoped Topology Matrix.Norms.Elementwise
open MissedUpdates.Matrices

-- A separate symbolic consumer of the all-later-windows implication.
example {n : Type*} [Fintype n] [DecidableEq n] [Nonempty n]
    {B E : Matrix n n ℝ} (F : Frame B) (hB : ∀ i j, 0 < B i j) (hE : Nonnegative E)
    {m q k0 : ℕ} (hm : 1 ≤ m) (hq : 0 < q) (hk0 : m*(q+1) ≤ k0) (hk02 : 2*(m*q) ≤ k0)
    {e : ℝ} (ht : RelativeTail B (outer F.right F.left) q e) (hehalf : e ≤ 1/2)
    {H delta : ℝ} (hH : Real.log (clusterSup F E m) ≤ H) (hdelta : 0 < delta)
    (he : 6*(m : ℝ)*e ≤ delta) (hsize : 4*(m*q : ℕ)*H ≤ (k0 : ℝ)*delta) :
    ∀ k ≥ k0, |(k : ℝ)*Real.log (constrainedRate B E m k)-Real.log (clusterSup F E m)| ≤ delta :=
  all_later_windows_accuracy F hB hE hm hq hk0 hk02 ht hehalf hH hdelta he hsize
