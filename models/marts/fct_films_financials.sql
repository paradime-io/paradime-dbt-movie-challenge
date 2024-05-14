SELECT 
    O.TITLE, 
    T.REVENUE, 
    T.BUDGET,
    T.REVENUE - T.BUDGET AS ROI,
    ROUND((T.REVENUE - T.BUDGET)/T.BUDGET*100, 2) AS ROI_PERCENT 
FROM 
    {{ ref('int_join_tmdb_imdb') }} 
WHERE 
    T.RELEASE_DATE < CURRENT_DATE 
    AND REVENUE <> 0
    AND BUDGET <> 0