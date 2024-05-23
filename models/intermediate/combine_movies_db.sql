WITH tmdb AS (
    SELECT
        imdb_id,
        tmdb_id,
        title,
        release_date,
        overview,
        tagline,
        keywords,
        original_language,
        spoken_languages,
        genre_names,
        runtime,
        vote_average,
        revenue,
        budget,
        status,
        video,
        production_company_names,
        production_country_names,
        vote_count
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
        runtime,
        metascore,
        imdb_rating,
        imdb_votes,
        box_office,
        plot,
        language,
        country,
        release_year,
        released_date
    FROM
        {{ ref('stg_omdb_movies') }}
),

joined AS (
    SELECT
        tmdb.imdb_id,
        tmdb.tmdb_id,
        tmdb.title as tmdb_title,
        tmdb.status,
        tmdb.overview,
        tmdb.tagline,
        tmdb.keywords,
        tmdb.video,
        tmdb.genre_names,
        tmdb.revenue,
        tmdb.budget,
        omdb.rated as OMDB_RATED,
        omdb.director as omdb_director,
        omdb.writer as omdb_writer,
        omdb.actors as omdb_actors,
        omdb.plot as omdb_plot,
        tmdb.original_language as tmdb_original_language,
        tmdb.spoken_languages as tmdb_spoken_language,
        omdb.language as omdb_language,
        omdb.country as omdb_country,
        omdb.awards as omdb_awards,
        tmdb.production_company_names as tmdb_production_company,
        tmdb.production_country_names as tmdb_production_country,
        omdb.production as omdb_production,
        omdb.dvd as omdb_dvd,
        tmdb.release_date as tmdb_release_date,
        omdb.release_year as omdb_release_year,
        omdb.released_date as omdb_release_date,
        tmdb.runtime as tmdb_runtime,
        omdb.runtime as omdb_runtime,
        tmdb.vote_average as tmdb_vote_average,
        tmdb.vote_count as tmdb_vote_count,
        omdb.metascore as omdb_metascore,
        omdb.imdb_rating as omdb_ratings,
        omdb.imdb_votes as omdb_votes,
        omdb.box_office as omdb_box_office
    FROM
        tmdb
    LEFT JOIN
        omdb ON tmdb.imdb_id = omdb.imdb_id
),

SELECT
    *
FROM
    joined2
    where sequel_id is not null