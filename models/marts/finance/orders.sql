-- Materialized as a table in Marts layer
{{ config(
    materialized='table'
) }}

with orders as (
    select * from {{ ref('int_orders_joined_to_products') }}
),

customers as (
    select * from {{ ref('int_customers_deduplicated') }}
),

final as (
    select
        o.order_key,
        o.order_id,
        o.customer_id,
        c.customer_name,
        o.order_date,
        o.product_id,
        o.product_name,
        o.category,
        o.brand,
        o.quantity,
        o.unit_price,
        o.total_order_amount,
        o.payment_status,
        o.ingestion_timestamp,
        o.source_file_name
    from orders o
    left join customers c 
        on o.customer_id = c.customer_id
)

select * from final
