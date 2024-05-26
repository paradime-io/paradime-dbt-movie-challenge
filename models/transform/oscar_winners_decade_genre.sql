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
    concat(gs.decade,'s') as decade,
    gs.genre,
    ref.vibe,
    COUNT(*) AS count
FROM GenreSplit gs
left join {{ ref('stg_genre_vibes') }} ref on gs.genre = ref.genre
GROUP BY gs.decade, gs.genre, ref.vibe
ORDER BY gs.decade