WITH split_values AS (
    SELECT
        IMDB_ID,
        LANGUAGE,
        {{split_on_comma('LANGUAGE')}}
    FROM 
        {{ref('cleaned_omdb_movies')}}
)

SELECT *
FROM split_values
ORDER BY IMDB_ID