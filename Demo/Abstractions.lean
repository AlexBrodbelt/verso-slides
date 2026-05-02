import VersoSlides
import Verso.Doc.Concrete
import Mathlib.Order.Lattice
import Mathlib.Algebra.Group.Subgroup.Defs
import Mathlib.Algebra.Group.Int.Defs
import Mathlib.Data.Nat.Cast.Defs
import Mathlib.Data.Multiset.Defs
import Mathlib.Data.Finset.Defs
import Mathlib.Order.Preorder.Chain
import Mathlib.Order.Filter.Defs

open VersoSlides

set_option verso.code.warnLineLength 500

#doc (Slides) "Abstractions in Mathlib" =>

# Outline - Typeclasses in Mathlib

%%%
autoAnimate := true
%%%

:::vstack
1. Mathlib, its missions and design considerations

2. Abstractions in Mathlib

3. Dangers with abstractions in Mathlib

4. Avoiding bad diamonds

5. Using priorities in Mathlib

6. Type synonyms
:::

# TYPECLASSES IN MATHLIB


%%%
autoAnimate := true
%%%

:::fitText
2. Abstractions in Mathlib
:::

# Code duplication

:::fragment fadeUp
In mathematics, it is often the case that objects have similar properties
and behave in analogous ways.

Consider the structures {lean}`Set`, {lean}`Finset`, {lean}`Subgroup`, {lean}`Submonoid`, {lean}`Flag`, ...

These structures all share in common lemmas like:

```lean -panel
example {S : Type*} {H K : Set S} : H < K ↔ H ≤ K ∧ ∃ x ∈ K, x ∉ H :=
  -- !hide
  by simp [Set.lt_iff_ssubset, Set.ssubset_iff_exists]
  -- !end hide

example {S : Type*} {H K : Finset S} : H < K ↔ H ≤ K ∧ ∃ x ∈ K, x ∉ H :=
  -- !hide
    SetLike.lt_iff_le_and_exists
  -- !end hide

example {G : Type*} [Group G] {H K : Subgroup G} : H < K ↔ H ≤ K ∧ ∃ x ∈ K, x ∉ H :=
  -- !hide
  SetLike.lt_iff_le_and_exists
  -- !end hide

example {M : Type*} [Monoid M] {H K : Submonoid M} : H < K ↔ H ≤ K ∧ ∃ x ∈ K, x ∉ H :=
  -- !hide
  SetLike.lt_iff_le_and_exists
  -- !end hide

example {C : Type*} [LE C] {H K : Flag C} : H < K ↔ H ≤ K ∧ ∃ x ∈ K, x ∉ H :=
  -- !hide
  SetLike.lt_iff_le_and_exists
  -- !end hide
```
:::

# Abstraction


:::fragment fadeIn
{fragment (style := highlightRed)}[Problem]: Maintaining all these lemmas is tedious.
If refactors happen, all these lemmas might need to be updated.

{fragment (style := highlightGreen)}[Solution]: Recall one of the crowning jewels in `Mathlib`'s design.
:::

# Abstraction

:::fragment fadeUp
The {lean}`Filter` structure.

Among other things, the {lean}`Filter` abstraction reduced 512 lemmas involving compositions of limits into a single lemma

```lean -panel
-- !hide
open Filter
set_option linter.unusedVariables false in
variable { α β γ : Type* } in
-- !end hide
theorem Tendsto.comp {f : α → β} {g : β → γ} {x : Filter α} {y : Filter β} {z : Filter γ}
    (hg : Tendsto g y z) (hf : Tendsto f x y) : Tendsto (g ∘ f) x z :=
    -- !hide
    fun _ hs => hf (hg hs)
    -- !end hide
```

This abstraction dealt with code duplication, and on a mathematical level,
captured the essential patterns and behaviours of limiting processes.

Of course, {lean}`Filter` is a *structure* and not a *typeclass*. But we can also use typeclasses to achieve the same result!
:::

# Abstractions in typeclasses

:::fragment fadeUp
As you probably suspected, all of the structures:

{lean}`Set`, {lean}`Finset`, {lean}`Subgroup`, {lean}`Submonoid`, {lean}`Flag`

look very {lean}`SetLike` 🤔

Indeed so! All structures have a registered {lean}`SetLike` instance,
so it suffices to prove the desired lemma once.

```lean -panel
-- !hide
open SetLike in
variable {A B : Type*} [SetLike A B] [PartialOrder A] [IsConcreteLE A B] {p q : A} in
-- !end hide
theorem lt_iff_le_and_exists : p < q ↔ p ≤ q ∧ ∃ x ∈ q, x ∉ p := by
  -- !hide
  rw [lt_iff_le_not_ge, not_le_iff_exists]
  -- !end hide

```

Of course we don't register a {lean}`SetLike` instance on {lean}`Set`! Otherwise this would yield a cycle.
:::

# Bundled morphisms

:::fragment fadeUp
Similarly, we can do the same for morphisms which extend the {lean}`MonoidHom` structure
and create classes like {lean}`MonoidHomClass`, {lean}`MulHomClass` which extend the {lean}`FunLike` class

To have lemmas like:

```lean -panel
-- !hide
namespace test

variable {M : Type*} {N : Type*} {F : Type*}
-- !end hide

theorem map_mul [Mul M] [Mul N] [FunLike F M N] [MulHomClass F M N] (f : F) (x y : M) : f (x * y) = f x * f y :=
  MulHomClass.map_mul f x y

theorem map_mul_eq_one [MulOne M] [MulOne N] [FunLike F M N] [MonoidHomClass F M N] (f : F) {a b : M} (h : a * b = 1) :
f a * f b = 1 := by
  rw [← map_mul, h, map_one]

-- !hide
end test
-- !end hide
```

We will also see how it is easy to abuse this system.
But more on this later
:::
