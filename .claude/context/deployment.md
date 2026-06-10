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

## Recupero e rotazione dell'accesso SSH

L'accesso amministrativo alla VM passa per una chiave SSH ed25519 protetta da passphrase, riferita dall'alias `oracle-vaultwarden` nella configurazione SSH locale. La chiave privata vive fuori dalla cartella di progetto, sotto la directory `.ssh` dell'utente, cosi che un eventuale backup della cartella su supporto removibile non la includa; la sua unica copia di riserva e dentro il bundle cifrato `secrets-bundle.7z`. Essendo protetta da passphrase, il file in se non e un segreto in chiaro, ma resta tenuto fuori dal perimetro di backup per principio di minima esposizione.

Il recupero dell'accesso da una nuova macchina, quando quella attuale non e piu disponibile, segue tre livelli. Nel caso ordinario, con il bundle a disposizione, si estrae la chiave privata dal bundle con la sua passphrase, la si colloca sotto `.ssh`, se ne restringe l'ACL alla sola lettura dell'utente, si ricrea la voce di configurazione dell'alias e ci si collega digitando la passphrase della chiave. Sono coinvolte due passphrase distinte, quella del bundle e quella della chiave, entrambe custodite nell'Excel cifrato. Nel caso in cui si voglia ruotare la chiave, perche la vecchia macchina non e piu fidata, si genera una nuova coppia, si aggiunge la nuova chiave pubblica al file delle chiavi autorizzate sulla VM mentre si dispone ancora di un accesso valido, si rimuove la vecchia voce e si aggiorna il bundle. Nel caso estremo di perdita totale di chiave e bundle, l'accesso si rigenera dalla console di Oracle Cloud, che resta la radice di fiducia protetta dalle credenziali dell'account custodite anch'esse nell'Excel: si crea una connessione alla console seriale dell'istanza fornendo una chiave pubblica generata al momento, ci si collega e da li si aggiunge una nuova chiave pubblica al file delle chiavi autorizzate dell'utente di sistema. I passaggi puntuali della console seriale vanno seguiti dalla documentazione Oracle corrente, che ne e la fonte autorevole.
