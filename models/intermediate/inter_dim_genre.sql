WITH stg_tmdb_tv_series AS (
    SELECT * FROM {{ ref('stg_tmdb_tv_series') }}
)

SELECT
    release_date,
    release_year,
    tv_series_id,
    C.value::string AS genre_name
FROM 
    stg_tmdb_tv_series,
LATERAL FLATTEN(input=>split(genres, ', ')) C