with source as (

    select * from {{ source('raw', 'shopify_customers_file') }}

),

renamed as (

    select
        "ID" as customer_id,
        "APP_ID" as app_id,
        "TAGS" as tags,
        "ADMIN_GRAPHQL_API_ID" as admin_graphql_api_id,
        "CREATED_AT"::bigint as created_at_epoch,
        to_timestamp("CREATED_AT"::bigint) as created_at_utc,
        "_PORTABLE_EXTRACTED"::timestamp as portable_extracted_at,
        "ADDRESSES" as addresses,
        _airbyte_extracted_at,
        _airbyte_raw_id,
        _airbyte_meta,
        _airbyte_generation_id
    from source

)

select * from renamed