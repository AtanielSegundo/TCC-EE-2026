#import "../config/settings.typ":*
// =============================================================================
// ABSTRACT
// =============================================================================
#centro[#text(size: 12pt, weight: "bold")[ABSTRACT]]

#v(0.5cm)

#block[
#set par(leading: 0.92em, spacing: 0.92em)
_Deep Reinforcement Learning_ (DRL) has consolidated itself as one of the most
productive paradigms for building autonomous agents capable of learning complex
behaviors from interaction with the environment. However, training deep networks
is computationally intensive and energy-demanding, and continuous learning faces
the problem of catastrophic forgetting. Constructive architectural expansion
strategies address both problems: instead of training from scratch a large and
fixed topology, the network grows by inserting new modules, while already
consolidated parameters are frozen. This work investigated a constructive
strategy called SAECollabNet, inspired by the layer insertion proposal in
_Stacked Autoencoder_ networks and integrated with _Double Deep Q-Network_ (DDQN)
agents for autonomous navigation in labyrinthine environments. Navigation was
modeled as a Markov Decision Process, with agents trained in discrete mazes of
10#sym.times#h(1pt)12, 15#sym.times#h(1pt)25, and 30#sym.times#h(1pt)30 cells. Two refinements were
incorporated: Potential-Based Reward Shaping (PBRS) and Prioritized Experience
Replay (PER). A factorial ablation study compared the constructive architecture
with a static dense baseline under identical hyperparameters. Generalization was
evaluated with goal-conditioned formulation (UVFA) combined with Hindsight
Experience Replay (HER), and the strategy was validated on a real robotic
platform. Results demonstrate that, with densified reward, the constructive
strategy outperformed the baseline in success rate while employing 25.3% of
parameters and 69.0% of training time.

]

#v(0.5cm)

#block[
  #set par(justify: true, first-line-indent: 0pt, leading: 0.92em)
  *Keywords:* deep reinforcement learning. Topology optimization. Layer
  freezing. Constructive neural networks. Autonomous navigation.
]

#pagebreak()
