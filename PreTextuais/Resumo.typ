#import "../config/settings.typ":*

// =============================================================================
// RESUMO
// =============================================================================
#centro[#text(size: 12pt, weight: "bold")[RESUMO]]

#v(0.5cm)

#block[
#set par(leading: 0.92em, spacing: 0.92em)
A Aprendizagem por Reforço Profunda (_Deep Reinforcement Learning_ – DRL)
consolidou-se como um dos paradigmas mais produtivos para a construção de
agentes autônomos capazes de aprender comportamentos complexos a partir da
interação com o ambiente. Contudo, o treinamento de redes profundas é intensivo
em recursos computacionais, e o aprendizado contínuo enfrenta o
problema do esquecimento catastrófico. Estratégias construtivas de expansão
arquitetural respondem a ambos os problemas: em vez de treinar desde o início
uma topologia grande e fixa, a rede cresce pela inserção de novos módulos,
enquanto os parâmetros já consolidados são congelados. Este trabalho investigou
uma estratégia construtiva denominada SAECollabNet, inspirada na proposta de
inserção de camadas em redes _Stacked Autoencoder_ e integrada a agentes
_Double Deep Q-Network_ (DDQN) para navegação autônoma em ambientes labirínticos.
A navegação foi modelada como um Processo de Decisão de Markov, com agentes
treinados em labirintos discretos de 10#sym.times#h(1pt)12, 15#sym.times#h(1pt)25 e
30#sym.times#h(1pt)30 células. Dois refinamentos foram incorporados: modelagem de
recompensa baseada em potencial (PBRS) e amostragem priorizada de experiências
(PER). Um estudo fatorial de ablação comparou a arquitetura construtiva com uma
linha de base densa estática sob hiperparâmetros idênticos. A generalização foi
avaliada com formulação condicionada ao objetivo (UVFA) combinada a repetição
retrospectiva de experiências (HER), e a estratégia foi validada em plataforma
robótica real. Os resultados demonstram que, com recompensa densificada, a
estratégia construtiva superou a linha de base em taxa de sucesso empregando
25,3% dos parâmetros e 69,0% do tempo de treinamento.

]

#v(0.5cm)

#block[
  #set par(justify: true, first-line-indent: 0pt, leading: 0.92em)
  *Palavras-chave:* aprendizagem por reforço profundo. Otimização de topologia.
  Congelamento de camadas. Redes neurais construtivas. Navegação autônoma.
]

#pagebreak()
