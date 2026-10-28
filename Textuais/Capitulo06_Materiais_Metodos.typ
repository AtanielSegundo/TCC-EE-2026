// =============================================================================
// CAPÍTULO 6 · MATERIAIS E MÉTODOS
// Adaptado do main.typ: "Plataforma Robótica e Integração" + "Metodologia Detalhada"
// Estrutura conforme summary.txt: Seções 6.0 a 6.5
// =============================================================================

#import "../config/settings.typ": *

= Materiais e Métodos

== Arquitetura do Sistema

A validação em ambiente real foi construída sobre um orquestrador que integra o
kart físico LAFVIN, o simulador CoppeliaSim (ROHMER; SINGH; FREESE, 2013) e um
planejador de caminhos. O labirinto é discretizado em células quadradas de 30 cm
de lado, dimensão que assegura folga de 2 cm por lado em relação ao maior
diâmetro do kart, de 26 cm, permitindo que ele gire livremente dentro de uma
célula. O orquestrador espelha a telemetria do kart real no modelo
tridimensional em tempo real, apresenta uma interface gráfica de operação em
_raylib_ e executa o planejamento célula a célula. O deslocamento entre células
é decomposto em segmentos de rotação em torno do próprio eixo, servocontrolados
pela malha de direção realimentada pelo MPU6050, e segmentos retilíneos,
servocontrolados pela malha de posição realimentada pela odometria.

A separação das duas malhas decorre da configuração _skid-steer_: em linha reta
a odometria é confiável, mas na rotação o arrasto lateral das rodas invalida a
estimativa de ângulo derivada das contagens dos encoders, o que exige uma
referência angular independente.

== LAFVIN Pi Kart

A plataforma física é construída sobre o kart LAFVIN Raspberry Pi Smart Car
(LAFVIN, 2023), com um Raspberry Pi 3B+ executando Raspberry Pi OS (RASPBERRY
PI, 2026) como computador de bordo.

=== Modificações dos Motores e Encoders

Em relação ao modelo de fábrica, foram realizadas as seguintes modificações:
substituição dos motores TT originais por motores TT _Full Metal_ com encoder e
redução 1:45; remoção do display OLED e instalação, em seu lugar, de uma
unidade inercial MPU6050 para medição de ângulo; e deslocamento do servo de
_pan_ da câmera do canal 1 para o canal 5 do controlador PCA9685.

As rodas omnidirecionais inicialmente previstas foram descartadas na montagem
final. As unidades disponíveis possuíam roletes de superfície lisa, cuja
aderência ao piso do ambiente de ensaio mostrou-se insuficiente para sustentar o
acionamento em malha fechada: o escorregamento sob aceleração corrompe a
odometria por encoders, única realimentação de posição do sistema. Optou-se,
portanto, por rodas emborrachadas em configuração _skid-steer_, que preservam a
confiabilidade da odometria em linha reta ao custo de arrasto lateral nas
rotações.

=== Rodas Skid-Steer

A configuração _skid-steer_ trata as duas rodas de cada lado como uma roda
virtual, de modo que a plataforma de quatro rodas é controlada como um
acionamento diferencial. A decodificação em quadratura dos quatro encoders é
feita por quatro transições por período pelo daemon `pigpio`, escrito em C, com
filtro de _glitch_ de 100 #sym.mu\s por fase.

=== Unidade Inercial

A unidade inercial MPU6050 foi instalada no lugar do display OLED de fábrica e
fornece medição de ângulo para a malha de direção. A amostragem do MPU6050 é
realizada a 50 Hz, enquanto a taxa da malha de controle é de 20 Hz.

== Calibração

=== Calibração do Encoder por Revolução

A contagem de pulsos por revolução foi determinada a partir da especificação do
encoder Hall AB de 13 fios e da redução 1:45 do motor, resultando em 2.340
contagens por volta da roda. O diâmetro efetivo da roda é de 65 mm e o torque
nominal é de 1,2 kgf#sym.dot\cm, com rotação após redução de 355 rpm sob
tensão nominal de 6 V.

=== Calibração de Concordância entre Motores

A caracterização experimental do acionamento produziu a curva de conversão entre
ciclo de trabalho do PWM e velocidade linear. O ajuste linear sobre a faixa de
1.000 a 3.500 resultou em:

$
v = "4,569" times 10^(-4) dot "PWM" + "0,0609",
$

