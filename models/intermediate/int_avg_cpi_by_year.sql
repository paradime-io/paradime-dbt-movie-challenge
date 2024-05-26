WITH cpi_unpivoted AS (
    SELECT 
        calendar_year
        , month
        , cpi
        , ROW_NUMBER() OVER (PARTITION BY calendar_year ORDER BY 
            CASE month
                WHEN 'JAN' THEN 1
                WHEN 'FEB' THEN 2
                WHEN 'MAR' THEN 3
                WHEN 'APR' THEN 4
                WHEN 'MAY' THEN 5
                WHEN 'JUN' THEN 6
                WHEN 'JUL' THEN 7
                WHEN 'AUG' THEN 8
                WHEN 'SEP' THEN 9
                WHEN 'OCT' THEN 10
                WHEN 'NOV' THEN 11
                WHEN 'DEC' THEN 12
            END DESC) AS month_order
    FROM 
        {{ ref('stg_cpi') }}
    UNPIVOT (
        cpi FOR month IN (JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC)
    )
),

cpi_data AS (
    SELECT 
        calendar_year
        , MAX(CASE WHEN month_order = 1 THEN cpi END) AS latest_cpi
        , COUNT(DISTINCT month) AS num_months_with_data
        , SUM(COALESCE(cpi, 0)) AS sum_cpi
    FROM 
        cpi_unpivoted
    GROUP BY 
        calendar_year
)

SELECT 
    calendar_year
    , ROUND(
        CASE 
            WHEN num_months_with_data = 12 THEN sum_cpi / 12.0 
            ELSE latest_cpi
        END,
        3
    ) AS avg_cpi
FROM 
    cpi_data