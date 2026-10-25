-- Suburb -> LGA name mapping (used to turn host_neighbourhood into an LGA)
select distinct
    upper({{ clean_text('suburb_name') }}) as suburb_name,
    upper({{ clean_text('lga_name') }})    as lga_name
from {{ source('bronze', 'raw_lga_suburb') }}
where {{ clean_text('suburb_name') }} is not null
