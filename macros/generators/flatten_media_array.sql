/*
    This macro takes an array from the 'media' model as an argument,
    flattens it, and outputs a flattened structure as a dbt model.

    Example usage:
        {{ flatten_media_array('production_countries', 'production_country') }}

    Example output:
        IMDB_ID	    TMDB_ID	  PRODUCTION_COUNTRY
        tt0411234	51345	  Malta
        tt0198668	277302	  United Kingdom
        tt5805056	433460	  United States
        tt5805056	433460	  United Kingdom
*/


{% macro flatten_media_array(array_name, column_name) %}


    select distinct

        media.record_key                    as record_key,
        {{ column_name }}.value::string     as {{ column_name }}

    from {{ ref('media') }} as media

    inner join lateral flatten (input => media.{{ array_name }}) as {{ column_name }}


{% endmacro %}
