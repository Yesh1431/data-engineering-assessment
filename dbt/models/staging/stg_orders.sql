with source as (

    select * from {{ source('raw', 'shopify_orders_file') }}

),

renamed as (

    select
        "ID" as order_id,
        "CUSTOMER"->>'ID' as customer_id,
        "EMAIL" as email,
        "NAME" as order_name,
        "ORDER_NUMBER"::bigint as order_number,
        "CURRENCY" as currency,
        "FINANCIAL_STATUS" as financial_status,
        "FULFILLMENT_STATUS" as fulfillment_status,
        "TOTAL_PRICE"::numeric(18,2) as total_price,
        "SUBTOTAL_PRICE"::numeric(18,2) as subtotal_price,
        "TOTAL_TAX"::numeric(18,2) as total_tax,
        "TOTAL_DISCOUNTS"::numeric(18,2) as total_discounts,
        "CREATED_AT"::timestamp as created_at_utc,
        "UPDATED_AT"::timestamp as updated_at_utc,
        case
            when "CANCELLED_AT" is null or "CANCELLED_AT" = '' then null
            else "CANCELLED_AT"::timestamp
        end as cancelled_at,
        case
            when "PROCESSED_AT" is null or "PROCESSED_AT" = '' then null
            else "PROCESSED_AT"::timestamp
        end as processed_at,
        "LINE_ITEMS" as line_items,
        "_AIRBYTE_EXTRACTED_AT" as airbyte_extracted_at,
        "_AIRBYTE_RAW_ID" as airbyte_raw_id,
        "_AIRBYTE_META" as airbyte_meta,
        "_AIRBYTE_GENERATION_ID" as airbyte_generation_id
    from source

)

select * from renamed