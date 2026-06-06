with source as (
    select * from {{ source('ecom', 'raw_customers') }}
),

renamed as (
    select
        customer_id as customer_id,
        customer_name as customer_name,
        email as email,
        city as city,
        country as country
    from source
)

select
    *,
    {{ audit_columns(source_file='raw_customers.csv') }}
from renamed
