-- Singular Test: Asserts that total_order_amount in orders mart must always be positive.
-- Fails if any row returns where total_order_amount is negative.
select
    order_id,
    total_order_amount
from {{ ref('orders') }}
where total_order_amount < 0
