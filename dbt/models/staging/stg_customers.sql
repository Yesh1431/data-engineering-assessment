with source as (

    select * from {{ source('raw', 'shopify_customers_file') }}

),

renamed as (

    select
        "ID" as customer_id,
        "APP_ID" as app_id,
        "TAGS" as tags,
        "ADDRESSES" as addresses_json,
        "CREATED_AT" as customer_created_at_epoch,
        to_timestamp("CREATED_AT") as customer_created_at,
        "_PORTABLE_EXTRACTED"::timestamp as portable_extracted_at,
        "ADMIN_GRAPHQL_API_ID" as admin_graphql_api_id
    from source

)

select * from renamed