---
generated-from-commit: fd6a6cb
generated-from-branch: main
generated-date: 2026-06-10
covers-paths: []
last-verified-commit: fd6a6cb
---

# Roadmap

## Direzione

Portare il sistema dallo stato di stack funzionante e validato a quello di strumento d'uso quotidiano pienamente popolato, mantenendo la separazione dei segreti e la recuperabilita totale dello stato. Chiusa la messa in opera e l'allineamento documentale, il valore d'uso reale passa dalla migrazione del secondo fattore e dal popolamento del vault.

## Priorita

La prima priorita e l'accesso a Ente Auth dal telefono con il solo riconoscimento biometrico, senza salvare la master password, replicando il meccanismo gia adottato per l'app Bitwarden. Segue la migrazione progressiva dei codici TOTP da Google Authenticator a Ente Auth, per microstep e senza disattivare nulla finche il nuovo authenticator non e verificato, mantenendo temporaneamente Samsung Pass per non interrompere l'autofill. Terza priorita il popolamento del vault con le credenziali. In parallelo restano due attivita di consolidamento: l'archiviazione della chiave SSH privata dentro Vaultwarden e il completamento della configurazione del client Samsung S25, distinguendo l'unica password che deve permanere in Samsung Pass.

## Idee e ipotesi da verificare

Resta da verificare la modalita piu sicura di sblocco dell'autofill sul client desktop senza reinserire la master password, oltre al PIN dell'estensione gia adottato. Va inoltre confermato, e promosso a decisione solo dopo prova sul campo, se e quando disattivare Samsung Pass senza perdita di funzionalita.
