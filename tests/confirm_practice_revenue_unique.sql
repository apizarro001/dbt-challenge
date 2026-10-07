select
    practice_id,
    revenue_month,
    count(*) as record_count
from {{ ref('practice_revenue') }}
group by
    practice_id,
    revenue_month
having count(*) > 1