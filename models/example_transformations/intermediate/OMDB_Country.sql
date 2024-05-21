WITH split_values AS (
    SELECT
        IMDB_ID,
        COUNTRY,
        {{split_on_comma('COUNTRY')}}
    FROM 
        {{ref('cleaned_omdb_movies')}}
)

SELECT *
FROM split_values
ORDER BY IMDB_ID