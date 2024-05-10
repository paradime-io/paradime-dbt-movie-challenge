SELECT 
    O.TITLE, 
    T.REVENUE, 
    T.BUDGET,
    T.REVENUE - T.BUDGET AS ROI,
    ROUND((T.REVENUE - T.BUDGET)/T.BUDGET*100, 2) AS ROI_PERCENT 
FROM 
    {{ ref('stg_omdb_movies') }} AS O
INNER JOIN 
    {{ ref('stg_tmdb_movies') }} AS T
ON
    O.IMDB_ID = T.IMDB_ID
WHERE 
    T.RELEASE_DATE < CURRENT_DATE 
    AND REVENUE <> 0
    AND BUDGET <> 0