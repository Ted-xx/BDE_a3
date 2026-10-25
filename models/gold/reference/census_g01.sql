-- Census 2016 G01 reference table for the Gold layer, with the LGA name attached
select
    l.lga_name,
    c.*
from {{ ref('silver_census_g01') }} c
left join {{ ref('silver_lga_code') }} l on c.lga_code = l.lga_code
