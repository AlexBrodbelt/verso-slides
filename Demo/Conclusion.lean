import VersoSlides
import Verso.Doc.Concrete
import Mathlib.Algebra.Group.Basic
import Mathlib.Order.Lattice
import Mathlib.Data.Multiset.Defs
import Mathlib.Data.Finset.Defs
import Mathlib.Algebra.Group.Hom.Defs
import Mathlib.Algebra.Algebra.RestrictScalars
import Mathlib.Analysis.Normed.Group.Defs

open VersoSlides

set_option verso.code.warnLineLength 500

-- instance search space to be partitioned to particular areas of mathematics
--
-- fly as close to mathlib as possible

#doc (Slides) "Conclusion" =>

# Conclusion

:::fragment fadeUp
When working with typeclasses in Mathlib, think of the following things:

Typeclasses can be used to reduce code duplication and capture essential patterns in mathematics
as was seen with {lean}`SetLike` and {lean}`MonoidHomClass`.

But we have to be careful with how we (set up)/(declare) our typeclasses
for optimisation reasons as was seen:

* (Bundled/Unbundled) When integrating the algebra, order (, topology, normed, etc.) hierarchies
* (Priorities) When registering instances like {lean}`Algebra.id` and `ESeminormedAddMonoid.toAddMonoid`
:::

# Conclusion

:::fragment fadeUp
Furthermore, we have to watch out for bad diamonds like that encountered in the interaction between
{lean}`TopologicalSpace`, {lean}`MetricSpace` and {lean}`Prod`.

In this case we should stick as much as we can to *forgetful inheritance* when extending poorer typeclasses
to richer typeclasses.

Finally, one should be aware of type synonyms like {lean}`OrderDual`, {lean}`MulOpposite` and `IsOpen[ · ]`.
:::
