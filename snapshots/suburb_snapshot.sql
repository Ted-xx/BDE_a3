{% snapshot suburb_snapshot %}
{{
    config(
        target_schema='silver',
        unique_key='suburb_name',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}
-- Suburb entity (suburb -> LGA). Same constant timestamp as lga_snapshot.
select
    suburb_name,
    lga_name,
    '2016-08-09'::timestamp as updated_at
from {{ ref('silver_lga_suburb') }}
{% endsnapshot %}
