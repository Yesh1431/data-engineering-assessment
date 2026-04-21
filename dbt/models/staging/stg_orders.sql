with source as (

    select * from {{ source('raw', 'shopify_orders_file') }}

),

renamed as (

    select
        "ID" as order_id,
        "EMAIL" as email,
        "NAME" as order_name,
        "ORDER_NUMBER"::bigint as order_number,
        "CUSTOMER"->>'ID' as customer_id,
        "CURRENCY" as currency,
        "FINANCIAL_STATUS" as financial_status,
        "FULFILLMENT_STATUS" as fulfillment_status,
        "TOTAL_PRICE"::numeric(18,2) as total_price,
        "SUBTOTAL_PRICE"::numeric(18,2) as subtotal_price,
        "TOTAL_TAX"::numeric(18,2) as total_tax,
        "TOTAL_DISCOUNTS"::numeric(18,2) as total_discounts,
        "CREATED_AT"::bigint as created_at_epoch,
        to_timestamp("CREATED_AT"::bigint) as created_at_utc,
        case
            when "CANCELLED_AT" is null then null
            else ("CANCELLED_AT"#>>'{}')::timestamp
        end as cancelled_at,
        "_PORTABLE_EXTRACTED"::timestamp as portable_extracted_at,
        _airbyte_extracted_at,
        _airbyte_raw_id,
        _airbyte_meta,
        _airbyte_generation_id
    from source

)

select * from renamed