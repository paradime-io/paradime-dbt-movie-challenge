WITH movie_data AS (
    SELECT
        O.IMDB_ID,
        O.TITLE,
        O.DIRECTOR,
        O.WRITER,
        O.IMDB_VOTES,
        O.IMDB_RATING,
        {{ calculate_awards('o.awards') }}
    FROM
        {{ ref('stg_omdb_movies') }} AS o 
)
,

movie_financials AS (
        SELECT 
            T.IMDB_ID,
            T.BUDGET,
            T.REVENUE,
            T.REVENUE - T.BUDGET AS ROI
        FROM 
            {{ ref('stg_tmdb_movies') }} AS t
        WHERE 
        T.RELEASE_DATE < CURRENT_DATE 
        AND T.REVENUE <> 0
        AND T.BUDGET <> 0
        AND O.IMDB_VOTES > 10
)

,

movies_with_financials AS (
    SELECT 


)

,

movies_with_financials_and_genre AS(

)


SELECT * 
FROM
    movies_with_financials_and_genre
