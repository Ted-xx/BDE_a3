{% snapshot property_snapshot %}
{{
    config(
        target_schema='silver',
        unique_key='listing_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}
-- Property entity decomposed from the listings table (one row per listing):
-- the descriptive attributes of the listing that can change over time.
select distinct on (listing_id)
    listing_id,
    property_type,
    room_type,
    accommodates,
    listing_neighbourhood,
    month_year::timestamp as updated_at
from {{ ref('silver_listings') }}
order by listing_id, scraped_date desc
{% endsnapshot %}
