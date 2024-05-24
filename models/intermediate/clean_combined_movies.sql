WITH

TMDB AS (
    SELECT * FROM {{ ref('stg_tmdb_movies') }}
),

OMDB AS (
    SELECT * FROM {{ ref('stg_omdb_movies') }}
),

omdb_movie_ids as (
select
    trim(imdb_id) as imdb_id,
    trim(tmdb_id) as tmdb_id,
    title as omdb_title
from OMDB
),

tmdb_movie_ids as (
select
    trim(imdb_id) as imdb_id,
    trim(tmdb_id) as tmdb_id,
    title as tmdb_title
from TMDB
),

combined_movie_ids as(
    select
        coalesce(tm.tmdb_id, om.tmdb_id) as tmdb_id,
        coalesce(tm.imdb_id, om.imdb_id) as imdb_id,
        coalesce(tm.tmdb_title, om.omdb_title) as title,
    from tmdb_movie_ids tm
    full join omdb_movie_ids om
    on tm.tmdb_id = om.tmdb_id
),

combined_movies AS (
    SELECT
        cmi.tmdb_id,
        cmi.imdb_id,
        cmi.title,
        coalesce(TMDB.release_date, OMDB.released_date) as release_date, -- 161k records where tmdb_release_date != omdb_release_date; tmdb dates are generally more correct as per google search
        extract(year from release_date) as release_year,
        coalesce(TMDB.overview, OMDB.plot) as overview,
        TMDB.tagline,
        TMDB.keywords,
        coalesce(TMDB.original_language, TMDB.spoken_languages, OMDB.language) as languages,
        TMDB.genre_names,
        coalesce(TMDB.runtime, OMDB.runtime) as runtime,
        TMDB.vote_average,
        TO_NUMBER(TMDB.revenue) as revenue,
        TO_NUMBER(TMDB.budget) as budget,
        revenue - budget as profit,
        TMDB.status,
        TMDB.video,
        --  TMDB.production_company_names,
        --  TMDB.production_country_names,
        TMDB.vote_count,
        OMDB.director,
        OMDB.writer,
        OMDB.actors,
        OMDB.awards,
        OMDB.production,
        OMDB.dvd as dvd_date,
        OMDB.rated,
        --  OMDB.metascore, 96% null values
        OMDB.imdb_rating,
        OMDB.imdb_votes,
        --  OMDB.box_office, 96% null values
        OMDB.country,

    FROM combined_movie_ids cmi
    LEFT JOIN TMDB
        ON (cmi.tmdb_id = TMDB.TMDB_ID)
    LEFT JOIN OMDB
        ON cmi.imdb_id = OMDB.IMDB_ID
    --  WHERE
    --      coalesce(TMDB.runtime, OMDB.runtime) > 40
        -- movies are defined as a minimum of 40 minutes in length
),
-- add a boolean column if movie is apart of a sequel
movie_sequels AS (
    select
        trim(IMDB_ID) as imdb_id_series,
        trim(series) as movie_series,
    from
        {{ref ('movies_trilogies')}}
),
final as (
    select
        cm.*,
        CASE
            WHEN ms.movie_series IS NOT NULL THEN true
            ELSE false
        END AS movie_series_check,
        ms.movie_series
    from combined_movies cm
    left join movie_sequels ms
        on cm.imdb_id = ms.imdb_id_series
)

SELECT * FROM final

