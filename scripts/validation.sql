\echo =========================
\echo RAW TABLE CHECK
\echo =========================

\dt raw.*

\echo =========================
\echo ROW COUNTS
\echo =========================

SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM raw.shopify_customers_file
UNION ALL
SELECT 'orders' AS table_name, COUNT(*) AS row_count
FROM raw.shopify_orders_file
UNION ALL
SELECT 'products' AS table_name, COUNT(*) AS row_count
FROM raw.shopify_products_file;

\echo =========================
\echo SAMPLE CUSTOMERS
\echo =========================

SELECT * FROM raw.shopify_customers_file LIMIT 5;

\echo =========================
\echo SAMPLE ORDERS
\echo =========================

SELECT * FROM raw.shopify_orders_file LIMIT 5;

\echo =========================
\echo SAMPLE PRODUCTS
\echo =========================

SELECT * FROM raw.shopify_products_file LIMIT 5;