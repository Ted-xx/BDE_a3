-- Fact table: one row per listing per month. Only keys and metrics.
--   number_of_stays   = 30 - availability_30 (active listings only)
--   estimated_revenue = number_of_stays * price (active listings only)
select
    f.listing_id,
    f.host_id,
    l.lga_code                                     as listing_lga_code,
    f.scraped_date,
    f.month_year,
    f.price,
    f.has_availability,
    f.availability_30,
    f.number_of_reviews,
    f.review_scores_rating,
    case when f.has_availability = 't' then 30 - f.availability_30 end            as number_of_stays,
    case when f.has_availability = 't' then (30 - f.availability_30) * f.price end as estimated_revenue
from {{ ref('silver_listings') }} f
left join {{ ref('silver_lga_code') }} l
       on f.listing_neighbourhood = l.lga_name