com $R^2 = "0,937"$. O ponto correspondente ao ciclo máximo de 4.095 foi
excluído do ajuste por apresentar velocidade inferior à obtida em 3.500,
indicando saturação do conjunto motor-bateria acima desse patamar.

A dispersão entre repetições cresce nos patamares intermediários: 0,142 m/s de
desvio-padrão em PWM 1.500 e 0,114 m/s em PWM 2.500, contra 0,001 m/s em PWM
3.500, comportamento compatível com escorregamento de rodas e com a variação de
tensão da bateria ao longo dos ensaios.

== Ganhos PID

=== Controle de Distância Linear

O PID de posição utiliza ganhos $k_p = 10.000$, $k_i = 2.000$, $k_d = 1.000$,
com tolerância de 1 cm. A pré-alimentação é de 2.600 e a saturação de PWM é
$plus.minus 4095$.

=== Controle de Heading

O PID de direção utiliza ganhos $k_p = 4.200$, $k_i = 2.000$, $k_d = 3.200$,
com tolerância de 0,5#sym.degree.

=== Modelo da Planta

O modelo da planta foi identificado experimentalmente por acionamento do kart
por intervalos fixos de 2 segundos e medição da distância percorrida, com cada
ponto repetido três vezes e a velocidade média obtida por regressão linear,
conforme o modelo $v = K dot "PWM" + v_0$.

=== CMA-ES Adaptado para Ajuste Automático de Ganhos PID

O algoritmo CMA-ES (_Covariance Matrix Adaptation Evolution Strategy_) foi
adaptado para o ajuste automático dos ganhos PID, buscando otimizar o conjunto
de parâmetros que minimiza o erro de rastreamento de trajetórias de referência.

== Odometria Diferencial

A odometria diferencial é calculada a partir das contagens dos encoders das duas
rodas virtuais. O esquema de discretização do ambiente utiliza células
quadradas de 30 cm de lado, que correspondem a aproximadamente 1,88
diâmetros efetivos da roda por célula.

A integração de odometria foi verificada comparada ao arco analítico
$R = v \/ omega$, onde $v$ é a velocidade linear e $omega$ a velocidade
angular medida pelo MPU6050. A camada independente de hardware foi verificada
por 28 testes unitários executáveis fora do Raspberry Pi, cobrindo anti-_windup_
do PID, ida e volta da cinemática direta e inversa, integração de odometria
comparada ao arco analítico, decodificação de sentido dos encoders e roteamento
do protocolo.

== Scheduler API REST, WebSockets e Telemetria

A camada independente de hardware comunica-se com o orquestrador por meio de um
scheduler que integra uma API REST para envio de comandos e WebSockets para
transmissão de telemetria em tempo real. A pilha de controle embarcada foi
reescrita para separar a lógica pura do hardware, permitindo que toda a
matemática de controle seja verificada fora do Raspberry Pi.

#tabela(
  [Parâmetros da plataforma robótica e da pilha de controle],
  [Elaborada pelo autor (2026), a partir de LAFVIN (2023) e da implementação.],
)[
  #tab(
    (auto, auto, auto, auto),
    table.hline(stroke: 0.8pt),
    [*Parâmetro*], [*Valor*], [*Parâmetro*], [*Valor*],
    table.hline(stroke: 0.5pt),
    [Diâmetro efetivo da roda], [65 mm], [Entre-eixos lateral], [151 mm],
    [Contagens por volta], [2340], [Redução do motor], [1:45],
    [Encoder], [Hall AB, 13 fios], [Tensão nominal], [6 V],
    [Torque nominal], [1,2 kgf#sym.dot\cm], [Rotação após redução], [355 rpm],
    [Taxa da malha], [20 Hz], [Amostragem do MPU6050], [50 Hz],
    [PID de velocidade], [$k_p$ 900; $k_i$ 1200; $k_d$ 20], [Pré-alimentação], [2600],
    [PID de posição], [$k_p$ 10000; $k_i$ 2000; $k_d$ 1000], [Tolerância], [1 cm],
    [PID de direção], [$k_p$ 4200; $k_i$ 2000; $k_d$ 3200], [Tolerância], [0,5#sym.degree],
    [Saturação de PWM], [$plus.minus$ 4095], [Lado da célula], [30 cm],
    table.hline(stroke: 0.8pt),
  )
] <tab-plataforma>
