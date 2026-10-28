// =============================================================================
// CAPÍTULO 4 · METODOLOGIA
// Conteúdo adaptado do resumo_expandido.typ e main.typ (seções Metodologia Detalhada)
// =============================================================================

#import "../config/settings.typ": *

= Metodologia Detalhada

== Formulação do Problema e Ambiente de Simulação

A navegação autônoma foi modelada como um Processo de Decisão de Markov (MDP),
definido pela tupla $(S, A, P, R, gamma)$, em que $S$ é o espaço de estados,
$A$ o espaço discreto de ações, $P$ a função de transição, $R$ a função de
recompensa e $gamma in [0, 1]$ o fator de desconto. O objetivo é aprender uma
política $pi$ que maximize o retorno descontado esperado
$G_t = sum_(k=0)^infinity gamma^k r_(t+k+1)$.

O ambiente é um espaço bidimensional discreto e finito do tipo _grid world_,
representado por uma matriz $R times C$ cujas células codificam espaço livre,
obstáculo, posição inicial e célula objetivo. O espaço de ações contém quatro
comandos cardinais: frente, trás, esquerda e direita. Foram utilizados três
ambientes de complexidade crescente.

#tabela(
  [Ambientes labirínticos utilizados nos experimentos],
  [Elaborada pelo autor (2026).],
)[
  #tab(
    (auto, auto, auto, auto, auto, auto),
    table.hline(stroke: 0.8pt),
    [*Ambiente*], [*Dimensões*], [*Células*], [*Navegáveis*], [*Paredes*], [*Passos máx.*],
    table.hline(stroke: 0.5pt),
    [Pequeno (`small_eg`)], [10 #sym.times 12], [120], [54], [66], [208],
    [Médio (`medium_eg`)], [15 #sym.times 25], [375], [215], [160], [852],
    [Grande (`big_eg`)], [30 #sym.times 30], [900], [482], [418], [1920],
    table.hline(stroke: 0.8pt),
  )
] <tab-ambientes>

A função de recompensa base atribui $+"1,0"$ ao alcance do objetivo, $-"0,5"$ à
colisão com parede e $-"0,01"$ como penalidade de passo. O episódio encerra
quando o agente atinge o objetivo, tenta sair dos limites da grade ou excede o
limite de passos, fixado em quatro vezes o número de células navegáveis.

== Arquiteturas Comparadas

Duas arquiteturas foram implementadas em Python com PyTorch (PASZKE et al., 2019) e comparadas de
forma pareada. A linha de base (`TorchDDQN`) é um agente DDQN convencional de
topologia estática, na formulação de van Hasselt, Guez e Silver (2016). A
arquitetura proposta (`SAECollabDDQN`) implementa o modelo construtivo inspirado
em _Stacked Autoencoders_ com crescimento dinâmico de topologia. Ambas otimizam
seus parâmetros com Adam (KINGMA; BA, 2014), minimizam a perda de Huber sobre
o erro de diferença temporal e atualizam a rede-alvo por média de Polyak
(LILLICRAP et al., 2015) com $tau = "0,005"$. A seleção de ações segue política
$epsilon$-gulosa com decaimento exponencial de $epsilon_0 = "1,0"$ até
$epsilon_"min" = "0,1"$.

A estratégia construtiva é caracterizada por quatro fatores de projeto,
variados de forma fatorial:

- *Arquitetura da rede.* Definida pela largura, função de ativação e uso de
  viés, especificados de modo independente para a camada oculta, a camada de
  saída e a camada extra.

- *Método de inserção* (CNT, CRT, DRT e ALT). Determina a trajetória das
  larguras ao longo das inserções: constante (CNT), crescente (CRT),
  decrescente (DRT) e estocástica do tipo passeio aleatório (ALT).

- *Modo de operação da camada inserida* (M1 a M4). Combina duas decisões
  binárias: se a camada utiliza um ramo extra e se o coeficiente de mistura
  $kappa$ é treinável ou fixo.

- *Tipo de mutação* (Normal, Out e Hidden). Especifica em que ponto da rede a
  não linearidade é introduzida após uma inserção.

== Mecanismo de Inserção, Congelamento e Mutação

A inserção de uma nova ramificação é acionada quando a variância da perda TD
por episódio, calculada sobre a janela dos $W$ episódios mais recentes, cai
abaixo de um limiar $sigma_"thr"^2$, desde que nenhuma ramificação tenha sido
inserida nos $W$ episódios anteriores e que um número mínimo de objetivos já
tenha sido alcançado. Imediatamente após a inserção, os parâmetros de todas as
ramificações previamente ativas são congelados e excluídos das atualizações por
gradiente; apenas a ramificação recém-inserida é otimizada, com taxa de
aprendizado própria $alpha_"branch"$.

Para que a inserção não provoque descontinuidade na função de custo, os novos
pesos e vieses de saída são inicializados com valores nulos e uma conexão
residual de fator escalar $kappa$ é estabelecida a partir da saída anterior.
A não linearidade é então introduzida gradualmente por interpolação linear
controlada por um coeficiente $eta in [0, 1]$:

$
f_eta (z) = (1 - eta) z + eta f_"alvo" (z),
$

em que $z$ é a saída de pré-ativação e $f_"alvo"$ a função não linear
alvo. O modo _Normal_ dispensa a interpolação; o modo _Out_ interpola a
contribuição da camada já existente que se conecta à nova camada; e o modo
_Hidden_ interpola a camada oculta inserida.

== Refinamentos Introduzidos

A análise comparativa inicial revelou a esparsidade do sinal de recompensa como
fator limitante dominante. Dois refinamentos complementares foram implementados.

O primeiro é a *modelagem de recompensa baseada em potencial* (_Potential-Based
Reward Shaping_ – PBRS) (NG; HARADA; RUSSELL, 1999). Define-se um potencial
$Phi(s)$ sobre o espaço de estados:

$
Phi(s) = -"manhattan"(s, g) \/ d_max in [-1, 0],
$

e a recompensa de modelagem aplicada a cada transição é:

$
F(s, s') = gamma Phi(s') - Phi(s),
$

de modo que a recompensa observada passa a ser $r' = r + F(s, s')$.

O segundo é a *amostragem priorizada de experiências* (_Prioritized Experience
Replay_ – PER), na variante proporcional descrita por Schaul et al. (2016).
Cada transição armazenada recebe prioridade $p_i = (abs(delta_i) + epsilon)^alpha$,
em que $delta_i$ é o erro TD.

== Protocolo Experimental de Ablação

O estudo fatorial de ablação refinado variou seis fatores: ambiente (3),
representação de estado (5), arquitetura da rede diferenciada pela função de
ativação oculta (3), método de inserção (4), modo de operação da camada
inserida (4) e tipo de mutação (3), totalizando 2.160 configurações. Para cada
configuração, dois modelos são treinados sob hiperparâmetros idênticos.

#tabela(
  [Hiperparâmetros globais do estudo fatorial de ablação refinado],
  [Elaborada pelo autor (2026).],
)[
  #tab(
    (auto, auto, auto, auto),
    table.hline(stroke: 0.8pt),
    [*Parâmetro*], [*Valor*], [*Parâmetro*], [*Valor*],
    table.hline(stroke: 0.5pt),
    [Taxa de aprendizado], [$1 times 10^(-5)$], [Episódios], [400],
    [Taxa da nova camada], [$5 times 10^(-5)$], [Tamanho do mini-lote], [512],
    [Fator de desconto $gamma$], [0,999], [Janela de média móvel $W$], [20],
    [Épocas até inserção], [15], [Objetivos mínimos], [5],
    [Variância mínima $sigma_"thr"^2$], [0,6], [Camadas máximas], [16],
    [Neurônios ocultos], [400], [Neurônios extras], [20],
    [$Delta$ de largura], [5% por camada], [Semente], [401],
    [PBRS], [ativo], [PER], [inativo],
    table.hline(stroke: 0.8pt),
  )
] <tab-hiper>

