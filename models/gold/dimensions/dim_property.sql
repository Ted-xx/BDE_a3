-- Property / listing dimension (SCD2): type, room, capacity and neighbourhood
select
    listing_id,
    property_type,
    room_type,
    accommodates,
    listing_neighbourhood,
    dbt_valid_from::date as valid_from,
    dbt_valid_to::date   as valid_to
from {{ ref('property_snapshot') }}
