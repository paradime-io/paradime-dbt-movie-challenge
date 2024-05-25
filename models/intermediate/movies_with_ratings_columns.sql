 WITH ratings_rows AS (
    SELECT 
        --  identifier_unique_key,
        imdb_id,
        title,
        ratings,
        TO_VARCHAR(ARRAY_AGG(flat_inner_array.value)[0]) AS RATING_SOURCE,
		TO_VARCHAR(ARRAY_AGG(flat_inner_array.value)[1]) AS RATING_VALUE
    FROM
        {{ ref('all_movies_combined_columns')}} as combined,
            LATERAL flatten(INPUT => combined.ratings) AS flat_outer_array,
            LATERAL FLATTEN(INPUT => flat_outer_array.value) AS flat_inner_array
        GROUP BY imdb_id, title, ratings, flat_outer_array.INDEX
        ORDER BY title, flat_outer_array.INDEX        
),

ratings_columns AS (
    SELECT 
        *
    FROM ratings_rows
    PIVOT (MAX(RATING_VALUE) FOR RATING_SOURCE IN ('Internet Movie Database', 'Rotten Tomatoes', 'Metacritic')) 
        AS p (imdb_id, title, ratings, imdb_rating, rotten_tomatoes_rating, metacritic_rating)
)

 select 
    *
from 
    ratings_columns