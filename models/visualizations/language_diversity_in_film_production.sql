SELECT
    GENRE,
    ORIGINAL_LANGUAGE,
    COUNT(IMDB_ID) as count,
    ROUND(AVG(IMDB_RATING),2) AS avg_rating
FROM 
    {{ ref('join_tmdb_omdb') }}
GROUP BY
    GENRE,
    ORIGINAL_LANGUAGE    