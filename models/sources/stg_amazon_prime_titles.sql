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
    TRY_TO_DATE(date_added) AS date_added_converted, -- Correct use of 'AS' for function result aliasing
    release_year,
    rating,
    duration,
    listed_in,
    description
FROM source