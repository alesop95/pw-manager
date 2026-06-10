---
generated-from-commit: fd6a6cb
generated-from-branch: main
generated-date: 2026-06-10
covers-paths:
  - docker-compose.yml
  - Caddyfile
  - scripts/**
  - .env.example
last-verified-commit: fd6a6cb
---

# Stack

## Stack e runtime

Il sistema e un'orchestrazione *Docker Compose* di tre servizi a lunga vita, dichiarati in `docker-compose.yml`, ciascuno con `restart: unless-stopped` e con i log limitati a `max-size 10m` su `max-file 3`. Il primo servizio e *Vaultwarden*, reimplementazione in Rust del server Bitwarden, che espone le API del vault sulla porta interna ottanta e persiste l'intera base dati nel volume `vw-data/`, dove vive il file *SQLite* `db.sqlite3` con il vault cifrato e gli allegati. Il secondo e *Caddy*, reverse proxy che termina il TLS e inoltra in chiaro verso `vaultwarden:80` sulla rete interna di Compose; ottiene e rinnova i certificati via ACME contro Let's Encrypt. Il terzo e un updater di DNS dinamico costruito sull'immagine `curlimages/curl`, che in ciclo invoca l'endpoint di aggiornamento di *deSEC* per mantenere allineato il record A all'indirizzo pubblico corrente della VM.

Tutti i valori d'istanza sono iniettati da variabili d'ambiente lette dal file `.env` non versionato, di cui `.env.example` documenta lo schema: `VW_HOSTNAME` per l'hostname pubblico, `DESEC_TOKEN` per l'autenticazione presso deSEC, `ADMIN_TOKEN_HASH` per l'hash Argon2 del token della pagina di amministrazione, `SIGNUPS_ALLOWED` per consentire o bloccare le registrazioni.

## Alternative deliberatamente escluse

DuckDNS e stato valutato e scartato per irreperibilita del servizio durante il provisioning, a favore di deSEC. L'istanza A1.Flex ARM Always Free e stata abbandonata per indisponibilita capacitiva persistente, ripiegando su uno shape x86. Come destinazione dei backup e stato escluso MEGA, per non conservare credenziali di terze parti sulla VM, a favore di Oracle Object Storage con autenticazione instance principal. La build di rclone dei repository Ubuntu e stata scartata perche priva del backend Object Storage, in favore della build ufficiale.

## Flussi di codice e ruolo architetturale dei file

Il file `docker-compose.yml` e il manifesto centrale: descrive i tre servizi, le rispettive variabili d'ambiente, i volumi e le politiche di riavvio e di logging. Il `Caddyfile` contiene la sola direttiva di reverse proxy che lega l'hostname pubblico a `vaultwarden:80`, delegando a Caddy l'intera gestione del certificato. Gli script operativi vivono in `scripts/`: `vw-backup.sh` esegue una copia coerente del database con `sqlite3 .backup`, la cifra con age verso un destinatario a chiave pubblica, la carica su Object Storage con rclone e applica la retention; `status.sh` e l'health-check riepilogativo che ispeziona container, disco, memoria, scadenza del certificato, risoluzione DNS e ultimi backup. Entrambi leggono i valori reali da `scripts/vw.conf`, non versionato, di cui `scripts/vw.conf.example` e il modello.

## Riferimenti a snippet

`docker-compose.yml:services` per la definizione dei tre servizi e delle loro variabili. `Caddyfile` per la direttiva `reverse_proxy`. `scripts/vw-backup.sh` per la catena backup-cifratura-upload-retention. `scripts/status.sh` per la diagnostica. `scripts/vw.conf.example` per lo schema dei valori d'istanza.
