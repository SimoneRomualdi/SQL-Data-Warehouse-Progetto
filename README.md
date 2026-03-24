# SQL Data Warehouse & Analytics

## Executive Summary

- **Business Problem**: I dati di vendita sono distribuiti tra due sistemi separati (CRM e ERP), rendendo impossibile avere una visione unica di clienti e prodotti.
- **Soluzione**: Costruzione di un data warehouse moderno in PostgreSQL con architettura multi-layer (Bronze → Silver → Gold) che unifica le due sorgenti e le rende interrogabili per analisi di business.
- **Risultati**: Pipeline ETL completamente automatizzata tramite stored procedures; Star Schema finale con 3 oggetti analitici pronti per il business; segmentazione clienti e analisi Year-over-Year sui prodotti.
- **Prossimi Passi**: Collegare il Gold Layer a Power BI per dashboard interattive; aggiungere storicizzazione per tracking dei cambiamenti nel tempo.

---

## Business Problem

Quando i dati vivono in silos separati, rispondere a domande semplici diventa complicato: *"Chi sono i nostri clienti più redditizi?"* o *"Quali prodotti stanno performando meglio per categoria?"*. L'obiettivo era costruire una base dati affidabile, pulita e strutturata su cui costruire analisi concrete — non solo caricare dati, ma renderli utili.

---

## Metodologia

1. **Bronze Layer** → Caricamento dati grezzi as-is dai CSV sorgente (CRM + ERP) tramite stored procedure con logging integrato (righe caricate, durata, gestione errori).
2. **Silver Layer** → Pulizia e standardizzazione: duplicati rimossi, date inconsistenti corrette, codici normalizzati in valori leggibili (es. `"M"` → `"Male"`, `"S"` → `"Single"`), colonne derivate aggiunte.
3. **Gold Layer** → Creazione di views SQL in Star Schema (`dim_customer`, `dim_products`, `fact_sales_details`) pronte per analisi e reporting.
4. **Analytics** → Query avanzate sul Gold Layer per segmentazione clienti, ranking prodotti, analisi temporale e calcolo KPI.

---

## Competenze

- **SQL**: CTE, Window Functions (`LAG`, `ROW_NUMBER`, `DENSE_RANK`, `SUM OVER`), Stored Procedures, Star Schema, Views
- **PostgreSQL**: `AGE()`, `EXTRACT()`, `DATE_TRUNC()`, gestione errori con `SQLSTATE`, `GET DIAGNOSTICS`

---

## Risultati & Raccomandazioni

- **Segmentazione clienti**: Identificati tre tier (VIP / Regular / New) basati su valore speso e mesi di attività — i clienti VIP rappresentano la priorità per campagne di retention.
- **Performance prodotti**: Analisi YoY con `LAG()` evidenzia quali prodotti stanno crescendo e quali calando — base per decisioni di assortimento.
- **Contributo per categoria**: Analisi part-to-whole mostra quali categorie trainano il fatturato — utile per allocazione budget marketing.
- **Nota tecnica**: Le due sorgenti avevano logiche di codifica del genere diverse e parzialmente sovrapposte. Soluzione adottata: priorità al CRM come fonte di riferimento, ERP usato solo come fallback — una decisione di business documentata, non solo tecnica.

---

## Prossimi Passi

1. Collegare il Gold Layer a Power BI per dashboard interattive su KPI e segmentazione.
2. Aggiungere storicizzazione per tracciare i cambiamenti nei dati dei clienti nel tempo.
3. Estendere l'analisi con cohort retention per misurare la fedeltà dei clienti mese su mese.

---

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

**Stack**: PostgreSQL · SQL
