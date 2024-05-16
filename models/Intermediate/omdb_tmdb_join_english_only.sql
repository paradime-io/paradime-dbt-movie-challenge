WITH tmdb AS (
    SELECT
        imdb_id,
        tmdb_id,
        title,
        release_date,
        genre_names,
        vote_average,
        vote_count,
        revenue,
        budget
    FROM
        {{ ref('stg_tmdb_movies') }}
    where original_language='en'
), 

omdb AS (
    SELECT 
        imdb_id,
        metascore,
        imdb_rating,
        imdb_votes,
        box_office,
        release_year
    FROM
        {{ ref('stg_omdb_movies') }}
), 

joined AS (
    SELECT
        tmdb.imdb_id,
        tmdb.tmdb_id,
        tmdb.title,
        tmdb.release_date,
        tmdb.genre_names,
        tmdb.vote_average,
        tmdb.vote_count,
        tmdb.revenue,
        tmdb.budget,
        omdb.metascore,
        omdb.imdb_rating,
        omdb.imdb_votes,
        omdb.box_office,
        omdb.release_year
    FROM
        tmdb
    LEFT JOIN
        omdb ON tmdb.imdb_id = omdb.imdb_id
)

SELECT
    *
FROM
    joined