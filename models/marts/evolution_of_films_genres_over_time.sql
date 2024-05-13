SELECT
    CAST(CONCAT(RELEASE_YEAR, '-01-01') AS DATE) AS release_date,
    GENRE,
    IMDB_ID,
    IMDB_RATING
FROM 
    {{ ref('join_tmdb_omdb') }}
WHERE
    GENRE <> 'N/A'