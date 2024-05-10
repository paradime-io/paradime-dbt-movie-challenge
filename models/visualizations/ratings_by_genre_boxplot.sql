SELECT
    imdb_id,
    genre,
    imdb_rating
FROM 
    {{ ref('join_tmdb_omdb') }}
WHERE 
    imdb_rating is not null

