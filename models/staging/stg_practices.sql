{{ config(
    materialized='view',
    tags=['practice_expansion']
) }}

select
    upper(trim(practice_id)) as practice_id,
    trim(practice_name) as practice_name,
    trim(region) as region
from {{ ref('practices') }}