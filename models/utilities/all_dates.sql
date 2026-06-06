{{ config(
    materialized='view'
) }}

-- Generates a 10-year date spine using Snowflake generator functions
with generator as (
    select row_number() over (order by null) - 1 as row_num
    from table(generator(rowcount => 3650))
),

date_spine as (
    select
        dateadd('day', row_num, cast('2025-01-01' as date)) as date_day
    from generator
)

select
    date_day,
    date_trunc('month', date_day) as date_month,
    date_trunc('year', date_day) as date_year,
    extract(dayofweek from date_day) as day_of_week,
    extract(dayofyear from date_day) as day_of_year
from date_spine
where date_day <= dateadd('year', 1, current_date())
