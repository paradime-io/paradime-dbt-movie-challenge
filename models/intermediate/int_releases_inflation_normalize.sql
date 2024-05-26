WITH current_cpi AS (
    SELECT 
        avg_cpi
    FROM
        {{ ref('int_avg_cpi_by_year') }}
    WHERE 
        calendar_year = year(current_date())
)

, adjusted_gross AS (
    SELECT 
        bo.imdb_id
        , bo.release_group
        , bo.rollout
        , bo.release_year
        , bo.markets
        , bo.domestic_gross * (ccpi.avg_cpi / cpi.avg_cpi) AS adjusted_domestic_gross
        , bo.international_gross * (ccpi.avg_cpi / cpi.avg_cpi) AS adjusted_international_gross
        , bo.worldwide_gross * (ccpi.avg_cpi / cpi.avg_cpi) AS adjusted_worldwide_gross
    FROM
        {{ ref('int_bomojo_releases') }} bo
    LEFT JOIN
        {{ ref('int_avg_cpi_by_year') }} cpi ON cpi.calendar_year = bo.release_year
    LEFT JOIN 
        current_cpi ccpi ON 1 = 1
)

SELECT 
    * 
FROM 
    adjusted_gross