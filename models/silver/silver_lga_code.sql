-- LGA code -> name, names upper-cased to match listings and suburb mapping
select
    {{ clean_text('lga_code') }}::int     as lga_code,
    upper({{ clean_text('lga_name') }})   as lga_name
from {{ source('bronze', 'raw_lga_code') }}
where {{ clean_text('lga_code') }} is not null
