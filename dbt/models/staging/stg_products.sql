with source as (

    select * from {{ source('raw', 'shopify_products_file') }}

),

renamed as (

    select
        "ID" as product_id,
        "TITLE" as title,
        "VENDOR" as vendor,
        "PRODUCT_TYPE" as product_type,
        "TAGS" as tags,
        "OPTIONS" as options,
        "VARIANTS" as variants,
        "APP_ID" as app_id,
        "ADMIN_GRAPHQL_API_ID" as admin_graphql_api_id,
        "_PORTABLE_EXTRACTED"::timestamp as portable_extracted_at,
        "_AIRBYTE_EXTRACTED_AT" as airbyte_extracted_at,
        "_AIRBYTE_RAW_ID" as airbyte_raw_id,
        "_AIRBYTE_META" as airbyte_meta,
        "_AIRBYTE_GENERATION_ID" as airbyte_generation_id
    from source

)

select * from renamed