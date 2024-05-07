WITH movie_data AS (
    SELECT
        O.IMDB_ID
        O.TITLE,
        O.DIRECTOR,
        O.WRITER,
        O.IMDB_VOTES,
        O.IMDB_RATING,
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
        {{ ref('stg_omdb_movies') }} AS O
    INNER JOIN 
        {{ ref('stg_tmdb_movies') }} AS T
        ON O.IMDB_ID = T.IMDB_ID
    WHERE 
        T.RELEASE_DATE < CURRENT_DATE 
        AND T.REVENUE <> 0
        AND T.BUDGET <> 0
        AND O.IMDB_VOTES > 10
        AND NOMINATIONS > 0
)

SELECT * FROM movie_data