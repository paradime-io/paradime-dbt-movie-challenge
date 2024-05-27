select 
    imdb_id,
    title,
    actor,
    imdb_rating
FROM {{ ref('actors_split') }}
