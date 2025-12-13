# SQL-Data-Warehouse-Progetto
Creazione di un Data Warehouse moderno con Postgre SQL. Sono inclusi Processi di ETL, Data Modeling e Analisi. 

# Sales Data Warehouse & Analytics

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
├── datasets/             # Dataset sorgente (ERP, CRM)
├── scripts/              # Script SQL per ETL e analisi
├── documentazione/       # Documentazione del modello dati
└── README.md             # Questo file
```
