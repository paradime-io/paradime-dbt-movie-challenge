WITH source AS (
    SELECT 
        BRAND_ID,
        RELEASE_ID,
        RELEASE AS release_name,
        LIFETIME_GROSS,
        MAX_THEATERS,
        OPENING,
        OPEN_TH AS OPEN_THEATER,
        COMPANY_ID,
        DISTRIBUTOR AS DISTRIBUTOR_NAME,
        RELEASE_DATE_ID AS RELEASE_DATE
    FROM 
        {{ source('ADDITIONAL_DATA', 'IMDB_BRAND_RELEASE') }}
)

SELECT 
    * 
FROM 
    source