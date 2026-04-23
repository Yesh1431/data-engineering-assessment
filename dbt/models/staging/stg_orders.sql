with source as (

    select * from {{ source('raw', 'shopify_orders_file') }}

),

renamed as (

    select
        "ID" as order_id,
        "NAME" as order_name,
        "APP_ID" as app_id,
        "EMAIL" as email,
        "CURRENCY" as currency,
        "TOTAL_PRICE"::numeric as total_price,
        "SUBTOTAL_PRICE"::numeric as subtotal_price,
        "TOTAL_TAX"::numeric as total_tax,
        "TOTAL_DISCOUNTS"::numeric as total_discounts,
        "FINANCIAL_STATUS" as financial_status,
        "FULFILLMENT_STATUS" as fulfillment_status,
        "ORDER_NUMBER" as order_number,
        "CREATED_AT"::timestamp as order_created_at,
        "UPDATED_AT"::timestamp as order_updated_at,
        "PROCESSED_AT"::timestamp as processed_at,
        case
            when "CANCELLED_AT" is null then null
            when "CANCELLED_AT"::text in ('""', 'null') then null
            else replace("CANCELLED_AT"::text, '"', '')::timestamp
        end as cancelled_at,
        "CUSTOMER" as customer_json,
        "LINE_ITEMS" as line_items_json,
        "_PORTABLE_EXTRACTED"::timestamp as portable_extracted_at,
        "ADMIN_GRAPHQL_API_ID" as admin_graphql_api_id
    from source

)

select * from renamed