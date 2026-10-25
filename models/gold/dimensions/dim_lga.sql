-- LGA dimension (SCD2, a single version per LGA)
select
    lga_code,
    lga_name,
    dbt_valid_from::date as valid_from,
    dbt_valid_to::date   as valid_to
from {{ ref('lga_snapshot') }}
