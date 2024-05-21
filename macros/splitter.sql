
{% macro split_on_comma(column_name) %}
  split({{ column_name }}, ',')[0]::text as val_1,
  split({{ column_name }}, ',')[1]::text as val_2,
  split({{ column_name }}, ',')[2]::text as val_3,
  split({{ column_name }}, ',')[3]::text as val_rest
{% endmacro %}
