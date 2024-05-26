WITH source AS (
    SELECT 
        *
    FROM
        {{ source('MOVIE_EXPANDED', 'CPI') }}
)

, renamed AS (
    SELECT 
        YEAR AS calendar_year
        , JAN
        , FEB
        , MAR
        , APR
        , MAY
        , JUN
        , JUL
        , AUG
        , SEP
        , OCT
        , NOV
        , DEC
    FROM 
        source

)

SELECT
    *
FROM
    renamed