{% macro get_month_number(colum_name) %}
case
    when {{ colum_name }} = 'JAN' then 1
    when {{ colum_name }} = 'FEB' then 2
    when {{ colum_name }} = 'MAR' then 3
    when {{ colum_name }} = 'APR' then 4
    when {{ colum_name }} = 'MAY' then 5
    when {{ colum_name }} = 'JUN' then 6
    when {{ colum_name }} = 'JUL' then 7
    when {{ colum_name }} = 'AUG' then 8
    when {{ colum_name }} = 'SEP' then 9
    when {{ colum_name }} = 'OCT' then 10
    when {{ colum_name }} = 'NOV' then 11
    when {{ colum_name }} = 'DEC' then 12
    else -1 -- to indicate data issue
end
{% endmacro %}
