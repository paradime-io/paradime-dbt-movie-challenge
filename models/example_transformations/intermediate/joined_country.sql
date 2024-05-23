WITH split_values AS (
    SELECT
        IMDB_ID,
        COUNTRY,
        {{split_on_comma('COUNTRY')}}
    FROM 
        {{ref('omdb_join_tmdb')}}
)

SELECT *
FROM split_values
where COUNTRY is not null and COUNTRY <> 'N/A'
ORDER BY IMDB_ID