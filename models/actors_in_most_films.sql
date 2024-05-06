WITH 

actor_films AS (
    SELECT
        TRIM(f.value) AS actor,
        COUNT(DISTINCT TITLE) AS number_of_films
    FROM
        {{ ref('stg_omdb_movies') }},
        LATERAL FLATTEN(input => SPLIT(ACTORS, ', ')) AS f
    WHERE
        actor <> 'N/A'  -- Exclude entries where the actor is 'N/A'
    GROUP BY
        TRIM(f.value)
)

SELECT 
    *
FROM 
    actor_films
ORDER BY 
    number_of_films DESC
