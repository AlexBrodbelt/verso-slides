import VersoSlides
import Verso.Doc
import Demo.Introduction
import Demo.TypeclassUseInMathlib
import Demo.OptimisingTypeclassSynthesis
import Demo.HazardsOfTypeclassUse
import Demo.OptimisingTypeclassSynthesis_Priority
import Demo.RegisteringMultipleInstances
import Demo.Conclusion
import Demo.References
import Demo.Example

open VersoSlides

namespace Demo

/-- Combined deck assembled from all six chapter documents. -/
def slidesDoc : Verso.Doc.Part Slides :=
  let test : Verso.Doc.Part Slides := %doc Demo.Example
  let ch1 : Verso.Doc.Part Slides := %doc Demo.Introduction
  let ch2 : Verso.Doc.Part Slides := %doc Demo.TypeclassUseInMathlib
  let ch3 : Verso.Doc.Part Slides := %doc Demo.OptimisingTypeclassSynthesis
  let ch4 : Verso.Doc.Part Slides := %doc Demo.OptimisingTypeclassSynthesis_Priority
  let ch5 : Verso.Doc.Part Slides := %doc Demo.HazardsOfTypeclassUse
  let ch6 : Verso.Doc.Part Slides := %doc Demo.RegisteringMultipleInstances
  let ch7 : Verso.Doc.Part Slides := %doc Demo.Conclusion
  let ch8 : Verso.Doc.Part Slides := %doc Demo.References
  Verso.Doc.Part.mk
    ch1.title
    "VersoSlides Demo"
    ch1.metadata
    (
      -- test.content ++
      ch1.content ++ ch2.content ++ ch3.content ++ ch4.content ++ ch5.content ++ ch6.content ++ ch7.content ++ ch8.content)
    (
      -- test.subParts ++
      ch1.subParts ++ ch2.subParts ++ ch3.subParts ++ ch4.subParts ++ ch5.subParts ++ ch6.subParts ++ ch7.subParts ++ ch8.subParts)

end Demo
