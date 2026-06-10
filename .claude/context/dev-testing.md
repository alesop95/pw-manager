---
generated-from-commit: fd6a6cb
generated-from-branch: main
generated-date: 2026-06-10
covers-paths:
  - scripts/status.sh
last-verified-commit: fd6a6cb
---

# Verifiche e test

## Test runner e comandi

Il progetto e infrastrutturale e non ha una suite di test automatici ne un test runner: la correttezza si verifica osservando il comportamento dello stack a runtime. Lo strumento di verifica principale e `scripts/status.sh`, un health-check che riepiloga lo stato dei container, l'occupazione del disco e della memoria, la data di scadenza del certificato TLS interrogando direttamente la porta sicura, la risoluzione DNS dell'hostname e i tre backup piu recenti sul remote. Va eseguito sulla VM dopo ogni intervento significativo e periodicamente come controllo di routine.

## Rotte e dati mockati

Non esistono ambienti mockati ne fixture: le verifiche avvengono contro l'istanza reale di produzione, con la cautela che cio comporta. Le prove distruttive, come un restore test, si conducono su copie temporanee del database e mai sovrascrivendo il `db.sqlite3` in esercizio.

## Hook e controlli di qualita

Non sono configurati hook di pre-commit ne controlli automatici di lint o build, coerentemente con la natura del progetto. La checklist operativa delle verifiche manuali, comprese le prove di restore e di resilienza al riavvio, e mantenuta privata in `_notes/TEST-CHECKLIST.md`.
