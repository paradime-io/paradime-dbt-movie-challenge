WITH source AS (
    SELECT 
        * 
    FROM       
        {{ source('ADDITIONAL_DATASETS', 'HULU_TITLES') }}

)

SELECT
    show_id,
    type,
    title,
    director,
    country,
    date_added::DATE,
    release_year,
    rating,
    duration,
    listed_in,
    description
FROM source