WITH

-- Imports
TMDB AS (
    SELECT * FROM {{ ref('stg_tmdb_movies') }}
),

OMDB AS (
    SELECT * FROM {{ ref('stg_omdb_movies') }}
),

IMDB AS (
    SELECT * FROM {{ ref('stg_imdb_basics_movies') }}
    WHERE
        -- To be totally sure that the movie was released
        START_YEAR IS NOT NULL
        AND START_YEAR < 2024
        -- to remove genres we know shouldn't be part of the analysis
        AND GENRES NOT LIKE '%TV Movie%'
        AND GENRES NOT LIKE '%Documentary%'
        AND GENRES NOT LIKE '%Reality-TV%'
        AND GENRES NOT LIKE '%Talk-Show%'
        AND GENRES NOT LIKE '%Game-Show%'
        AND GENRES NOT LIKE '%News%'
        AND GENRES NOT LIKE '%Music%'
        AND GENRES NOT LIKE '%Sport%'
        AND GENRES NOT LIKE '%Adult%'
),

IMDB_RATINGS AS (
    SELECT * FROM {{ ref('stg_imdb_ratings') }}
),

-- Create a complete list of movies IDs
KEY_PAIRS AS (
    SELECT DISTINCT
        TRIM(IMDB_ID) AS IMDB_ID,
        TRIM(TMDB_ID) AS TMDB_ID
    FROM TMDB
    -- Where both IMDB_ID and TMDB_ID are not null or blank
    -- also, all IMDB_ID should start with "tt", 
    -- if not, we don't want to bother with them
    WHERE
        NULLIF(TRIM(IMDB_ID), '') IS NOT NULL
        AND NULLIF(TRIM(TMDB_ID), '') IS NOT NULL
        AND LEFT(TRIM(IMDB_ID), 2) = 'tt'


    UNION ALL

    SELECT DISTINCT
        TRIM(IMDB_ID) AS IMDB_ID,
        TRIM(TMDB_ID) AS TMDB_ID
    FROM OMDB
    -- Where both IMDB_ID and TMDB_ID are not null or blank
    -- also, all IMDB_ID should start with "tt", if not, we don't want to bother with them
    WHERE
        NULLIF(TRIM(IMDB_ID), '') IS NOT NULL
        AND NULLIF(TRIM(TMDB_ID), '') IS NOT NULL
        AND LEFT(TRIM(IMDB_ID), 2) = 'tt'
),

-- Deduplicate the pairs of IDs
CLEAN_IDS AS (
    SELECT
        IMDB_ID,
        TMDB_ID
    FROM KEY_PAIRS
    -- Make sure we only load one pair of keys
    -- If there are multiple pairs, then pick one randomly.
    QUALIFY
        ROW_NUMBER() OVER (PARTITION BY IMDB_ID ORDER BY RANDOM()) = 1
),

