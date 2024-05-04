WITH stg_tmdb_tv_series AS (
    SELECT * FROM {{ ref('stg_tmdb_tv_series') }}
)
select * from stg_tmdb_tv_series