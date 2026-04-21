CREATE SCHEMA IF NOT EXISTS marts;

DROP VIEW IF EXISTS marts.dim_customers;
CREATE VIEW marts.dim_customers AS
SELECT
    customer_id,
    app_id,
    tags,
    customer_created_at,
    portable_extracted_at,
    admin_graphql_api_id
FROM staging.stg_customers;

DROP VIEW IF EXISTS marts.dim_products;
CREATE VIEW marts.dim_products AS
SELECT
    product_id,
    app_id,
    product_title,
    vendor,
    product_type,
    tags,
    portable_extracted_at,
    admin_graphql_api_id
FROM staging.stg_products;

DROP VIEW IF EXISTS marts.fact_orders;
CREATE VIEW marts.fact_orders AS
SELECT
    order_id,
    order_name,
    order_number,
    app_id,
    customer_email,
    customer_phone,
    currency,
    source_name,
    financial_status,
    fulfillment_status,
    total_tax,
    total_price,
    subtotal_price,
    total_discounts,
    current_total_tax,
    current_total_price,
    current_subtotal_price,
    total_line_items_price,
    total_outstanding,
    total_tip_received,
    total_weight,
    confirmed,
    test,
    taxes_included,
    duties_included,
    tax_exempt,
    cancelled_at,
    closed_at,
    order_created_at,
    order_updated_at,
    processed_at,
    portable_extracted_at,
    admin_graphql_api_id
FROM staging.stg_orders;

DROP VIEW IF EXISTS marts.sales_summary;
CREATE VIEW marts.sales_summary AS
SELECT
    date_trunc('month', order_created_at) AS order_month,
    financial_status,
    fulfillment_status,
    COUNT(*) AS order_count,
    ROUND(SUM(total_price), 2) AS total_revenue,
    ROUND(AVG(total_price), 2) AS avg_order_value,
    ROUND(SUM(total_discounts), 2) AS total_discounts,
    ROUND(SUM(total_tax), 2) AS total_tax
FROM staging.stg_orders
GROUP BY 1, 2, 3;

DROP VIEW IF EXISTS marts.customer_order_summary;
CREATE VIEW marts.customer_order_summary AS
SELECT
    customer_email,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_price), 2) AS lifetime_value,
    ROUND(AVG(total_price), 2) AS avg_order_value,
    MIN(order_created_at) AS first_order_at,
    MAX(order_created_at) AS last_order_at
FROM staging.stg_orders
WHERE customer_email IS NOT NULL
GROUP BY customer_email;