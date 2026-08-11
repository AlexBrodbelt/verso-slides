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

#doc (Slides) "References" =>

# References

Anne Baanen et al. “Growing Mathlib: maintenance of a large scale mathematical
library”.

Anne Baanen. “Use and Abuse of Instance Parameters in the Lean Mathematical
Library”.

Eric Wieser. “Multiple-Inheritance Hazards in Dependently-Typed Algebraic Hierarchies”.


