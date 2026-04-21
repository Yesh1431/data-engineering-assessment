select
    customer_id,
    app_id,
    tags,
    admin_graphql_api_id,
    created_at_epoch,
    created_at_utc,
    portable_extracted_at,
    addresses,
    _airbyte_extracted_at
from {{ ref('stg_customers') }}