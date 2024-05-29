WITH source AS (
    SELECT 
        FRANCHISE_ID, 
        FRANCHISE AS franchise_name,
        RELEASES as release_total,
        regexp_replace(TOTAL, '[^0-9]', '')::integer as earnings_total
    FROM 
        {{ source('ADDITIONAL_DATA', 'IMDB_FRANCHISE') }}
)

SELECT 
    * 
FROM 
    source