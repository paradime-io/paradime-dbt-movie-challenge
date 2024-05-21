WITH split_values AS (
    SELECT
        IMDB_ID,
        GENRE,
        {{split_on_comma('GENRE')}}
    FROM 
        {{ref('cleaned_omdb_movies')}}
)

SELECT *
FROM split_values
ORDER BY IMDB_ID