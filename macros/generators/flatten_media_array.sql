/*
    This macro takes an array from the 'media' model as an argument,
    flattens it, and outputs a flattened structure as a dbt model.

    Example usage:
        {{ flatten_media_array('production_countries', 'production_country') }}

    Example output:
        RECORD KEY                          PRODUCTION_COUNTRY
        46136120f93eef27e8894fabf404ef8b	United States
        d9f4b2d6e27fbf1518dd7903a5fe7a50	Belgium
        e8c6796c4597f8a5e3b8a2571110b3de	Brazil
        0000d80506b976cb31849258536316bc	Germany
        0000d80506b976cb31849258536316bc	United Kingdom
        0000d80506b976cb31849258536316bc	United States
*/


{% macro flatten_media_array(array_name, column_name) %}


    select distinct

        media.record_key                    as record_key,
        {{ column_name }}.value::string     as {{ column_name }}

    from {{ ref('media') }} as media

    inner join lateral flatten (input => media.{{ array_name }}) as {{ column_name }}


{% endmacro %}
