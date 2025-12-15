/*
===============================================================================
Stored Procedure: Caricamento Layer Bronze (Sorgente → Bronze)
===============================================================================
Scopo dello script:
    Questa procedura si occupa del caricamento dei dati nel layer
    'bronze' a partire da file CSV esterni (sistemi CRM ed ERP).

    In particolare, la procedura esegue le seguenti operazioni:
    - Troncamento delle tabelle del layer bronze prima del caricamento.
    - Caricamento massivo dei dati tramite il comando COPY da file CSV.
    - Tracciamento delle tempistiche di caricamento e del numero di righe
      caricate per ciascuna tabella.
    - Logging dell’avanzamento del processo tramite messaggi RAISE NOTICE.
    - Gestione centralizzata degli errori con restituzione di messaggio
      e codice SQLSTATE.

Layer coinvolto:
    - Bronze (dati grezzi, caricati as-is dalla sorgente, senza trasformazioni)

Prerequisiti:
    - I file CSV devono essere accessibili dal server PostgreSQL.
    - Le tabelle del layer bronze devono esistere con struttura coerente
      ai file sorgente.
    - L’utente che esegue la procedura deve avere i permessi di lettura
      sui file e di TRUNCATE / COPY sulle tabelle.

Esempio di utilizzo:
    CALL bronze.caricamento_bronze();

===============================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.caricamento_bronze()
LANGUAGE plpgsql

AS $$
DECLARE -- Dichiaro l'esistenza delle variabili e che tipo di dato possono contenere'
	ora_inizio_caricamento TIMESTAMP;
	ora_fine_caricamento TIMESTAMP;
	ora_inizio_batch TIMESTAMP;
	ora_fine_batch TIMESTAMP;
	durata INT;
	righe_caricate INT;
	
-- Inizio procedura --
BEGIN
	ora_inizio_batch := CURRENT_TIMESTAMP;
	
	RAISE NOTICE '===============================';
	RAISE NOTICE 'Caricamento Layer Bronze';
	RAISE NOTICE '===============================';
	
	RAISE NOTICE '-------------------------------';
	RAISE NOTICE 'Caricamento Dati in Tabelle CRM';
	RAISE NOTICE '-------------------------------';

	-- Inserimento massivo dei dati dal Csv alla tabella crm_cust_info --
	ora_inizio_caricamento := CURRENT_TIMESTAMP;
	RAISE NOTICE 'Troncamento Tabella: bronze.crm_cust_info';
	-- Pulisco la tabella mantenendo la struttura --
	TRUNCATE bronze.crm_cust_info;
	RAISE NOTICE 'Inserimento Dati nella tabella: bronze.crm_cust_info';
	COPY bronze.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
	FROM 'C:/PostgreSQL_Data/sorgente_crm/cust_info.csv'
	WITH (FORMAT csv, HEADER true, DELIMITER ',');
	GET DIAGNOSTICS righe_caricate = ROW_COUNT; -- Permette di avere una diagnostica dell'operazione appena conclusa -- 
	ora_fine_caricamento := CURRENT_TIMESTAMP;
	durata := EXTRACT(EPOCH FROM (ora_fine_caricamento - ora_inizio_caricamento))::INT;
	RAISE NOTICE 'Caricate % righe in % secondi', righe_caricate, durata;
	RAISE NOTICE '---------------';

	-- Inserimento massivo dei dati dal Csv alla tabella crm_prd_info --
	ora_inizio_caricamento := CURRENT_TIMESTAMP;
	RAISE NOTICE 'Troncamento Tabella: bronze.crm_prd_info';
	TRUNCATE bronze.crm_prd_info;
	RAISE NOTICE 'Inserimento Dati nella tabella: bronze.crm_prd_info';
	COPY bronze.crm_prd_info (prd_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
	FROM 'C:/PostgreSQL_Data/sorgente_crm/prd_info.csv'
	WITH (FORMAT csv, HEADER true, DELIMITER ',');
	GET DIAGNOSTICS righe_caricate = ROW_COUNT;
	ora_fine_caricamento := CURRENT_TIMESTAMP;
	durata := EXTRACT(EPOCH FROM (ora_fine_caricamento - ora_inizio_caricamento))::INT;
	RAISE NOTICE 'Caricate % righe in % secondi', righe_caricate, durata;
	RAISE NOTICE '---------------';

	
	-- -- Inserimento massivo dei dati dal Csv alla tabella crm_sales_details --
	ora_inizio_caricamento := CURRENT_TIMESTAMP;
	RAISE NOTICE 'Troncamento Tabella: bronze.crm_sales_details';
	TRUNCATE bronze.crm_sales_details;
	RAISE NOTICE 'Inserimento Dati nella tabella: bronze.crm_sales_details';
	COPY bronze.crm_sales_details (sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price)
	FROM 'C:/PostgreSQL_Data/sorgente_crm/sales_details.csv'
	WITH (FORMAT csv, HEADER true, DELIMITER ',');
	GET DIAGNOSTICS righe_caricate = ROW_COUNT;
	ora_fine_caricamento := CURRENT_TIMESTAMP;
	durata := EXTRACT(EPOCH FROM (ora_fine_caricamento - ora_inizio_caricamento))::INT;
	RAISE NOTICE 'Caricate % righe in % secondi', righe_caricate, durata;
	RAISE NOTICE '---------------';

	RAISE NOTICE '-------------------------------';
	RAISE NOTICE 'Caricamento Dati in Tabelle ERP';
	RAISE NOTICE '-------------------------------';

	-- Inserimento massivo dei dati dal Csv alla tabella erp_cust_az12 --
	ora_inizio_caricamento := CURRENT_TIMESTAMP;
	RAISE NOTICE 'Troncamento Tabella: bronze.erp_cust_az12';
	TRUNCATE bronze.erp_cust_az12;
	RAISE NOTICE 'Inserimento Dati nella tabella: bronze.erp_cust_az12';
	COPY bronze.erp_cust_az12 (cid, bdate, gen)
	FROM 'C:/PostgreSQL_Data/sorgente_erp/CUST_AZ12.csv'
	WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
	GET DIAGNOSTICS righe_caricate = ROW_COUNT;
	ora_fine_caricamento := CURRENT_TIMESTAMP;
	durata := EXTRACT(EPOCH FROM (ora_fine_caricamento - ora_inizio_caricamento))::INT;
	RAISE NOTICE 'Caricate % righe in % secondi', righe_caricate, durata;
	RAISE NOTICE '---------------';

	-- Inserimento massivo dei dati dal Csv alla tabella erp_loc_a101 --
	ora_inizio_caricamento := CURRENT_TIMESTAMP;
	RAISE NOTICE 'Troncamento Tabella: bronze.erp_loc_a101';
	TRUNCATE bronze.erp_loc_a101;
	RAISE NOTICE 'Inserimento Dati nella tabella: bronze.erp_loc_a101';
	COPY bronze.erp_loc_a101 (cid, cntry)
	FROM 'C:/PostgreSQL_Data/sorgente_erp/LOC_A101.csv'
	WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
	GET DIAGNOSTICS righe_caricate = ROW_COUNT;
	ora_fine_caricamento := CURRENT_TIMESTAMP;
	durata := EXTRACT(EPOCH FROM (ora_fine_caricamento - ora_inizio_caricamento))::INT;
	RAISE NOTICE 'Caricate % righe in % secondi', righe_caricate, durata;
	RAISE NOTICE '---------------';

	-- Inserimento massivo dei dati dal Csv alla tabella erp_px_cat_g1v2 --
	ora_inizio_caricamento := CURRENT_TIMESTAMP;
	RAISE NOTICE 'Troncamento Tabella: bronze.erp_px_cat_g1v2';
	TRUNCATE bronze.erp_px_cat_g1v2;
	RAISE NOTICE 'Inserimento Dati nella tabella: bronze.erp_px_cat_g1v2';
	COPY bronze.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
	FROM 'C:/PostgreSQL_Data/sorgente_erp/PX_CAT_G1V2.csv'
	WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
	GET DIAGNOSTICS righe_caricate = ROW_COUNT;
	ora_fine_caricamento := CURRENT_TIMESTAMP;
	durata := EXTRACT(EPOCH FROM (ora_fine_caricamento - ora_inizio_caricamento))::INT;
	RAISE NOTICE 'Caricate % righe in % secondi', righe_caricate, durata;
	RAISE NOTICE '---------------';

	ora_fine_batch := CURRENT_TIMESTAMP;
	durata := EXTRACT(EPOCH FROM (ora_fine_batch - ora_inizio_batch))::INT;
	RAISE NOTICE '===============================';
	RAISE NOTICE 'Caricamento Layer Bronze completato';
	RAISE NOTICE 'Durata Batch: % secondi', durata;
	RAISE NOTICE '===============================';

-- Gestione di eventuali errori nella Procedura --
EXCEPTION
	WHEN OTHERS THEN
		RAISE NOTICE '===============================';
		RAISE NOTICE 'Errore nel caricamento del Layer Bronze';
		RAISE NOTICE 'Messaggio Errore: %', SQLERRM; -- Variabile che scrive il Nome dell'errore -- 
		RAISE NOTICE 'Codice Errore: %', SQLSTATE; -- Variabile che scrive il Codice dell'errore --
		RAISE; -- Raise necessario per evitare che l'errore venga riconosciuto ma che la procedura continui -- 
END;
$$;
