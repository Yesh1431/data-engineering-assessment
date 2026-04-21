select
    customer_id,
    count(*) as total_orders,
    sum(total_price) as lifetime_value,
    min(created_at_utc) as first_order_at,
    max(created_at_utc) as last_order_at
from {{ ref('fact_orders') }}
where customer_id is not null
group by 1
order by lifetime_value desc