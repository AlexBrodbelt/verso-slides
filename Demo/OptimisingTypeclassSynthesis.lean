import VersoSlides
import Verso.Doc.Concrete
import Mathlib.Order.Lattice
import Mathlib.Algebra.Group.Basic
import Mathlib.Algebra.Group.Int.Defs
import Mathlib.Data.Nat.Cast.Defs
import Mathlib.Data.Multiset.Defs
import Mathlib.Data.Finset.Defs
import Mathlib.Algebra.Group.Hom.Defs
import Mathlib.Algebra.Field.Defs
import Mathlib.Analysis.Normed.Field.Basic

open VersoSlides

set_option verso.code.warnLineLength 500
-- recap on bundled and unbundled, readable vs performant

-- algebraic hierarchy before table typeclass resolution,

-- refactor to more convenient and idiomatic design

-- more performant design with semi-bundled hierarchy for the algebraic, order and normed hierarchies, partitions the search space

#doc (Slides) "Bundled Vs Unbundled" =>

# OUTLINE - TYPECLASSES IN MATHLIB

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

Bundling vs. Unbundling
:::

# 3. Optimising typeclass synthesis in Mathlib

:::fragment fadeUp
Indeed, typeclasses like {lean}`SetLike`, {lean}`FunLike`, {lean}`EquivLike`, {lean}`MonoidHomClass`
are extremely convenient and reduce a lot of code duplication.

However, challenges arise as Mathlib scales.

Mathlib must be fast.

Instance synthesis accounts for 10 to 25 percent of the build time for a typical Mathlib file.

Instance synthesis algorithm to fail, it must have explored the entire search space.
:::

# 3. Optimising typeclass synthesis in Mathlib

:::fragment fadeUp
For instance, consider the following code snippet:

```lean +error
inductive P
inductive Q
example (p : P) : Q := p
```

As expected this example results an error.

But what was surprising at the time, is that this took 250ms to fail.

At the time, classes like {lean}`MulHomClass` were set up in the following way:

```
class MulHomClass (F : Type*) (M N : outParam (Type*)) [Mul M] [Mul N]
  extends DFunLike F M fun _ => N where
  ...
```
:::

# 3. Optimising typeclass synthesis in Mathlib

When peaking under the hood to see what was taking so long, we see that after triggering a
typeclass search for `CoeT P p Q`.

:::fragment fadeUp


Typeclass search goes crazy once it applies the `FunLike.hasCoeToFun`.

```
[tryResolve] ✅ CoeFun P fun x ↦ (a : ?m.146) → ?m.147 a ≟ CoeFun P fun x ↦ (a : ?m.146) → ?m.147 a
[] new goal FunLike P _tc.2 _tc.3 ▼
  [instances] #[@ZeroHomClass.toFunLike, @AddHomClass.toFunLike, @OneHomClass.toFunLike, @MulHomClass.toFunLike, @EmbeddingLike.toFunLike, @RelHomClass.toFunLike, @StarHomClass.toFunLike, @SMulHomClass.toFunLike, @TopHomClass.toFunLike, @BotHomClass.toFunLike, @SupHomClass.toFunLike, @InfHomClass.toFunLike, @NonnegHomClass.toFunLike, @SubadditiveHomClass.toFunLike, @SubmultiplicativeHomClass.toFunLike, @MulLEAddHomClass.toFunLike, @NonarchimedeanHomClass.toFunLike, @sSupHomClass.toFunLike, @sInfHomClass.toFunLike, @ContinuousMapClass.toFunLike, @LocallyBoundedMapClass.toFunLike, @SpectralMapClass.toFunLike, @DilationClass.toFunLike, @SlashInvariantFormClass.toFunLike]
```
:::

# 3. Optimising typeclass synthesis in Mathlib


The solution:
:::fragment fadeUp
```
class MulHomClass (F : Type*) (M N : outParam Type*) [Mul M] [Mul N] [FunLike F M N] : Prop where
```

This refactor resulted in a 33 percent speed up for typeclass instance synthesis.

and an overall 19 percent decrease in build instructions.
:::

# 3. Optimising typeclass synthesis in Mathlib

:::fragment fadeUp
In case you were left wondering

The code snippet shown before fails much faster:

```lean +error
#time example (p : P) : Q := p
```
:::

# 3. Optimising typeclass synthesis in Mathlib

:::fragment fadeUp

Consider now the mathematical objects with
varying levels of structure:

{lean}`Mul` < {lean}`Semigroup` < {lean}`Monoid` < {lean}`Group`

{lean}`Preorder` < {lean}`PartialOrder` < {lean}`Lattice` < {lean}`LinearOrder`

Last week, we saw that these hierarchies are set up through forgetful inheritance.

But how should these hierarchies interact?
:::

# 3. Optimising typeclass synthesis in Mathlib



Consider we have to synthesize a {lean}`CommMonoid` instance.

:::fragment fadeUp
Let's think about two ways we could set up the interaction between the algebraic and order hierarchy:
:::

