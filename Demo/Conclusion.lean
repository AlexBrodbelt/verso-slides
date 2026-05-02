import VersoSlides
import Verso.Doc.Concrete


open VersoSlides

set_option verso.code.warnLineLength 500

-- instance search space to be partitioned to particular areas of mathematics
--
-- fly as close to mathlib as possible

#doc (Slides) "Conclusion" =>

# Take aways

Despite wanting a unified library which integrates well the hierarchies like
the algebraic, order and normed hierarchy. At the time of writing,
a semi-bundled approach has been chosen for performance reasons over readability,
but this could change with improvements to `class abbrev`
