select
    customer_id,
    email,
    first_name,
    last_name,
    created_at,
    updated_at,
    orders_count,
    state,
    total_spent,
    verified_email,
    tags,
    airbyte_extracted_at
from {{ ref('stg_customers') }}