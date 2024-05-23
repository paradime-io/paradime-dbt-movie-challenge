WITH split_values AS (
    SELECT
        IMDB_ID,
        ACTORS,
        {{split_on_comma('ACTORS')}}
    FROM 
        {{ref('omdb_join_tmdb')}}
)

SELECT *
FROM split_values
where ACTORS is not null and ACTORS <> 'N/A'
ORDER BY IMDB_ID
