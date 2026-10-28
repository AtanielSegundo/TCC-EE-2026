#import "../config/settings.typ":centro

// =============================================================================
// FOLHA DE ROSTO
// =============================================================================
#centro[
  #v(0.3cm)
  #text(size: 12pt, weight: "bold")[
    INSTITUTO FEDERAL DE EDUCAÇÃO, CIÊNCIA E TECNOLOGIA DO MARANHÃO
  ]

  #v(0.25cm)
  #text(size: 12pt, weight: "bold")[CAMPUS SÃO LUÍS – MONTE CASTELO]

  #v(1.6cm)
  #text(size: 12pt, weight: "bold")[
    ATANIEL SILVA SANTOS SEGUNDO
  ]

  #v(0.8cm)
  #text(size: 14pt, weight: "bold")[
    OTIMIZAÇÃO DA TOPOLOGIA EM REDES NEURAIS PARA APRENDIZAGEM POR REFORÇO
    PROFUNDO: ESTRATÉGIA COM CONGELAMENTO E ADIÇÃO DE CAMADAS DENSAS
  ]
]

#v(1.1cm)

#block(width: 100%)[
  #set par(justify: true, first-line-indent: 0pt, leading: 0.75em)
  #box(width: 100%)[
    #align(right)[
      #box(width: 9cm)[
        #set align(left)
        #text(size: 11pt)[
          Trabalho de Concluso de Curso submetido ao Departamento de
          Eletroeletronica (DEE) do Instituto Federal de Educacao, Ciencia e
          Tecnologia do Maranhao como parte dos requisitos basicos para
          obtencao do titulo de Bacharel em Engenharia Eletrica Industrial.
        ]
      ]
    ]
  ]
]

#v(0.5cm)

#block(width: 100%)[
  #set par(justify: false, first-line-indent: 0pt, leading: 0.8em)
  #align(right)[
    #box(width: 10cm)[
      *Orientador:* Prof. Dr. Francisco dos Santos Viana
    ]
  ]
]

#v(0.3cm)

#block(width: 100%)[
  #set par(justify: true, first-line-indent: 0pt, leading: 0.75em)
  #box(width: 100%)[
    #align(right)[
      #box(width: 9cm)[
        #set align(left)
        #text(size: 11pt)[
          Banca Examinadora

          #v(0.4cm)

          #line(length: 100%, stroke: 0.5pt)
          Prof. Dr. Francisco dos Santos Viana \
          IFMA

          #v(0.4cm)

          #line(length: 100%, stroke: 0.5pt)
          Prof. Dr. #box(width: 1fr, repeat[\_]) \
          #box(width: 1fr, repeat[\_])
        ]
      ]
    ]
  ]
]

#v(1fr)

#centro[
  #text(size: 12pt, weight: "bold")[SÃO LUÍS – MA]

  #v(0.2cm)
  #text(size: 12pt, weight: "bold")[2026]
  #v(0.6cm)
]

#pagebreak()
