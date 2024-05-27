WITH historical_total_gross AS (
    SELECT
        c.region
        , omdb.release_year
        , SUM(c.lifetime_gross) AS lifetime_gross
    FROM 
        {{ ref('stg_bomojo_countries') }}  c
    INNER JOIN 
        {{ ref('stg_omdb_movies') }} omdb ON omdb.imdb_id = C.imdb_id
    GROUP BY
        c.region
        , omdb.release_year
),

total_gross_year AS (
    SELECT 
        release_year
        , SUM(lifetime_gross) AS total_gross
    FROM
        historical_total_gross
    GROUP BY
        release_year
)

SELECT
    htg.region
    , TO_DATE(htg.release_year || '-01-01', 'YYYY-MM-DD') AS release_year
    , htg.lifetime_gross
    , (htg.lifetime_gross / tgy.total_gross) * 100 AS percent_total_gross
FROM 
    historical_total_gross htg
INNER JOIN 
    total_gross_year tgy ON tgy.release_year = htg.release_year