SELECT
    t.GENRE,
    lc.Language AS Language,
    COUNT(t.IMDB_ID) AS count,
    ROUND(AVG(t.IMDB_RATING), 2) AS avg_rating
FROM 
    {{ ref('join_tmdb_omdb') }} t
JOIN 
    {{ ref('language_codes') }} lc
ON 
    t.ORIGINAL_LANGUAGE = lc.ISO_code
GROUP BY
    t.GENRE,
    t.ORIGINAL_LANGUAGE,
    lc.Language
