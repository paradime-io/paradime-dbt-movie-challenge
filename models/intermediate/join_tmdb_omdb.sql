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
        o.RELEASED_DATE,
        o.RUNTIME,
        o.TMDB_ID,
        o.TYPE,
        o.WEBSITE
    FROM
        {{ ref('stg_omdb_movies') }} o 

),
tmdb AS (
    SELECT 
        t.IMDB_ID,
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
        t.RELEASE_DATE,
        t.RUNTIME,
        t.SPOKEN_LANGUAGES,
        t.STATUS,
        t.TAGLINE,
        t.TITLE AS TMDB_TITLE,
        t.TMDB_ID,
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
        md.*,
        mf.*
    FROM 
        omdb md
    LEFT JOIN 
        tmdb mf
    ON 
        md.IMDB_ID = mf.IMDB_ID
)
SELECT 
    *
FROM 
    joined_tables
