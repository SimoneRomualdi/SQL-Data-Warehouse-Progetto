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
-- Contiene i dati anagrafici dei clienti dal sistema CRMDROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
	cst_id INT,
	cst_key VARCHAR(50),
	cst_firstname VARCHAR(50),
	cst_lastname VARCHAR(50),
	cst_material_status VARCHAR(50),
	cst_gndr VARCHAR(50),
	cst_create_date DATE
);

DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
	prd_id INT,
	prd_key VARCHAR(50),
	prd_nm VARCHAR(50),
	prd_cost INT,
	prd_line VARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE
);

DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
	sls_ord_num VARCHAR(50),
	sls_prd_key VARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);

DROP TABLE IF EXISTS bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
	cid VARCHAR(50),
	bdate DATE,
	gen VARCHAR(50)
);

DROP TABLE IF EXISTS bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
	cid VARCHAR(50),
	cntry VARCHAR(50)
);

DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
	id VARCHAR(50),
	cat VARCHAR(50),
	subcat VARCHAR(50),
	maintenance VARCHAR(50)
);
