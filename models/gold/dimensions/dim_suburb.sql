-- Suburb dimension (SCD2, a single version per suburb) with its LGA
select
    suburb_name,
    lga_name,
    dbt_valid_from::date as valid_from,
    dbt_valid_to::date   as valid_to
from {{ ref('suburb_snapshot') }}
