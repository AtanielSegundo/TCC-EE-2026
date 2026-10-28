// =============================================================================
// CAPÍTULO 7 · RESULTADOS E DISCUSSÃO
// Adaptado do main.typ: seções "Resultados" e "Discussão"
// Estrutura conforme summary.txt: Seções 7.1 a 7.9
// =============================================================================

#import "../config/settings.typ": *

= Resultados e Discussão

== Configuração dos Experimentos

O estudo fatorial refinado foi concluído integralmente para os ambientes pequeno
e médio, cobrindo 1.440 configurações e 2.880 treinamentos; o ambiente grande,
cuja execução demanda ordem de grandeza superior de tempo de máquina, permaneceu
incompleto no horizonte do projeto e foi excluído das agregações quantitativas.
As métricas reportadas correspondem à média sobre os 50 últimos episódios de
cada execução, exceto os objetivos cumulativos, os parâmetros e o tempo, tomados
ao final do treinamento.

Um agente Q-learning tabular (WATKINS; DAYAN, 1992) e a solução ótima por A\*
são calculados por labirinto como referências de convergência. Ao término do
treinamento, as métricas episódio a episódio — recompensa acumulada, taxa de
sucesso, objetivos cumulativos, perda TD, número de parâmetros, passos por
episódio, ramificações inseridas e tempo de execução — são agregadas por
agrupamento ao longo de uma dimensão de interesse, com média e variância
calculadas de forma incremental pelo algoritmo de Welford (1962). As execuções
por modelo são paralelizadas em processos independentes.

== Curvas de Aprendizado do Agente

No agregado, a estratégia construtiva superou a linha de base em 6,17 pontos
percentuais de taxa de sucesso, empregando 25,3% dos parâmetros e 69,0% do
tempo de treinamento.

#tabela(
  [Resultado global agregado da comparação pareada (1.440 configurações)],
  [Elaborada pelo autor (2026).],
)[
  #tab(
    (auto, auto, auto, auto),
    table.hline(stroke: 0.8pt),
    [*Métrica*], [*SAECollabNet*], [*Linha de base*], [*Razão*],
    table.hline(stroke: 0.5pt),
    [Taxa de sucesso final (%)], [38,10], [31,93], [1,19],
    [Objetivos cumulativos], [141,3], [135,8], [1,04],
    [Parâmetros], [687.797], [2.714.727], [0,253],
    [Tempo de treinamento (s)], [1.120,5], [1.624,4], [0,690],
    [Ramificações ativas], [3,76], [16,00], [0,235],
    table.hline(stroke: 0.8pt),
  )
] <tab-global>

No agregado, a estratégia construtiva superou a linha de base em 6,17 pontos
percentuais de taxa de sucesso, empregando 25,3% dos parâmetros e 69,0% do
tempo de treinamento. Esse é o resultado central do projeto e representa uma
inversão em relação ao quadro do relatório parcial, quando o modelo construtivo
apenas igualava o desempenho assintótico da referência estática. Na comparação
pareada configuração a configuração, o modelo construtivo utilizou menos
parâmetros em 94,7% dos pares e concluiu o treinamento em menos tempo em 75,7%
deles.

A vantagem em taxa de sucesso, contudo, não é uniforme: o modelo construtivo
venceu individualmente em 34,9% dos pares. A média favorável decorre, portanto,
de ganhos expressivos em um subconjunto de configurações, e não de uma
superioridade generalizada. A separação por ambiente confirma essa leitura: no
labirinto pequeno o modelo construtivo alcançou 43,69% de taxa de sucesso
contra 26,23% da linha de base, ao passo que no labirinto médio a relação se
inverte (32,51% contra 37,62%). A vantagem paramétrica e temporal, contudo,
mantém-se em ambos os ambientes.

== Evolução da Arquitetura durante as Inserções de Camadas

