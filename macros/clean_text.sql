-- Turn empty strings and 'NaN' text into real NULLs
{% macro clean_text(col) -%}
    nullif(nullif(trim({{ col }}), ''), 'NaN')
{%- endmacro %}

-- Parse a date written either as D/M/YYYY or YYYY-MM-DD
{% macro parse_date(col) -%}
    case
        when {{ clean_text(col) }} ~ '^\d{1,2}/\d{1,2}/\d{4}$' then to_date({{ clean_text(col) }}, 'DD/MM/YYYY')
        when {{ clean_text(col) }} ~ '^\d{4}-\d{1,2}-\d{1,2}' then to_date(left({{ clean_text(col) }}, 10), 'YYYY-MM-DD')
    end
{%- endmacro %}

-- Cast text to numeric, stripping $ and thousands separators
{% macro to_num(col) -%}
    nullif(regexp_replace({{ clean_text(col) }}, '[^0-9.\-]', '', 'g'), '')::numeric
{%- endmacro %}
