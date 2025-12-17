/*
===============================================================================
Script DDL: Creazione Viste Gold
===============================================================================
Scopo dello Script:
    Questo script crea le viste per il layer Gold del data warehouse.
    Il layer Gold rappresenta le tabelle dimensionali e di fatto finali (Star Schema).
    Ogni vista esegue trasformazioni e combina dati dal layer Silver
    per produrre un dataset pulito, arricchito e pronto per il business.
    
Utilizzo:
    - Queste viste possono essere interrogate direttamente per analisi e reporting.
===============================================================================
*/

-- =============================================================================
-- Creazione Dimensione: gold.dim_customer
-- =============================================================================
DROP VIEW IF EXISTS gold.dim_customer;

CREATE VIEW gold.dim_customer AS
SELECT
    ROW_NUMBER() OVER(ORDER BY ci.cst_id) as customer_key, -- Chiave surrogata
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender, -- La sorgente CRM viene considerata quella di riferimento 
    ca.bdate AS birthday,
    ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;

-- =============================================================================
-- Creazione Dimensione: gold.dim_products
-- =============================================================================
DROP VIEW IF EXISTS gold.dim_products;

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER(ORDER BY pi.prd_start_dt, pi.prd_key) AS product_key, -- Chiave surrogata
    pi.prd_id AS product_id,
    pi.prd_key AS product_number,
    pi.prd_nm AS product_name,
    pi.cat_id AS category_id,
    pe.cat AS category,
    pe.subcat AS subcategory,
    pe.maintenance,
    pi.prd_cost AS product_cost,
    pi.prd_line AS product_line,
    pi.prd_start_dt AS start_date
FROM silver.crm_prd_info pi
LEFT JOIN silver.erp_px_cat_g1v2 pe
    ON pi.cat_id = pe.id
WHERE pi.prd_end_dt IS NULL; -- Per filtrare solo i dati correnti ed eliminare tutti i dati storici

-- =============================================================================
-- Creazione Tabella dei Fatti: gold.fact_sales_details
-- =============================================================================
DROP VIEW IF EXISTS gold.fact_sales_details;

CREATE VIEW gold.fact_sales_details AS 
SELECT
    sd.sls_ord_num AS order_number,
    dp.product_key,
    dc.customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products dp
    ON sd.sls_prd_key = dp.product_number
LEFT JOIN gold.dim_customer dc
    ON sd.sls_cust_id = dc.customer_id;
