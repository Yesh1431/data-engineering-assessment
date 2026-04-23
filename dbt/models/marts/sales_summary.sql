select
    date(order_created_at) as order_date,
    count(*) as total_orders,
    sum(total_price) as total_sales,
    avg(total_price) as avg_order_value
from {{ ref('fact_orders') }}
group by 1
order by 1