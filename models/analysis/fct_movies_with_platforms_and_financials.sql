WITH financials AS (
    SELECT
        IMDB_ID,
        GENRE,
        md_title,
        DIRECTOR,
        WRITER,
        RELEASE_YEAR,
        IMDB_VOTES,
        IMDB_RATING,
        wins,
        nominations,
        ACTORS,
        BOX_OFFICE,
        DVD,
        LANGUAGE,
        RATINGS,
        TYPE,
        BUDGET,
        REVENUE,
        ROI,
        GENRE_NAMES,
        ORIGINAL_LANGUAGE,
        ORIGINAL_TITLE,
        PRODUCTION_COMPANY_NAMES,
        Runtime,
        STATUS,
        VOTE_AVERAGE,
        VOTE_COUNT
    FROM 
        {{ ref('int_join_tmdb_omdb') }}
),
platforms AS (
    SELECT
        platform,
        movie_id,
        title,
        director,
        country,
        date_added,
        release_year,
        rating,
        duration_mins,
        listed_in
    FROM 
        {{ ref('int_movies_on_all_platforms') }}
),
joined_tables AS (
    SELECT
        f.IMDB_ID,
        f.GENRE,
        f.md_title,
        f.DIRECTOR AS f_director,
        f.WRITER,
        f.RELEASE_YEAR,
        f.IMDB_VOTES,
        f.IMDB_RATING,
        f.wins,
        f.nominations,
        f.ACTORS,
        f.BOX_OFFICE,
        f.DVD,
        f.LANGUAGE,
        f.RATINGS,
        f.TYPE,
        f.BUDGET,
        f.REVENUE,
        f.ROI,
        f.GENRE_NAMES,
        f.ORIGINAL_LANGUAGE,
        f.ORIGINAL_TITLE,
        f.PRODUCTION_COMPANY_NAMES,
        f.Runtime,
        f.STATUS,
        f.VOTE_AVERAGE,
        f.VOTE_COUNT,
        p.platform,
        p.movie_id,
        p.country,
        p.date_added,
        p.rating,
        p.duration_mins,
        p.listed_in
    FROM
        financials f
    INNER JOIN
        platforms p
    ON
        LOWER(REPLACE(p.title, ' ', '')) = LOWER(REPLACE(f.original_title, ' ', ''))
        AND p.release_year = f.release_year
        AND p.director = f.director  -- Assuming director is reliable for refining the join
    WHERE 
        f.ORIGINAL_TITLE = f.md_title
)

SELECT * FROM joined_tables