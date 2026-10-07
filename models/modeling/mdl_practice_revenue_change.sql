{{ config(
    materialized='table',
    tags=['practice_expansion']
) }}

with previous_revenue as (

    select
        practice_id,
        revenue_month,
        monthly_revenue,
        lag(monthly_revenue) over (
            partition by practice_id
            order by revenue_month
        ) as previous_month_revenue
    from {{ ref('stg_practice_revenue') }}

)

select
    practice_id,
    revenue_month,
    monthly_revenue,
    previous_month_revenue,
    monthly_revenue - previous_month_revenue as revenue_change,
    case
        when previous_month_revenue is null then 'First observed month'
        when monthly_revenue > previous_month_revenue then 'Expansion'
        when monthly_revenue < previous_month_revenue then 'Contraction'
        else 'Unchanged'
    end as revenue_change_type
from previous_revenue