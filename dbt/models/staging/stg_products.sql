with source as (

    select * from {{ source('raw', 'shopify_products_file') }}

),

renamed as (

    select
        "ID" as product_id,
        "APP_ID" as app_id,
        "TITLE" as product_title,
        "VENDOR" as vendor,
        "PRODUCT_TYPE" as product_type,
        "TAGS" as tags,
        "OPTIONS" as options_json,
        "VARIANTS" as variants_json,
        "_PORTABLE_EXTRACTED"::timestamp as portable_extracted_at,
        "ADMIN_GRAPHQL_API_ID" as admin_graphql_api_id
    from source

)

select * from renamed