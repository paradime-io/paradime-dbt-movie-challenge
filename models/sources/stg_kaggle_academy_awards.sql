WITH source AS (
    SELECT 
        film_title,
        awards_year,
        awards_won as count_awards_won,
        nominations as count_nominations
    FROM 
        {{ source('ADDITIONAL_SOURCE_DATA', 'KAGGLE_ACADEMY_AWARDS') }}
)

SELECT 
    * 
FROM 
    source
