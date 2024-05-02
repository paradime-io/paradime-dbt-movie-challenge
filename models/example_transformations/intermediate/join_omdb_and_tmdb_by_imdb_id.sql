WITH tmdb AS (
    SELECT
        imdb_id,
        tmdb_id,
        title,
        release_date,
        overview,
        tagline,
        keywords,
        genre_names,
        runtime,
        vote_average,
        revenue,
        budget
    FROM
        {{ ref('src_tmdb_movies') }}
), 

omdb AS (
    SELECT 
        imdb_id,
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
        {{ ref('src_omdb_movies') }}
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