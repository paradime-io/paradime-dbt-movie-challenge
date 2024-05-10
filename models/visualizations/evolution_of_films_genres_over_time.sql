SELECT
    RELEASE_YEAR,
    GENRE,
    COUNT(IMDB_ID) as count,
    ROUND(AVG(IMDB_RATING),2) AS avg_rating
FROM 
    {{ ref('join_tmdb_omdb') }}
GROUP BY
    RELEASE_YEAR,
    GENRE    