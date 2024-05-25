WITH year_rollout AS (
    SELECT 
        *
        , TRY_TO_NUMBER(RIGHT(ROLLOUT, 4)) AS RELEASE_YEAR
    FROM 
        {{ ref('stg_bomojo_releases') }}
    WHERE 
        ROLLOUT IS NOT NULL 
),

year_release_group AS (
    SELECT
        R.*
        , 
        CASE 
           WHEN TRY_TO_NUMBER(SUBSTR(R.RELEASE_GROUP, 1, 4)) IS NOT NULL THEN SUBSTR(R.RELEASE_GROUP, 1, 4)
           WHEN R.RELEASE_GROUP LIKE '50th%' THEN OMBD.RELEASE_YEAR + 50
           WHEN R.RELEASE_GROUP LIKE '25th%' THEN OMBD.RELEASE_YEAR + 25
           WHEN R.RELEASE_GROUP LIKE '10th%' THEN OMBD.RELEASE_YEAR + 10
           ELSE OMBD.RELEASE_YEAR
        END AS RELEASE_YEAR
    FROM 
        {{ ref('stg_bomojo_releases') }} R
    INNER JOIN 
        {{ source('MOVIE_BASE', 'OMDB_MOVIES') }} OMBD ON OMBD.IMDB_ID = R.IMDB_ID
    WHERE 
        R.ROLLOUT IS NULL
)

, union_year AS (
    SELECT 
        *
    FROM 
        year_rollout

    UNION 

    SELECT 
        *
    FROM
        year_release_group
)

SELECT 
    IMDB_ID,
	RELEASE_GROUP,
	ROLLOUT,
	MARKETS,
	DOMESTIC_GROSS,
	INTERNATIONAL_GROSS,
	WORLDWIDE_GROSS,
	TO_NUMBER(RELEASE_YEAR) AS RELEASE_YEAR
FROM 
    union_year