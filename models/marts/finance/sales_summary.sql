-- Materialized as a table in Marts layer
{{ config(
    materialized='table'
) }}

with orders as (
    select * from {{ ref('int_orders_joined_to_products') }}
),

sales as (
    select
        order_date as sales_day,
        date_trunc('month', order_date) as sales_month,
        sum(total_order_amount) as total_sales,
        count(distinct order_id) as total_orders,
        round(
            sum(total_order_amount) / nullif(count(distinct order_id), 0), 
            2
        ) as average_order_value
    from orders
    group by 1, 2
)

select * from sales
order by sales_day desc
