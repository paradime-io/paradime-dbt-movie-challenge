WITH omdb AS (
    SELECT
        o.IMDB_ID,
        SPLIT_PART(o.GENRE, ',', 1) AS GENRE,
        o.TITLE,
        o.DIRECTOR,
        o.WRITER,
        o.RELEASE_YEAR,
        o.IMDB_VOTES,
        o.IMDB_RATING,
        {{ parse_awards('o.awards') }},
        o.ACTORS,
        o.BOX_OFFICE,
        o.COUNTRY,
        o.DVD,
        o.LANGUAGE,
        o.METASCORE,
        o.PLOT,
        o.POSTER,
        o.PRODUCTION,
        o.RATED,
        o.RATINGS,
        o.RUNTIME,
        o.TMDB_ID as o_tmdb_id, -- Aliasing to distinguish from t.TMDB_ID
        o.TYPE,
        o.WEBSITE
    FROM
        {{ ref('stg_omdb_movies') }} o 
),
tmdb AS (
    SELECT 
        t.IMDB_ID as t_imdb_id, -- Aliased to prevent collisions with o.IMDB_ID
        t.BUDGET,
        t.REVENUE,
        t.REVENUE - t.BUDGET AS ROI,
        t.BACKDROP_PATH,
        t.BELONGS_TO_COLLECTION,
        t.GENRE_NAMES,
        t.HOMEPAGE,
        t.KEYWORDS,
        t.ORIGINAL_LANGUAGE,
        t.ORIGINAL_TITLE,
        t.OVERVIEW,
        t.POSTER_PATH,
        t.PRODUCTION_COMPANY_NAMES,
        t.PRODUCTION_COUNTRY,
        t.RUNTIME as t_runtime, -- Aliased because o.RUNTIME exists
        t.RELEASE_DATE,
        t.SPOKEN_LANGUAGES,
        t.STATUS,
        t.TAGLINE,
        t.TITLE AS TMDB_TITLE,
        t.TMDB_ID as t_tmdb_id, -- Aliased to distinguish from o.TMDB_ID
        t.VIDEO,
        t.VOTE_AVERAGE,
        t.VOTE_COUNT
    FROM 
        {{ ref('stg_tmdb_movies') }} t
    WHERE 
        t.RELEASE_DATE < CURRENT_DATE 
        AND t.REVENUE <> 0
        AND t.BUDGET <> 0
),
joined_tables AS (
    SELECT
        md.IMDB_ID, -- Select IMDB_ID from omdb as it's common
        md.GENRE,
        md.TITLE as md_title,
        md.DIRECTOR,
        md.WRITER,
        md.RELEASE_YEAR,
        md.IMDB_VOTES,
        md.IMDB_RATING,
        md.wins,
        md.nominations,
        md.ACTORS,
        md.BOX_OFFICE,
        md.COUNTRY,
        md.DVD,
        md.LANGUAGE,
        md.METASCORE,
        md.PLOT,
        md.POSTER,
        md.PRODUCTION,
        md.RATED,
        md.RATINGS,
        mf.RELEASE_DATE,
        md.RUNTIME,
        md.TYPE,
        md.WEBSITE,
        mf.BUDGET,
        mf.REVENUE,
        mf.ROI,
        mf.BACKDROP_PATH,
        mf.BELONGS_TO_COLLECTION,
        mf.GENRE_NAMES,
        mf.HOMEPAGE,
        mf.KEYWORDS,
        mf.ORIGINAL_LANGUAGE,
        mf.ORIGINAL_TITLE,
        mf.OVERVIEW,
        mf.POSTER_PATH,
        mf.PRODUCTION_COMPANY_NAMES,
        mf.PRODUCTION_COUNTRY,
        mf.t_runtime,
        mf.SPOKEN_LANGUAGES,
        mf.STATUS,
        mf.TAGLINE,
        mf.TMDB_TITLE,
        mf.VIDEO,
        mf.VOTE_AVERAGE,
        mf.VOTE_COUNT
    FROM 
        omdb md
    INNER JOIN 
        tmdb mf
    ON 
        md.IMDB_ID = mf.t_imdb_id
)
SELECT 
    *
FROM 
    joined_tables
