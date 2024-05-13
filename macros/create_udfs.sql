{% macro create_udfs() %}

    create schema if not exists {{target.schema}}

    {% do run_query(create_f_concat_lists_get_distinct()) %}

    {% do run_query(create_f_concat_lists_get_min()) %}

    {% do run_query(create_f_concat_lists_get_max()) %}

    
{% endmacro %}