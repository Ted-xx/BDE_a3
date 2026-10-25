-- Datamart: metrics per property_type, room_type, accommodates and month.
-- Same SCD2 join logic and metric definitions as dm_listing_neighbourhood.
with base as (
    select
        f.*,
        p.property_type,
        p.room_type,
        p.accommodates,
        h.host_is_superhost
    from {{ ref('fact_listings') }} f
    join {{ ref('dim_property') }} p
      on f.listing_id = p.listing_id
     and f.month_year >= p.valid_from
     and f.month_year <  coalesce(p.valid_to, '9999-12-31')
    left join {{ ref('dim_host') }} h
      on f.host_id = h.host_id
     and f.month_year >= h.valid_from
     and f.month_year <  coalesce(h.valid_to, '9999-12-31')
),
agg as (
    select
        property_type,
        room_type,
        accommodates,
        month_year,
        count(*) filter (where has_availability = 't')                       as active_listings,
        count(*) filter (where has_availability <> 't')                      as inactive_listings,
        round(100.0 * count(*) filter (where has_availability = 't')
              / nullif(count(*), 0), 2)                                      as active_listing_rate,
        min(price) filter (where has_availability = 't')                     as min_price,
        max(price) filter (where has_availability = 't')                     as max_price,
        percentile_cont(0.5) within group (order by price)
            filter (where has_availability = 't')                            as median_price,
        round(avg(price) filter (where has_availability = 't'), 2)           as avg_price,
        count(distinct host_id)                                              as distinct_hosts,
        round(100.0 * count(distinct host_id) filter (where host_is_superhost = 't')
              / nullif(count(distinct host_id), 0), 2)                       as superhost_rate,
        round(avg(review_scores_rating) filter (where has_availability = 't'), 2)
                                                                             as avg_review_scores_rating,
        sum(number_of_stays)                                                 as total_stays,
        round(avg(estimated_revenue) filter (where has_availability = 't'), 2)
                                                                             as avg_estimated_revenue_per_active_listing
    from base
    group by property_type, room_type, accommodates, month_year
)
select
    property_type,
    room_type,
    accommodates,
    month_year,
    active_listing_rate,
    min_price,
    max_price,
    median_price,
    avg_price,
    distinct_hosts,
    superhost_rate,
    avg_review_scores_rating,
    round(100.0 * (active_listings - lag(active_listings) over w)
          / nullif(lag(active_listings) over w, 0), 2)                       as pct_change_active_listings,
    round(100.0 * (inactive_listings - lag(inactive_listings) over w)
          / nullif(lag(inactive_listings) over w, 0), 2)                     as pct_change_inactive_listings,
    total_stays,
    avg_estimated_revenue_per_active_listing
from agg
window w as (partition by property_type, room_type, accommodates order by month_year)
order by property_type, room_type, accommodates, month_year
