WITH split_values AS (
    SELECT
        IMDB_ID,
        GENRE,
        {{split_on_comma('GENRE')}}
    FROM 
        {{ref('omdb_join_tmdb')}}
)

SELECT *
FROM split_values
where GENRE is not null and GENRE <> 'N/A'
ORDER BY IMDB_ID