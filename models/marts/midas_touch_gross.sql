WITH writers_directors_gross AS (
    SELECT 
        dw.name AS name
        , dw.role
        , MEDIAN(omdb.summarized_worldwide_gross_inflation_adjusted) AS median_worldwide_gross
        , COUNT(*) AS movie_count
    FROM
        {{ ref('int_flattened_directors_writers') }} dw
    INNER JOIN
        {{ ref('int_aggregated_inflation_adjusted_gross') }} omdb ON omdb.imdb_id = dw.imdb_id
    GROUP BY
        dw.name
        , dw.role
)

/*
The threshold of 5 is applied to filter out writers who appear in a small number of movies, 
ensuring that a reliable median can be calculated. For instance, in cases like "Gone with the Wind", 
where a director or writer is associated with only one movie, their median could be misleadingly high. 
Applying a threshold of 5 ensures more meaningful results.
*/

SELECT 
    * 
FROM 
    writers_directors_gross