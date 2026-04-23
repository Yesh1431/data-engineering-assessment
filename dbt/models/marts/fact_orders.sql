with orders as (

    select * from {{ ref('stg_orders') }}

)

select
    order_id,
    order_name,
    app_id,
    customer_json ->> 'ID' as customer_id,
    email,
    currency,
    total_price,
    subtotal_price,
    total_tax,
    total_discounts,
    financial_status,
    fulfillment_status,
    order_number,
    order_created_at,
    order_updated_at,
    processed_at,
    cancelled_at,
    customer_json,
    line_items_json,
    portable_extracted_at,
    admin_graphql_api_id
from orders