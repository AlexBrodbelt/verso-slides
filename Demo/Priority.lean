import VersoSlides
import Verso.Doc.Concrete
import Mathlib.Algebra.Algebra.RestrictScalars


open VersoSlides

set_option verso.code.warnLineLength 500

-- example of using priorities to force the instance synthesis algorithm to choose a more sensible path

-- use the show instance synthesis trace

-- show case of when one had to fiddle with priorities to gain a speed up

#doc (Slides) "Priorities" =>

# Slow instances

Sometimes instance synthesis can take long and therefore it is convenient
to set a preference for which instances to look for first.

We now demonstrate with an example what working with priorities is like

# A pretty diamond 💎

:::fragment fadeUp
To illustrate how tweaking the priorities of instances might be useful to make instance synthesis faster.

Recall the diamond described last week:

::stretch
{image "../figures/SingleDiamond.svg"}[Diamond]
::
:::

# A pretty diamond 💎

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

# GETTING OUR PRIORITIES RIGHT

Let us define a type which has a {lean}`Diamond` instance

:::fragment fadeUp
```lean -panel
inductive D

instance : Diamond D where base := "base"
```

On the right hand, if we now ask the instance synthesis algorithm to infer that the type {lean}`D` with a {lean}`Diamond` instance
has the {lean}`Base` instance, we get the following path:

```lean
-- !hide
set_option trace.Meta.synthInstance true in
-- !end hide
#synth Base D

```
:::
# GETTING OUR PRIORITIES RIGHT

:::fragment fadeUp

On the left hand, if we now tweak the priority of the {lean}`LeftBranch` instance

```lean -panel
instance (priority := high) (B : Type u) [LeftBranch B] : Base B :=
  inferInstance
```

```lean
-- !hide
set_option trace.Meta.synthInstance true in
--!end hide
#synth Base D

```
:::

# Priorities in the wild

:::fragment fadeUp
So far so good.

Our toy example was not too interesting.

But it does illustrate how priorities tell the
instance synthesis algorithm to consider certain instances before others.

Consider the random definition I found in Mathlib

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

# Priorities in the wild

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

{lean}`Algebra.id` instance is a great example of what instances should have a high priority.

If it is to fail, it generally fails quickly!

If it is to be successful, it is almost surely the instance we want

For context, see how many instances are of the form `Algebra ?R ?S`
:::

# Priorities in the wild


{image "../figures/AlgebraInstances.png" (width := "600px")}[Algebra Instances]

:::fragment fadeUp
The list does go on.
:::
