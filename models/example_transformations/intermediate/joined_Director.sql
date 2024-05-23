WITH split_values AS (
    SELECT
        IMDB_ID,
        DIRECTOR,
        {{split_on_comma('DIRECTOR')}}
    FROM 
        {{ref('omdb_join_tmdb')}}
)

SELECT *
FROM split_values
where DIRECTOR is not null and DIRECTOR <> 'N/A'
ORDER BY IMDB_ID