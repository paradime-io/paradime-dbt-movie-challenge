SELECT
    imdb_rating
FROM 
    {{ ref('join_tmdb_omdb') }}

