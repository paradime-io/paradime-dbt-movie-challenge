WITH source AS (
    SELECT 
        concat('tt', IMDBID) as IMDB_ID,
        rating as bechdel_rating,
        title,
        year as release_year
    FROM 
        {{ source('ADDITIONAL_SOURCE_DATA', 'MOVIES_BECHDEL_TEST') }}
)

SELECT 
    * 
FROM 
    source
