with staged_customers as (
    select * from {{ ref('stg_ecom__customers') }}
),

deduplicated as (
    select
        customer_id,
        customer_name,
        email,
        city,
        country,
        ingestion_timestamp,
        source_file_name,
        row_number() over (
            partition by customer_id 
            order by ingestion_timestamp desc
        ) as rn
    from staged_customers
)

select
    {{ generate_surrogate_key(['customer_id']) }} as customer_key,
    customer_id,
    initcap(trim(customer_name)) as customer_name,
    lower(trim(coalesce(email, 'n/a'))) as email,
    trim(coalesce(city, 'Unknown')) as city,
    trim(coalesce(country, 'Unknown')) as country,
    ingestion_timestamp,
    source_file_name
from deduplicated
where rn = 1
