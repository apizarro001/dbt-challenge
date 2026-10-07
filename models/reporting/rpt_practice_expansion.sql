{{ config(
    materialized='table',
    tags=['practice_expansion']
) }}

select
    revenue.practice_id,
    practices.practice_name,
    practices.region,
    revenue.revenue_month,
    revenue.monthly_revenue,
    revenue.previous_month_revenue,
    revenue.revenue_change,
    revenue.revenue_change_type
from {{ ref('mdl_practice_revenue_change') }} as revenue
left join {{ ref('stg_practices') }} as practices
    on revenue.practice_id = practices.practice_id