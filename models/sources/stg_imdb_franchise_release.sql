WITH source AS (
    SELECT 
        FRANCHISE_ID,
        RELEASE_ID,
        RELEASE as release_name,
        LIFETIME_GROSS,
        MAX_THEATERS,
        OPENING,
        OPEN_TH as open_theaters,
        COMPANY_ID,
        DISTRIBUTOR as distributor_name,
        RELEASE_DATE_ID as release_date
    FROM 
        {{ source('ADDITIONAL_DATA', 'IMDB_FRANCHISE_RELEASE') }}
)

SELECT 
    * 
FROM 
    source