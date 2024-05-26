WITH current_cpi AS (
    SELECT 
        avg_cpi
    FROM
        {{ ref('int_avg_cpi_by_year') }}
    WHERE 
        calendar_year = year(current_date())
)

, adjusted_budget AS (
    SELECT 
        tmdb.title
        , tmdb.imdb_id
        , tmdb.budget
        , tmdb.budget * (ccpi.avg_cpi / cpi.avg_cpi) AS adjusted_budget
    FROM
        {{ ref('stg_tmdb_movies') }} tmdb
    LEFT JOIN
        {{ ref('int_avg_cpi_by_year') }} cpi ON cpi.calendar_year = tmdb.release_year
    LEFT JOIN 
        current_cpi ccpi ON 1 = 1
)

SELECT 
    * 
FROM 
    adjusted_budget