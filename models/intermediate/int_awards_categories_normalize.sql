WITH categories_normalize AS (
    SELECT 
        year_film
        , year_ceremony
        ,
            CASE 
                WHEN category = 'ACTOR' THEN 'ACTOR IN A LEADING ROLE'
                WHEN category = 'ACTRESS' THEN 'ACTRESS IN A LEADING ROLE'
                WHEN category = 'BEST MOTION PICTURE' THEN 'BEST PICTURE'
                ELSE category
            END AS category
        , nominee
        , movie
        , CONCAT(movie, ' (', year_film, ')')  AS movie_name_year
        , winner
        , award
    FROM 
        {{ ref('stg_movie_awards') }}
)

SELECT 
    * 
FROM 
    categories_normalize