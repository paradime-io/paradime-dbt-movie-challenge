SELECT
    *
FROM {{ ref('join_omdb_and_tmdb_by_imdb_id') }}