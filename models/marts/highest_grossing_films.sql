WITH grossing_films AS (
    SELECT 
        gr.imdb_id,
        omdb.title,
        gr.summarized_domestic_gross_inflation_adjusted,
        gr.summarized_international_gross_inflation_adjusted,
        gr.summarized_worldwide_gross_inflation_adjusted
    FROM
        {{ ref('int_aggregated_inflation_adjusted_gross') }} gr
    INNER JOIN
        {{ ref('stg_omdb_movies') }} omdb ON omdb.imdb_id = gr.imdb_id
)

SELECT
    *
FROM
    grossing_films