import VersoSlides
import Verso.Doc
import Demo.TypeclassesInMathlib
import Demo.Abstractions
import Demo.BundledVsUnbundled
import Demo.Diamond
import Demo.Priority
import Demo.TypeSynonyms
import Demo.Conclusion
import Demo.Example

open VersoSlides

namespace Demo

/-- Combined deck assembled from all six chapter documents. -/
def slidesDoc : Verso.Doc.Part Slides :=
  let test : Verso.Doc.Part Slides := %doc Demo.Example
  let ch1 : Verso.Doc.Part Slides := %doc Demo.TypeclassesInMathlib
  let ch2 : Verso.Doc.Part Slides := %doc Demo.Abstractions
  let ch3 : Verso.Doc.Part Slides := %doc Demo.BundledVsUnbundled
  let ch4 : Verso.Doc.Part Slides := %doc Demo.Diamond
  let ch5 : Verso.Doc.Part Slides := %doc Demo.Priority
  let ch6 : Verso.Doc.Part Slides := %doc Demo.TypeSynonyms
  let ch7 : Verso.Doc.Part Slides := %doc Demo.Conclusion
  Verso.Doc.Part.mk
    ch1.title
    "VersoSlides Demo"
    ch1.metadata
    (
      -- test.content ++
      ch1.content ++ ch2.content ++ ch3.content ++ ch4.content ++ ch5.content ++ ch6.content ++ ch7.content)
    (
      -- test.subParts ++
      ch1.subParts ++ ch2.subParts ++ ch3.subParts ++ ch4.subParts ++ ch5.subParts ++ ch6.subParts ++ ch7.subParts )

end Demo
