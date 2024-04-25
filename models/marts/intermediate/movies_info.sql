WITH tmdb AS (
    SELECT
        imdb_id,
        tmdb_id,
        title AS tmdb_title,
        release_date AS tmdb_release_date,
        original_language,
        overview AS tmdb_overview,
        status,
        genre_names,
        runtime,
        vote_average,
        vote_count,
        revenue,
        budget,
        PRODUCTION_COMPANY_NAMES,
        PRODUCTION_COUNTRY_NAMES
    FROM
        {{ ref('stg_tmdb_movies') }}
), 

omdb AS (
    SELECT 
        imdb_id,
        tmdb_id,
        title AS omdb_title,
        type,
        director,
        writer,
        actors,
        genre AS omdb_genre,
        rated,
        awards,
        production,
        released_date AS omdb_released_date,
        release_year,
        runtime AS omdb_runtime,
        metascore,
        imdb_rating,
        imdb_votes,
        box_office
    FROM
        {{ ref('stg_omdb_movies') }}
), 

lan AS (
    SELECT 
        C1 as abbreviation,
        C2 as language
    FROM
        {{ ref('stg_language_codes') }}

), 

joined AS (
    SELECT
        tmdb.imdb_id                                                            as imdb_id,
        tmdb.tmdb_title                                                         as title,
        COALESCE(tmdb.tmdb_overview, 'N/A' )                                    as overview,
        tmdb.status                                                             as status,
        COALESCE(omdb.type, 'N/A')                                              as type,
        COALESCE(tmdb.tmdb_release_date, omdb.omdb_released_date, '1900-01-01') as release_date,
        lan.language                                                            as original_language,
        COALESCE(tmdb.genre_names, omdb.omdb_genre, 'N/A')                      as genre,
        COALESCE(tmdb.runtime, omdb.omdb_runtime)                               as duration_minutes,
        TO_CHAR(COALESCE(tmdb.revenue, '-1'), '9G999G999G999')                  as worldwide_box_office,
        TO_CHAR(COALESCE(omdb.box_office, '-1'), '9G999G999G999')               as domestic_box_office,
        TO_CHAR(COALESCE(tmdb.budget, '-1'), '9G999G999G999')                   as budget,
        COALESCE(omdb.director, 'N/A')                                          as director,
        COALESCE(omdb.writer, 'N/A')                                            as writer,
        COALESCE(omdb.actors, 'N/A')                                            as actors,
        COALESCE(omdb.rated, 'N/A')                                             as rated,
        COALESCE(omdb.awards, 'N/A')                                            as awards,
        COALESCE(tmdb.production_company_names, 'N/A')                          as production_companies,
        COALESCE(tmdb.production_country_names, 'N/A')                          as production_countries,
        COALESCE(omdb.metascore, '-1')                                          as metascore,
        COALESCE(omdb.imdb_rating, '-1')                                        as imdb_rating,
        TO_CHAR(COALESCE(omdb.imdb_votes, '-1'), '9G999G999G999')               as imdb_votes,
        COALESCE(tmdb.vote_average, '-1')                                       as tmdb_vote_average,
        TO_CHAR(COALESCE(tmdb.vote_count, '-1'), '9G999G999G999')               as tmdb_vote_count
    FROM
        tmdb
    LEFT JOIN
        omdb ON tmdb.imdb_id = omdb.imdb_id or tmdb.tmdb_id = omdb.tmdb_id
    LEFT JOIN 
        lan ON lan.abbreviation = tmdb.original_language
)

SELECT
    *
FROM
    joined