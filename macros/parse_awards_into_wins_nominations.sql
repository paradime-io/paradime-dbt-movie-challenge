{% macro parse_awards(awards_column) %}

CASE
    WHEN {{ awards_column }} LIKE '%win%' THEN
        TRY_CAST(REGEXP_SUBSTR({{ awards_column }}, '\\d+', 1, 1) AS INTEGER)
    ELSE 0
END AS wins,
CASE
    WHEN {{ awards_column }} LIKE '%nomination%' THEN
        TRY_CAST(REGEXP_SUBSTR({{ awards_column }}, '\\d+', 1,
            CASE 
                WHEN {{ awards_column }} LIKE '%win%' THEN 2 
                ELSE 1 
            END) AS INTEGER)
    ELSE 0
END AS nominations
{% endmacro %}
