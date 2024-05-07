WITH movie_data AS (
    SELECT
        O.TITLE,
        O.DIRECTOR,
        O.WRITER,
        O.IMDB_RATING,
        O.IMBD_VOTES AS IMDB_VOTES,  -- Fixed potential typo in column name
        CASE
            WHEN O.AWARDS LIKE '%win%' THEN
                TRY_CAST(REGEXP_SUBSTR(O.AWARDS, '[0-9]+', 1, 1) AS INTEGER)
            ELSE 0
        END AS wins,
        CASE
            WHEN O.AWARDS LIKE '%nomination%' THEN
                TRY_CAST(REGEXP_SUBSTR(O.AWARDS, '[0-9]+', 1, 
                    CASE 
                        WHEN O.AWARDS LIKE '%win%' THEN 2 
                        ELSE 1 
                    END) AS INTEGER)
            ELSE 0
        END AS nominations,
        T.BUDGET,
        T.REVENUE,
        T.REVENUE - T.BUDGET AS ROI
    FROM 
        {{ ref('STG_OMDB_MOVIES') }} AS O
    INNER JOIN 
        {{ ref('STG_TMDB_MOVIES') }} AS T
        ON O.IMDB_ID = T.IMDB_ID
    WHERE 
        T.RELEASE_DATE < CURRENT_DATE 
        AND T.REVENUE <> 0
        AND T.BUDGET <> 0
        AND O.IMDB_VOTES > 10
)

SELECT * FROM movie_data -- Ensure you add this line to select from your CTE
