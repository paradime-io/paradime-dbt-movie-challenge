WITH dim_franchise AS (
    SELECT
        FRANCHISE_ID,
        franchise_name        
    FROM
        {{ ref('stg_imdb_franchise') }}
), 

dim_releases AS (
    SELECT 
    FROM
        {{ ref('stg_omdb_movies') }}
), 

joined AS (
    SELECT
        tmdb.imdb_id,
        tmdb.title,
        tmdb.release_date,
        tmdb.overview,
        tmdb.tagline,
        tmdb.keywords,
        tmdb.genre_names,
        tmdb.runtime,
        tmdb.vote_average,
        tmdb.revenue,
        tmdb.budget,
        omdb.director,
        omdb.writer,
        omdb.actors,
        omdb.awards,
        omdb.production,
        omdb.dvd,
        omdb.imdb_rating,
        omdb.metascore,
        omdb.imdb_votes,
        omdb.box_office
    FROM
        tmdb
    LEFT JOIN
        omdb ON tmdb.imdb_id = omdb.imdb_id
)

SELECT
    *
FROM
    joined