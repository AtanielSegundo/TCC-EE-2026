// =============================================================================
// CAPÍTULO 8 · CONCLUSÃO
// Adaptado do main.typ: seção "Conclusões"
// Estrutura conforme summary.txt: Seções 8.1 a 8.3
// =============================================================================

= Conclusão

== Considerações Finais

Este projeto investigou uma estratégia construtiva de otimização de topologia
para redes neurais em aprendizagem por reforço profundo, baseada no
congelamento seletivo de camadas densas previamente treinadas e na adição
progressiva de novas ramificações, percorrendo simulação, ablação fatorial em
larga escala, avaliação de generalização e construção de uma plataforma
robótica real.

O objetivo geral foi alcançado em duas de suas três dimensões. A otimização do
tempo de treinamento foi demonstrada: 69,0% do tempo da linha de base no
agregado de 1.440 configurações pareadas. A convergência para soluções de
qualidade equivalente foi demonstrada com folga: 38,10% de taxa de sucesso
contra 31,93% da referência estática, com 25,3% dos parâmetros, chegando a
75,00% contra 40,55% com 10,5% dos parâmetros sob a melhor representação de
estado, e razão de otimalidade unitária sempre que o objetivo é alcançado. A
reutilização de treinamentos em ambientes distintos, avaliada pela formulação
condicionada ao objetivo, ficou abaixo da linha de base densa (96,26% contra
98,94% dos pares origem–destino), ainda que com 24,0% dos parâmetros, e com
degradação crescente em função da distância.

Os oito objetivos específicos foram executados: ambientes labirínticos em três
escalas, com editor, treinador tabular e visualizador próprios; agentes
profundos nas variantes estática e construtiva; coleta sistemática de métricas
de desempenho, tempo e qualidade; integração da estratégia ao fluxo dos agentes
em três variantes de implementação; avaliação comparativa em estudo fatorial de
2.880 treinamentos; teste de generalização sobre todos os pares alcançáveis; e
testes em ambiente real sobre plataforma instrumentada, calibrada e integrada a
um espelho digital. Um desvio deve ser registrado neste último item: a
plataforma final é um acionamento diferencial _skid-steer_ com rodas
emborrachadas, e não omnidirecional como consta do objetivo cadastrado, por
insuficiência de aderência das rodas omnidirecionais disponíveis.

Três contribuições merecem destaque: a eficácia da estratégia construtiva
depende criticamente da densidade do sinal de recompensa, o que recomenda
projetar o critério de crescimento em conjunto com o desenho da recompensa; o
impasse circular entre critério de inserção e capacidade representacional
produz colapso completo do aprendizado em configurações específicas, o que
recomenda mecanismos de escape no gatilho de inserção; e o limite do
congelamento em tarefas multiobjetivo foi delimitado empiricamente em função da
distância entre origem e destino.

O impacto acadêmico do projeto materializou-se na publicação do artigo
_Topology Optimization in Neural Networks for Deep Reinforcement Learning_ na
série _Lecture Notes in Networks and Systems_ da Springer, apresentado na
WorldCIST'26 (SEGUNDO et al., 2026), e na disponibilização pública do código-fonte e dos dados
experimentais (SEGUNDO, 2026). Para o campus, o projeto consolidou uma linha de
investigação em aprendizagem por reforço e uma plataforma robótica reutilizável,
com pilha de controle documentada e verificada por testes, disponível para
projetos subsequentes de iniciação científica.

== Limitações

Duas limitações metodológicas devem ser registradas. A primeira é que o estudo
fatorial não foi concluído no labirinto de 30 #sym.times 30 células, cujo custo
computacional excedeu o horizonte do projeto, o que restringe as conclusões
quantitativas aos ambientes pequeno e médio. A segunda é que o uso de semente
única por configuração privilegiou a amplitude do espaço explorado sobre a
repetição, efeito atenuado, mas não eliminado, pela agregação sobre centenas de
configurações por nível de fator. A avaliação de generalização, por ser
pontual, empregou três sementes independentes.

Uma terceira limitação decorre do congelamento: em tarefas condicionadas ao
objetivo, as camadas congeladas convertem-se em gargalo representacional, o que
limita o desempenho do modelo construtivo quando o espaço de objetivos é
ampliado. A degradação progressiva com a distância entre origem e destino
evidencia esse limite fundamental.

== Trabalhos Futuros

Como desdobramentos, indicam-se: concluir o estudo fatorial no ambiente de
30 #sym.times 30 células; implementar critérios de inserção com mecanismo de
escape para contornar o impasse entre critério de inserção e capacidade
representacional; avaliar a estratégia sobre algoritmos de gradiente de política
(PPO, A2C), além dos métodos baseados em valor aqui investigados; e descongelar
seletivamente camadas iniciais em tarefas condicionadas ao objetivo, de modo a
aliviar o gargalo representacional identificado nos experimentos de generalização.

A plataforma robótica construída e instrumentada oferece uma base para
investigações subsequentes em navegação autônoma com agentes DRL, incluindo a
validação da estratégia construtiva em ambientes reais com obstáculos dinâmicos
e a avaliação de transferência _sim-to-real_ sob _domain randomization_ (TOBIN et al., 2017).
