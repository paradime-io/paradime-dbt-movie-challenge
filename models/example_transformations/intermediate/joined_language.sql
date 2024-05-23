WITH split_values AS (
    SELECT
        IMDB_ID,
        LANGUAGE,
        {{split_on_comma('LANGUAGE')}}
    FROM 
        {{ref('omdb_join_tmdb')}}
)

SELECT *
FROM split_values
where LANGUAGE is not null and LANGUAGE <> 'N/A'
ORDER BY IMDB_ID
