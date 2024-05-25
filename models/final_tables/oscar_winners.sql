WITH GenreSplit AS (
    SELECT 
        imdb_id,
        EXTRACT(YEAR FROM released_date) - EXTRACT(YEAR FROM released_date) % 10 AS decade,
        TRIM(genre_value.VALUE::STRING) AS genre
    FROM {{ ref('stg_omdb_movies') }},
    LATERAL FLATTEN(INPUT => SPLIT(genre, ',')) AS genre_value
    WHERE awards LIKE 'Won%Oscar%'
        AND released_date IS NOT NULL
)

SELECT 
    decade,
    genre,
    COUNT(*) AS count
FROM GenreSplit
GROUP BY decade, genre
ORDER BY decade