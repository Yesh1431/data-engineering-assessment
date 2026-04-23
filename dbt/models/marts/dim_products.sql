with products as (

    select * from {{ ref('stg_products') }}

)

select
    product_id,
    app_id,
    product_title,
    vendor,
    product_type,
    tags,
    options_json,
    variants_json,
    portable_extracted_at,
    admin_graphql_api_id
from products