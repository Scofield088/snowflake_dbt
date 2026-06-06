with source as (
    select * from {{ source('ecom', 'raw_products') }}
),

renamed as (
    select
        product_id as product_id,
        product_name as product_name,
        category as category,
        brand as brand
    from source
)

select
    *,
    {{ audit_columns(source_file='raw_products.csv') }}
from renamed
