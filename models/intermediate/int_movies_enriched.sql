
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
        vote_count,
        revenue,
        budget,
        original_title, 
        original_language, 
        status, 
        video,
        homepage,
        poster_path,
        backdrop_path,
        belongs_to_collection,
        spoken_languages,
        production_company_names,
        production_country_names
    FROM
        {{ ref('stg_tmdb_movies') }}
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
        box_office,
        genre,
        language,
        country,
        type,
        plot,
        ratings,
        released_date,
        release_year,
        poster,
        website
    FROM
        {{ ref('stg_omdb_movies') }}
), 

joined AS (
    SELECT
        tmdb.imdb_id,
        tmdb.tmdb_id,
        tmdb.title,
        tmdb.release_date,
        tmdb.overview,
        tmdb.tagline,
        tmdb.keywords,
        tmdb.genre_names,
        tmdb.runtime,
        tmdb.vote_average,
        tmdb.vote_count,
        tmdb.revenue,
        tmdb.budget,
        tmdb.original_title, 
        tmdb.original_language, 
        tmdb.status, 
        tmdb.video,
        omdb.director,
        omdb.writer,
        omdb.actors,
        omdb.awards,
        omdb.production,
        omdb.dvd,
        omdb.rated,
        omdb.metascore,
        omdb.imdb_rating,
        omdb.imdb_votes,
        omdb.box_office,
        omdb.genre,
        omdb.language,
        omdb.country,
        omdb.type,
        omdb.plot,
        omdb.released_date,
        omdb.release_year,
        omdb.poster
    FROM
        tmdb
    INNER JOIN
        omdb ON tmdb.imdb_id = omdb.imdb_id
)

SELECT
    *
FROM
    joined
order by vote_count desc