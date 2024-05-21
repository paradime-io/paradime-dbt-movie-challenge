WITH split_values AS (
    SELECT
        IMDB_ID,
        DIRECTOR,
        {{split_on_comma('DIRECTOR')}}
    FROM 
        {{ref('cleaned_omdb_movies')}}
)

SELECT *
FROM split_values
ORDER BY IMDB_ID