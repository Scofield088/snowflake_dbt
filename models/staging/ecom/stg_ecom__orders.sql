with source as (
    select * from {{ source('ecom', 'raw_orders') }}
),

renamed as (
    select
        order_id as order_id,
        customer_id as customer_id,
        order_date as order_date,
        product_id as product_id,
        cast(quantity as integer) as quantity,
        cast(unit_price as decimal(10,2)) as unit_price,
        payment_status as payment_status
    from source
)

select
    *,
    {{ audit_columns(source_file='raw_orders.csv') }}
from renamed