-- Now, we can use the IDMB additional source as a basis for all movies
BACKFILL AS (
    SELECT
        IDB.IMDB_ID AS IMDB_ID,
        CLE.TMDB_ID AS TMDB_ID,

        COALESCE(
            IDB.PRIMARY_TITLE,
            TD1.TITLE,
            OD1.TITLE,
            TD2.TITLE,
            OD2.TITLE
        )
            AS TITLE,

        COALESCE(
            TO_NUMBER(IDB.START_YEAR, 4, 0),
            TO_NUMBER(YEAR(TD1.RELEASE_DATE), 4, 0),
            TO_NUMBER(OD1.RELEASE_YEAR, 4, 0),
            TO_NUMBER(YEAR(TD2.RELEASE_DATE), 4, 0),
            TO_NUMBER(OD2.RELEASE_YEAR, 4, 0)
        )
            AS RELEASE_YEAR,

        -- Ensure movie runtime if between 1h and 4h
        COALESCE(
            CASE
                WHEN
                    TO_NUMBER(IDB.RUNTIME_MINUTES) > 60
                    AND TO_NUMBER(IDB.RUNTIME_MINUTES) < 240
                    THEN TO_NUMBER(IDB.RUNTIME_MINUTES)
            END,
            CASE
                WHEN
                    TO_NUMBER(TD1.RUNTIME) > 60 AND TO_NUMBER(TD1.RUNTIME) < 240
                    THEN TO_NUMBER(TD1.RUNTIME)
            END,
            CASE
                WHEN
                    TO_NUMBER(OD1.RUNTIME) > 60 AND TO_NUMBER(OD1.RUNTIME) < 240
                    THEN TO_NUMBER(OD1.RUNTIME)
            END,
            CASE
                WHEN
                    TO_NUMBER(TD2.RUNTIME) > 60 AND TO_NUMBER(TD2.RUNTIME) < 240
                    THEN TO_NUMBER(TD1.RUNTIME)
            END,
            CASE
                WHEN
                    TO_NUMBER(OD2.RUNTIME) > 60 AND TO_NUMBER(OD2.RUNTIME) < 240
                    THEN TO_NUMBER(OD2.RUNTIME)
            END
        )
            AS RUNTIME,

        COALESCE(
            IDB.GENRES,
            TD1.GENRE_NAMES,
            OD1.GENRE,
            TD2.GENRE_NAMES,
            OD2.GENRE
        )
            AS GENRES,

        COALESCE(
            RAT.AVERAGE_RATING,
            OD1.IMDB_RATING,
            OD2.IMDB_RATING
        )
            AS RATING,

        COALESCE(
            NULLIF(TO_NUMBER(RAT.NUMBER_OF_VOTES), 0),
            NULLIF(TO_NUMBER(OD1.IMDB_VOTES), 0),
            NULLIF(TO_NUMBER(OD2.IMDB_VOTES), 0)
        )
            AS VOTES,

        -- Judgment call: 
        -- 1. We will assume that these columns means the same thing in both data sets
        -- 2. In 97% of cases, the revenue is greater than 789;
        -- we will consider any value under 1,000 as an outlier, 
        -- probably due to data input issue, and nullify their value.
        COALESCE(
            CASE
                WHEN TO_NUMBER(TD1.REVENUE) >= 1000
                    THEN TO_NUMBER(TD1.REVENUE)
            END,
            CASE
                WHEN TO_NUMBER(OD1.BOX_OFFICE) >= 1000
                    THEN TO_NUMBER(OD1.BOX_OFFICE)
            END,
            CASE
                WHEN TO_NUMBER(TD2.REVENUE) >= 1000
                    THEN TO_NUMBER(TD2.REVENUE)
            END,
            CASE
                WHEN TO_NUMBER(OD2.BOX_OFFICE) >= 1000
                    THEN TO_NUMBER(OD2.BOX_OFFICE)
            END
        )
            AS REVENUE,

        COALESCE(
            NULLIF(OD1.DIRECTOR, 'N/A'),
            NULLIF(OD2.DIRECTOR, 'N/A')
        )
            AS DIRECTOR,

        COALESCE(
            NULLIF(OD1.ACTORS, 'N/A'),
            NULLIF(OD2.ACTORS, 'N/A')
        )
            AS ACTORS,

        COALESCE(
            TD1.PRODUCTION_COUNTRY_NAMES,
            OD1.COUNTRY,
            TD2.PRODUCTION_COUNTRY_NAMES,
            OD2.COUNTRY
        )
            AS COUNTRY

    --  -- DATA QUALITY CONTROL
    --      CASE
    --          WHEN IDB.PRIMARY_TITLE IS NOT NULL THEN 'IMDB'
    --          WHEN TD1.TITLE IS NOT NULL THEN 'TD1'
    --          WHEN OD1.TITLE IS NOT NULL THEN 'OD1'
    --          WHEN TD2.TITLE IS NOT NULL THEN 'TD2'
    --          WHEN OD2.TITLE IS NOT NULL THEN 'OD2'
    --          ELSE 'UNSET'
    --      END
    --          AS SOURCE

    FROM IMDB AS IDB
    LEFT JOIN IMDB_RATINGS AS RAT ON IDB.IMDB_ID = RAT.IMDB_ID
    LEFT JOIN CLEAN_IDS AS CLE ON IDB.IMDB_ID = CLE.IMDB_ID
    LEFT JOIN TMDB AS TD1 ON IDB.IMDB_ID = TD1.IMDB_ID
    LEFT JOIN OMDB AS OD1 ON IDB.IMDB_ID = OD1.IMDB_ID
    LEFT JOIN TMDB AS TD2 ON CLE.TMDB_ID = TD2.TMDB_ID
    LEFT JOIN OMDB AS OD2 ON CLE.TMDB_ID = OD2.TMDB_ID

),

CUSTOM_LOGIC AS (
    SELECT
        IMDB_ID,
        TMDB_ID,
        TITLE,
        GENRES,
        RELEASE_YEAR,
        CASE
            WHEN RELEASE_YEAR < 1930 THEN 'Silent Era <1930'
            WHEN RELEASE_YEAR < 1950 THEN 'Golden Age 1930-1949'
            WHEN RELEASE_YEAR < 1970 THEN 'Color and Widescreen 1950-1969'
            WHEN RELEASE_YEAR < 1980 THEN 'New Hollywood and Blockbusters 1970-1989'
            WHEN RELEASE_YEAR < 2010 THEN 'Digital Revolution 1990-2009'
            WHEN RELEASE_YEAR < 2024 THEN 'Streaming Era 2010-Present'
            ELSE 'Unknown'
        END
            AS ERA,
        RUNTIME,
        COUNTRY,
        DIRECTOR,
        ACTORS,
        RATING,
        VOTES,
        REVENUE
    FROM BACKFILL
)

SELECT * FROM CUSTOM_LOGIC
