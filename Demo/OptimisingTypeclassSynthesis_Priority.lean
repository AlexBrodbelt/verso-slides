import VersoSlides
import Verso.Doc.Concrete
import Mathlib.Algebra.Algebra.RestrictScalars
import Mathlib.Analysis.Normed.Group.Defs

open VersoSlides

set_option verso.code.warnLineLength 500

-- example of using priorities to force the instance synthesis algorithm to choose a more sensible path

-- use the show instance synthesis trace

-- show case of when one had to fiddle with priorities to gain a speed up

#doc (Slides) "Priorities" =>

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

:::fitText
3. Optimising typeclass synthesis in Mathlib

Priorities
:::

# 3. Optimising typeclass synthesis in Mathlib

:::fragment fadeUp
As illustrated last week, many hierarchies present diamonds.

{image "../figures/HierarchyAlgebra.png" (width := "600px")}[Algebraic hierarchy]

Diamonds are not always bad. But there are performance considerations to keep in mind.
:::

# 3. Optimising typeclass synthesis in Mathlib

Consider the toy example covered last week.

:::fragment fadeUp
{image "../figures/SingleDiamond.svg" (width := "700px")}[Diamond]
:::

# 3. Optimising typeclass synthesis in Mathlib

:::fragment fadeUp
In code this corresponds to:

```lean -panel
set_option linter.unusedVariables false

class Base (B : Type u) where
  base : String

class LeftBranch (B : Type u) extends Base B
class RightBranch (B : Type u) extends Base B

class Diamond (B : Type u) extends LeftBranch B, RightBranch B
```
:::

# 3. Optimising typeclass synthesis in Mathlib

Let us define a type which has a {lean}`Diamond` instance

:::fragment fadeUp
```lean -panel
inductive D

instance : Diamond D where base := "base"
```

On the right hand, if we now ask the instance synthesis algorithm to infer that the type {lean}`D` with a {lean}`Diamond` instance
has the {lean}`Base` instance, we get the following path:

```lean
set_option trace.Meta.synthInstance true in

#synth Base D

```
:::
# 3. Optimising typeclass synthesis in Mathlib

:::fragment fadeUp

On the left hand, if we now tweak the priority of the {lean}`LeftBranch` instance

```lean
instance (priority := high) {α : Type u} [LeftBranch α] : Base α := inferInstance

set_option trace.Meta.synthInstance true in
#synth Base D
```
:::

# 3. Optimising typeclass synthesis in Mathlib

:::fragment fadeUp
So far so good.

Our toy example was not too interesting.

But it does illustrate how priorities tell the
instance synthesis algorithm to consider certain instances before others.

Consider the "random" definition found in Mathlib

```lean
-- !hide
namespace test
variable {M S : Type*} [Semiring S] [AddCommMonoid M] [CommSemiring R] [Algebra R S]
[Module S M] [Module Sᵐᵒᵖ M]
set_option trace.Meta.synthInstance true
-- !end hide
def RestrictScalars.lsmul [Module S M] : S →ₐ[R] Module.End R (RestrictScalars R S M) :=
  -- We use `RestrictScalars.moduleOrig` in the implementation,
  -- but not in the type

  letI : Module S (RestrictScalars R S M) := RestrictScalars.moduleOrig R S M
  Algebra.lsmul R R (RestrictScalars R S M)
-- !hide
end test
-- !end hide
```
:::

# 3. Optimising typeclass synthesis in Mathlib

```lean
-- !hide
namespace test'
variable {M S : Type*} [Semiring S] [AddCommMonoid M] [CommSemiring R] [Algebra R S]
[Module S M] [Module Sᵐᵒᵖ M]
set_option trace.Meta.synthInstance true
-- !end hide
def RestrictScalars.lsmul [Module S M] : S →ₐ[R] Module.End R (RestrictScalars R S M) :=
  -- We use `RestrictScalars.moduleOrig` in the implementation,
  -- but not in the type

  letI : Module S (RestrictScalars R S M) := RestrictScalars.moduleOrig R S M
  Algebra.lsmul R R (RestrictScalars R S M)
-- !hide
end test'
-- !end hide
```

:::fragment fadeUp
When we peek into the trace of the instance synthesis algorithm we keep seeing
{lean}`Algebra.id`

This is not by chance!

But first, let's do a loogle search.
:::

# 3. Optimising typeclass synthesis in Mathlib

{image "../figures/AlgebraInstances.png" (width := "500px")}[Algebra Instances]

:::fragment fadeUp
The list indeed goes on.
:::

# 3. Optimising typeclass synthesis in Mathlib

As we saw, there are many instances of the from `Algebra ?R ?S`.

:::fragment fadeUp
As anticipated, {lean}`Algebra.id` has a high priority.

Why?

If it is to fail, it generally fails fast.

If it is to be successful, it is almost surely the instance we want.
:::

# 3. Optimising typeclass synthesis in Mathlib

:::fragment fadeUp

Dually, we can also set low priorities for instances which are most likely not going to succeed.

Considering that when searching for algebraic instances we often do not need to search for the `Normed` hierarchy.

We can set

```lean -panel
attribute [instance 200] ESeminormedAddMonoid.toAddMonoid
```

To have the instance synthesis algorithm explore the `Normed` hierarchy last.
:::

# 3. Optimising typeclass synthesis in Mathlib

Summarising,

:::fragment fadeUp
Set high priorities for instances that are cheap to fail
and are often what one wants, as seen with {lean}`Algebra.id`

Set low priorities for instances which are less likely to apply,
as seen with `ESeminormedAddMonoid.toAddMonoid`

However, there are rumours that the typeclass system will be redesigned in some
way which will render priority twiddling obsolete.
:::
