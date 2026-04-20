DROP VIEW IF EXISTS staging.stg_orders;
CREATE VIEW staging.stg_orders AS
SELECT
    "ID" AS order_id,
    "NAME" AS order_name,
    "NUMBER" AS order_number,
    "APP_ID" AS app_id,
    "EMAIL" AS customer_email,
    "PHONE" AS customer_phone,
    "CURRENCY" AS currency,
    "SOURCE_NAME" AS source_name,
    "FINANCIAL_STATUS" AS financial_status,
    "FULFILLMENT_STATUS" AS fulfillment_status,
    "TOTAL_TAX"::numeric AS total_tax,
    "TOTAL_PRICE"::numeric AS total_price,
    "SUBTOTAL_PRICE"::numeric AS subtotal_price,
    "TOTAL_DISCOUNTS"::numeric AS total_discounts,
    "CURRENT_TOTAL_TAX"::numeric AS current_total_tax,
    "CURRENT_TOTAL_PRICE"::numeric AS current_total_price,
    "CURRENT_SUBTOTAL_PRICE"::numeric AS current_subtotal_price,
    "TOTAL_LINE_ITEMS_PRICE"::numeric AS total_line_items_price,
    "TOTAL_OUTSTANDING"::numeric AS total_outstanding,
    "TOTAL_TIP_RECEIVED"::numeric AS total_tip_received,
    "TOTAL_WEIGHT"::numeric AS total_weight,
    "CONFIRMED" AS confirmed,
    "TEST" AS test,
    "TAXES_INCLUDED" AS taxes_included,
    "DUTIES_INCLUDED" AS duties_included,
    "TAX_EXEMPT" AS tax_exempt,

    CASE
        WHEN "CANCELLED_AT" IS NULL THEN NULL
        WHEN jsonb_typeof("CANCELLED_AT"::jsonb) = 'null' THEN NULL
        WHEN trim(both '"' from "CANCELLED_AT"::text) = '' THEN NULL
        ELSE trim(both '"' from "CANCELLED_AT"::text)::timestamp
    END AS cancelled_at,

    CASE
        WHEN "CLOSED_AT" IS NULL THEN NULL
        WHEN jsonb_typeof("CLOSED_AT"::jsonb) = 'null' THEN NULL
        WHEN trim(both '"' from "CLOSED_AT"::text) = '' THEN NULL
        ELSE trim(both '"' from "CLOSED_AT"::text)::timestamp
    END AS closed_at,

    trim(both '"' from "CREATED_AT"::text)::timestamp AS order_created_at,
    trim(both '"' from "UPDATED_AT"::text)::timestamp AS order_updated_at,
    trim(both '"' from "PROCESSED_AT"::text)::timestamp AS processed_at,

    "CUSTOMER"::jsonb AS customer_json,
    "LINE_ITEMS"::jsonb AS line_items_json,
    "REFUNDS"::jsonb AS refunds_json,
    "DISCOUNT_CODES"::jsonb AS discount_codes_json,
    "SHIPPING_LINES"::jsonb AS shipping_lines_json,
    "BILLING_ADDRESS"::jsonb AS billing_address_json,
    "SHIPPING_ADDRESS"::jsonb AS shipping_address_json,
    "NOTE" AS note,
    "TAGS" AS tags,
    "NOTE_ATTRIBUTES"::jsonb AS note_attributes_json,
    "BROWSER_IP" AS browser_ip,
    "LANDING_SITE" AS landing_site,
    "LANDING_SITE_REF" AS landing_site_ref,
    "REFERRING_SITE" AS referring_site,
    "ORDER_STATUS_URL" AS order_status_url,
    "_PORTABLE_EXTRACTED"::timestamp AS portable_extracted_at,
    "ADMIN_GRAPHQL_API_ID" AS admin_graphql_api_id
FROM raw.shopify_orders_file;