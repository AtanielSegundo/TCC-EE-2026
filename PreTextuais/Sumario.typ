#import "../config/settings.typ":*

// =============================================================================
// SUMÁRIO
// =============================================================================
#centro[#text(size: 12pt, weight: "bold")[SUMÁRIO]]

#v(0.5cm)

#block[
  #set par(justify: false, first-line-indent: 0pt, leading: 0.85em)
  #show outline.entry: it => link(it.element.location(), it.indented(it.prefix(), it.inner()))
  #show outline.entry.where(level: 1): it => link(
    it.element.location(),
    strong(upper(it.indented(it.prefix(), it.inner()))),
  )
  #outline(title: none, depth: 3, indent: 0pt)
]
