// =============================================================================
// CAPÍTULO 2 · FUNDAMENTAÇÃO TEÓRICA
// Estrutura conforme summary.txt: Seções 2.1 a 2.5
// =============================================================================

= Fundamentação Teórica

== Navegação Autônoma de Robôs Móveis

A navegação autônoma de robôs móveis é um problema fundamental em robótica,
consistindo na capacidade de um robô se deslocar de um ponto de origem a um
ponto de destino em um ambiente conhecido ou desconhecido, evitando obstáculos
no percurso. Esse problema pode ser decomposto em subproblemas: percepção do
ambiente, representação do conhecimento, planejamento de caminho e controle de
movimento (SIEGWART; NOURBAKHSH; SCARAMUZZA, 2011).

=== Representação do Ambiente: Labirintos e Grades de Ocupação

Uma das formas mais simples e amplamente utilizadas de representar ambientes
para navegação é a grade discreta (_grid world_), na qual o espaço é
discretizado em células que podem ser classificadas como espaço livre,
obstáculo, posição inicial ou célula objetivo. Essa representação é particularmente
adequada para ambientes estruturados como labirintos, onde a mobilidade é
restrita a movimentos cardinais (frente, trás, esquerda, direita).

Paralelamente, a grade de ocupação (_occupancy grid_) é uma representação
probabilística que atribui a cada célula a probabilidade de estar ocupada,
sendo amplamente utilizada em ambientes com incerteza perceptiva (ELFES,
1989).

=== Navegação Origem–Destino e Algoritmos Clássicos de Busca

O problema de navegação origem–destino em um ambiente representado por grafo ou
grade pode ser resolvido por algoritmos clássicos de busca. O algoritmo A\*
(HART; NILSSON; RAPHAEL, 1968) combina o custo acumulado desde a origem com
uma heurística admissível que estima o custo até o objetivo, garantindo
otimalidade do caminho encontrado quando a heurística é consistente. Algoritmos
de busca em largura (BFS) e em profundidade (DFS) constituem casos particulares
de A\* sem heurística.

== Aprendizado por Reforço

O aprendizado por reforço (_Reinforcement Learning_ – RL) é um paradigma de
aprendizado de máquina no qual um agente aprende a tomar decisões por meio da
interação com um ambiente, recebendo sinais de recompensa que indicam a
qualidade de suas ações (SUTTON; BARTO, 2018). Diferentemente do aprendizado
supervisionado, no RL o agente não recebe exemplos rotulados de ações corretas,
mas deve explorar o ambiente para descobrir quais ações geram maior recompensa
acumulada.

=== Processo de Decisão de Markov

O processo de decisão de Markov (_Markov Decision Process_ – MDP) é a
ferramenta matemática formal para modelar problemas de decisão sequencial no
aprendizado por reforço. Um MDP é definido pela tupla $(S, A, P, R, gamma)$,
em que:

