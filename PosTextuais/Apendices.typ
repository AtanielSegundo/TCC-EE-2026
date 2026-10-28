// =============================================================================
// APÊNDICES
// Estrutura conforme summary.txt: A, B, C
// =============================================================================

#import "../config/settings.typ": *

#set par(
  justify: true,
  first-line-indent: 1.25cm,
  leading: 1.01em,
  spacing: 1.01em,
)

// ── Numeração dos apêndices: A, B, C (subseções A.1, A.2, ...) ───────────────
#counter(heading).update(0)
#set heading(numbering: "A.1")

#show heading.where(level: 1): it => {
  set par(first-line-indent: 0pt, justify: false, leading: 0.75em)
  block(above: 1.45em, below: 0.85em)[
    #text(size: 12pt, weight: "bold")[APÊNDICE #counter(heading).display("A") – #upper(it.body)]
  ]
}

// =============================================================================
// APÊNDICE A
// =============================================================================

= Hiperparâmetros Completos dos Agentes

Esta seção apresenta os hiperparâmetros completos utilizados em cada configuração
do estudo fatorial de ablação refinado. Os valores reportados correspondem aos
hiperparâmetros globais fixos (apresentados na Tab. X do Cap. 4) acrescidos dos
parâmetros específicos por configuração.

#table(
  columns: 6,
  align: (left, center, center, center, center, center),
  stroke: none,
  inset: (x: 5pt, y: 4pt),
  table.hline(stroke: 0.8pt),
  [*Configuração*], [*$alpha$*], [*$alpha_"branch"$*], [*$gamma$*], [*$epsilon_0$*], [*$tau$*],
  table.hline(stroke: 0.5pt),
  [C001], [$1 times 10^(-5)$], [$5 times 10^(-5)$], [0,999], [1,0], [0,005],
  [C002], [$1 times 10^(-5)$], [$5 times 10^(-5)$], [0,999], [1,0], [0,005],
  // ... demais configurações
  table.hline(stroke: 0.8pt),
) <tab-apend-a>

== Nota sobre Variabilidade por Configuração

Cada configuração fatorial pode variar os seguintes hiperparâmetros em relação
ao valor global: largura da camada oculta (controlada pelo fator $Delta$),
função de ativação oculta (ReLU, Tanh ou Sigmoide), tipo de mutação (Normal,
Out ou Hidden), método de inserção (CNT, CRT, DRT ou ALT) e modo de operação
da camada (M1 a M4).

// =============================================================================
// APÊNDICE B
// =============================================================================

= Labirintos Utilizados nos Experimentos

Esta seção apresenta as representações matriciais dos três labirintos utilizados
nos experimentos: pequeno (10#sym.times#h(1pt)12), médio (15#sym.times#h(1pt)25)
e grande (30#sym.times#h(1pt)30).

== Labirinto Pequeno (`small_eg`)

Dimensões: 10 #sym.times 12 células \
Células navegáveis: 54 / 120 \
Paredes: 66 \
Passos máximos: 208

#text(size: 10pt)[
  (Representação matricial: 0 = espaço livre, 1 = parede, 2 = origem, 3 = destino)

  // Matriz 10x12 do labirinto pequeno
  [0 0 0 0 0 0 0 0 0 0 0 0]
  [0 2 1 1 1 0 1 1 1 1 1 0]
  [0 0 0 0 1 0 1 0 0 0 1 0]
  ...
] <apend-b-small>

== Labirinto Médio (`medium_eg`)

Dimensões: 15 #sym.times 25 células \
Células navegáveis: 215 / 375 \
Paredes: 160 \
Passos máximos: 852

#text(size: 10pt)[
  // Matriz 15x25 do labirinto médio
  ...
] <apend-b-medium>

== Labirinto Grande (`big_eg`)

Dimensões: 30 #sym.times 30 células \
Células navegáveis: 482 / 900 \
Paredes: 418 \
Passos máximos: 1920

#text(size: 10pt)[
  // Matriz 30x30 do labirinto grande
  ...
] <apend-b-large>

// =============================================================================
// APÊNDICE C
// =============================================================================

= Códigos-Fonte Principais

Esta seção apresenta os trechos de código principais da implementação da
estratégia SAECollabNet. O código-fonte completo está disponível no repositório
público (SEGUNDO, 2026).

== Classe SAECollabDDQN

#sem-recuo[
#set text(size: 10pt)
#set par(justify: false, leading: 0.6em, spacing: 0.6em)
```python
class SAECollabDDQN(torch.nn.Module):
    """Agente DDQN com Stacked Autoencoder e inserção de camadas."""

    def __init__(self, state_dim, action_dim, hidden_width=400,
                 extra_width=20, activation=torch.relu):
        super().__init__()
        self.state_dim = state_dim
        self.action_dim = action_dim
        self.hidden_width = hidden_width
        self.extra_width = extra_width
        self.activation = activation
        self.branches = []
        self.frozen_branches = []
        self.branch_lr = 5e-5
        self.insertion_count = 0
        self.max_layers = 16
        self.loss_window = []
        self.window_size = 20
        self.min_targets = 5
        self.var_threshold = 0.6
        ...
```
] <apend-c-sae>

== Mecanismo de Inserção

#sem-recuo[
#set text(size: 10pt)
#set par(justify: false, leading: 0.6em, spacing: 0.6em)
```python
def check_and_insert_branch(self, td_loss, targets_reached):
    """Verifica critério de inserção e aciona nova ramificação."""
    self.loss_window.append(td_loss)
    if len(self.loss_window) > self.window_size:
        self.loss_window.pop(0)

    if len(self.loss_window) < self.window_size:
        return False

    variance = np.var(self.loss_window)
    if (variance < self.var_threshold and
        len(self.frozen_branches) > 0 and
        targets_reached >= self.min_targets):
        # Verifica se já inseriu na janela
        return self._insert_new_branch()
    return False
```
] <apend-c-insert>

== Função de Reward Shaping (PBRS)

#sem-recuo[
#set text(size: 10pt)
#set par(justify: false, leading: 0.6em, spacing: 0.6em)
```python
def compute_reward_shaping(r, s, s_prime, gamma, phi):
    """Potential-Based Reward Shaping (Ng; Harada; Russell, 1999)."""
    return r + gamma * phi(s_prime) - phi(s)

def manhattan_potential(s, goal, d_max):
    """Potencial baseado em distância de Manhattan."""
    return -np.manhattan_distance(s, goal) / d_max
```
] <apend-c-pbrs>
