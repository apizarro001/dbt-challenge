{{ config(
    materialized='view',
    tags=['practice_expansion']
) }}

select
    upper(trim(practice_id)) as practice_id,
    cast(revenue_month as date) as revenue_month,
    cast(monthly_revenue as decimal(18, 2)) as monthly_revenue
from {{ ref('practice_revenue') }}