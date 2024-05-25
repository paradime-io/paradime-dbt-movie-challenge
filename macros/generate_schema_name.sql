{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

        
    {{ default_schema | trim }}_{{ custom_schema_name | trim }}  

{%- endmacro %}