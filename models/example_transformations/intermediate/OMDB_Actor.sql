WITH split_values AS (
    SELECT
        IMDB_ID,
        ACTORS,
        {{split_on_comma('ACTORS')}}
    FROM 
        {{ref('cleaned_omdb_movies')}}
)

SELECT *
FROM split_values
ORDER BY IMDB_ID