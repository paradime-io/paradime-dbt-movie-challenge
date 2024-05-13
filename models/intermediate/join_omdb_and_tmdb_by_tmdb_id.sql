WITH 

tmdb AS (
    SELECT
        tmdb_id,
        title,
        t_release_date,
        genre_names,
        tagline,
        keywords,
        runtime,
        vote_average,
        revenue,
        budget,
        status
    FROM {{ ref('stg_tmdb_movies') }}
), 

omdb AS (
    SELECT 
        IMDB_ID,
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
    FROM {{ ref('stg_omdb_movies') }}
), 

joined AS (
    SELECT
        tmdb.tmdb_id,
        tmdb.title,
        tmdb.t_release_date,
        tmdb.genre_names,
        tmdb.tagline,
        tmdb.keywords,
        tmdb.runtime,
        tmdb.vote_average,
        tmdb.revenue,
        tmdb.budget,
        tmdb.status,
        omdb.IMDB_ID,
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
    FROM tmdb
    inner JOIN omdb using (tmdb_id)
)

SELECT *
FROM joined
-- tmdb data points are entered by users, sometimes, repeatedly 
-- so we need to exclude possible duplicates by no particular criteria
QUALIFY ROW_NUMBER() OVER (PARTITION BY imdb_id ORDER BY tmdb_id) = 1
