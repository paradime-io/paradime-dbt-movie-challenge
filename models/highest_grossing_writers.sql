WITH revenue_data AS (
    SELECT 
        TRIM(f.value) AS writer,
        SUM(T.REVENUE) AS total_revenue
    FROM 
        {{ ref('stg_omdb_movies') }} AS O
    INNER JOIN 
        {{ ref('stg_tmdb_movies') }} AS T
    ON
        O.IMDB_ID = T.IMDB_ID
    CROSS JOIN 
        TABLE(FLATTEN(input => SPLIT(O.WRITER, ', '))) AS f
    WHERE 
        T.RELEASE_DATE < CURRENT_DATE
        AND T.REVENUE <> 0
    GROUP BY 
        TRIM(f.value)
)

SELECT *
FROM revenue_data
ORDER BY total_revenue DESc