WITH source AS (
    SELECT 
        year_film
        , year_ceremony
        , category
        , nominee
        , movie
        , winner
        , award
    FROM 
        {{ source('MOVIE_EXPANDED', 'MOVIE_AWARDS') }}
)

, filtered AS (
    SELECT
        *
    FROM
        source
    WHERE
        movie IS NOT NULL
)

SELECT 
    *
FROM
    filtered