---
generated-from-commit: fd6a6cb
generated-from-branch: main
generated-date: 2026-06-10
covers-paths:
  - docker-compose.yml
  - Caddyfile
  - .env.example
  - scripts/**
last-verified-commit: fd6a6cb
---

# Deployment

## Livelli

Esiste un solo livello di produzione: una macchina virtuale Oracle Cloud nel perimetro Always Free, in regione Frankfurt, con shape x86 a basse risorse. La macchina ospita il repository clonato sotto `/home/ubuntu/pw-manager`, affiancato dal file `.env` con i valori reali e da `scripts/vw.conf`. L'hostname pubblico e un sottodominio dinamico deSEC, mantenuto allineato all'indirizzo della VM dall'updater. Caddy espone il servizio in HTTPS e i client vi si collegano in modalita self-hosted. Non esistono ambienti di staging separati; le verifiche si fanno sull'istanza stessa con prudenza.

## Comandi

Il deploy si effettua da dentro la directory del progetto sulla VM portando su lo stack con Docker Compose, dopo aver popolato `.env`. L'aggiornamento dell'istanza consiste nel `git pull`, seguito dal ricreare i container; il rollback corrisponde al ritorno a un commit precedente e al nuovo avvio. Lo stato di salute si ispeziona con `scripts/status.sh`, che riepiloga container, disco, memoria, scadenza del certificato, DNS e ultimi backup. I container ripartono da soli dopo un riavvio della macchina grazie alla politica `restart: unless-stopped`, e il demone Docker e abilitato all'avvio. La prune periodica delle immagini inutilizzate e schedulata via cron per non saturare il disco.

## Variabili d'ambiente e segreti

Lo schema delle variabili e in `.env.example`; i valori reali vivono solo nel `.env` non versionato sulla VM. Le variabili richieste sono `VW_HOSTNAME` con l'hostname pubblico, `DESEC_TOKEN` con il token deSEC, `ADMIN_TOKEN_HASH` con l'hash Argon2 del token di amministrazione, `SIGNUPS_ALLOWED` per abilitare o bloccare le registrazioni. Gli script leggono i propri valori da `scripts/vw.conf`, modellato su `scripts/vw.conf.example`, che raccoglie il percorso del database, il destinatario age dei backup, il remote e il bucket rclone, i giorni di retention, il percorso della configurazione rclone e l'hostname. Nessuno di questi valori reali e mai committato: token, hash dell'admin token, chiave SSH e passphrase risiedono nel bundle cifrato e nell'Excel cifrato. L'autenticazione di rclone verso Object Storage avviene per instance principal, senza credenziali memorizzate sulla VM, e la chiave privata age di decifratura dei backup resta offline.
