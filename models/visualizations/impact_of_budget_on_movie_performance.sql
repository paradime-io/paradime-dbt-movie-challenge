SELECT 
    TITLE,
    DIRECTOR,
    BUDGET,
    REVENUE,
    IMDB_RATING,
    IMDB_VOTES
FROM 
    {{ ref('join_tmdb_omdb') }}
WHERE
    BUDGET IS NOT NULL
    AND REVENUE IS NOT NULL
    AND IMDB_RATING IS NOT NULL
    AND IMDB_VOTES > 1000 -- Arbitrary treshold to accept a rating.