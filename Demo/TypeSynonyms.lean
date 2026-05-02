import VersoSlides
import Verso.Doc.Concrete
import Mathlib.Order.Defs.LinearOrder
import Mathlib.Data.Nat.Basic
import Mathlib.Order.OrderDual
import Mathlib.Algebra.Group.Subgroup.Defs

open VersoSlides

set_option verso.code.warnLineLength 500

#doc (Slides) "Type Synonyms" =>

# Class vs structures

:::fragment fadeUp
Typically, when deciding between whether a mathematical notion should be a `class` or
a `structure`.

The decision to make it a typeclass often comes down to recognizing whether:

-We are dealing with a *property* on a type which we want to use implicitly → `class`

-Or whether we are working with an *object* that belongs to a family of objects → `structure`
:::

# Group and Subgroup

:::fragment fadeUp
As seen for example with {lean}`Group` and {lean}`Subgroup`:

We use {lean}`Group` when we want to work with properties of groups, such as inversion, identity and so on.

We use {lean}`Subgroup` when we want to talk about the {lean}`Lattice` of subgroups to a particular `Group`.

But what if we want to equip a type with different properties.
:::

# TYPE SYNONYMS

:::fragment fadeUp
However, there are cases when it is possible to register multiple instances on a type such as for example,
the natural numbers.

As one would expect one can use the natural ordering on the natural numbers

```lean -panel
example : (0 : ℕ) ≤ (1 : ℕ) := by decide
```
:::

# TYPE SYNONYMS

:::fragment fadeUp
But it is also possible to equip the same type with the dual order.

But given we do not want competing instances on the same type, we use type synonyms
such as {lean}`OrderDual` with handy notation to differentiate between

```lean -panel
-- !hide
open OrderDual

instance OrderDual.instOfNatNat (n : ℕ) : OfNat ℕᵒᵈ n where
  ofNat := n
-- !end hide

example : (1 : ℕᵒᵈ) ≤ (0 : ℕᵒᵈ) := by decide
```
:::
