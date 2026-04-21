with source as (

    select * from {{ source('raw', 'shopify_customers_file') }}

),

renamed as (

    select
        "ID" as customer_id,
        "TAGS" as tags,
        "CREATED_AT" as created_at_raw,
        "UPDATED_AT" as updated_at_raw,
        "EMAIL" as email,
        "FIRST_NAME" as first_name,
        "LAST_NAME" as last_name,
        "ORDERS_COUNT" as orders_count,
        "STATE" as state,
        "TOTAL_SPENT" as total_spent,
        "VERIFIED_EMAIL" as verified_email,
        _airbyte_extracted_at,
        "_AIRBYTE_RAW_ID" as airbyte_raw_id,
        "_AIRBYTE_META" as airbyte_meta,
        "_AIRBYTE_GENERATION_ID" as airbyte_generation_id
    from source

)

select * from renamed