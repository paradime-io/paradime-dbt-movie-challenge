WITH source AS (
    SELECT 
        BRAND AS brand_name,
        BRAND_ID, 
        RELEASES as release_total,
        regexp_replace(TOTAL, '[^0-9]', '')::integer as earnings_total
    FROM 
        {{ source('ADDITIONAL_DATA', 'IMDB_BRAND') }}
)

SELECT 
    * 
FROM 
    source