# SQL-Data-Warehouse-Progetto

Creazione di un Data Warehouse moderno con PostgreSQL. Sono inclusi Processi di ETL, Data Modeling e Analisi.

---

## Overview

Progetto completo di Data Engineering e Data Analysis per la creazione di un data warehouse moderno e lo sviluppo di analytics avanzate sui dati di vendita.

---

## 🎯 Project Requirements

### Building the Data Warehouse (Data Engineering)

**Objective**

Realizzare un data warehouse moderno basato su PostgreSQL per centralizzare i dati di vendita provenienti da diverse fonti, così da supportare analisi avanzate e processi decisionali più consapevoli.

**Specifications**

- **Sorgenti Dati**: Caricamento dei dati da due sistemi (ERP e CRM), forniti in formato CSV
- **Data Quality**: Attività di pulizia e normalizzazione dei dati per eliminare incoerenze, duplicati e valori anomali prima della fase analitica
- **Integrazione**: Unificazione delle due sorgenti in un unico modello dati chiaro e facilmente interrogabile, pensato per analisi e reporting
- **Ambito**: Il progetto si concentra sui dati più recenti; non è prevista la storicizzazione delle informazioni
- **Documentazione**: Produzione di una documentazione completa del modello dati, utile sia per i team di business sia per chi si occupa di analytics

### BI: Analytics & Reporting (Data Analysis)

**Objective**

Sviluppare analisi basate su SQL per ottenere insight approfonditi su diversi aspetti del business, così da supportare processi decisionali strategici.

**Focus dell'Analisi**

- **Comportamento dei Clienti**: Identificazione di pattern, segmenti e dinamiche di acquisto
- **Performance dei Prodotti**: Valutazione dei prodotti più performanti e analisi dei driver di vendita
- **Trend di Vendita**: Individuazione di andamenti temporali e variazioni stagionali nelle vendite

Le analisi prodotte forniscono metriche chiave ai principali stakeholder, facilitando decisioni data-driven e una pianificazione più efficace.

---

## 🛠️ Stack Tecnologico

- **Database**: PostgreSQL
- **Query Language**: SQL
- **Data Format**: CSV

---

## 📁 Struttura del Repository

```
SQL-Data-Warehouse-Progetto/
├── datasets/                 # Dataset sorgente (ERP, CRM)
│   ├── sorgente_crm/        # File CSV dal sistema CRM
│   └── sorgente_erp/        # File CSV dal sistema ERP
├── scripts/                  # Script SQL per ETL e analisi
│   ├── bronze/              # Layer Bronze
│   │   ├── ddl_bronze_tabelle.sql
│   │   └── proc_caricamento_bronze.sql
│   ├── silver/              # Layer Silver
│   │   ├── ddl_tabelle_silver.sql
│   │   └── proc_caricamento_silver.sql
│   └── gold/                # Layer Gold
│       └── ddl_layer_gold.sql
├── tests/                    # Script controllo qualità
│   ├── controllo_qualità_silver.sql
│   └── controllo_qualità_oro.sql
├── documentazione/           # Documentazione del modello dati
│   ├── Architettura.drawio
│   ├── Data Model.drawio
│   ├── Flusso Dati.drawio
│   ├── Modello di Integrazione.drawio
│   └── data_catalog.md
└── README.md                 # Questo file
```

---

## 🏗️ Architettura dei Dati

Il progetto implementa un'architettura a tre layer seguendo le best practice moderne di data warehousing:

### Bronze Layer - Dati Grezzi
- **Tipo**: Tabelle
- **Caricamento**: 
  - Caricamento Completo
  - Truncate & Insert
- **Trasformazioni**: Nessuna
- **Data Model**: Nessuno (as-is)

Contiene i dati grezzi caricati direttamente dai file CSV senza alcuna trasformazione. Include:
- 3 tabelle CRM (`crm_cust_info`, `crm_prd_info`, `crm_sales_details`)
- 3 tabelle ERP (`erp_cust_az12`, `erp_loc_a101`, `erp_px_cat_g1v2`)

### Silver Layer - Dati Puliti e Standardizzati
- **Tipo**: Tabelle
- **Caricamento**: 
  - Caricamento Completo
  - Truncate & Insert
- **Trasformazioni**:
  - Data Cleaning
  - Data Standardization
  - Data Normalization
  - Colonne Derivate
- **Data Model**: Nessuno (as-is)

In questo layer vengono applicati processi di pulizia e standardizzazione:
- Gestione valori nulli e duplicati
- Normalizzazione formati (date, categorie)
- Standardizzazione codifiche
- Derivazione colonne aggiuntive

### Gold Layer - Dati Pronti per il Business
- **Tipo**: Data Views
- **Caricamento**: Nessuno
- **Trasformazioni**:
  - Integrazione di Dati
  - Aggregazioni
  - Logiche di Business
- **Data Model**:
  - Star Schema
  - Tabelle Flat
  - Tabelle Aggregate

Layer finale ottimizzato per analisi e reporting, con:
- **Dimensioni**: `dim_customer`, `dim_products`
- **Fatto**: `fact_sales_details`

---

## 📊 Modello Dati

Il Gold Layer implementa uno **Star Schema** con:

### Tabelle Dimensionali

**gold.dim_customer**
- Anagrafica completa dei clienti
- Integrazione dati CRM + ERP
- Informazioni demografiche e geografiche

**gold.dim_products**
- Catalogo prodotti
- Categorie e sottocategorie
- Costi e linee di prodotto

### Tabella dei Fatti

**gold.fact_sales_details**
- Transazioni di vendita
- Metriche di business (importo, quantità, prezzo)
- Collegamenti alle dimensioni tramite foreign key

---

### Documentazione
- Commenti dettagliati in ogni script SQL
- Diagrammi architetturali
- Data catalog completo
- Esempi di query per casi d'uso comuni

---

## 🎓 Competenze Applicate

**Data Engineering**
- Progettazione Data Warehouse
- Processi ETL end-to-end
- Data modeling dimensionale
- Data quality e governance

**Data Analysis**
- Query SQL avanzate
- Analisi customer behavior
- Performance analysis
- Business metrics e KPI

**Database Design**
- Star Schema
- Normalizzazione
- Ottimizzazione performance
- Design pattern per analytics

---

## 📝 Note

Questo progetto si concentra sui dati più recenti e non implementa la storicizzazione. È stato sviluppato come parte del percorso di apprendimento in Data Analysis e Data Engineering.
