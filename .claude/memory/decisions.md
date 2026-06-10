# Registro delle decisioni architetturali

## ADR-001 — Adozione del sistema di progetto portabile

Data: 2026-06-10
Stato: accettata
Contesto: il progetto necessita di uno stato interamente recuperabile da un clone e di documentazione che resti allineata al codice senza rilettura integrale a ogni sessione.
Decisione: adottare il sistema descritto in `.claude/PROJECT-SYSTEM.md`, con motore di riconciliazione ancorato ai commit e doppio livello documentale tracciato/ignorato.
Motivazione: persistenza strutturale su disco indipendente dalla sessione di chat, e controllo umano sul versionamento.
Conseguenze: ogni passo significativo aggiorna schede, `last-verified-commit`, snapshot e work-log; commit e push restano manuali.

## ADR-002 — Stack self-hosted Vaultwarden con Caddy ed Ente Auth

Data: 2026-06-08
Stato: accettata
Contesto: serviva una soluzione di password management e secondo fattore sotto controllo diretto, a costo nullo, compatibile con i client Bitwarden esistenti.
Decisione: adottare Vaultwarden come server compatibile Bitwarden, Caddy come reverse proxy con TLS automatico, ed Ente Auth come authenticator TOTP separato dal vault.
Motivazione: Vaultwarden e leggero e copre le API Bitwarden; Caddy semplifica la terminazione TLS e l'ottenimento dei certificati; tenere i TOTP in Ente, fuori da Vaultwarden, evita che un'unica compromissione esponga sia la password sia il secondo fattore.
Conseguenze: secondo fattore di Vaultwarden custodito in Ente, con dipendenza esplicita tra i due sistemi gestita nella mappa dei segreti.

## ADR-003 — Repository pubblico ridotto ai soli artefatti di deployment

Data: 2026-06-08
Stato: accettata
Contesto: si voleva pubblicare il progetto senza esporre alcun segreto ne identificativo dell'istanza.
Decisione: rendere pubblico il repository ma versionare soltanto gli artefatti di deployment parametrizzati; tenere in locale, sotto `_notes/`, la documentazione tecnica con i valori reali.
Motivazione: massimizzare la riproducibilita e la condivisibilita senza che hostname, indirizzi, namespace o segreti finiscano nella storia pubblica.
Conseguenze: le schede tracciate sono sanitizzate a segnaposto; attivata la secret scanning con push protection lato GitHub.

## ADR-004 — Identita git personale impostata a livello locale

Data: 2026-06-08
Stato: accettata
Contesto: la macchina ospita sia l'identita di lavoro sia quella personale; il progetto e personale.
Decisione: impostare `user.name` e `user.email` personali a livello del solo repository, con `core.sshCommand` verso la chiave personale e remote tramite l'alias SSH `github-personal`.
Motivazione: evitare commit accidentali con l'email di lavoro; `user.useConfigOnly` globale e attivo come ulteriore protezione.
Conseguenze: ogni nuovo repository personale richiede l'impostazione esplicita dell'identita locale.

## ADR-005 — deSEC come DNS dinamico in sostituzione di DuckDNS

Data: 2026-06-08
Stato: accettata
Contesto: DuckDNS risultava irraggiungibile durante il provisioning, bloccando l'aggiornamento del record e quindi il rilascio del certificato.
Decisione: usare deSEC, aggiornando il record con un container che invoca periodicamente `update.dedyn.io` con token di autorizzazione.
Motivazione: servizio affidabile, gratuito e con API semplice via header di autorizzazione.
Conseguenze: variabili `DESEC_TOKEN` e `VW_HOSTNAME`; il token deSEC e un segreto custodito nel bundle cifrato.

## ADR-006 — Shape x86 in fallback all'A1.Flex ARM

Data: 2026-06-08
Stato: accettata
Contesto: l'istanza A1.Flex ARM Always Free risultava costantemente in out of capacity su tutti i fault domain di Frankfurt.
Decisione: ripiegare su VM.Standard.E2.1.Micro x86, anch'essa nel perimetro Always Free.
Motivazione: ottenere subito una macchina stabile senza attese indefinite di capacita.
Conseguenze: meno risorse rispetto all'A1; lo stack e dimensionato di conseguenza, con cap ai log e prune periodica per restare nel free tier.

## ADR-007 — Backup del solo database cifrato verso Object Storage

Data: 2026-06-08
Stato: accettata
Contesto: il free tier offre dieci gibibyte di Object Storage; un'immagine completa della VM eccederebbe il limite.
Decisione: effettuare il backup del solo `db.sqlite3`, cifrato a chiave pubblica con age, verso Oracle Object Storage tramite rclone autenticato con instance principal, con retention a trenta giorni.
Motivazione: il database e l'unico dato irriproducibile; il resto e ricostruibile da repository pubblico e dal `.env` custodito nel bundle. L'instance principal evita di conservare credenziali sulla VM. La chiave privata age resta offline.
Conseguenze: il ripristino richiede la chiave privata age, custodita fuori dalla VM; periodicamente va eseguito un restore test.

## ADR-008 — Separazione dei segreti su tre custodi

Data: 2026-06-08
Stato: accettata
Contesto: concentrare tutti i segreti in un unico contenitore renderebbe una sola compromissione catastrofica.
Decisione: ripartire i segreti tra Vaultwarden (password e dati di login), Ente Auth (semi TOTP, incluso quello del secondo fattore di Vaultwarden) e una custodia offline (codici di recupero, chiave privata age, master password e passphrase nell'Excel cifrato). Nessun PIN bancario viene mai memorizzato in forma digitale.
Motivazione: difesa in profondita; la compromissione di un custode non basta a ricostruire l'accesso completo.
Conseguenze: la mappa dei segreti documenta ogni elemento, il suo custode e le dipendenze; alcune scelte di co-locazione (recovery code nell'Excel) sono trade-off consapevoli annotati.

## ADR-009 — Sblocco dell'estensione Chrome tramite PIN locale

Data: 2026-06-08
Stato: accettata
Contesto: reinserire la master password a ogni autocompletamento e scomodo; serviva un compromesso tra usabilita e sicurezza sul client desktop.
Decisione: abilitare lo sblocco con PIN dell'estensione Chrome (Strada A), con il PIN valido solo per quella installazione del browser.
Motivazione: l'usabilita migliora senza esporre la master password; il PIN non sblocca nient'altro e resta locale al dispositivo.
Conseguenze: il PIN dell'estensione entra nella mappa dei segreti come elemento locale per-installazione; la master password resta necessaria per la riconfigurazione.
