WITH source AS (
    SELECT *
    FROM 
        {{ source('ADDITIONAL_DATASETS', 'AMAZON_PRIME_TITLES') }}
)

SELECT
    show_id,
    type,
    title,
    director,
    country,
    date_added,
    release_year,
    rating,
    duration,
    listed_in,
    description
FROM source