# 3. Optimising typeclass synthesis in Mathlib
%%%
vertical := true
%%%

:::table +colHeaders +stripedRows
*
  * Bundled
  * Semi-bundled
*
  * `[LinearOrdered(Add)CommMonoid α]`
  * `[(Add)CommMonoid α] [LinearOrder α] [IsOrdered(Add)Monoid α]`
*
  * `[LinearOrderedCancel(Add)CommMonoid α]`
  * `[(Add)CommMonoid α] [LinearOrder α] [IsOrderedCancel(Add)Monoid α]`
:::

## 3. Optimising typeclass synthesis in Mathlib
:::table +stripedRows
*
  * `[Ordered(Add)CommGroup α]`
  * `[(Add)CommGroup α] [PartialOrder α] [IsOrdered(Add)Monoid α]`
*
  * `[LinearOrdered(Add)CommGroup]`
  * `[(Add)CommGroup α] [LinearOrder α] [IsOrdered(Add)Monoid α]`
*
  * `[OrderedSemiring α]`
  * `[Semiring α] [PartialOrder α] [IsOrderedRing α]`
:::

## 3. Optimising typeclass synthesis in Mathlib

:::table +stripedRows
*
  * `[OrderedCommSemiring α]`
  * `[CommSemiring α] [PartialOrder α] [IsOrderedRing α]`
*
  * `[OrderedRing α]`
  * `[Ring α] [PartialOrder α] [IsOrderedRing α]`
*
  * `[OrderedCommRing α]`
  * `[CommRing α] [PartialOrder α] [IsOrderedRing α]`
:::

## 3. Optimising typeclass synthesis in Mathlib


:::table +stripedRows
*
  * `[StrictOrderedSemiring α]`
  * `[Semiring α] [PartialOrder α] [IsStrictOrderedRing α]`
*
  * `[StrictOrderedCommSemiring α]`
  * `[CommSemiring α] [PartialOrder α] [IsStrictOrderedRing α]`
*
  * `[StrictOrderedRing α]`
  * `[Ring α] [PartialOrder α] [IsStrictOrderedRing α]`
:::

## 3. Optimising typeclass synthesis in Mathlib

:::table +stripedRows
*
  * `[StrictOrderedCommRing α]`
  * `[CommRing α] [PartialOrder α] [IsOrderedRing α]`
*
  * `[LinearOrderedSemiring α]`
  * `[Semiring α] [LinearOrder α] [IsStrictOrderedRing α]`
*
  * `[LinearOrderedCommSemiring α]`
  * `[CommSemiring α] [LinearOrder α] [IsStrictOrderedRing α]`
:::

## 3. Optimising typeclass synthesis in Mathlib

:::table +stripedRows
*
  * `[LinearOrderedRing α]`
  * `[Ring α] [LinearOrder α] [IsStrictOrderedRing α]`
*
  * `[LinearOrderedCommRing α]`
  * `[CommRing α] [LinearOrder α] [IsStrictOrderedRing α]`
*
  * `[LinearOrderedSemifield α]`
  * `[Semifield α] [LinearOrder α] [IsStrictOrderedRing α]`
:::

## 3. Optimising typeclass synthesis in Mathlib

:::table +stripedRows
*
  * `[LinearOrderedField α]`
  * `[Field α] [LinearOrder α] [IsStrictOrderedRing α]`
*
  * `[NormedLatticeAddCommGroup α]`
  * `[NormedAddCommGroup α] [Lattice α] [HasSolidNorm α] [IsOrderedAddMonoid α]`
*
  * `[NormedOrdered(Add)Group α]`
  * `[Normed(Add)CommGroup α] [PartialOrder α] [IsOrdered(Add)Monoid α]`
:::

## 3. Optimising typeclass synthesis in Mathlib


:::table +stripedRows
*
  * `[NormedLinearOrdered(Add)Group α]`
  * `[Normed(Add)CommGroup α] [LinearOrder α] [IsOrdered(Add)Monoid α]`
*
  * `[NormedLinearOrderedField α]`
  * `[NormedField α] [LinearOrder α] [IsStrictOrderedRing α]`
:::


# 3. Optimising typeclass synthesis in Mathlib

This refactor partitioned the instance search space.

:::fragment fadeUp

When trying to synthesize a {lean}`CommMonoid` instance.

Before, Lean would try infer this instance by searching through declarations like
`NormedLinearOrderedField` or `NormedOrderedGroup`.

Now, Lean will only go as far as {lean}`NormedField` and {lean}`Group`.
:::

# 3. Optimising typeclass synthesis in Mathlib

This decoupling yielded a 20% speedup to typeclass inference time.

:::fragment fadeUp
Resulting in a 6% overall speedup to Mathlib.

But it does result in more verbose parameters.

Which raises the question:

Should the normed hierarchy be decoupled from the algebraic hierarchy?

And in general, when should one use a bundled or unbundled typeclass design?
:::
