WITH movies_data AS (
    SELECT
        O.IMDB_ID AS IMDB_ID,
        O.TITLE AS TITLE,
        O.DIRECTOR AS DIRECTOR,
        O.WRITER AS WRITER,
        O.RELEASE_YEAR AS RELEASE_YEAR,
        O.IMDB_VOTES AS IMDB_VOTES,
        O.IMDB_RATING AS IMDB_RATING,
        {{ parse_awards('o.awards') }}
    FROM
        {{ ref('stg_omdb_movies') }} AS o 
    WHERE
        O.IMDB_VOTES > 10
)
,
movies_financials AS (
    SELECT 
        T.IMDB_ID AS IMDB_ID,
        T.BUDGET AS BUDGET,
        T.REVENUE AS REVENUE,
        T.REVENUE - T.BUDGET AS ROI
    FROM 
        {{ ref('stg_tmdb_movies') }} AS t
    WHERE 
        T.RELEASE_DATE < CURRENT_DATE 
        AND T.REVENUE <> 0
        AND T.BUDGET <> 0
)
,
movies_data_with_financials AS (
    SELECT
        md.IMDB_ID AS IMDB_ID,
        md.TITLE AS TITLE,
        md.DIRECTOR AS DIRECTOR,
        md.WRITER AS WRITER,
        md.RELEASE_YEAR AS RELEASE_YEAR,
        md.IMDB_VOTES AS IMDB_VOTES,
        md.IMDB_RATING AS IMDB_RATING,
        md.WINS AS WINS,
        md.NOMINATIONS AS NOMINATIONS,
        mf.BUDGET AS BUDGET,
        mf.REVENUE AS REVENUE,
        mf.ROI AS ROI
    FROM 
        movies_data AS md
    LEFT JOIN 
        movies_financials AS mf
    ON 
        md.IMDB_ID = mf.IMDB_ID
)

SELECT * FROM movies_data_with_financials
