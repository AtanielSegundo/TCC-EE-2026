// =============================================================================
// TCC · SAECollabNet · Arquivo Principal
// Estrutura modular: PreTextuais / Textuais / PosTextuais
// =============================================================================

#import "./config/settings.typ": *
#show: abnt

// =============================================================================
// ELEMENTOS PRÉ-TEXTUAIS
// =============================================================================
#include "./PreTextuais/Capa.typ"
#include "./PreTextuais/FolhaDeRosto.typ"
#include "./PreTextuais/FolhaDeAprovacao.typ"
#include "./PreTextuais/Agradecimentos.typ"
#include "./PreTextuais/Resumo.typ"
#include "./PreTextuais/Abstract.typ"
#include "./PreTextuais/Sumario.typ"

// =============================================================================
// ELEMENTOS TEXTUAIS
// =============================================================================
#pagebreak()
#include "./Textuais/Capitulo01_Introducao.typ"
#include "./Textuais/Capitulo02_Fundamentacao_Teorica.typ"
#include "./Textuais/Capitulo03_Trabalhos_Relacionados.typ"
#include "./Textuais/Capitulo04_Metodologia.typ"
// #include "./Textuais/Capitulo05_Resultados.typ"  // Futuro
#include "./Textuais/Capitulo06_Materiais_Metodos.typ"
#include "./Textuais/Capitulo07_Resultados_Disussao.typ"
#include "./Textuais/Capitulo08_Conclusao.typ"

// =============================================================================
// ELEMENTOS PÓS-TEXTUAIS
// =============================================================================
#pagebreak()
#include "./PosTextuais/Referencias.typ"

// #pagebreak()
// #include "./PosTextuais/Apendices.typ"