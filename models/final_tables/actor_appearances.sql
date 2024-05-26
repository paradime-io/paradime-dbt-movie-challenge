select 
    imdb_id,
    title,
    actor
FROM {{ ref('actors_split') }}
