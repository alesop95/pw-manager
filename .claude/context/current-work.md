---
generated-from-commit: fd6a6cb
generated-from-branch: main
generated-date: 2026-06-10
covers-paths:
  - .claude/**
last-verified-commit: fd6a6cb
stato: in corso
---

# Lavoro attuale

## Feature: Allineamento allo standard di progetto e migrazione dei TOTP

Cosa fa: porta il progetto sotto il sistema di contesto, documentazione e version control descritto in `.claude/PROJECT-SYSTEM.md`, rendendone lo stato recuperabile da un clone, e prepara la successiva migrazione dei codici TOTP da Google Authenticator a Ente Auth.

File da creare:
  .claude/PROJECT-SYSTEM.md           sorgente di verita del sistema (importato)
  .claude/rules/                      regole di identita git e stile (importate)
  .claude/skills/                     skill di init, sync, git-sync, repo-status (importate)
  .claude/settings.json               permessi condivisi
  .claude/memory/                     index, progress, decisions
  .claude/context/                    sei schede tecniche
  .claude/context/diagrams/           diagrammi sorgente Mermaid
  CLAUDE.md, CLAUDE.local.md          indice e override personali
  _notes/DIARIO.md, RESOCONTO.md, TEST-CHECKLIST.md   materiale privato

File da modificare:
  .gitignore                          aggiunta di CLAUDE.local.md, settings.local.json, *.docx, .tmp-docx-*/

Definition of done:
  - [x] file standard importati senza sovrascrivere l'esistente
  - [x] memoria ricostruita dalla storia dei commit e dagli interventi manuali
  - [x] sei schede istanziate, sanitizzate e ancorate a fd6a6cb
  - [x] diagrammi sorgente creati in diagrams/
  - [x] .gitignore integrato
  - [ ] primo commit della cartella .claude eseguito a mano
  - [ ] codici TOTP migrati da Google Authenticator a Ente Auth
  - [ ] vault popolato con le credenziali

Domande aperte:
  La dismissione di Samsung Pass va valutata con cautela per non interrompere l'autofill sul telefono prima che Bitwarden ed Ente siano pienamente operativi; resta da decidere quale unica password debba permanere in Samsung Pass.

## Riconciliazione
Ultima verifica: 2026-06-10 al commit fd6a6cb.
