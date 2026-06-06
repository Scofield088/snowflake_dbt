{% snapshot customer_snapshot %}

{{
    config(
      target_database=target.database,
      target_schema=target.schema,
      unique_key='customer_id',
      strategy='check',
      check_cols=['customer_name', 'email', 'city', 'country'],
    )
}}

-- Pulls from intermediate layer to track customer details over time (SCD Type 2)
select
    customer_id,
    customer_name,
    email,
    city,
    country
from {{ ref('int_customers_deduplicated') }}

{% endsnapshot %}
