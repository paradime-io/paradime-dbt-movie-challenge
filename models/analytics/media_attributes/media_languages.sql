-- depends_on: {{ ref('media') }}

{{ config(tags=['lightdash']) }}


/*
    Using a custom dbt macro called 'flatten_media_array()' to uphold the DRY
    principle in the codebase. This macro efficiently handles repeated array
    flattening operations for various arrays in the 'media' model.
*/

with final as (
    {{ flatten_media_array('languages', 'language') }}
)

select * from final
