-- Materialized as a table in Marts layer
{{ config(
    materialized='table'
) }}

with customers as (
    select * from {{ ref('int_customers_deduplicated') }}
),

orders as (
    select * from {{ ref('int_orders_joined_to_products') }}
),

customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(distinct order_id) as number_of_orders,
        coalesce(sum(total_order_amount), 0) as lifetime_value
    from orders
    group by 1
),

final as (
    select
        c.customer_key,
        c.customer_id,
        c.customer_name,
        c.email,
        c.city,
        c.country,
        coalesce(co.first_order_date, '1970-01-01') as first_order_date,
        coalesce(co.most_recent_order_date, '1970-01-01') as most_recent_order_date,
        coalesce(co.number_of_orders, 0) as number_of_orders,
        coalesce(co.lifetime_value, 0.0) as customer_lifetime_value,
        coalesce(co.lifetime_value, 0.0) as total_spent
    from customers c
    left join customer_orders co
        on c.customer_id = co.customer_id
)

select * from final
