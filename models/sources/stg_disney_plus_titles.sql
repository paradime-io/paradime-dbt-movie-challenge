WITH source AS (
    SELECT * FROM {{ source('ADDITIONAL_DATASETS', 'DISNEY_PLUS_TITLES') }}
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