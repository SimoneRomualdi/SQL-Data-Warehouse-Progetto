/*
===============================================================================
Script: Creazione Tabelle Bronze Layer
===============================================================================
Descrizione:
    Questo script crea le tabelle dello schema 'bronze' per il progetto di 
    Data Warehouse. Il bronze layer contiene i dati grezzi (raw) provenienti 
    dai sistemi sorgente (CRM e ERP) senza alcuna trasformazione.

Struttura:
    - 3 tabelle CRM (Customer Relationship Management)
    - 3 tabelle ERP (Enterprise Resource Planning)

Note Importanti:
    - Le tabelle vengono eliminate e ricreate ad ogni esecuzione (DROP + CREATE)
    - Questo garantisce che la struttura sia sempre aggiornata
    - ⚠️ ATTENZIONE: Tutti i dati nelle tabelle verranno persi!
    - Eseguire questo script solo in fase di setup iniziale o dopo modifiche alla struttura

Prerequisiti:
    - Lo schema 'bronze' deve esistere: CREATE SCHEMA IF NOT EXISTS bronze;

Ordine di esecuzione:
    1. Questo script (creazione tabelle)
    2. Script di caricamento dati (COPY from CSV)
===============================================================================
*/

-- ============================================================================
-- TABELLE CRM (Customer Relationship Management)
-- ============================================================================

-- Tabella: Informazioni Clienti
-- Contiene i dati anagrafici dei clienti dal sistema CRM
DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
	cst_id INT,                           -- ID univoco cliente
	cst_key VARCHAR(50),                  -- Chiave business del cliente
	cst_firstname VARCHAR(50),            -- Nome
	cst_lastname VARCHAR(50),             -- Cognome
	cst_material_status VARCHAR(50),      -- Stato civile
	cst_gndr VARCHAR(50),                 -- Genere
	cst_create_date DATE                  -- Data di creazione record
);

-- Tabella: Informazioni Prodotti
-- Contiene il catalogo prodotti dal sistema CRM
DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
	prd_id INT,                           -- ID univoco prodotto
	prd_key VARCHAR(50),                  -- Chiave business del prodotto
	prd_nm VARCHAR(50),                   -- Nome prodotto
	prd_cost INT,                         -- Costo prodotto
	prd_line VARCHAR(50),                 -- Linea di prodotto
	prd_start_dt DATE,                    -- Data inizio validità
	prd_end_dt DATE                       -- Data fine validità
);

-- Tabella: Dettagli Vendite
-- Contiene le transazioni di vendita dal sistema CRM
DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
	sls_ord_num VARCHAR(50),              -- Numero ordine
	sls_prd_key VARCHAR(50),              -- Chiave prodotto venduto
	sls_cust_id INT,                      -- ID cliente
	sls_order_dt INT,                     -- Data ordine (formato numerico)
	sls_ship_dt INT,                      -- Data spedizione (formato numerico)
	sls_due_dt INT,                       -- Data scadenza (formato numerico)
	sls_sales INT,                        -- Importo vendita
	sls_quantity INT,                     -- Quantità venduta
	sls_price INT                         -- Prezzo unitario
);

-- ============================================================================
-- TABELLE ERP (Enterprise Resource Planning)
-- ============================================================================

-- Tabella: Clienti ERP
-- Contiene dati anagrafici aggiuntivi dei clienti dal sistema ERP
DROP TABLE IF EXISTS bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
	cid VARCHAR(50),                      -- ID cliente (chiave per join con CRM)
	bdate DATE,                           -- Data di nascita
	gen VARCHAR(50)                       -- Genere
);

-- Tabella: Localizzazione Clienti
-- Contiene informazioni geografiche dei clienti
DROP TABLE IF EXISTS bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
	cid VARCHAR(50),                      -- ID cliente
	cntry VARCHAR(50)                     -- Paese di residenza
);

-- Tabella: Categorie Prodotti ERP
-- Contiene la classificazione dei prodotti dal sistema ERP
DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
	id VARCHAR(50),                       -- ID prodotto (chiave per join con CRM)
	cat VARCHAR(50),                      -- Categoria principale
	subcat VARCHAR(50),                   -- Sottocategoria
	maintenance VARCHAR(50)               -- Informazioni manutenzione
);

-- ============================================================================
-- VERIFICA CREAZIONE TABELLE
-- ============================================================================
-- Eseguire questa query per verificare che tutte le tabelle siano state create:
-- 
-- SELECT table_name 
-- FROM information_schema.tables 
-- WHERE table_schema = 'bronze' 
-- ORDER BY table_name;
--
-- Output atteso: 6 tabelle (crm_cust_info, crm_prd_info, crm_sales_details, 
--                           erp_cust_az12, erp_loc_a101, erp_px_cat_g1v2)
-- ============================================================================
