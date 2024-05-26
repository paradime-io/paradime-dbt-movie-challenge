WITH all_nominations AS (
    SELECT
        movie_name_year
        , award
        , COUNT(*) AS total_nominations
    FROM
        {{ ref('int_awards_categories_normalize') }}
    GROUP BY
        movie_name_year
        , award
),

total_wins AS (
    SELECT
        movie_name_year,
        award,
        COUNT(*) AS total_wins
    FROM
        {{ ref('int_awards_categories_normalize') }}
    WHERE 
        winner = TRUE
    GROUP BY
        movie_name_year,
        award
),

movie_budget AS (
    SELECT DISTINCT
        CONCAT(an.movie, ' (', an.year_film, ')') AS movie_name_year
        , inf.budget
        , inf.imdb_id
    FROM
        {{ ref('int_awards_categories_normalize') }} an
    LEFT JOIN 
        {{ ref('int_budget_inflation_normalize') }} inf ON inf.title = an.movie
    INNER JOIN
        {{ ref('stg_omdb_movies') }} omdb ON omdb.imdb_id = inf.imdb_id
    WHERE 
        omdb.release_year = an.year_film
)

SELECT 
    an.movie_name_year
    , an.award
    , an.total_nominations
    , COALESCE(tw.total_wins, 0) AS total_wins
    , COALESCE(tw.total_wins, 0) / an.total_nominations AS win_rate
    , mb.budget
FROM 
    all_nominations an
LEFT JOIN 
    total_wins tw ON tw.movie_name_year = an.movie_name_year
LEFT JOIN
    movie_budget mb ON mb.movie_name_year = an.movie_name_year