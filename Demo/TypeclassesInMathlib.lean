import VersoSlides
import Verso.Doc.Concrete
import Mathlib.Order.Lattice
import Mathlib.Algebra.Group.Basic
import Mathlib.Algebra.Group.Int.Defs
import Mathlib.Data.Nat.Cast.Defs

open VersoSlides

set_option verso.code.warnLineLength 500

#doc (Slides) "How to use typeclass inference in Mathlib" =>

# Outline - Typeclasses in Mathlib

%%%
autoAnimate := true
%%%

:::vstack
1. Mathlib, its missions and design considerations

2. Abstractions in Mathlib

3. Unbundling vs. bundling in Mathlib

4. Avoiding bad diamonds

5. Using priorities in Mathlib

6. Type synonyms
:::

# Typeclasses in Mathlib

%%%
autoAnimate := true
%%%

:::::fitText
1. Mathlib, its missions and design considerations
:::::

# Mathlib, its mission and design considerations

Mathlib's aim is to *unify* different areas of mathematics into a
_convenient_ mathematical library for formalising current research in mathematics.

# Convenience
