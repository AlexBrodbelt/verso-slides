import VersoSlides
import Verso.Doc.Concrete
import Mathlib.Topology.MetricSpace.Pseudo.Defs
import Mathlib.Topology.MetricSpace.Defs
import Mathlib.Data.ENNReal.Real

-- what is a diamond

open VersoSlides

variable {α β : Type u}

set_option verso.code.warnLineLength 500

#doc (Slides) "Dealing with Diamonds" =>

# TYPECLASSES IN MATHLIB

%%%
autoAnimate := true
%%%

:::vstack
1. Mathlib, its missions and design considerations

2. Typeclass use in Mathlib

3. Optimising typeclass synthesis in Mathlib

4. Hazards of typeclass use

5. Type synonyms
:::


# TYPECLASSES IN MATHLIB

%%%
autoAnimate := true
%%%

:::::fitText
4. Hazards of typeclass use
:::::

# 4. Hazards of typeclass use

:::fragment fadeUp
It is often the case that one deals with diamond like hierarchies
when building up mathematical structures.

We saw this for example with the algebraic hierarchy.

{image "../figures/HierarchyAlgebra.png" (width := "600px")}[Algebraic hierarchy]
:::

# 4. Hazards of typeclass use

:::fragment fadeUp
If different paths are definitionally equal, this is not a problem.

However, in the following diamond:

{image "../figures/TopDiamond.svg" (width := "600px")}[Demo image]

It is easy to set up the typeclasses in such a way that a bad diamond is produced.
:::

# 4. Hazards of typeclass use

:::fragment fadeUp

Consider synthesizing a {lean}`TopologicalSpace` instance on `α × β`, given two {lean}`MetricSpace` instances.

Consider the "natural" set up for the {lean}`MetricSpace` typeclass.

```lean -panel
class BadMetricSpace (α : Type u) : Type u extends Dist α where
  dist_self : ∀ x : α, dist x x = 0
  dist_comm : ∀ x y : α, dist x y = dist y x
  dist_triangle : ∀ x y z : α, dist x z ≤ dist x y + dist y z
  eq_of_dist_eq_zero {x y : α} : dist x y = 0 → x = y
```
:::

# 4. Hazards of typeclass use

Consider the paths:

:::fragment fadeUp
 {lean}`MetricSpace α` → {lean}`TopologicalSpace α` → {lean}`TopologicalSpace (α × β)`

{lean}`MetricSpace α` → {lean}`MetricSpace (α × β)` → {lean}`TopologicalSpace (α × β)`
where $$`d((a_1,b_1) , (a_2, b_2)) = d_{\alpha}(a_1, a_2) \sqcup d_{\beta}(b_1, b_2)`

The two topologies are the same mathematically, but not definitionally.

This is a problem.
:::

# 4. Hazards of typeclass use

The fix.

:::fragment fadeUp
Inspired by the algebraic hierarchy's *forgetful inheritance*.

A metric space contains both a *distance*, a *topology*, and a *proof* that the topology coincides with the one coming from the distance.

Furthermore, define the instance {lean}`MetricSpace α × β` with the *supremum distance*, the *product topology*  and the proof that the topology induced by the metric
coincides with the product topology.

Both *definitionally equal* paths yield the product topology on the product space.
:::

# 4. Hazards of typeclass use

We set up {lean}`PseudoMetricSpace`s to contain a {lean}`UniformSpace` which in turn contains
a {lean}`TopologicalSpace`.

```lean -panel
-- !hide
namespace test''

open Set Filter TopologicalSpace Bornology
open scoped ENNReal NNReal Uniformity Topology

private theorem dist_nonneg' {α} {x y : α} (dist : α → α → ℝ)
    (dist_self : ∀ x : α, dist x x = 0) (dist_comm : ∀ x y : α, dist x y = dist y x)
    (dist_triangle : ∀ x y z : α, dist x z ≤ dist x y + dist y z) : 0 ≤ dist x y :=
  have : 0 ≤ 2 * dist x y :=
    calc 0 = dist x x := (dist_self _).symm
    _ ≤ dist x y + dist y x := dist_triangle _ _ _
    _ = 2 * dist x y := by rw [two_mul, dist_comm]
  nonneg_of_mul_nonneg_right this two_pos
-- !end hide
class PseudoMetricSpace (α : Type u) : Type u extends Dist α where
  dist_self : ∀ x : α, dist x x = 0
  dist_comm : ∀ x y : α, dist x y = dist y x
  dist_triangle : ∀ x y z : α, dist x z ≤ dist x y + dist y z
  /-- Extended distance between two points -/
  edist : α → α → ENNReal := fun x y => ENNReal.ofNNReal (.mk (dist x y) (dist_nonneg' _ ‹_› ‹_› ‹_›))
  edist_dist : ∀ x y : α, edist x y = ENNReal.ofReal (dist x y) := by
    intro x y; exact ENNReal.coe_nnreal_eq _
  toUniformSpace : UniformSpace α := .ofDist dist dist_self dist_comm dist_triangle
  -- ^ !click
  uniformity_dist : 𝓤 α = ⨅ ε > 0, 𝓟 { p : α × α | dist p.1 p.2 < ε } := by intros; rfl
  toBornology : Bornology α := Bornology.ofDist dist dist_comm dist_triangle
  cobounded_sets : (Bornology.cobounded α).sets =
    { s | ∃ C : ℝ, ∀ x ∈ sᶜ, ∀ y ∈ sᶜ, dist x y ≤ C } := by intros; rfl
```
