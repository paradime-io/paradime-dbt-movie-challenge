WITH split_values AS (
    SELECT
        IMDB_ID,
        WRITER,
        {{split_on_comma('WRITER')}}
    FROM 
        {{ref('cleaned_omdb_movies')}}
)

SELECT *
FROM split_values
ORDER BY IMDB_ID