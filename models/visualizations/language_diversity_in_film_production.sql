SELECT
    RELEASE_YEAR,
    GENRE,
    COUNT(IMDB_ID),
    ROUND(AVG(IMDB_RATING),2)
FROM 
    {{ ref('join_tmdb_omdb') }}
GROUP BY
    RELEASE_YEAR,
    GENRE    