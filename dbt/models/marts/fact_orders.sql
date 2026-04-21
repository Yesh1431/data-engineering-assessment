select
    order_id,
    customer_id,
    order_name,
    order_number,
    currency,
    financial_status,
    fulfillment_status,
    total_price,
    subtotal_price,
    total_tax,
    total_discounts,
    created_at_utc,
    updated_at_utc,
    cancelled_at,
    processed_at
from {{ ref('stg_orders') }}