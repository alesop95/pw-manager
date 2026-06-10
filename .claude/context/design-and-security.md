---
generated-from-commit: fd6a6cb
generated-from-branch: main
generated-date: 2026-06-10
covers-paths:
  - docker-compose.yml
  - Caddyfile
  - .gitignore
  - scripts/**
  - .claude/context/diagrams/**
last-verified-commit: fd6a6cb
---

# Design e sicurezza

## Paradigmi di software design

L'architettura e stratificata in tre regioni nettamente separate. Il livello client riunisce i dispositivi che consumano il vault, ciascuno configurato in modalita self-hosted verso l'hostname dell'istanza. Il livello di edge e occupato da Caddy, unico punto di terminazione TLS e di esposizione verso l'esterno, affiancato dall'updater di DNS dinamico che ne mantiene raggiungibile l'indirizzo. Il livello backend ospita Vaultwarden e la sua base dati SQLite su volume dedicato. *Ente Auth* siede come infrastruttura TOTP indipendente, deliberatamente fuori dal perimetro del vault. La separazione delle responsabilita e netta: Caddy non conosce i segreti del vault, Vaultwarden non gestisce TLS, l'updater DNS non tocca i dati. Il contratto fra i servizi e ridotto al minimo, il solo inoltro HTTP interno fra proxy e backend.

## Sicurezza applicativa

Il modello e *zero-knowledge*: la chiave che cifra il vault e derivata localmente sul client a partire da email e master password, attraverso una funzione di derivazione iterata, e il server custodisce solo blob cifrati e un hash della master password, mai la master password in chiaro. Il secondo fattore di Vaultwarden e un TOTP il cui seme vive in Ente Auth, cosi che la compromissione del solo vault non basti ad autenticarsi. La superficie esposta e ristretta alla porta gestita da Caddy, che termina il TLS e ottiene i certificati via ACME; il traffico verso il backend resta interno alla rete di Compose. I segreti sono ripartiti su tre custodi distinti, descritti nel diagramma della mappa dei segreti, e nessun PIN bancario e mai memorizzato in forma digitale. L'igiene del version control completa il quadro applicativo: il `.gitignore` esclude `.env`, `vw-data/`, `secrets/`, i backup, le chiavi e l'intera documentazione privata, cosicche nessun segreto possa essere committato; la scansione lato GitHub con push protection e il presidio automatico. I backup sono cifrati a chiave pubblica con age e la chiave privata resta offline.

## Diagrammi

| Diagramma | Sorgente | Componenti rappresentati |
|---|---|---|
| Architettura a tre livelli | `diagrams/architecture.mmd`, `assets/stack-architecture.svg` | client, Caddy, updater DNS, Vaultwarden, SQLite, Ente Auth |
| Catena di derivazione zero-knowledge | `diagrams/zero-knowledge.mmd` | email e master password, derivazione, master key, vault cifrato |
| Mappa dei segreti e custodi | `diagrams/secrets-map.mmd` | Vaultwarden, Ente Auth, custodia offline, dipendenze |
| Flusso di backup e disaster recovery | `diagrams/backup-flow.mmd` | sqlite backup, cifratura age, Object Storage, restore |
| Sequenza di avvio della VM | `diagrams/boot-sequence.mmd` | Docker, updater DNS, deSEC, Caddy, ACME, Vaultwarden |
| Migrazione dei TOTP | `diagrams/totp-migration.mmd` | Google Authenticator, Ente Auth, dismissione progressiva |
