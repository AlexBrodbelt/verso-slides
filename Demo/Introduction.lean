import VersoSlides
import Verso.Doc.Concrete
import Mathlib.Order.Lattice
import Mathlib.Algebra.Group.Basic
import Mathlib.Algebra.Group.Int.Defs
import Mathlib.Data.Nat.Cast.Defs

open VersoSlides

-- uses techniques from
-- Number Theory, Linear Algebra, Algebraic Geometry, Topology and so forth.

-- Such challenges call for a *unified* library.

-- On the other hand, mathematicians would like to leave some arguments to the computer. Arguably this
-- is why tools like `Lean` are called proof assistants. For example, In Carleson's Project many proofs regarding measurability, continuity, differentiability, etc.
-- were left to the computer.

-- Such desires for *convenience* call for powerful automation like `fun_prop` (and even typeclass synthesis).

set_option verso.code.warnLineLength 500

#doc (Slides) "How to use typeclass inference in Mathlib" =>

# TYPECLASSES IN MATHLIB

Lean Seminar 2026

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
1. Mathlib, its missions and design considerations
:::::

# Mathlib, its mission and design considerations

:::fragment fadeUp
One of `Mathlib`'s aim is to *unify* different areas of mathematics into a
*convenient* mathematical library for formalising current research in mathematics.

Examples:

Fermat's Last Theorem.

Carleson's Project.

With this philosophy in mind, we explore some of the usages of typeclasses and the obstacles
that might arise.
:::
