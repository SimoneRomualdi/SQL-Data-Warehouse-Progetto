/*
===============================================================================
Script: Controllo Qualità Dati Layer Silver
===============================================================================
Scopo dello Script:
    Questo script esegue vari controlli di qualità per verificare la coerenza, 
    l'accuratezza e la standardizzazione dei dati nel layer 'silver'. Include 
    controlli per:
    - Chiavi primarie nulle o duplicate
    - Spazi non voluti nei campi stringa
    - Standardizzazione e consistenza dei dati
    - Intervalli e ordini di date non validi
    - Coerenza dei dati tra campi correlati

Note di Utilizzo:
    - Eseguire questi controlli dopo il caricamento del Layer Silver
    - Investigare e risolvere eventuali discrepanze trovate durante i controlli

Aspettative:
    - La maggior parte delle query dovrebbe restituire zero risultati
    - Le query di standardizzazione mostrano i valori distinti presenti
===============================================================================
*/

-- ====================================================================
-- Controllo 'silver.crm_cust_info'
-- ====================================================================
-- Controllo valori nulli o duplicati nella Primary Key
-- Aspettative: Zero risultati
SELECT cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Controllo spazi non voluti
-- Aspettative: Zero risultati

SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Standardizzazione dei Dati & Consistenza

SELECT DISTINCT cst_marital_status, cst_gndr
FROM silver.crm_cust_info;

SELECT *
FROM silver.crm_cust_info;

-- ====================================================================
-- Controllo 'silver.crm_prd_info'
-- ====================================================================
-- Controllo di valori duplicati o nulli nella Primary Key

SELECT prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Controllo spazi non voluti

SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Controllo di valori Nulli o Numeri Negativi

SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Standardizzazione dei Dati & Consistenza

SELECT DISTINCT prd_line 
FROM silver.crm_prd_info;

-- Controllo di Date invalide per gli Ordini
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt; -- Ci sono alcune date di fine che sono precedenti a quelle d'inizio e questo non è corretto

-- ====================================================================
-- Controllo 'silver.crm_sales_details'
-- ====================================================================
-- Controllo che la Data di ordine sia sempre precedente a quella di spedizione o di reclamo
SELECT * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
OR sls_order_dt > sls_due_dt;

-- Controllo su Sales, Quantity e Price
-- Sales = Quantity * Price
-- Valori non possono essere NULL, Zero o Negativi

SELECT DISTINCT 
	sls_sales,
	sls_quantity,  
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <=0
ORDER BY sls_sales, sls_quantity, sls_price;

SELECT * FROM silver.crm_sales_details;

-- ====================================================================
-- Controllo 'silver.erp_cust_az12'
-- ====================================================================
-- Identificazione Date fuori RANGE

SELECT bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > CURRENT_TIMESTAMP;

-- Standardizzazione dei Dati & Consistenza

SELECT DISTINCT 
gen
FROM silver.erp_cust_az12;

SELECT * 
FROM silver.erp_cust_az12;

-- ====================================================================
-- Controllo 'silver.erp_loc_a101'
-- ====================================================================
-- Standardizzazione dei Dati nella colonna Country

SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

-- Controllo finale nel layer silver
SELECT * 
FROM silver.erp_loc_a101;

-- ====================================================================
-- Controllo 'silver.erp_px_cat_g1v2'
-- ====================================================================
-- Controllo di spazi non voluti
SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

-- Standardizzazione dei Dati & Consistenza
SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2;

SELECT DISTINCT subcat
FROM silver.erp_px_cat_g1v2;

SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2;

-- Check Finale
SELECT * 
FROM silver.erp_px_cat_g1v2;
