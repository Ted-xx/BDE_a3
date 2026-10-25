{% snapshot lga_snapshot %}
{{
    config(
        target_schema='silver',
        unique_key='lga_code',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}
-- LGA entity. The mapping file has no change date, so the 2016 Census date is used
-- as the timestamp: every LGA has one version valid for the whole period.
select
    lga_code,
    lga_name,
    '2016-08-09'::timestamp as updated_at
from {{ ref('silver_lga_code') }}
{% endsnapshot %}
