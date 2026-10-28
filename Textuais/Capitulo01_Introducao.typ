// =============================================================================
// CAPÍTULO 1 · INTRODUÇÃO
// Conteúdo reutilizado do resumo_expandido.typ e main.typ (seções Introdução e Objetivos)
// =============================================================================

= Introdução

A Aprendizagem por Reforço Profunda (_Deep Reinforcement Learning_ – DRL)
consolidou-se como um dos paradigmas mais produtivos para a construção de
agentes autônomos capazes de aprender comportamentos complexos a partir da
interação direta com o ambiente. Nesse paradigma, redes neurais profundas atuam
como aproximadores das funções de valor e de política, tornando tratáveis
espaços de estados de alta dimensionalidade que seriam inviáveis para métodos
tabulares clássicos (MNIH et al., 2015; SUTTON; BARTO, 2018).

Esse ganho de capacidade, entretanto, tem um custo. O treinamento de redes
profundas é intensivo em energia, e a complexidade do modelo, medida pelo
número de parâmetros e de operações, relaciona-se diretamente ao consumo
energético e às emissões associadas ao ciclo de desenvolvimento. A busca por
métodos que reduzam o número de iterações e o tamanho efetivo dos modelos
durante o treinamento é, portanto, simultaneamente uma questão de desempenho e
de sustentabilidade, tema que a literatura recente reúne sob a designação de
_Green AI_.

Um segundo problema, específico do aprendizado contínuo, é o esquecimento
catastrófico (_catastrophic forgetting_): a atualização dos parâmetros
compartilhados de uma rede para acomodar uma nova tarefa pode degradar o
conhecimento previamente adquirido (MCCLOSKEY; COHEN, 1989; KIRKPATRICK et
al., 2017). Em DRL o efeito é agravado pela não estacionariedade dos alvos de
regressão, uma vez que a própria rede define o valor que serve de referência
para o passo seguinte de otimização.

Estratégias construtivas de expansão arquitetural respondem a ambos os
problemas com o mesmo mecanismo: em vez de treinar desde o início uma topologia
grande e fixa, a rede cresce ao longo do treinamento pela inserção de novos
módulos, enquanto os parâmetros já consolidados são congelados e retirados das
atualizações por gradiente. O aprendizado passa a concentrar-se no erro
residual da estrutura recém-inserida, o que preserva as representações
anteriores e mantém baixo o número de parâmetros treináveis na maior parte do
treinamento (FEHRING; LINDAUER; EIMER, 2025; VIANA et al., 2025).

== Contextualização

A navegação autônoma de robôs móveis é uma das aplicações mais desafiadoras e
representativas do aprendizado por reforço profundo. Um agente capaz de navegar
em ambientes desconhecidos, evitando obstáculos e alcançando objetivos de forma
autônoma, possui implicações diretas em logística, exploração, serviços e
muitos outros domínios. Contudo, ambientes labirínticos impõem restrições
particularmente severas: o espaço de estados cresce exponencialmente com o
número de células, o sinal de recompensa é extremamente esparso (o agente
recebe recompensa positiva apenas ao atingir o objetivo, o que pode ocorrer
após centenas ou milhares de tentativas falhas), e a generalização para novos
ambientes ou novos pares origem–destino exige reconfiguração completa do agente.

Labirintos discretos do tipo _grid world_ constituem um ambiente de referência
amplamente utilizado na literatura para avaliar algoritmos de planejamento e
aprendizado (WATKINS; DAYAN, 1992; SUTTON; BARTO, 2018). A representação por
grade permite isolar o efeito dos algoritmos de decisão e aprendizado, sem as
complexidades adicionais de percepção visual ou ruído sensorial presente em
ambientes reais. Paralelamente, a transição para plataformas robótica reais —
como o kart LAFVIN Raspberry Pi Smart Car com odometria por encoders e unidade
inercial — demonstra a transferibilidade dos agentes treinados em simulação para
o mundo físico.

== Problema de Pesquisa

O problema de pesquisa pode ser enunciado nos seguintes termos: sob quais
condições o crescimento incremental da topologia, acompanhado de congelamento,
alcança desempenho equivalente ou superior ao de uma arquitetura densa estática
de referência, e a que custo em parâmetros, tempo e estabilidade numérica?

Responder a essa pergunta exige isolar o efeito de cada decisão de projeto da
estratégia construtiva, o que orienta a metodologia adotada: um estudo fatorial
de ablação com comparação pareada contra uma linha de base treinada sob
hiperparâmetros idênticos.

== Objetivos

=== Objetivo Geral

Demonstrar que a técnica de congelamento e adição de camadas em algoritmos de
aprendizagem por reforço profundo pode otimizar significativamente o tempo de
treinamento, promover a convergência para o mínimo global e possibilitar a
reutilização de treinamentos previamente realizados em diferentes ambientes.

=== Objetivos Específicos

+ Desenvolver uma simulação computacional de um ambiente labiríntico com
  dimensionalidade de estado reduzida.
+ Implementar algoritmos de aprendizagem por reforço profundo para que o agente
  possa resolver o ambiente.
+ Coletar e analisar métricas de desempenho, tempo computacional e qualidade do
  agente para cada algoritmo implementado.
+ Adaptar os algoritmos implementados incorporando a estratégia de congelamento
  e adição de camadas.
+ Avaliar o desempenho, o tempo computacional e a qualidade do agente com os
  algoritmos adaptados.
+ Criar um novo ambiente, baseado no ambiente labiríntico original, para testar
  a generalização dos treinamentos.
+ Treinar o agente com os algoritmos adaptados no novo ambiente, utilizando as
  camadas previamente treinadas, e obter as métricas correspondentes.
+ Realizar testes em ambiente real por meio de um agente robótico
  omnidirecional, demonstrando a eficiência da estratégia proposta.

== Justificativa

Apesar dos avanços em aprendizado por reforço e robótica móvel, ainda são
escassas as soluções que integram treinamento eficiente de redes com crescimento
arquitetural, generalização para novos ambientes e validação em plataforma
robótica real, especialmente em plataformas de baixo custo e fácil replicação.

Nesse contexto, justifica-se o desenvolvimento de uma estratégia que una
aprendizado por reforço profundo, crescimento arquitetural construtivo e
validação experimental, para oferecer um framework reutilizável que permita a
treinamento eficiente de agentes autônomos com custo computacional reduzido.

== Contribuições do Trabalho

Este trabalho busca contribuir com a consolidação prática de técnicas de aprendizado por reforço profundo com crescimento arquitetural, disponibilizando uma estratégia replicável que une
simulação, ablação sistemática e validação robótica para navegação autônoma
com agentes de topologia variável.

== Organização do Trabalho

Seções subsequentes, o Capítulo 2 apresenta a fundamentação teórica necessária
para a compreensão da pesquisa, abordando conceitos relacionados à navegação
autônoma, aprendizado por reforço clássico e profundo, autoencoders e redes
neurais construtivas. O Capítulo 3 revisa os trabalhos relacionados na
literatura, sintetizando o estado da arte e identificando lacunas. O Capítulo 4
descreve a metodologia proposta, incluindo a formulação do problema como MDP,
as arquiteturas comparadas, o mecanismo de inserção de camadas e o protocolo
experimental. O Capítulo 6 detalha a plataforma robótica utilizada para
validação experimental. O Capítulo 7 apresenta os resultados obtidos, com
análise comparativa, estudo de ablação e avaliação de generalização. Por fim,
o Capítulo 8 apresenta as conclusões do trabalho, limitações e perspectivas
para trabalhos futuros.