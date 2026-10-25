-- Cleaned and typed Airbnb listings (one row per listing per monthly scrape)
-- Fixes: text -> proper types, 'NaN'/'' -> NULL, D/M/YYYY dates, upper-cased
-- neighbourhood names so they join to the LGA / suburb mappings.
with src as (
    select * from {{ source('bronze', 'raw_listings') }}
)
select
    {{ clean_text('listing_id') }}::bigint                     as listing_id,
    {{ clean_text('scrape_id') }}::bigint                      as scrape_id,
    {{ parse_date('scraped_date') }}                           as scraped_date,
    -- every listing is attributed to the month it was scraped in
    date_trunc('month', {{ parse_date('scraped_date') }})::date as month_year,
    {{ clean_text('host_id') }}::bigint                        as host_id,
    {{ clean_text('host_name') }}                              as host_name,
    {{ parse_date('host_since') }}                             as host_since,
    coalesce({{ clean_text('host_is_superhost') }}, 'f')       as host_is_superhost,
    upper({{ clean_text('host_neighbourhood') }})              as host_neighbourhood,
    upper({{ clean_text('listing_neighbourhood') }})           as listing_neighbourhood,
    {{ clean_text('property_type') }}                          as property_type,
    {{ clean_text('room_type') }}                              as room_type,
    {{ to_num('accommodates') }}::int                          as accommodates,
    {{ to_num('price') }}                                      as price,
    coalesce({{ clean_text('has_availability') }}, 'f')        as has_availability,
    {{ to_num('availability_30') }}::int                       as availability_30,
    {{ to_num('number_of_reviews') }}::int                     as number_of_reviews,
    {{ to_num('review_scores_rating') }}                       as review_scores_rating,
    {{ to_num('review_scores_accuracy') }}                     as review_scores_accuracy,
    {{ to_num('review_scores_cleanliness') }}                  as review_scores_cleanliness,
    {{ to_num('review_scores_checkin') }}                      as review_scores_checkin,
    {{ to_num('review_scores_communication') }}                as review_scores_communication,
    {{ to_num('review_scores_value') }}                        as review_scores_value
from src
where {{ clean_text('listing_id') }} is not null
  and {{ parse_date('scraped_date') }} is not null
