-- macros/split_listed_in_to_rows.sql

{% macro split_listed_in_to_rows(column_name) %}
    LATERAL FLATTEN(input => SPLIT({{ column_name }}, ', ')) AS category
{% endmacro %}
