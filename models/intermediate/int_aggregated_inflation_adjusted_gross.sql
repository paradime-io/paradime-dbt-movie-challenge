WITH aggregated_gross AS (
    SELECT 
        imdb_id
        , ROUND(SUM(adjusted_domestic_gross), 0) AS summarized_domestic_gross_inflation_adjusted
        , ROUND(SUM(adjusted_international_gross), 0) AS summarized_international_gross_inflation_adjusted
        , ROUND(SUM(adjusted_worldwide_gross), 0) AS summarized_worldwide_gross_inflation_adjusted
    FROM 
        {{ ref('int_releases_inflation_normalize') }}
    GROUP BY
        imdb_id
)

SELECT 
    *
FROM 
    aggregated_gross