/*
===============================================================================
Stored Procedure: Caricamento Layer Silver (Bronze -> Silver)
===============================================================================
Scopo dello Script:
    Questa stored procedure esegue il processo ETL (Extract, Transform, Load) per 
    popolare le tabelle dello schema 'silver' a partire dallo schema 'bronze'.
    
    Azioni Eseguite:
        - Tronca le tabelle Silver.
        - Inserisce dati trasformati e puliti dal Bronze nelle tabelle Silver.
        
Parametri:
    Nessuno. 
    Questa stored procedure non accetta parametri né restituisce valori.

Esempio di Utilizzo:
    CALL silver.caricamento_silver();
===============================================================================
*/

CREATE OR REPLACE PROCEDURE silver.caricamento_silver()
LANGUAGE plpgsql
AS $$

DECLARE
	ora_inizio_processo TIMESTAMP;
	ora_fine_processo TIMESTAMP;
	ora_inizio_caricamento TIMESTAMP;
	ora_fine_caricamento TIMESTAMP;
	durata INT;
	righe_caricate INT;
	
BEGIN
	ora_inizio_processo := CURRENT_TIMESTAMP;

	RAISE NOTICE '========================';
	RAISE NOTICE 'Caricamento Layer Silver';
	RAISE NOTICE '========================';
	
	RAISE NOTICE '-------------------------------------------------';
	RAISE NOTICE 'Caricamento Dati Tabelle CRM dal bronzo al silver';
	RAISE NOTICE '-------------------------------------------------';
	
	-- Caricamento silver.crm_cust_info
	ora_inizio_caricamento := CURRENT_TIMESTAMP;
	RAISE NOTICE 'Troncamento Tabella: silver.crm_cust_info';
	TRUNCATE TABLE silver.crm_cust_info;
	RAISE NOTICE 'Inserimento Dati in Tabella: silver.crm_cust_info';
	INSERT INTO silver.crm_cust_info (
	    cst_id, 
	    cst_key, 
	    cst_firstname, 
	    cst_lastname, 
	    cst_marital_status, 
	    cst_gndr,
	    cst_create_date
	)
	SELECT
	    cst_id,
	    cst_key,
	    TRIM(cst_firstname) AS cst_firstname, 
	    TRIM(cst_lastname) AS cst_lastname,
	    CASE 
	        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	        ELSE 'n/a'
	    END AS cst_marital_status, -- Normalizza i valori dello stato civile in formato leggibile
	    CASE 
	        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	        ELSE 'n/a'
	    END AS cst_gndr, -- Normalizza i valori del genere in formato leggibile
	    cst_create_date
	FROM (
	    SELECT 
	        *,
	        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS dato_recente
	    FROM bronze.crm_cust_info
	    WHERE cst_id IS NOT NULL
	) t
	WHERE dato_recente = 1; -- Seleziona il record più recente per cliente
	GET DIAGNOSTICS righe_caricate = ROW_COUNT;
	ora_fine_caricamento := CURRENT_TIMESTAMP;
	durata := EXTRACT(EPOCH FROM(ora_fine_caricamento - ora_inizio_caricamento))::INT;
	RAISE NOTICE '% Righe caricate in % Secondi', righe_caricate, durata;
	RAISE NOTICE '---------------';
	
	-- Caricamento silver.crm_prd_info
	ora_inizio_caricamento := CURRENT_TIMESTAMP;
	RAISE NOTICE 'Troncamento Tabella: silver.crm_prd_info';
	TRUNCATE TABLE silver.crm_prd_info;
	RAISE NOTICE 'Inserimento Dati in Tabella: silver.crm_prd_info';
	INSERT INTO silver.crm_prd_info (
	    prd_id,
	    cat_id,
	    prd_key,
	    prd_nm,
	    prd_cost,
	    prd_line,
	    prd_start_dt,
	    prd_end_dt
	)
	SELECT 
	    prd_id,
	    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- Estrae l'ID della categoria
	    SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,     -- Estrae la chiave del prodotto
	    prd_nm,
	    COALESCE(prd_cost, 0) AS prd_cost,
	    CASE 
	        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
	        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
	        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
	        ELSE 'n/a' 
	    END AS prd_line, -- Mappa i codici della linea di prodotto in valori descrittivi
	    CAST(prd_start_dt AS DATE) AS prd_start_dt,
	    CAST(
	        LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1 Day' 
	        AS DATE
	    ) AS prd_end_dt -- Calcola la data di fine come un giorno prima della prossima data di inizio
	FROM bronze.crm_prd_info;
	GET DIAGNOSTICS righe_caricate = ROW_COUNT;
	ora_fine_caricamento := CURRENT_TIMESTAMP;
	durata := EXTRACT(EPOCH FROM(ora_fine_caricamento - ora_inizio_caricamento))::INT;
	RAISE NOTICE '% Righe caricate in % Secondi', righe_caricate, durata;
	RAISE NOTICE '---------------';
	
	-- Caricamento silver.crm_sales_details
	ora_inizio_caricamento := CURRENT_TIMESTAMP;
	RAISE NOTICE 'Troncamento Tabella: silver.crm_sales_details';
	TRUNCATE TABLE silver.crm_sales_details;
	RAISE NOTICE 'Inserimento Dati in Tabella: silver.crm_sales_details';
	INSERT INTO silver.crm_sales_details (
	    sls_ord_num,
	    sls_prd_key,
	    sls_cust_id,
	    sls_order_dt,
	    sls_ship_dt,
	    sls_due_dt,
	    sls_sales,
	    sls_quantity,
	    sls_price
	)
	SELECT
	    sls_ord_num,
	    sls_prd_key, 
	    sls_cust_id,
	    CASE 
	        WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt::TEXT) != 8 THEN NULL
	        ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) 
	    END AS sls_order_dt,
	    CASE 
	        WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt::TEXT) != 8 THEN NULL
	        ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) 
	    END AS sls_ship_dt, 
	    CASE 
	        WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt::TEXT) != 8 THEN NULL
	        ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) 
	    END AS sls_due_dt,
	    CASE 
	        WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
	        THEN sls_quantity * ABS(sls_price)
	        ELSE sls_sales
	    END AS sls_sales, -- Ricalcola le vendite se il valore originale è mancante o errato
	    sls_quantity,
	    CASE 
	        WHEN sls_price IS NULL OR sls_price <= 0 
	        THEN sls_sales / NULLIF(sls_quantity, 0)
	        ELSE sls_price  -- Deriva il prezzo se il valore originale non è valido
	    END AS sls_price
	FROM bronze.crm_sales_details;
	GET DIAGNOSTICS righe_caricate = ROW_COUNT;
	ora_fine_caricamento := CURRENT_TIMESTAMP;
	durata := EXTRACT(EPOCH FROM(ora_fine_caricamento - ora_inizio_caricamento))::INT;
	RAISE NOTICE '% Righe caricate in % Secondi', righe_caricate, durata;
	RAISE NOTICE '---------------';
	
	RAISE NOTICE '-------------------------------------------------';
	RAISE NOTICE 'Caricamento Dati Tabelle ERP dal bronzo al silver';
	RAISE NOTICE '-------------------------------------------------';
	
	-- Caricamento silver.erp_cust_az12
	ora_inizio_caricamento := CURRENT_TIMESTAMP;
	RAISE NOTICE 'Troncamento Tabella: silver.erp_cust_az12';
	TRUNCATE TABLE silver.erp_cust_az12;
	RAISE NOTICE 'Inserimento Dati in Tabella: silver.erp_cust_az12';
	INSERT INTO silver.erp_cust_az12 (
	    cid,
	    bdate,
	    gen
	)
	SELECT
	    CASE 
	        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid)) -- Rimuove il prefisso 'NAS' se presente
	        ELSE cid
	    END AS cid,
	    CASE 
	        WHEN bdate > CURRENT_TIMESTAMP THEN NULL
	        ELSE bdate
	    END AS bdate, -- Imposta a NULL le date di nascita future
	    CASE 
	        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	        ELSE 'n/a'
	    END AS gen -- Normalizza i valori del genere e gestisce i casi sconosciuti
	FROM bronze.erp_cust_az12;
	GET DIAGNOSTICS righe_caricate = ROW_COUNT;
	ora_fine_caricamento := CURRENT_TIMESTAMP;
	durata := EXTRACT(EPOCH FROM(ora_fine_caricamento - ora_inizio_caricamento))::INT;
	RAISE NOTICE '% Righe caricate in % Secondi', righe_caricate, durata;
	RAISE NOTICE '---------------';
	
	-- Caricamento silver.erp_loc_a101
	ora_inizio_caricamento := CURRENT_TIMESTAMP;
	RAISE NOTICE 'Troncamento Tabella: silver.erp_loc_a101';
	TRUNCATE TABLE silver.erp_loc_a101;
	RAISE NOTICE 'Inserimento Dati in Tabella: silver.erp_loc_a101';
	INSERT INTO silver.erp_loc_a101 (
	    cid,
	    cntry
	)
	SELECT
	    REPLACE(cid, '-', '') AS cid,
	    CASE 
	        WHEN TRIM(cntry) = 'DE' THEN 'Germany'
	        WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
	        WHEN TRIM(cntry) = '' OR TRIM(cntry) IS NULL THEN 'n/a'
	        ELSE TRIM(cntry)
	    END AS cntry -- Normalizza e gestisce i codici paese mancanti o vuoti
	FROM bronze.erp_loc_a101;
	GET DIAGNOSTICS righe_caricate = ROW_COUNT;
	ora_fine_caricamento := CURRENT_TIMESTAMP;
	durata := EXTRACT(EPOCH FROM(ora_fine_caricamento - ora_inizio_caricamento))::INT;
	RAISE NOTICE '% Righe caricate in % Secondi', righe_caricate, durata;
	RAISE NOTICE '---------------';
	
	-- Caricamento silver.erp_px_cat_g1v2
	ora_inizio_caricamento := CURRENT_TIMESTAMP;
	RAISE NOTICE 'Troncamento Tabella: silver.erp_px_cat_g1v2';
	TRUNCATE TABLE silver.erp_px_cat_g1v2;
	RAISE NOTICE 'Inserimento Dati in Tabella: silver.erp_px_cat_g1v2';
	INSERT INTO silver.erp_px_cat_g1v2 (
	    id,
	    cat,
	    subcat,
	    maintenance
	)
	SELECT 
	    id,
	    cat,
	    subcat,
	    maintenance
	FROM bronze.erp_px_cat_g1v2;
	GET DIAGNOSTICS righe_caricate = ROW_COUNT;
	ora_fine_caricamento := CURRENT_TIMESTAMP;
	durata := EXTRACT(EPOCH FROM(ora_fine_caricamento - ora_inizio_caricamento))::INT;
	RAISE NOTICE '% Righe caricate in % Secondi', righe_caricate, durata;
	RAISE NOTICE '---------------';

	ora_fine_processo := CURRENT_TIMESTAMP;
	durata := EXTRACT(EPOCH FROM(ora_fine_processo - ora_inizio_processo))::INT;
	RAISE NOTICE '========================';
	RAISE NOTICE 'Caricamento Layer Silver Completato';
	RAISE NOTICE '   - Durata Totale Caricamento: % Secondi', durata;
	RAISE NOTICE '========================';

	
EXCEPTION
	WHEN OTHERS THEN
		RAISE NOTICE '========================';
		RAISE NOTICE 'ERRORE DURANTE IL CARICAMENTO DEL LAYER SILVER';
		RAISE NOTICE 'Messaggio di Errore: %', SQLERRM;
		RAISE NOTICE 'Codice Errore: %', SQLSTATE;
		RAISE NOTICE '========================';
		RAISE;
END
$$;
