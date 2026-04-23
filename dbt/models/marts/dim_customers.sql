select
    customer_id,
    app_id,
    tags,
    addresses_json,
    customer_created_at_epoch,
    customer_created_at,
    portable_extracted_at,
    admin_graphql_api_id
from {{ ref('stg_customers') }}