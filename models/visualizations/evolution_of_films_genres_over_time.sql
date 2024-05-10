SELECT
    CAST(CONCAT(RELEASE_YEAR, '-01-01') AS DATE) AS release_date,
    GENRE,
    COUNT(IMDB_ID) as count,
    ROUND(AVG(IMDB_RATING),2) AS avg_rating
FROM 
    {{ ref('join_tmdb_omdb') }}
WHERE
    GENRE <> 'N/A'