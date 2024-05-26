WITH total_gross AS (
    SELECT 
        imdb_id
        , SUM(summarized_worldwide_gross_inflation_adjusted) AS worldwide
    FROM 
        {{ ref('int_aggregated_inflation_adjusted_gross') }}
    GROUP BY
        imdb_id
)

, roi_data AS (
    SELECT
        tmdb.title
        , tmdb.imdb_id
        , tmdb.budget
        , tmdb.adjusted_budget
        , tg.worldwide
        , ROUND(((tg.worldwide - tmdb.adjusted_budget) / tmdb.adjusted_budget) * 100, 0) AS roi_percentage
    FROM
        {{ ref('int_budget_inflation_normalize') }} tmdb
    INNER JOIN 
        total_gross tg ON tg.imdb_id = tmdb.imdb_id
)

SELECT 
    * 
FROM 
    roi_data
