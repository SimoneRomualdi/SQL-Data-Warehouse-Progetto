# SQL Data Warehouse & Analytics

Un'azienda con dati di vendita distribuiti tra due sistemi separati — CRM e ERP — non riesce ad avere una visione unica dei propri clienti e prodotti. Questo progetto costruisce l'infrastruttura che risolve quel problema: un data warehouse moderno in PostgreSQL che unifica le due sorgenti e le rende interrogabili per analisi di business.

---

## Il Problema di Business

Quando i dati vivono in silos separati, rispondere a domande semplici diventa complicato:
*"Chi sono i nostri clienti più redditizi?"* o *"Quali prodotti stanno performando meglio per categoria?"*

L'obiettivo era costruire una base dati affidabile, pulita e strutturata su cui costruire analisi concrete — non solo caricare dati, ma renderli utili.

---

## Cosa Ho Costruito

### Architettura a Tre Layer (Medallion)

I dati passano attraverso tre stadi di lavorazione progressiva:

**Bronze** — I dati grezzi vengono caricati as-is dai CSV sorgente (CRM + ERP), senza trasformazioni. È la fotografia fedele di quello che arriva dai sistemi.

**Silver** — Qui avviene la pulizia reale: duplicati rimossi, date inconsistenti corrette, codici normalizzati in valori leggibili (es. `"M"` → `"Male"`, `"S"` → `"Single"`), colonne derivate aggiunte. I dati diventano affidabili.

**Gold** — Il layer finale espone tre oggetti pronti per il business tramite views SQL: `dim_customer`, `dim_products` e `fact_sales_details` organizzati in Star Schema. Qualsiasi analisi parte da qui.

### Automazione con Stored Procedures

Il processo di caricamento Bronze → Silver è completamente automatizzato tramite stored procedures con logging integrato: ogni esecuzione registra quante righe sono state caricate per ogni tabella e in quanto tempo, con gestione centralizzata degli errori.

---

## Analisi Prodotte sul Gold Layer

Con la base dati pronta, ho sviluppato analisi che rispondono a domande concrete:

- **Quali categorie generano più fatturato?** → Analisi part-to-whole con contributo percentuale per categoria
- **Come stanno evolvendo le vendite nel tempo?** → Trend mensile e annuale con running totals cumulativi
- **Chi sono i clienti VIP?** → Segmentazione RFM-like basata su storico e valore (VIP / Regular / New)
- **Quali prodotti performano meglio rispetto alla media storica?** → Analisi Year-over-Year con LAG() per confronto annuale

---

## Cosa Ho Imparato

Il dato più interessante emerso durante la pulizia: le due sorgenti avevano logiche di codifica del genere diverse e parzialmente sovrapposte. Ho risolto dando priorità al CRM come sorgente di riferimento e usando ERP solo come fallback — una decisione di business che va documentata, non solo tecnica.

---

## Stack Tecnologico

- **PostgreSQL** — Database e logica ETL
- **SQL** — CTE, Window Functions, Stored Procedures, Star Schema

## Struttura della Repository

```
SQL-Data-Warehouse-Progetto/
├── datasets/               # Dataset sorgente (ERP, CRM)
│   ├── sorgente_crm/
│   └── sorgente_erp/
├── scripts/
│   ├── bronze/             # Caricamento dati grezzi
│   ├── silver/             # Pulizia e standardizzazione
│   └── gold/               # Views finali (Star Schema)
├── tests/                  # Script di controllo qualità
├── documentazione/         # Diagrammi e data catalog
└── README.md
```

---

## Stack Tecnologico

- **PostgreSQL** — Database e logica ETL
- **SQL** — CTE, Window Functions, Stored Procedures, Star Schema
