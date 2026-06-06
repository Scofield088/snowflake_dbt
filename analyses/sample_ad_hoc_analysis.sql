-- Ad-hoc analysis: Compiles using refs but is not written to the database.
-- Selects top customer spenders from the marts layer.
select
    customer_id,
    customer_name,
    customer_lifetime_value
from {{ ref('customers') }}
where customer_lifetime_value > 500
order by customer_lifetime_value desc
