WITH source AS (
    SELECT 
        *
    FROM 
        {{ ref('top_100_actors') }}
)

SELECT 
    * 
FROM 
    source