-- Host dimension (SCD2). host_neighbourhood is mapped to its LGA through the
-- suburb dimension; if the value is already an LGA name it is used directly.
-- valid_from / valid_to are month starts; valid_to NULL = current version.
select
    h.host_id,
    h.host_name,
    h.host_since,
    h.host_is_superhost,
    h.host_neighbourhood,
    coalesce(s.lga_name, l.lga_name)  as host_neighbourhood_lga,
    h.dbt_valid_from::date            as valid_from,
    h.dbt_valid_to::date              as valid_to
from {{ ref('host_snapshot') }} h
left join {{ ref('dim_suburb') }} s
       on h.host_neighbourhood = s.suburb_name and s.valid_to is null
left join {{ ref('dim_lga') }} l
       on h.host_neighbourhood = l.lga_name and l.valid_to is null
