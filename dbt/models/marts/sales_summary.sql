select
    date(created_at_utc) as order_date,
    count(*) as total_orders,
    sum(total_price) as gross_sales,
    sum(subtotal_price) as subtotal_sales,
    sum(total_tax) as total_tax,
    sum(total_discounts) as total_discounts
from {{ ref('fact_orders') }}
group by 1
order by 1