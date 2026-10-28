// =============================================================================
// CAPÍTULO 3 · TRABALHOS RELACIONADOS
// Estrutura conforme summary.txt: Seções 3.1 a 3.5
// =============================================================================

= Trabalhos Relacionos

== Aprendizado por Reforço em Navegação de Labirintos

=== Q-Learning Tabular em Ambientes do Tipo Gridworld

O Q-Learning tabular foi amplamente aplicado a labirintos discretos desde sua
formulação original (WATKINS; DAYAN, 1992). Watkins e Dayan demonstraram a
convergência do algoritmo para a política ótima em ambientes Markovianos.
Trabalhos subsequentes avaliaram a eficiência de diferentes configurações de
exploração e taxas de aprendizado em labirintos de dimensões variadas.

=== Agentes DRL em Labirintos Complexos

O DQN original (MNIH et al., 2015) foi inicialmente avaliado em Atari Games,
estabelecendo um novo estado da arte. Aplicações específicas a labirintos
complexos demonstraram que agentes DRL podem aprender políticas de navegação
eficientes em ambientes com espaços de estados grandes, superando o desempenho
de métodos tabulares em labirintos de dimensões acima de 20#sym.times#h(1pt)20
células.

== Aprendizado por Reforço Profundo Aplicado à Robótica Móvel

=== Deep Q-Network e Suas Variantes

O _Double DQN_ (VAN HASSELT; GUEZ; SILVER, 2016) reduziu a superestimativa
de valores Q, enquanto o _Dueling DQN_ (WANG et al., 2016) separou a estimação
de valor de estado e vantagem. Ambas as variantes foram aplicadas a problemas
de navegação autônoma, mostrando melhor estabilidade e convergência.

=== Navegação Orientada a Destino

A formulação de navegação orientada a destino, onde o agente deve alcançar
qualquer célula objetivo a partir de qualquer posição inicial, tem sido
abordada por meio de aproximadores de função de valor universais (_Universal
Value Function Approximators_ – UVFA) (SCHAUL et al., 2015), que condicionam
a função Q ao vetor do objetivo, e por repetição retrospectiva de experiências
(_Hindsight Experience Replay_ – HER) (ANDRYCHOWICZ et al., 2017), que reutiliza
transições fracassadas como experiências de sucesso com objetivos redefinidos.

=== Transferência da Simulação para o Robô Real

A transferência do simulador para o robô real (_sim-to-real transfer_) é um
desafio central na robótica. Trabalhos recentes empregam _domain randomization_
(TOBIN et al., 2017) para reduzir o _gap_ entre simulação e realidade, e abordagens de aprendizado por
reforço robusto que generalizam para diferentes condições de operação. A
plataforma LAFVIN Raspberry Pi Smart Car tem sido utilizada como benchmark de
baixo custo para validação de agentes treinados em simulação (LAFVIN, 2023).

== Autoencoders como Extratores de Estado em Aprendizado por Reforço

=== Autoencoders Profundos para Compactação de Estados

Autoencoders profundos foram aplicados à compactação de estados em RL para
reduzir a dimensionalidade das representações de entrada. Lange e Riedmiller
(2010) demonstraram que codificações aprendidas de forma não supervisionada por
um autoencoder profundo, a partir de imagens brutas, permitem aprender políticas
de navegação em um _gridworld_ visual, desde que a informação relevante para a
decisão seja preservada no espaço latente.

=== Modelos de Mundo Baseados em Autoencoders

Modelos de mundo (_world models_) utilizam autoencoders para aprender dinâmicas
latentes do ambiente, permitindo planejamento no espaço latente (HA; SCHMIDHUBER,
2018). Essa abordagem foi adaptada para RL, onde o agente planeja trajetórias no
espaço latente antes de executá-las no ambiente real.

=== Treinamento Conjunto de Autoencoder e Agente

O treinamento conjunto (_joint training_) do autoencoder e do agente RL permite
que a representação aprendida seja otimizada diretamente para a tarefa de
decisão, em vez de apenas para reconstrução. Essa abordagem, porém, exige
mecanismos cuidadosos para evitar que o autoencoder colapse para representações
triviais.

== Arquiteturas Neurais Adaptativas e Construtivas

=== Redes que Crescem Durante o Treinamento

Redes que crescem durante o treinamento, como _Cascade-Correlation_ (FAHLMAN;
LEBIERE, 1990) e _Dynamic Node Creation_ (ASH, 1989), adicionam
neurônios ou camadas quando o erro de treinamento estagna, reduzindo o custo
computacional em relação a redes de tamanho fixo superdimensionado.

=== Evolução de Topologias em Problemas de Controle

Algoritmos evolutivos foram aplicados à evolução de topologias de redes neurais
para problemas de controle (_NEAT_ – STANLEY; MIIKKULAINEN, 2002), demonstrando que a
busca por arquiteturas pode produzir redes mais eficientes do que o
dimensionamento manual. No contexto de RL, o crescimento de topologia durante
o treinamento oferece uma alternativa complementar.

=== Inserção de Camadas com Preservação do Conhecimento

O mecanismo de inserção de camadas com congelamento de parâmetros anteriores
foi inicialmente proposto no contexto de redes construtivas para aprendizado
supervisionado e posteriormente adaptado ao DRL. A preservação do conhecimento
aprendido é essencial para evitar o esquecimento catastrófico ao expandir a
arquitetura.

=== Inserção de Camadas em Stacked Autoencoders: Antecedentes da Tese de Doutorado

Viana et al. (2025) propuseram um método de inserção de camadas em redes
_Stacked Autoencoder_ baseado em ramificações paralelas, onde cada nova
ramificação é inicializada com pesos nulos e conectada por uma ligação residual.
O critério de inserção utiliza a variância da perda ao longo de uma janela de
episódios para detectar estagnação. Esta estratégia foi adaptada ao contexto de
DQN e avaliada em ambientes labirínticos.

== Síntese Comparativa e Lacunas Identificadas

A literatura apresenta avanços significativos em cada um dos componentes
individuais: DRL para navegação, autoencoders para extração de estado, redes
construtivas para otimização de topologia. Contudo, a integração desses três
componentes em um framework único, com validação sistemática por ablação fatorial
e teste em plataforma robótica real, é menos explorada. Este trabalho busca
preencher essa lacuna ao combinar DQN com Stacked Autoencoder e inserção
progressiva de camadas, comparado de forma pareada a linhas de base de
arquitetura fixa em múltiplos ambientes e representações de estado.
