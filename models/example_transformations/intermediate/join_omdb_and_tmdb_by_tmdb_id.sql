WITH tmdb AS (
    SELECT
        tmdb_id,
        title,
        release_date,
        overview,
        genre_names,
        tagline,
        keywords,
        runtime,
        vote_average,
        revenue,
        budget
    FROM
        {{ ref('stg_tmdb_movies') }}
), 

omdb AS (
    SELECT 
        tmdb_id,
        director,
        writer,
        actors,
        awards,
        production,
        dvd,
        rated,
        metascore,
        imdb_rating,
        imdb_votes,
        box_office
    FROM
        {{ ref('stg_omdb_movies') }}
), 

joined AS (
    SELECT
        tmdb.tmdb_id,
        tmdb.title,
        tmdb.release_date,
        tmdb.overview,
        tmdb.genre_names,
        tmdb.tagline,
        tmdb.keywords,
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
        omdb ON tmdb.tmdb_id = omdb.tmdb_id
)

SELECT
    *
FROM
    joined
WHERE 1=1