A estratégia construtiva é caracterizada por quatro fatores de projeto variados
de forma fatorial, entre eles o método de inserção (CNT, CRT, DRT e ALT), o
modo de operação da camada inserida (M1 a M4) e o tipo de mutação (Normal, Out
e Hidden). Ao longo do treinamento, a rede cresce pela inserção progressiva de
novas ramificações, cujo número médio ao final é de 3,76 no modelo construtivo
contra 16 camadas fixas na linha de base.

O gatilho de inserção é acionado quando a variância da perda TD por episódio,
calculada sobre a janela dos 20 episódios mais recentes, cai abaixo de um limiar
de 0,6, desde que nenhuma ramificação tenha sido inserida nos 20 episódios
anteriores e que um número mínimo de cinco objetivos já tenha sido alcançado.
Imediatamente após a inserção, os parâmetros de todas as ramificações
previamente ativas são congelados; apenas a ramificação recém-inserida é
otimizada, com taxa de aprendizado própria de $5 times 10^(-5)$.

== Desempenho na Navegação Origem–Destino

A representação de estado revelou-se o fator de maior efeito de todo o estudo,
com amplitude superior à de todos os fatores internos à estratégia somados.

#tabela(
  [Desempenho por representação de estado (média sobre 288 configurações cada)],
  [Elaborada pelo autor (2026).],
)[
  #tab(
    (auto, auto, auto, auto, auto, auto),
    table.hline(stroke: 0.8pt),
    table.cell(rowspan: 2)[*Representação*],
    table.cell(colspan: 2)[*Sucesso (%)*],
    table.cell(colspan: 2)[*Parâmetros*],
    table.cell(rowspan: 2)[*Ramif.*],
    [SAE], [Base], [SAE], [Base],
    table.hline(stroke: 0.5pt),
    [ONE#sub[HOT]+PAF], [75,00], [40,55], [293.044], [2.803.081], [1,18],
    [ONE#sub[HOT]], [54,66], [35,33], [449.930], [2.774.390], [2,05],
    [COORDS+PAF], [40,95], [36,92], [1.219.894], [2.647.182], [7,01],
    [MULTI#sub[HOT]], [19,67], [32,52], [1.471.714], [2.683.972], [8,56],
    [COORDS#sub[NORM]+hist.+visitas], [0,23], [14,31], [4.404], [2.665.009], [0,00],
    table.hline(stroke: 0.8pt),
  )
] <tab-encodes>

Sob a codificação _one-hot_ acrescida do sensor de ações possíveis, a estratégia
construtiva atingiu 75,00% de taxa de sucesso contra 40,55% da linha de base,
usando 10,5% dos parâmetros e 39,6% do tempo — o melhor resultado absoluto do
estudo, obtido com média de apenas 1,18 ramificações inseridas.

No extremo oposto, a representação por coordenadas normalizadas com histórico de
estados e contagem de visitas produziu colapso completo do modelo construtivo:
0,23% de taxa de sucesso, contra 14,31% da linha de base sob a mesma
representação. O valor de 4.404 parâmetros e a média de exatamente zero
ramificações inseridas identificam a causa de modo inequívoco: o critério de
inserção jamais foi acionado, e o modelo permaneceu por todo o treinamento na
topologia mínima inicial.

== Comparação com Agentes de Referência

=== Q-Learning Tabular

Um agente Q-learning tabular (WATKINS; DAYAN, 1992) foi calculado para cada
labirinto como referência de convergência, representando o limite de desempenho
alcançável por métodos tabulares. A solução ótima por A\* (HART; NILSSON;
RAPHAEL, 1968) foi utilizada como referência de otimalidade.

=== DQN com MLP de Profundidade Fixa

A linha de base (`TorchDDQN`) é um agente DDQN convencional de topologia
estática, na formulação de van Hasselt, Guez e Silver (2016). Ambas as
arquiteturas otimizam seus parâmetros com Adam (KINGMA; BA, 2014), minimizam a
perda de Huber sobre o erro de diferença temporal e atualizam a rede-alvo por
média de Polyak (LILLICRAP et al., 2015) com $tau = "0,005"$.

=== DQN com SAE de Profundidade Fixa

A arquitetura proposta (`SAECollabDDQN`, com a variante `ReservedSAECollabDDQN`,
que pré-aloca as camadas em memória) implementa o modelo construtivo inspirado
em _Stacked Autoencoders_ com crescimento dinâmico de topologia.

A função de ativação da camada oculta domina os demais fatores: ReLU supera
Tanh e sigmoide em cerca de 14 pontos percentuais e simultaneamente produz os
modelos mais compactos e mais rápidos. Entre os tipos de mutação, o modo Normal
apresentou a melhor taxa de sucesso e, sobretudo, o único comportamento
numericamente estável: a mediana da perda TD nos últimos episódios permaneceu em
0,212, contra valores não finitos nos modos Out e Hidden.

#tabela(
  [Efeito dos fatores de projeto da estratégia construtiva],
  [Elaborada pelo autor (2026).],
)[
  #tab(
    (auto, auto, auto, auto, auto),
    table.hline(stroke: 0.8pt),
    [*Fator*], [*Nível*], [*Sucesso (%)*], [*Parâmetros*], [*Tempo (s)*],
    table.hline(stroke: 0.5pt),
    [Ativação oculta], [ReLU], [47,45], [467.282], [899],
    [], [Tanh], [34,23], [844.200], [1.374],
    [], [Sigmoide], [32,64], [751.910], [1.089],
    [Mutação], [Normal], [42,09], [617.946], [1.008],
    [], [Out], [36,29], [720.503], [1.188],
    [], [Hidden], [35,93], [724.943], [1.165],
    [Modo da camada], [M3], [42,53], [618.252], [1.165],
    [], [M4], [39,42], [642.622], [1.180],
    [], [M1], [36,42], [688.872], [1.047],
    [], [M2], [34,04], [801.443], [1.090],
    [Método de inserção], [CRT], [39,95], [1.014.833], [1.086],
    [], [CNT], [38,81], [664.656], [1.193],
    [], [ALT], [37,46], [653.975], [1.097],
    [], [DRT], [36,20], [417.724], [1.107],
    table.hline(stroke: 0.8pt),
  )
] <tab-fatores>

No conjunto das execuções, 3,4% das do modelo construtivo apresentaram perda TD
não finita na fase final, contra nenhuma ocorrência na linha de base. Os
métodos de inserção diferenciam-se muito mais pelo custo do que pelo desempenho:
a amplitude de taxa de sucesso entre CRT e DRT é de 3,75 pontos percentuais,
enquanto o crescimento progressivo (CRT) consome 2,43 vezes mais parâmetros que
o decrescimento progressivo (DRT).

== Generalização para Novos Labirintos e Novos Pares Origem–Destino

A avaliação de generalização foi conduzida no ambiente pequeno com três
sementes independentes, 3.000 episódios por execução e avaliação exaustiva
sobre os 2.862 pares origem–destino alcançáveis.

O gatilho de inserção foi substituído nesta etapa por um critério que mede o
progresso diretamente na tarefa. Três elementos o compõem: o primeiro quarto
do treinamento é reservado à topologia mínima, antes de qualquer inserção; a
estagnação é aferida pela diferença entre as médias de duas janelas disjuntas
de avaliações no conjunto de validação; e o crescimento é suspenso quando a taxa
nesse conjunto atinge 85%. Como o terceiro elemento condiciona a inserção ao
desempenho corrente, o número de camadas ativadas deixa de ser fixo: nas três
execuções o crescimento foi suspenso após a segunda camada, de modo que apenas
metade do orçamento arquitetural foi utilizada.

Adotou-se a formulação de aproximadores de função de valor universais (SCHAUL
et al., 2015), na qual a função de valor passa a ser condicionada ao objetivo,
$Q(s, g, a)$, com o vetor do objetivo concatenado à observação em uma fatia
contígua ao final do vetor de entrada. Essa disposição do vetor de observação é
o que torna possível aplicar a repetição retrospectiva de experiências (HER),
na estratégia _future_, com $k = 4$ objetivos reamostrados por transição
(ANDRYCHOWICZ et al., 2017).

#tabela(
  [Generalização a objetivos arbitrários com UVFA e HER (média #sym.plus.minus desvio-padrão sobre três sementes)],
  [Elaborada pelo autor (2026).],
)[
  #tab(
    (auto, auto, auto),
    table.hline(stroke: 0.8pt),
    [*Métrica*], [*Linha de base densa*], [*SAECollabNet*],
    table.hline(stroke: 0.5pt),
    [Sucesso em todos os pares (%)], [98,94 #sym.plus.minus 0,73], [96,26 #sym.plus.minus 0,45],
    [Sucesso em todos os pares, ponto final (%)], [97,32 #sym.plus.minus 1,80], [94,15 #sym.plus.minus 2,72],
    [Melhor sucesso no conjunto de validação (%)], [98,70 #sym.plus.minus 0,60], [98,05 #sym.plus.minus 1,17],
    [Sucesso final no conjunto de validação (%)], [97,01 #sym.plus.minus 1,63], [94,92 #sym.plus.minus 1,41],
    [Razão de otimalidade], [1,00], [1,00],
    [Parâmetros], [8.590.204], [2.064.092],
    [Camadas ativas ao final], [fixa], [2 / 2 / 2],
    [Tempo de treinamento (s)], [417,6 #sym.plus.minus 4,1], [487,9 #sym.plus.minus 40,3],
    table.hline(stroke: 0.8pt),
  )
] <tab-uvfa>

A linha de base densa resolve 98,94% dos pares contra 96,26% do modelo
construtivo. A diferença entre as arquiteturas está no custo paramétrico: o
modelo construtivo encerra o treinamento com 2,06 milhões de parâmetros, ou
24,0% dos 8,59 milhões fixos da linha de base.

A razão de otimalidade de 1,00 em ambas as arquiteturas indica que todo par
efetivamente resolvido o foi por um caminho de comprimento ótimo: a diferença
entre as arquiteturas não se manifesta como caminhos piores, mas como falhas de
alcance. Até dezesseis passos de distância ótima ambas mantêm mais de 94% de
sucesso; a partir daí o modelo construtivo degrada progressivamente, chegando a
71,4% aos 20 passos e a 33,3% nos pares mais distantes, ao passo que a linha de
base permanece acima de 88% até 21 passos.

== Estudo de Ablação

O estudo fatorial de ablação refinado variou seis fatores: ambiente (3),
representação de estado (5), arquitetura da rede diferenciada pela função de
ativação oculta (3), método de inserção (4), modo de operação da camada inserida
(4) e tipo de mutação (3), totalizando 2.160 configurações. Para cada
configuração, dois modelos são treinados sob hiperparâmetros idênticos, o modelo
com a estratégia colaborativa e o modelo denso equivalente, permitindo comparação
pareada.

A separação por ambiente confirma que a vantagem do modelo construtivo é
variável: no labirinto pequeno o modelo construtivo alcançou 43,69% de taxa de
sucesso contra 26,23% da linha de base, ao passo que no labirinto médio a
relação se inverte (32,51% contra 37,62%). A vantagem paramétrica e temporal,
contudo, mantém-se em ambos os ambientes.

Os modos de operação da camada inserida, por sua vez, apresentam curvas
praticamente sobrepostas ao longo de todo o treinamento, com amplitude de 8,5
pontos percentuais entre o melhor e o pior nível.

== Custo Computacional

Os ganhos computacionais são consistentes: 31,0% de redução no tempo de parede
e 74,7% no número de parâmetros no agregado, chegando a 89,5% sob a melhor
representação de estado. Como o consumo energético do treinamento se relaciona
diretamente ao número de parâmetros e de operações, esses percentuais concretizam
o objetivo de sustentabilidade que motivou o projeto, e importam sobretudo em
plataformas embarcadas de recursos limitados, como o Raspberry Pi 3B+ aqui
utilizado.

No agregado, o modelo construtivo empregou 25,3% dos parâmetros e 69,0% do
tempo de treinamento. Na comparação pareada configuração a configuração, o
modelo construtivo utilizou menos parâmetros em 94,7% dos pares e concluiu o
treinamento em menos tempo em 75,7% deles.

== Discussão Geral

O resultado global confirma a hipótese central do projeto sob condição de
recompensa densificada. No relatório parcial, com recompensa esparsa, a
estratégia construtiva apenas igualava o desempenho assintótico da linha de base;
com o PBRS, passa a superá-la em taxa de sucesso utilizando um quarto dos
parâmetros. A causa está no acoplamento entre o sinal de recompensa e o gatilho
de crescimento: a inserção depende da estabilização da variância da perda TD e
de um número mínimo de objetivos alcançados, sinais que, sob recompensa esparsa,
chegam tarde e ruidosos, de modo que a rede cresce em momentos pouco
informativos. A densificação por diferença de potenciais, que preserva o
conjunto de políticas ótimas (NG; HARADA; RUSSELL, 1999), sincroniza o
crescimento com o progresso efetivo do aprendizado.

O colapso sob a representação por coordenadas normalizadas com histórico e
contagem de visitas expõe uma fragilidade estrutural do paradigma construtivo. O
critério exige que ao menos cinco objetivos tenham sido alcançados, mas a
topologia mínima inicial, de 4.404 parâmetros, não possui capacidade para
alcançá-los sob essa codificação: sem objetivos não há inserção; sem inserção
não há capacidade; sem capacidade não há objetivos. A linha de base, que já
nasce com toda a capacidade disponível, escapa do impasse e atinge 14,31%.
Critérios de inserção condicionados ao sucesso da tarefa exigem, portanto, um
mecanismo de escape, seja a inserção forçada após um número máximo de episódios
sem crescimento, seja um critério baseado apenas na dinâmica da perda.

Dois resultados secundários decorrem da mesma mudança no sinal de recompensa. O
modo de mutação Normal, inferior no relatório parcial, torna-se superior no
estudo refinado: a interpolação entre regime linear e não linear protege contra
o salto na função de custo no instante da inserção. A instabilidade numérica em
3,4% das execuções do modelo construtivo, inexistente na linha de base, decorre
da combinação de fator de desconto elevado, recompensa modelada e camadas
congeladas: o alvo de _bootstrap_ cresce sem que a rede disponha de parâmetros
livres para acompanhá-lo, uma vez que apenas a última ramificação é treinável.

Os resultados de generalização delimitam o alcance da estratégia. A degradação
progressiva com a distância, evidenciada na avaliação, é coerente com o
congelamento: propagar valor ao longo de horizontes longos exige reorganizar as
representações em todas as profundidades da rede, e é exatamente isso que o
congelamento impede. Com objetivo fixo, refinar o erro residual em uma camada
terminal é suficiente; quando o objetivo passa a ser variável de entrada, a
política torna-se função conjunta de estado e objetivo, e as camadas congeladas
convertem-se em gargalo representacional, o que persiste mesmo com o adiamento
das inserções para a segunda metade do treinamento.

A caracterização experimental do acionamento do kart, a integração ao
CoppeliaSim e a navegação célula a célula executada na plataforma real
completam a validação. A plataforma foi construída, instrumentada, caracterizada
experimentalmente e integrada a um espelho digital, com controle em malha
fechada verificado por 28 testes unitários e navegação executada.

Duas limitações metodológicas devem ser registradas: o estudo fatorial não foi
concluído no labirinto de 30 #sym.times 30 células, cujo custo computacional
excedeu o horizonte do projeto, o que restringe as conclusões quantitativas aos
ambientes pequeno e médio; e o uso de semente única por configuração privilegiou
a amplitude do espaço explorado sobre a repetição, efeito atenuado, mas não
eliminado, pela agregação sobre centenas de configurações por nível de fator. A
avaliação de generalização, por ser pontual, empregou três sementes
independentes.
