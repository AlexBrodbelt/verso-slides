import VersoSlides
import Verso.Doc.Concrete
import Mathlib.Order.Defs.LinearOrder
import Mathlib.Data.Nat.Basic
import Mathlib.Order.OrderDual
import Mathlib.Algebra.Group.Subgroup.Defs
import Mathlib.Topology.Basic
import Mathlib.Topology.Order
import Mathlib.Algebra.Group.Opposite
import Mathlib.GroupTheory.GroupAction.Defs


open Set Filter Topology


open VersoSlides

set_option verso.code.warnLineLength 500

#doc (Slides) "Type Synonyms" =>

# TYPECLASSES IN MATHLIB

%%%
autoAnimate := true
%%%

:::vstack
1. Mathlib, its missions and design considerations

2. Typeclass use in Mathlib

3. Optimising typeclass synthesis in Mathlib

4. Hazards of typeclass use

5. Registering multiple instances
:::

# TYPECLASSES IN MATHLIB

%%%
autoAnimate := true
%%%

:::fitText
5. Registering multiple instances
:::

# 5. Registering multiple instances

:::fragment fadeUp
Typically, when deciding between whether a mathematical notion should be a `class` or
a `structure`.

The decision to make it a typeclass often comes down to recognizing whether:

* We are dealing with a *property* on a type which we want to use implicitly → `class`

* Or whether we are working with an *object* that belongs to a family of objects → `structure`
:::

# 5. Registering multiple instances

:::fragment fadeUp
Think about {lean}`Group` and {lean}`Subgroup`:

We use {lean}`Group` when we want to work with properties of groups.

We use {lean}`Subgroup` when we want to talk about the {lean}`Lattice` of subgroups of a `Group`.

But what if:

We want to equip a same type with different properties?

Or, we want to explore the interactions between these properties?
:::

# 5. Registering multiple instances

In topology, we generally fix a specific topology.

But sometimes we want to reason about non-standard topologies on
a type and even, their interactions.

```lean
def indiscreteTopology : TopologicalSpace ℕ := ⊤
def discreteTopology : TopologicalSpace ℕ := ⊥

example : ¬ IsOpen[indiscreteTopology] {1} := by
  intro contr
  have := TopologicalSpace.isOpen_top_iff {1}
  simp only [singleton_ne_empty, singleton_ne_univ,
    or_self, iff_false] at this
  contradiction

example : IsOpen[discreteTopology] {1} := by
  exact trivial
```

# 5. Registering multiple instances

:::fragment fadeUp
In a similar fashion, consider the natural numbers, {lean}`ℕ`.

One can use the usual ordering on the natural numbers.

```lean -panel
example : (0 : ℕ) ≤ (1 : ℕ) := by decide
```
:::

# 5. Registering multiple instances

:::fragment fadeUp
But it is also possible to equip the same type with the dual order.

We do not want competing instances on a same type.

Solution: we use *type synonyms* such as {lean}`OrderDual`
with handy notation to differentiate between them.

```lean -panel
-- !hide
open OrderDual

instance OrderDual.instOfNatNat (n : ℕ) : OfNat ℕᵒᵈ n where
  ofNat := n
-- !end hide

example : (1 : ℕᵒᵈ) ≤ (0 : ℕᵒᵈ) := by decide
```
:::

# 5. Registering multiple instances

Similarly, we can use type synonyms when using {lean}`Group` actions.

```lean
variable {G : Type*} [Group G]

/- Left action -/
example (g x : G) : g • x = g * x :=
  rfl

open MulOpposite

/- Right action -/
example (g : Gᵐᵒᵖ) (x : G) : (g) • x = x * (unop g) :=  rfl
```
