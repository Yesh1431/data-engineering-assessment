\echo =========================
\echo STAGING OBJECTS
\echo =========================

\dv staging.*

\echo =========================
\echo STAGING COUNTS
\echo =========================

SELECT 'stg_customers' AS view_name, COUNT(*) AS row_count FROM staging.stg_customers
UNION ALL
SELECT 'stg_orders' AS view_name, COUNT(*) AS row_count FROM staging.stg_orders
UNION ALL
SELECT 'stg_products' AS view_name, COUNT(*) AS row_count FROM staging.stg_products;

\echo =========================
\echo SAMPLE STG_CUSTOMERS
\echo =========================

SELECT * FROM staging.stg_customers LIMIT 5;

\echo =========================
\echo SAMPLE STG_ORDERS
\echo =========================

SELECT order_id, order_name, total_price, financial_status, fulfillment_status, order_created_at
FROM staging.stg_orders
LIMIT 5;

\echo =========================
\echo SAMPLE STG_PRODUCTS
\echo =========================

SELECT * FROM staging.stg_products LIMIT 5;