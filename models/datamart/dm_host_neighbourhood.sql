-- Datamart: metrics per host_neighbourhood_lga (host suburb mapped to its LGA) and month.
-- SCD2 join on dim_host so each month uses the host's neighbourhood at that time.
with base as (
    select
        f.*,
        h.host_neighbourhood_lga
    from {{ ref('fact_listings') }} f
    join {{ ref('dim_host') }} h
      on f.host_id = h.host_id
     and f.month_year >= h.valid_from
     and f.month_year <  coalesce(h.valid_to, '9999-12-31')
    where h.host_neighbourhood_lga is not null
)
select
    host_neighbourhood_lga,
    month_year,
    count(distinct host_id)                                                  as distinct_hosts,
    round(avg(estimated_revenue) filter (where has_availability = 't'), 2)   as avg_estimated_revenue_per_active_listing,
    -- total estimated revenue of active listings / distinct hosts
    round(sum(estimated_revenue) / nullif(count(distinct host_id), 0), 2)    as estimated_revenue_per_host
from base
group by host_neighbourhood_lga, month_year
order by host_neighbourhood_lga, month_year