- $S$ é o espaço de estados;
- $A$ é o espaço de ações;
- $P: S times A times S -> [0, 1]$ é a função de transição de
  estados, $P(s' | s, a)$, que fornece a probabilidade de transição do
  estado $s$ para o estado $s'$ após executar a ação $a$;
- $R: S times A times S -> RR$ é a função de recompensa,
  que atribui um valor escalar ao agente ao realizar a transição $(s, a, s')$;
- $gamma in [0, 1]$ é o fator de desconto, que pondera a importância de
  recompensas futuras em relação a recompensas imediatas.

O objetivo do agente é aprender uma política $pi: S -> A$ que maximize
o retorno descontado esperado:

$
G_t = sum_(k=0)^infinity gamma^k r_(t+k+1).
$

=== Função Valor, Função Q e Equação de Bellman

A política ótima $pi_*$ é aquela que maximiza o retorno esperado a partir de
qualquer estado. Para avaliar uma política $pi$, definem-se a _função valor de
estado_ $v_pi (s)$ e a _função valor de ação_ (ou _função Q_) $q_pi (s, a)$:

$
v_pi (s) = EE_pi [G_t | s_t = s],
$

$
q_pi (s, a) = EE_pi [G_t | s_t = s, a_t = a].
$

A relação entre a função Q e a função valor de estado é dada por:

$
v_pi (s) = sum_(a in A) pi(a | s) dot q_pi (s, a).
$

As funções valor satisfazem as _equações de Bellman_, que estabelecem uma
relação recursiva entre o valor de um estado e o valor dos estados sucessores.
Para a política ótima, valem as _equações de Bellman ótimas_:

$
v_* (s) = max_(a in A) q_* (s, a),
$

$
q_* (s, a) = sum_(s' in S) P(s' | s, a) [R(s, a, s') + gamma dot v_* (s')].
$

=== Exploração × Explotação

Um dilema fundamental no aprendizado por reforço é o trade-off entre exploração
(experimentar novas ações para coletar mais informação sobre o ambiente) e
explotação (utilizar o conhecimento atual para maximizar a recompensa imediata).
Políticas $epsilon$-gulosas, que executam uma ação aleatória com probabilidade
$epsilon$ e a ação de maior valor Q com probabilidade $1-epsilon$, constituem
uma das estratégias mais simples para equilibrar exploração e explotação
(SUTTON; BARTO, 2018).

=== Q-Learning Tabular e Suas Limitações

O Q-Learning é um algoritmo de diferença temporal (_temporal difference_) que
aprende uma tabela de valores Q para cada par estado-ação (WATKINS; DAYAN,
1992). O algoritmo é _model-free_ (não requer conhecimento da dinâmica do ambiente)
e _off-policy_ (segue uma política de
exploração $epsilon$-gulosa).

A atualização incremental de cada transição observada $(s_t, a_t, r_(t+1), s_(t+1))$
é dada por:

$
Q(s_t, a_t) <- Q(s_t, a_t) + alpha [r_(t+1) + gamma dot max_(a') Q(s_(t+1), a') - Q(s_t, a_t)],
$

em que $alpha in (0, 1]$ é a taxa de aprendizado. O termo entre colchetes é o
_erro de diferença temporal_ (TD error):

$
delta_t = r_(t+1) + gamma dot max_(a') Q(s_(t+1), a') - Q(s_t, a_t).
$

Para $alpha -> 0$, a atualização se aproxima da iteração de Bellman
_determinística_; com passos de aprendizagem decrescentes que satisfaçam
$sum_t alpha_t = infinity$ e $sum_t alpha_t^2 < infinity$, o algoritmo converge
com probabilidade 1 para os valores Q ótimos sob visita infinita de cada par
$(s, a)$ (WATKINS; DAYAN, 1992; TSITSIKLIS, 1994).

Apesar de sua simplicidade e garantia de convergência para o MDP original, o
Q-Learning tabular não escala para espaços de estados grandes ou contínuos,
pois requer uma entrada na tabela para cada par $(s, a)$. Essa limitação motiva
a combinação do Q-Learning com aproximadores funcionais, levando ao
_aprendizado por reforço profundo_.

== Aprendizado por Reforço Profundo

O aprendizado por reforço profundo (_Deep Reinforcement Learning_ – DRL)
combina algoritmos de aprendizado por reforço com redes neurais profundas,
utilizadas para aproximar as funções valor e/ou política.
Como estados semelhantes produzem saídas semelhantes, o agente passa a
generalizar o conhecimento adquirido para estados ainda não observados.

=== Deep Q-Network (DQN)

O Deep Q-Network (DQN) substitui a tabela Q por uma rede neural $Q(s, a; theta)$
com parâmetros $theta$, treinada para minimizar o erro de diferença temporal.
Mnih et al. (2015) propuseram quatro contribuições principais para estabilizar
o treinamento com aproximadores não lineares: (i) rede neural profunda para
aproximação da função Q; (ii) amostragem por mini-lotes do _replay buffer_,
substituindo atualizações passo a passo; (iii) rede-alvo separada para geração
de alvos; (iv) _clip_ do erro na perda para limitar a influência de outliers.

A perda a ser minimizada em cada iteração $i$ é:

$
L_i (theta_i) = EE_((s, a, r, s') ~ cal(D)) [(y_i - Q(s, a; theta_i))^2],
$

em que o alvo de Bellman é:

$
y_i = r + gamma dot max_(a') Q(s', a'; theta_i^-),
$

$cal(D)$ é o _replay buffer_ com capacidade finita $N$, $theta_i^-$ são os
parâmetros da rede-alvo (fixos entre clonagens) e $gamma = "0,99"$ no DQN
original. O gradiente da perda é:

$
nabla_(theta_i) L_i (theta_i) = EE [(y_i - Q(s, a; theta_i)) dot nabla_(theta_i) Q(s, a; theta_i)].
$

A otimização é realizada por descenso de gradiente estocástico com o algoritmo
RMSProp (TIELEMAN; HINTON, 2012) sobre mini-lotes de tamanho 32. A função de ativação
usada nas camadas ocultas é ReLU (JARRETT et al., 2009).

Além disso, o erro $(y_i - Q(s, a; theta_i))$ é _clipped_ ao intervalo $[-1, 1]$
para equivaler a uma perda do tipo valor absoluto fora desse intervalo, o que
reduz a sensibilidade a recompensas extremas (MNIH et al., 2015).

=== Replay de Experiências e Rede-Alvo

Dois mecanismos foram introduzidos no DQN original para estabilizar o
treinamento (MNIH et al., 2015): o _replay de experiências_ amostra transições
uniformemente de um buffer de experiências armazenadas, quebrando as correlações
temporais; a _rede-alvo_ é uma cópia dos parâmetros da rede principal, atualizada
periodicamente, que fornece alvos mais estáveis para a otimização.

Variantes modernas utilizam média de Polyak (_soft update_) para a atualização
da rede-alvo (LILLICRAP et al., 2015):

$
theta^- <- tau dot theta + (1 - tau) dot theta^-,
$

em que $tau << 1$.

=== Variantes: Double DQN e Dueling DQN

O _Double DQN_ (VAN HASSELT; GUEZ; SILVER, 2016) corrige a superestimativa
dos valores Q introduzida pela maximização dupla. Quando o máximo é aplicado
tanto na seleção quanto na avaliação da ação ótima, erros positivos na estima
dos valores Q são sistematicamente amplificados. O Double DQN resolve esse
problema separando seleção e avaliação:

$
a^* = op("arg max", limits: #true)_(a') Q(s', a'; theta), quad quad y = r + gamma dot Q(s', a^*; theta^-).
$

A rede principal $Q(dot; theta)$ seleciona a ação greedy e a rede-alvo
$Q(dot; theta^-)$ avalia seu valor, eliminando a correlação entre
seleção e avaliação. A atualização com Double DQN é:

$
y^"DDQN" = r + gamma dot Q(s', op("arg max", limits: #true)_(a') Q(s', a'; theta); thin theta^-).
$

O _Dueling DQN_ separa a estimação do valor de estado e do _advantage_ das ações,
permitindo aprender qual estado é valioso independentemente da ação executada
(WANG et al., 2016). A função Q é decomposta como:

$
Q(s, a; theta) = V(s; theta_V) + [A(s, a; theta_A) - inline(1/abs(A)) sum_(a') A(s, a'; theta_A)].
$

=== Instabilidade e Dificuldades de Convergência

O treinamento de agentes DRL é notoriamente instável, com dificuldades como:
distribuição não estacionária das experiências, correlações temporais, sensibilidade
a hiperparâmetros e esquecimento catastrófico de políticas aprendidas
anteriormente. Estratégias construtivas de arquitetura buscam mitigar parte
desses problemas.

== Autoencoders e Stacked Autoencoders

Autoencoders são redes neurais não supervisionadas que aprendem uma
representação compacta (codificação) dos dados de entrada, passando por um
gargalo de dimensão reduzida (_latent space_), e depois reconstruindo os dados
originais a partir dessa representação (HINTON; SALAKHUTDINOV, 2006).

=== Autoencoder Básico, Esparso e com Remoção de Ruído

O autoencoder básico consiste em um _encoder_ $f: cal(X) -> cal(H)$
que mapeia a entrada $x$ para uma codificação $h = f(x)$, e um _decoder_
$g: cal(H) -> cal(X)$ que reconstrói a entrada:
$hat(x) = g(h)$. O treinamento minimiza uma função de perda de reconstrução,
como o erro quadrático médio $norm(x - hat(x))^2$.

Variantes incluem: o autoencoder esparso, que adiciona uma restrição de
esparsidade na codificação; e o autoencoder com remoção de ruído (_denoising
autoencoder_), que treina a rede para reconstruir dados limpos a partir de
versões corrompidas (VINCENT et al., 2010).

=== Stacked Autoencoders e Pré-treinamento Camada a Camada

Stacked Autoencoders (_SAE_) consistem em múltiplas camadas de autoencoders
compostos, onde a saída de um autoencoder serve como entrada para o próximo.
O pré-treinamento camada a camada (_layer-wise pretraining_) treina cada
autoencoder de forma greed e não supervisionada, permitindo a aprendizagem de
representações hierárquicas e progressivamente mais abstratas das entradas.

=== Autoencoders para Aprendizado de Representações de Estado

No contexto de aprendizado por reforço, autoencoders podem ser utilizados para
aprender representações compactas e informativas do espaço de estados,
reduzindo a dimensionalidade e extraindo características relevantes para a
tomada de decisão. Essa abordagem é particularmente útil quando o espaço de
estados é de alta dimensionalidade, como imagens de câmeras (LANGE;
RIEDMILLER, 2010).

== Inserção de Camadas em Stacked Autoencoders

Redes neurais construtivas (_constructive neural networks_) são arquiteturas que
crescem durante o treinamento, adicionando novas camadas ou neurônios conforme
necessário, em vez de iniciar com uma topologia fixa (FEHRING; LINDAUER;
EIMER, 2025).

=== Redes Neurais Construtivas

As redes construtivas incluem abordagens como _Cascade-Correlation_ (FAHLMAN;
LEBIERE, 1990), que adiciona camadas ocultas iterativamente, e _Progressive
Neural Networks_ (RUSU et al., 2016), que cria novas colunas de rede para
cada tarefa nova, congelando as anteriores para evitar esquecimento
catastrófico.

=== O Método de Inserção de Camadas Proposto na Tese de Doutorado

Viana et al. (2025) propuseram um método de inserção de camadas em redes
_Stacked Autoencoder_ que consiste em adicionar novas ramificações densas
durante o treinamento, com congelamento seletivo dos parâmetros das
ramificações anteriores. A nova ramificação é inicializada com pesos nulos e
conectada por uma ligação residual que preserva a função de saída original no
instante da inserção.

=== Critérios de Inserção e Preservação do Conhecimento Aprendido

O critério de inserção baseado na variância da perda TD permite detectar quando
a rede atingiu um patamar de estagnação e uma nova ramificação pode melhorar o
desempenho. O congelamento dos parâmetros das ramificações anteriores preserva
as representações aprendidas, enquanto a nova ramificação aprende a reduzir o
erro residual. Essa abordagem combina os princípios de redes construtivas com
os requisitos específicos do aprendizado por reforço profundo.
