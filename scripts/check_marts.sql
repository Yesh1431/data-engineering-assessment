\echo =========================
\echo MARTS OBJECTS
\echo =========================

\dv marts.*

\echo =========================
\echo FACT ORDERS COUNT
\echo =========================

SELECT COUNT(*) AS fact_orders_count
FROM marts.fact_orders;

\echo =========================
\echo SALES SUMMARY SAMPLE
\echo =========================

SELECT *
FROM marts.sales_summary
ORDER BY order_month, financial_status, fulfillment_status
LIMIT 10;

\echo =========================
\echo CUSTOMER ORDER SUMMARY SAMPLE
\echo =========================

SELECT *
FROM marts.customer_order_summary
ORDER BY lifetime_value DESC
LIMIT 10;