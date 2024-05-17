WITH clean_movies AS (
    SELECT * FROM {{ ref('clean_movies') }}
)

SELECT
    tmdb_id,
    --  release_date,
    release_year,
    C.value::string AS genre_name
FROM 
    clean_movies,
LATERAL FLATTEN(input=>split(genre_names, ', ')) C
WHERE
    (release_year IS NOT NULL) AND
    (release_year < 2025)
ORDER BY release_date DESC
