select
    product_id,
    title,
    vendor,
    product_type,
    tags,
    options,
    variants,
    app_id,
    admin_graphql_api_id,
    portable_extracted_at,
    _airbyte_extracted_at
from {{ ref('stg_products') }}