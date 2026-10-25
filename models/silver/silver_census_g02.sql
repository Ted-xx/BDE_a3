-- Census 2016 G02 (Selected Medians and Averages) at LGA level, typed.
-- LGA_CODE_2016 'LGA10050' -> integer 10050 so it joins to the LGA code mapping.
select
    replace(lga_code_2016, 'LGA', '')::int as lga_code,
    {{ to_num('median_age_persons') }} as median_age_persons,
    {{ to_num('median_mortgage_repay_monthly') }} as median_mortgage_repay_monthly,
    {{ to_num('median_tot_prsnl_inc_weekly') }} as median_tot_prsnl_inc_weekly,
    {{ to_num('median_rent_weekly') }} as median_rent_weekly,
    {{ to_num('median_tot_fam_inc_weekly') }} as median_tot_fam_inc_weekly,
    {{ to_num('average_num_psns_per_bedroom') }} as average_num_psns_per_bedroom,
    {{ to_num('median_tot_hhd_inc_weekly') }} as median_tot_hhd_inc_weekly,
    {{ to_num('average_household_size') }} as average_household_size
from {{ source('bronze', 'raw_census_g02') }}
