WITH source AS (
    SELECT 
        concat('tt', IMDBID) as IMDB_ID,
        rating as bechdel_rating,
        title,
        year as release_year
    FROM 
        {{ source('ADDITIONAL_SOURCE_DATA', 'MOVIES_BECHDEL_TEST') }}
),

-- If an IMDB_ID appears more than once, take the row with the higher bechdel rating.
-- Let's be generous!
deduplicated as (
    SELECT 
        IMDB_ID,
        bechdel_rating,
        title,
        release_year
    FROM
        source
    QUALIFY ROW_NUMBER() OVER (
            PARTITION BY IMDB_ID
            ORDER BY bechdel_rating desc
        ) = 1
)

SELECT 
    * 
FROM 
    deduplicated
