{% snapshot host_snapshot %}
{{
    config(
        target_schema='silver',
        unique_key='host_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}
-- Host entity decomposed from the listings table.
-- One row per host: its most recent scrape. updated_at = the month of that scrape,
-- so every monthly load creates a new SCD2 version valid from that month.
select distinct on (host_id)
    host_id,
    host_name,
    host_since,
    host_is_superhost,
    host_neighbourhood,
    month_year::timestamp as updated_at
from {{ ref('silver_listings') }}
where host_id is not null
order by host_id, scraped_date desc, listing_id
{% endsnapshot %}
