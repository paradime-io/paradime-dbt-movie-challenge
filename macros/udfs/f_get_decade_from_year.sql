{% macro create_f_get_decade_from_year() %}

    create or replace function {{target.schema}}.f_get_decade_from_year("calendar_year" number)
        returns string
        language sql
        comment = 'Returns the decade a year is in from the year number'
    as
    $$

        CONCAT(LEFT(TO_VARCHAR(calendar_year), 3), '0s')
            

    $$

{% endmacro %}