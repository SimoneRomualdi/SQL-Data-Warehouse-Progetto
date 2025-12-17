/*
===============================================================================
Controlli di Qualità
===============================================================================
Scopo dello Script:
    Questo script esegue controlli di qualità per validare l'integrità, la coerenza
    e l'accuratezza del Layer Gold. Questi controlli assicurano:
    - Unicità delle chiavi surrogate nelle tabelle dimensionali.
    - Integrità referenziale tra tabelle di fatto e dimensionali.
    - Validazione delle relazioni nel modello dati per scopi analitici.
    
Note d'uso:
    - Investigare e risolvere eventuali discrepanze trovate durante i controlli.
===============================================================================
*/

-- ====================================================================
-- Controllo 'gold.dim_customer'
-- ====================================================================
-- Verifica dell'unicità della chiave cliente in gold.dim_customer
-- Risultato atteso: Nessun risultato
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customer
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Controllo 'gold.dim_products'
-- ====================================================================
-- Verifica dell'unicità della chiave prodotto in gold.dim_products
-- Risultato atteso: Nessun risultato
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Controllo 'gold.fact_sales_details'
-- ====================================================================
-- Verifica della connettività del modello dati tra fatto e dimensioni
-- Risultato atteso: Nessun risultato (tutte le chiavi devono corrispondere)
SELECT * 
FROM gold.fact_sales_details f
LEFT JOIN gold.dim_customer c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;

-- ====================================================================
-- Visualizzazione rapida dei dati (opzionale per verifica manuale)
-- ====================================================================
-- Anteprima dim_customer
SELECT *
FROM gold.dim_customer
LIMIT 10;

-- Anteprima dim_products
SELECT * 
FROM gold.dim_products
LIMIT 10;

-- Anteprima fact_sales_details
SELECT *
FROM gold.fact_sales_details
LIMIT 10;
