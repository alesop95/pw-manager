# pw-manager

> Istruzioni di team, versionate. Questo file e l'indice del progetto: rimanda solo ai file satellite tracciati e descrive la procedura di ripresa di una sessione. Le preferenze personali vivono in `CLAUDE.local.md`, ignorato da git.

## Cos'e questo progetto

Stack self-hosted per la gestione di password e secondo fattore: un server *Vaultwarden* compatibile con le API Bitwarden, esposto da un reverse proxy *Caddy* con TLS automatico, raggiungibile tramite DNS dinamico *deSEC*, affiancato da *Ente Auth* come authenticator TOTP indipendente. L'hosting e una macchina Oracle Cloud Always Free; i backup cifrati del database finiscono su Oracle Object Storage. Il repository e pubblico ma versiona soltanto gli artefatti di deployment; la documentazione tecnica con i valori reali resta locale in `_notes/`.

## Procedura di ripresa in una sessione nuova

Lo stato del progetto e interamente recuperabile su disco. All'inizio di una sessione si legge per primo `.claude/memory/index.md`, che fotografa il commit di riferimento e lo stato di verifica delle schede. Se esiste una feature attiva, si legge `.claude/context/current-work.md`. Si invoca quindi la skill `sync-context` per misurare la deriva delle schede rispetto a HEAD e si leggono solo le schede pertinenti al compito, mai tutte insieme. La storia delle decisioni e dei passi si consulta in `.claude/memory/decisions.md` e `.claude/memory/progress.md`.

## Indice dei file satellite tracciati

Memoria e meta-stato, sotto `.claude/memory/`, letti sempre a inizio sessione.

```
.claude/memory/index.md       snapshot e tabella di sincronizzazione, da leggere per primo
.claude/memory/progress.md    work-log append-only di passi e riconciliazioni
.claude/memory/decisions.md   registro ADR-lite delle decisioni architetturali
```

Schede tecniche, sotto `.claude/context/`, con frontmatter di riconciliazione ancorato ai commit.

```
.claude/context/STACK.md                stack, flussi di codice, ruolo architetturale dei file
.claude/context/design-and-security.md  paradigmi di design e sicurezza applicativa, diagrammi
.claude/context/deployment.md           livelli, hosting, comandi, variabili d'ambiente
.claude/context/dev-testing.md          verifiche operative e health-check
.claude/context/current-work.md         feature attiva, definition of done, domande aperte
.claude/context/roadmap.md              direzione e priorita
```

I diagrammi sorgente in formato Mermaid sono sotto `.claude/context/diagrams/`. Le regole modulari sono sotto `.claude/rules/` e le skill richiamabili sotto `.claude/skills/`. Lo standard di sistema completo e in `.claude/PROJECT-SYSTEM.md`.

## Vincoli di team

Le operazioni git restano manuali: l'agente prepara i file e fornisce i comandi, ma non esegue mai `git add`, `commit` o `push`. L'identita git e impostata a livello locale del repository, con l'identita personale, e non va portata a livello globale. Lo stile della documentazione segue `.claude/rules/interaction-style.md`. L'agente non scrive in `memory/` e `context/` di propria iniziativa: gli aggiornamenti avvengono su richiesta esplicita, a tutela del controllo umano sul versionamento. Nessun valore segreto, ne identificativo d'istanza reale (hostname, indirizzo IP pubblico, namespace), compare nei file tracciati.
