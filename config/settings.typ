// =============================================================================
// TCC · SAECollabNet · Configurações Globais
// Formatação ABNT (NBR 14724/2011) · Arial 12 · entrelinhas 1,5 · margens
// sup./esq. 3 cm, inf./dir. 2 cm · recuo 1,25 cm · justificado
// Reutilizável em outros trabalhos do autor.
// =============================================================================

// =============================================================================
// FUNÇÕES REUTILIZÁVEIS
// =============================================================================

// Numeração do título + espaço
#let num-titulo(it) = context {
  if it.numbering != none [#counter(heading).display(it.numbering)#h(0.35em)]
}

// =============================================================================
// MODELO ABNT
// Regras set/show não atravessam #import: aplique-as no main.typ com
//   #show: abnt
// =============================================================================
#let abnt(doc) = {
  // ── Documento ──────────────────────────────────────────────────────────────
  set document(
    title: "Otimização da Topologia em Redes Neurais para Aprendizagem por Reforço Profundo:\nEstratégia com Congelamento e Adição de Camadas Densas",
    author: "Ataniel Silva Santos Segundo",
  )
  
  // ── Página ─────────────────────────────────────────────────────────────────
  set page(
    paper: "a4",
    margin: (top: 3cm, left: 3cm, bottom: 2cm, right: 2cm),
  )

  // ── Texto ──────────────────────────────────────────────────────────────────
  set text(font: "Arial", size: 12pt, lang: "pt", region: "br")

  // ── Parágrafo ──────────────────────────────────────────────────────────────
  set par(
    justify: true,
    leading: 1.01em,
    spacing: 1.01em,
    first-line-indent: (amount: 1.25cm, all: true),
  )

  // ── Numeração de títulos: 1, 1.1, 1.1.1, ... ───────────────────────────────
  set heading(numbering: "1.1")

  // ── Cabeçalho: numeração de página no canto superior direito ───────────────
  set page(
    header: context {
      set text(size: 10pt)
      set par(first-line-indent: 0pt)
      align(right)[#counter(page).get().first()]
    },
    header-ascent: 1.0cm,
  )

  // ── Show rules para níveis de seção ────────────────────────────────────────
  show heading.where(level: 1): it => {
    set par(first-line-indent: 0pt, justify: false, leading: 0.75em)
    block(above: 1.45em, below: 0.85em)[
      #text(size: 12pt, weight: "bold")[#num-titulo(it)#upper(it.body)]
    ]
  }

  show heading.where(level: 2): it => {
    set par(first-line-indent: 0pt, justify: false, leading: 0.75em)
    block(above: 1.15em, below: 0.65em)[
      #text(size: 12pt, weight: "bold")[#num-titulo(it)#it.body]
    ]
  }

  show heading.where(level: 3): it => {
    set par(first-line-indent: 0pt, justify: false, leading: 0.75em)
    block(above: 1.2em, below: 0.7em)[
      #text(size: 12pt, style: "italic")[#num-titulo(it)#it.body]
    ]
  }

  // ── Legendas de figuras: acima, corpo 10pt ─────────────────────────────────
  set figure.caption(position: top, separator: [ – ])
  show figure.caption: it => {
    set par(justify: false, first-line-indent: 0pt, leading: 0.6em)
    text(size: 10pt)[#it]
  }
  show figure: set block(above: 1.15em, below: 1.15em)

  // ── Equações ───────────────────────────────────────────────────────────────
  set math.equation(numbering: "(1)")
  show math.equation.where(block: true): set block(above: 1.0em, below: 1.0em)

  // ── Listas ─────────────────────────────────────────────────────────────────
  set list(indent: 0.6cm, spacing: 1.01em)
  set enum(indent: 0.6cm, spacing: 1.01em)

  doc
}

// =============================================================================
// FUNÇÕES AUXILIARES REUTILIZÁVEIS
// =============================================================================

// ── Fonte de legenda/figura/tabela ───────────────────────────────────────────
// Uso: #fonte("Elaborada pelo autor (2026).")
#let fonte(txt) = {
  set par(justify: false, first-line-indent: 0pt, leading: 0.6em)
  text(size: 10pt)[Fonte: #txt]
}

// ── Inserir figura com legenda e fonte ───────────────────────────────────────
// Uso: #ilustra("caminho/figura.png", [Legenda da figura], ["Elaborada pelo autor (2026)."])
//      #ilustra("caminho/figura.png", [Legenda], ["Fonte."], largura: 80%)
#let ilustra(caminho, legenda, origem, largura: 100%) = figure(
  caption: legenda,
  kind: image,
  supplement: [Figura],
  [
    #image(caminho, width: largura)
    #v(3pt)
    #fonte(origem)
  ],
)

// ── Inserir tabela com legenda e fonte ───────────────────────────────────────
// Uso: #tabela([Legenda], ["Fonte."], [ conteúdo da tabela ])
#let tabela(legenda, origem, corpo) = figure(
  caption: legenda,
  kind: table,
  supplement: [Tabela],
  [
    #corpo
    #v(3pt)
    #align(left)[#fonte(origem)]
  ],
)

// ── Tabela ABNT sem fios verticais ───────────────────────────────────────────
// Uso: #tab((auto, auto, auto), table.hline(), [*Col1*], [*Col2*], [*Col3*], ...)
//      cols: número de colunas (auto = auto-size)
//      ..celulas: células da tabela
#let tab(cols, ..celulas) = {
  set text(size: 10pt)
  set par(justify: false, first-line-indent: 0pt, leading: 0.55em)
  table(
    columns: cols,
    stroke: none,
    inset: (x: 5pt, y: 4pt),
    align: (col, row) => if col == 0 { left + horizon } else { center + horizon },
    ..celulas,
  )
}

// ── Texto centralizado ───────────────────────────────────────────────────────
// Uso: #centro[Texto centralizado]
#let centro(corpo) = {
  set par(justify: false, first-line-indent: 0pt)
  align(center)[#corpo]
}

// ── Bloco com recuo de primeira linha desativado ─────────────────────────────
// Uso para resumos, agradecimentos etc.
#let sem-recuo(corpo) = {
  set par(first-line-indent: 0pt)
  corpo
}

// ── Referência a elemento por ID ─────────────────────────────────────────────
// Uso: @meu-id retorna a referência ao elemento marcado
// (já funciona nativamente no Typst, esta é apenas uma convenção de uso)

// ── Marcação de seções com ID para referência ────────────────────────────────
// Uso: = Título <secao-id> ou == Subtítulo <sub-id>
