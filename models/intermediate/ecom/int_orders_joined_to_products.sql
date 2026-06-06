with staged_orders as (
    select * from {{ ref('stg_ecom__orders') }}
),

staged_products as (
    select * from {{ ref('stg_ecom__products') }}
),

deduplicated as (
    select
        order_id,
        customer_id,
        order_date,
        product_id,
        quantity,
        unit_price,
        payment_status,
        ingestion_timestamp,
        source_file_name,
        row_number() over (
            partition by order_id, product_id 
            order by ingestion_timestamp desc
        ) as rn
    from staged_orders
    where order_id is not null
),

joined as (
    select
        -- Generate surrogate key representing grain (order line item)
        {{ generate_surrogate_key(['o.order_id', 'o.product_id']) }} as order_key,
        o.order_id,
        o.customer_id,
        coalesce(o.order_date, cast(o.ingestion_timestamp as date)) as order_date,
        o.product_id,
        p.product_name,
        p.category,
        p.brand,
        coalesce(o.quantity, 0) as quantity,
        coalesce(o.unit_price, 0.0) as unit_price,
        -- Calculated derived metric
        (coalesce(o.quantity, 0) * coalesce(o.unit_price, 0.0)) as total_order_amount,
        -- Standardize text columns
        upper(coalesce(o.payment_status, 'UNKNOWN')) as payment_status,
        o.ingestion_timestamp,
        o.source_file_name
    from deduplicated o
    left join staged_products p 
        on o.product_id = p.product_id
    where o.rn = 1
)

select * from joined
