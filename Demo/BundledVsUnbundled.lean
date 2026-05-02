import VersoSlides
import Verso.Doc.Concrete
import Mathlib.Order.Lattice
import Mathlib.Algebra.Group.Basic
import Mathlib.Algebra.Group.Int.Defs
import Mathlib.Data.Nat.Cast.Defs
import Mathlib.Data.Multiset.Defs
import Mathlib.Data.Finset.Defs
import Mathlib.Algebra.Group.Hom.Defs

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

2. Abstractions in Mathlib

3. Dangers of abstractions in Mathlib

4. Avoiding bad diamonds

5. Optimising abstractions in Mathlib

6. Type synonyms
:::

# TYPECLASSES IN MATHLIB

%%%
autoAnimate := true
%%%

:::fitText
3. Dangers of abstractions in Mathlib
:::

# Beware of abstraction

Indeed, typeclasses like {lean}`SetLike`, {lean}`FunLike`, {lean}`EquivLike`, {lean}`MonoidHomClass`
are extremely convenient by reducing code duplication.

However, there is technical challenge which arises when thinking of Mathlib as a software enginerring project

Consider the following instance

# Mathematical hierarchies

:::fragment fadeUp
In mathematics, we often define mathematical structures with
varying levels of structure:

{lean}`Mul` < {lean}`Semigroup` < {lean}`Monoid` < {lean}`Group`

{lean}`Preorder` < {lean}`PartialOrder` < {lean}`Lattice` < {lean}`LinearOrder` <

And as we saw last week, for the sake of *convenience* we use typeclasses
to encode and reason about these mathematical structures.

But one quickly runs into a design choice.

*Bundled* or *Unbundled* typeclasses?
:::

# Bundled and Unbundled

:::fragment fadeUp
Given we want `Mathlib` to be quick, one of the guiding principles is also to make
instance synthesis both fail fast and succeed quickly.

Let us first consider how to make instance synthesis fail fast.

Recall that Bundled
:::

# Decoupling the algebra and order library


:::table +colHeaders +stripedRows
*
  * Old (Bundled)
  * Current (Semi-bundled)
*
  * Bundled
  * Unbundled
*
  * `[LinearOrdered(Add)CommMonoid α]`
  * `[(Add)CommMonoid α] [LinearOrder α] [IsOrdered(Add)Monoid α]`
*
  * `[LinearOrderedCancel(Add)CommMonoid α]`
  * `[(Add)CommMonoid α] [LinearOrder α] [IsOrderedCancel(Add)Monoid α]`
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

# Decoupling the algebra and order hierarchy

:::table +colHeaders +stripedRows
*
  * `[OrderedCommSemiring α]`
  * `[CommSemiring α] [PartialOrder α] [IsOrderedRing α]`
*
  * `[OrderedRing α]`
  * `[Ring α] [PartialOrder α] [IsOrderedRing α]`
*
  * `[OrderedCommRing α]`
  * `[CommRing α] [PartialOrder α] [IsOrderedRing α]`
*
  * `[StrictOrderedSemiring α]`
  * `[Semiring α] [PartialOrder α] [IsStrictOrderedRing α]`
*
  * `[StrictOrderedCommSemiring α]`
  * `[CommSemiring α] [PartialOrder α] [IsStrictOrderedRing α]`
*
  * `[StrictOrderedRing α]`
  * `[Ring α] [PartialOrder α] [IsStrictOrderedRing α]`
*
  * `[StrictOrderedCommRing α]`
  * `[CommRing α] [PartialOrder α] [IsOrderedRing α]`
*
  * `[LinearOrderedSemiring α]`
  * `[Semiring α] [LinearOrder α] [IsStrictOrderedRing α]`
*
  * `[LinearOrderedCommSemiring α]`
  * `[CommSemiring α] [LinearOrder α] [IsStrictOrderedRing α]`
*
  * `[LinearOrderedRing α]`
  * `[Ring α] [LinearOrder α] [IsStrictOrderedRing α]`
*
  * `[LinearOrderedCommRing α]`
  * `[CommRing α] [LinearOrder α] [IsStrictOrderedRing α]`
*
  * `[LinearOrderedSemifield α]`
  * `[Semifield α] [LinearOrder α] [IsStrictOrderedRing α]`
*
  * `[LinearOrderedField α]`
  * `[Field α] [LinearOrder α] [IsStrictOrderedRing α]`
*
  * `[NormedLatticeAddCommGroup α]`
  * `[NormedAddCommGroup α] [Lattice α] [HasSolidNorm α] [IsOrderedAddMonoid α]`
*
  * `[NormedOrdered(Add)Group α]`
  * `[Normed(Add)CommGroup α] [PartialOrder α] [IsOrdered(Add)Monoid α]`
*
  * `[NormedLinearOrdered(Add)Group α]`
  * `[Normed(Add)CommGroup α] [LinearOrder α] [IsOrdered(Add)Monoid α]`
*
  * `[NormedLinearOrderedField α]`
  * `[NormedField α] [LinearOrder α] [IsStrictOrderedRing α]`
:::

# Decoupling the algebraic and order hierachies

This decoupling yielded a 20% speedup to Mathlib