As representações de estado avaliadas combinam características adicionais a
três codificações base: coordenadas normalizadas (COORDS#sub[NORM]),
_one-hot_ de dimensão $R times C$ e _multi-hot_, que codifica linha e coluna
em vetores separados. As características são o sensor de ações possíveis (PAF),
o histórico dos $n$ estados anteriores e a contagem de visitas.

== Avaliação de Generalização por Objetivos Arbitrários

Para avaliar a generalização, a tarefa foi reformulada: em vez de aprender um
único par origem–destino fixo, o agente deve alcançar qualquer célula objetivo a
partir de qualquer célula inicial. Adotou-se a formulação de aproximadores de
função de valor universais (SCHAUL et al., 2015), na qual a função de valor
passa a ser condicionada ao objetivo, $Q(s, g, a)$, com o vetor do objetivo
concatenado à observação.

Essa disposição do vetor de observação permite aplicar a repetição retrospectiva
de experiências (_Hindsight Experience Replay_ – HER) na estratégia _future_,
com $k = 4$ objetivos reamostrados por transição (ANDRYCHOWICZ et al., 2017).
A avaliação percorre exaustivamente todos os pares origem–destino alcançáveis
do labirinto e reporta duas métricas: a taxa de sucesso e a razão de
otimalidade.
