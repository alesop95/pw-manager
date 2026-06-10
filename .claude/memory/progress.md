# Work-log

## 2026-06-10 — Chiave SSH spostata fuori dalla working tree

Commit: nessuno (intervento locale su `~/.ssh` e config SSH)
File toccati: `~/.ssh/id_ed25519_oracle` (copia blindata), `~/.ssh/config` (IdentityFile aggiornato); aggiunti il runbook di recupero in `deployment.md` e il diagramma `diagrams/local-backup.mmd`.
Motivo: la cartella `E:\pw-manager` viene copiata su SD privata come backup, e la copia del filesystem ignora il `.gitignore`. La chiave privata SSH risiedeva in `secrets/`; benche protetta da passphrase, e stata spostata sotto `.ssh` dell'utente per tenerla fuori dal perimetro del backup. In `secrets/` restano solo il `.pub` e il bundle cifrato. Connessione verificata interattivamente con esito positivo; originale rimosso da `secrets/` dopo presa di possesso (`takeown`), per cui la working tree e priva di chiavi private.

## 2026-06-10 — Adozione del sistema di progetto portabile

Commit: (da eseguire a mano; HEAD di riferimento fd6a6cb)
File toccati: importazione di `.claude/PROJECT-SYSTEM.md`, `.claude/rules/`, `.claude/skills/` e `.claude/settings.json`; istanziazione di `CLAUDE.md`, `CLAUDE.local.md`, `.claude/memory/` (index, progress, decisions), `.claude/context/` (sei schede) e `.claude/context/diagrams/`; aggiunta dei file privati `_notes/DIARIO.md`, `_notes/RESOCONTO.md`, `_notes/TEST-CHECKLIST.md`; integrazione del `.gitignore`.
Motivo: rendere lo stato del progetto interamente recuperabile da un clone e mantenere la documentazione allineata al codice tramite il motore di riconciliazione ancorato ai commit. Le schede sono state istanziate sanitizzate, con segnaposto al posto degli identificativi d'istanza, perche il repository e pubblico. La memoria e stata ricostruita dalla storia dei commit e dagli interventi manuali documentati, senza inventare.

## 2026-06-08 — Mappa dei segreti e sblocco dell'estensione Chrome

Commit: nessuno (configurazione lato client, non versionata)
File toccati: sezione 16 della documentazione tecnica privata.
Motivo: impostato il PIN locale di sblocco dell'estensione Chrome (Strada A) per evitare di reinserire la master password a ogni autocompletamento; il PIN vive solo nell'installazione del browser. Inventario completo dei segreti coinvolti, con segnaposto stampabili, distinguendo i tre custodi: Vaultwarden per le password, Ente Auth per i TOTP, custodia offline per i codici di recupero e la chiave privata age.

## 2026-06-08 — Validazione di disaster recovery e resilienza al riavvio

Commit: nessuno (interventi operativi sulla VM e sul client)
File toccati: `~/.ssh/config` locale, permessi della chiave ripristinata.
Motivo: dopo un riavvio della VM, l'accesso SSH falliva perche la chiave era stata rimossa dal disco locale tenendola solo nel bundle cifrato; ripristino dal bundle con `7z e`, poi correzione dei permessi Windows con `icacls`. Verificato che i container ripartono da soli grazie a `restart: unless-stopped`. Test di restore del database completato a partire dal `.age` scaricato da Object Storage.

## 2026-06-08 — fd6a6cb — Script operativi parametrici

Commit: fd6a6cb
File toccati: `scripts/vw-backup.sh`, `scripts/status.sh`, `scripts/vw.conf.example`.
Motivo: estratti i valori d'istanza in un file di configurazione esterno `vw.conf` (non versionato), in modo che gli script restino pubblicabili. `status.sh` funge da quick-start diagnostico; `vw-backup.sh` esegue backup cifrato con age e applica la retention.

## 2026-06-08 — 792fe5d — Igiene dello storage

Commit: 792fe5d
File toccati: `docker-compose.yml`.
Motivo: limitati i log dei container (`max-size 10m`, `max-file 3`) per non saturare il disco della VM entro il free tier; affiancata una prune periodica via cron.

## 2026-06-08 — 95445f0 — Passaggio a deSEC come DNS dinamico

Commit: 95445f0
File toccati: `docker-compose.yml`, `.env.example`.
Motivo: il servizio DuckDNS era irraggiungibile; sostituito il container con un updater basato su `curl` verso `update.dedyn.io` autenticato con token deSEC. Variabili `DESEC_TOKEN` e `VW_HOSTNAME` al posto delle chiavi DuckDNS. Risolto cosi anche il fallimento iniziale del rilascio del certificato Let's Encrypt, dovuto all'assenza di record A aggiornati.

## 2026-06-08 — 092ddce — Stack di deployment parametrizzato

Commit: 092ddce
File toccati: `docker-compose.yml`, `Caddyfile`, `.env.example`, `.gitignore`.
Motivo: definiti i tre servizi (vaultwarden, caddy, updater DNS) con valori da variabili d'ambiente; Caddyfile come reverse proxy con hostname parametrico; esclusi dal versionamento `secrets/`, chiavi SSH, screenshot e `_notes/`.

## 2026-06-08 — ed76b7d — Inizializzazione del version control

Commit: ed76b7d
File toccati: `.gitignore`, `.env.example`, diagramma `assets/stack-architecture.svg`.
Motivo: primo commit. Perimetro di pubblicazione ridotto ai soli artefatti di deployment; documentazione tecnica e materiali di partenza tenuti in locale; segreti esclusi (`.env`, `vw-data/`, `backups/`, volumi Caddy, token e chiavi). Attivata lato GitHub la secret scanning con push protection.

## Interventi infrastrutturali precedenti (non versionati)

Provisioning della VM su Oracle Cloud Always Free in regione Frankfurt, con shape VM.Standard.E2.1.Micro x86 scelto dopo l'indisponibilita capacitiva dell'A1.Flex ARM. Preparazione del sistema operativo e installazione di Docker. Creazione del dominio dinamico su deSEC. Deploy dello stack e ottenimento del certificato TLS. Creazione dell'account Vaultwarden con master password a sei parole e attivazione del secondo fattore TOTP. Configurazione di Ente Auth con blocco a livello di dispositivo e verifica via email. Installazione di rclone ufficiale (la build Ubuntu mancava del backend Object Storage) con autenticazione instance principal, e pianificazione dei backup e della prune via cron. Indurimento con fail2ban.
